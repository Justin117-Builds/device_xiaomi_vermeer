#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common infinity X stuff.
$(call inherit-product, vendor/infinity/config/common_full_phone.mk)

# Inherit from vermeer device
$(call inherit-product, device/xiaomi/vermeer/device.mk)

# Infinity X Settings
INFINITY_BUILD_TYPE := UNOFFICIAL
INFINITY_MAINTAINER := Justin117(Spacemk)
TARGET_SUPPORTS_BLUR := true
TARGET_HAS_UDFPS := true
WITH_GAPPS := true
TARGET_BUILD_GOOGLE_TELEPHONY := true

PRODUCT_DEVICE := vermeer
PRODUCT_NAME := infinity_vermeer
PRODUCT_BRAND := POCO
PRODUCT_MODEL := 23113RKC6G
PRODUCT_MANUFACTURER := xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# Boot Animation
TARGET_BOOT_ANIMATION_RES := 1440

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="vermeer_global-user 14 UKQ1.230804.001 V816.0.7.0.UNKMIXM release-keys"

BUILD_FINGERPRINT := POCO/vermeer_global/vermeer:14/UKQ1.230804.001/V816.0.7.0.UNKMIXM:user/release-keys
