# Display
PRODUCT_PACKAGES := \
    a300_pfp.fw \
    a300_pm4.fw

# WCNSS
PRODUCT_PACKAGES += \
    WCNSS_qcom_wlan_nv.bin

PRODUCT_COPY_FILES := \
	$(LOCAL_PATH)/wcnss.b00:$(TARGET_COPY_OUT_VENDOR)/firmware/wcnss.b00 \
	$(LOCAL_PATH)/wcnss.b01:$(TARGET_COPY_OUT_VENDOR)/firmware/wcnss.b01 \
	$(LOCAL_PATH)/wcnss.b02:$(TARGET_COPY_OUT_VENDOR)/firmware/wcnss.b02 \
	$(LOCAL_PATH)/wcnss.b04:$(TARGET_COPY_OUT_VENDOR)/firmware/wcnss.b04 \
	$(LOCAL_PATH)/wcnss.b06:$(TARGET_COPY_OUT_VENDOR)/firmware/wcnss.b06 \
	$(LOCAL_PATH)/wcnss.b09:$(TARGET_COPY_OUT_VENDOR)/firmware/wcnss.b09 \
	$(LOCAL_PATH)/wcnss.b10:$(TARGET_COPY_OUT_VENDOR)/firmware/wcnss.b10 \
	$(LOCAL_PATH)/wcnss.b11:$(TARGET_COPY_OUT_VENDOR)/firmware/wcnss.b11 \
	$(LOCAL_PATH)/wcnss.mdt:$(TARGET_COPY_OUT_VENDOR)/firmware/wcnss.mdt
