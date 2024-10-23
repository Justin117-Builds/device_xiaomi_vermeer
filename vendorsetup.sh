# Vendor  
git clone --depth=1 https://github.com/Spacemk1014/proprietary_vendor_xiaomi.git vendor/xiaomi 

# Kernel
rm -rf device/xiaomi/vermeer-kernel 
git clone --depth=1 https://github.com/Spacemk1014/android_device_xiaomi_vermeer-kernel.git device/xiaomi/vermeer-kernel 

# Camera 
git clone https://gitlab.com/ThankYouMario/proprietary_vendor_xiaomi_camera.git -b uvite-sm8550 vendor/xiaomi/camera 

# Hardware 
git clone --depth=1 https://github.com/Spacemk1014/android_hardware_xiaomi.git hardware/xiaomi 

# Sepolicy 
git clone --depth=1 https://github.com/Spacemk1014/android_device_xiaomi_sepolicy.git device/xiaomi/sepolicy 

# Hardware Qcom
git clone --depth=1 https://github.com/Spacemk1014/android_hardware_qcom-caf_sm8550_gps.git hardware/qcom-caf/sm8550/gps

# Sepolicy_vndr
rm -rf device/qcom/sepolicy_vndr/sm8550
git clone --depth=1 https://github.com/Spacemk1014/android_device_qcom_sepolicy_vndr.git device/qcom/sepolicy_vndr/sm8550

# System Qcom
git clone --depth=1 https://github.com/Spacemk1014/android_system_qcom.git system/qcom
