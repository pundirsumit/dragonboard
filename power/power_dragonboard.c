/*
 * Copyright (C) 2013 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Based on the HiKeyPowerHAL
 */

#include <dirent.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>
#include <pthread.h>
#include <semaphore.h>
#include <cutils/properties.h>

#define LOG_TAG "DragonboardPowerHAL"
#include <log/log.h>

#include <hardware/hardware.h>
#include <hardware/power.h>

#define SCHEDTUNE_BOOST_PATH "/dev/stune/top-app/schedtune.boost"
#define SCHEDTUNE_BOOST_VAL_PROP "ro.config.schetune.touchboost.value"
#define SCHEDTUNE_BOOST_TIME_PROP "ro.config.schetune.touchboost.time_ns"

#define SCHEDTUNE_BOOST_VAL_DEFAULT "40"

char schedtune_boost_norm[PROPERTY_VALUE_MAX] = "10";
char schedtune_boost_interactive[PROPERTY_VALUE_MAX] = SCHEDTUNE_BOOST_VAL_DEFAULT;
long long schedtune_boost_time_ns = 1000000000LL;

struct dragonboard_power_module {
    struct power_module base;
    pthread_mutex_t lock;
    /* EAS schedtune values */
    int schedtune_boost_fd;
    long long deboost_time;
    sem_t signal_lock;
};

#define container_of(addr, struct_name, field_name) \
    ((struct_name *)((char *)(addr) - offsetof(struct_name, field_name)))

#define NSEC_PER_SEC 1000000000LL
static long long gettime_ns(void)
{
    struct timespec ts;

    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
}

static void nanosleep_ns(long long ns)
{
    struct timespec ts;
    ts.tv_sec = ns/NSEC_PER_SEC;
    ts.tv_nsec = ns%NSEC_PER_SEC;
    nanosleep(&ts, NULL);
}

int schedtune_sysfs_boost(struct dragonboard_power_module *dragonboard, char* booststr)
{
    char buf[80];
    int len;

    if (dragonboard->schedtune_boost_fd < 0)
        return dragonboard->schedtune_boost_fd;

    len = write(dragonboard->schedtune_boost_fd, booststr, strlen(booststr));
    if (len < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error writing to %s: %s\n", SCHEDTUNE_BOOST_PATH, buf);
    }
    return len;
}

static void* schedtune_deboost_thread(void* arg)
{
    struct dragonboard_power_module *dragonboard = (struct dragonboard_power_module *)arg;

    while(1) {
        sem_wait(&dragonboard->signal_lock);
        while(1) {
            long long now, sleeptime = 0;

            pthread_mutex_lock(&dragonboard->lock);
            now = gettime_ns();
            if (dragonboard->deboost_time > now) {
                sleeptime = dragonboard->deboost_time - now;
                pthread_mutex_unlock(&dragonboard->lock);
                nanosleep_ns(sleeptime);
                continue;
            }

            schedtune_sysfs_boost(dragonboard, schedtune_boost_norm);
            dragonboard->deboost_time = 0;
            pthread_mutex_unlock(&dragonboard->lock);
            break;
        }
    }
    return NULL;
}

static int dragonboard_schedtune_boost(struct dragonboard_power_module *dragonboard)
{
    long long now;

    if (dragonboard->schedtune_boost_fd < 0)
        return dragonboard->schedtune_boost_fd;

    now = gettime_ns();
    if (!dragonboard->deboost_time) {
        schedtune_sysfs_boost(dragonboard, schedtune_boost_interactive);
        sem_post(&dragonboard->signal_lock);
    }
    dragonboard->deboost_time = now + schedtune_boost_time_ns;

    return 0;
}

static void dragonboard_schedtune_power_init(struct power_module *module)
{
    char buf[50];
    pthread_t tid;

    struct dragonboard_power_module *dragonboard = container_of(module,
                                              struct dragonboard_power_module, base);

    dragonboard->deboost_time = 0;
    sem_init(&dragonboard->signal_lock, 0, 1);

    dragonboard->schedtune_boost_fd = open(SCHEDTUNE_BOOST_PATH, O_RDWR);
    if (dragonboard->schedtune_boost_fd < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error opening %s: %s\n", SCHEDTUNE_BOOST_PATH, buf);
        return;
    }

    schedtune_boost_time_ns = property_get_int64(SCHEDTUNE_BOOST_TIME_PROP,
                                                 1000000000LL);
    property_get(SCHEDTUNE_BOOST_VAL_PROP, schedtune_boost_interactive,
                 SCHEDTUNE_BOOST_VAL_DEFAULT);

    if (dragonboard->schedtune_boost_fd >= 0) {
        size_t len = read(dragonboard->schedtune_boost_fd, schedtune_boost_norm,
                          PROPERTY_VALUE_MAX);
	if (len <= 0)
            ALOGE("Error reading normal boost value\n");
	else if (schedtune_boost_norm[len] == '\n')
            schedtune_boost_norm[len] = '\0';

    }

    ALOGD("Starting with schedtune boost norm: %s touchboost: %s and boosttime: %lld\n",
	  schedtune_boost_norm, schedtune_boost_interactive, schedtune_boost_time_ns);

    pthread_create(&tid, NULL, schedtune_deboost_thread, dragonboard);
}

static void dragonboard_power_hint(struct power_module *module, power_hint_t hint,
                                void __unused *data)
{
    struct dragonboard_power_module *dragonboard = container_of(module,
                                              struct dragonboard_power_module, base);

    pthread_mutex_lock(&dragonboard->lock);
    switch (hint) {
    case POWER_HINT_INTERACTION:
        dragonboard_schedtune_boost(dragonboard);
        break;

    case POWER_HINT_VSYNC:
        break;

    case POWER_HINT_LOW_POWER:
        break;

    default:
        break;
    }
    pthread_mutex_unlock(&dragonboard->lock);
}

static void set_feature(struct power_module __unused *module,
                        feature_t feature, int state)
{
    switch (feature) {
    case POWER_FEATURE_DOUBLE_TAP_TO_WAKE:
        ALOGW("Double-tap wake gesture feature is not supported\n");
        break;
    default:
        ALOGW("Error setting the feature %d and state %d, it doesn't exist\n",
              feature, state);
        break;
    }
}

static int power_open(const hw_module_t* __unused module, const char* name,
                    hw_device_t** device)
{
    int retval = 0; /* 0 is ok; -1 is error */
    ALOGD("%s: enter; name=%s", __FUNCTION__, name);

    if (strcmp(name, POWER_HARDWARE_MODULE_ID) == 0) {
        struct dragonboard_power_module *dev = (struct dragonboard_power_module *)calloc(1,
                sizeof(struct dragonboard_power_module));

        if (dev) {
            /* Common hw_device_t fields */
            dev->base.common.tag = HARDWARE_DEVICE_TAG;
            dev->base.common.module_api_version = POWER_MODULE_API_VERSION_0_5;
            dev->base.common.hal_api_version = HARDWARE_HAL_API_VERSION;

            dev->base.init = dragonboard_schedtune_power_init;
            dev->base.powerHint = dragonboard_power_hint;
            dev->base.setFeature = set_feature;

            pthread_mutex_init(&dev->lock, NULL);

            *device = (hw_device_t*)&dev->base;
        } else
            retval = -ENOMEM;
    } else {
        retval = -EINVAL;
    }

    return retval;
}

static struct hw_module_methods_t power_module_methods = {
    .open = power_open,
};

struct dragonboard_power_module HAL_MODULE_INFO_SYM = {
    .base = {
        .common = {
            .tag = HARDWARE_MODULE_TAG,
            .module_api_version = POWER_MODULE_API_VERSION_0_2,
            .hal_api_version = HARDWARE_HAL_API_VERSION,
            .id = POWER_HARDWARE_MODULE_ID,
            .name = "Dragonboard Power HAL",
            .author = "The Android Open Source Project",
            .methods = &power_module_methods,
        },
    },
};
