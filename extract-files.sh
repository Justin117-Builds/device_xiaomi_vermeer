#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=vermeer
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=true
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        product/etc/permissions/vendor.qti.hardware.data.connectionaidl-V1-java.xml)
            sed -i 's/xml version="2.0"/xml version="1.0"/g' "${2}"
            ;;
        product/etc/permissions/vendor.qti.hardware.data.connection-V1*.xml)
            sed -i 's/xml version="2.0"/xml version="1.0"/g' "${2}"
           ;;
        odm/etc/camera/aivsModel_6C06C006 | odm/lib64/libmialgo_aisn.so)
            split --bytes=20M -d "${2}" "${2}".part
            ;;
        odm/etc/camera/enhance_motiontuning.xml |odm/etc/camera/night_motiontuning.xml | odm/etc/camera/motiontuning.xml)
            sed -i 's/<?xml=/<?xml /g' "${2}"
            ;;
        odm/lib64/hw/displayfeature.default.so)
            "${PATCHELF}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
            ;;
        odm/lib64/libailab_rawhdr.so | odm/lib64/libxmi_high_dynamic_range_cdsp.so)
            "${ANDROID_ROOT}"/prebuilts/clang/host/linux-x86/clang-r450784e/bin/llvm-strip --strip-debug "${2}"
            ;;
        odm/lib64/libmt@1.3.so)
            "${PATCHELF}" --replace-needed "libcrypto.so" "libcrypto-v33.so" "${2}"
            ;;
        vendor/bin/hw/android.hardware.security.keymint-service-qti | vendor/lib64/libqtikeymint.so)
            "${PATCHELF}" --add-needed android.hardware.security.rkp-V3-ndk.so "${2}"
            ;;
        vendor/bin/hw/dolbycodec2 | vendor/bin/hw/vendor.dolby.hardware.dms@2.0-service | vendor/bin/hw/vendor.dolby.media.c2@1.0-service | vendor/lib64/hw/audio.primary.kalama.so)
            "${PATCHELF}" --add-needed "libstagefright_foundation-v33.so" "${2}"
            ;;
        vendor/lib64/c2.dolby.client.so)
            "${PATCHELF}" --add-needed "dolbycodec_shim.so" "${2}"
            ;;
        vendor/etc/seccomp_policy/qwesd@2.0.policy)
            echo "pipe2: 1" >> "${2}"
            ;;
    esac
}

    # Initialize the helper
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
