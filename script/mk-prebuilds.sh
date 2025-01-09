#!/bin/bash

PATH_DUO_SDK=/home/u/ws/duo/duo-buildroot-sdk
PATH_DUO_PKGTOOL=/home/u/ws/duo/duo-pkgtool

# $ cd $PATH_DUO_SDK
#
# # Checking out to the vesion we would like to ......
# $ git checkout 8e970aa49 -b prebuilds # 8e970aa49 is the commit ID when I am testing
#
# # Applying patches for duo-sdk ......
# $ git am $PATH_DUO_PKGTOOL/patches/0001-patchs-for-duo-pkgtool.patch
#
# # Building prebuilds ......
# $ source device/milkv-duo256m-sd/boardconfig.sh
# $ source build/milkvsetup.sh
# $ defconfig cv1812cp_milkv_duo256m_sd
# $ clean_all
# $ build_fsbl
# $ build_kernel
#
# $ source device/milkv-duo-sd/boardconfig.sh
# $ source build/milkvsetup.sh
# $ defconfig cv1800b_milkv_duo_sd
# $ clean_all
# $ build_fsbl
# $ build_kernel
#
# $ source device/milkv-duos-sd/boardconfig.sh 
# $ source build/milkvsetup.sh 
# $ defconfig cv1813h_milkv_duos_sd
# $ clean_all
# $ build_fsbl
# $ clean_all
# $ build_fsbl
# $ build_kernel

# Copying prebuilds from duo-sdk to duo-pkgtool ......

# common, but seems better move to separated folders, FIXME
cp $PATH_DUO_SDK/fsbl/plat/cv181x/fiptool.py $PATH_DUO_PKGTOOL/prebuilt/common/fiptool.py

# duo 256m sd
cp $PATH_DUO_SDK/ramdisk/build/cv1812cp_milkv_duo256m_sd/workspace/cv1812cp_milkv_duo256m_sd.dtb $PATH_DUO_PKGTOOL/prebuilt/milkv-duo256m/dtb/cv1812cp_milkv_duo256m_sd.dtb
cp $PATH_DUO_SDK/ramdisk/build/cv1812cp_milkv_duo256m_sd/workspace/multi.its $PATH_DUO_PKGTOOL/prebuilt/milkv-duo256m/dtb/multi.its
cp $PATH_DUO_SDK/fsbl/build/cv1812cp_milkv_duo256m_sd/bl2.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo256m/fsbl/bl2.bin
cp $PATH_DUO_SDK/fsbl/build/cv1812cp_milkv_duo256m_sd/blmacros.env $PATH_DUO_PKGTOOL/prebuilt/milkv-duo256m/fsbl/blmacros.env
cp $PATH_DUO_SDK/fsbl/build/cv1812cp_milkv_duo256m_sd/chip_conf.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo256m/fsbl/chip_conf.bin
cp $PATH_DUO_SDK/fsbl/test/cv181x/ddr_param.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo256m/fsbl/ddr_param.bin
cp $PATH_DUO_SDK/fsbl/test/empty.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo256m/fsbl/empty.bin
cp $PATH_DUO_SDK/opensbi/build/platform/generic/firmware/fw_dynamic.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo256m/opensbi/fw_dynamic.bin
cp $PATH_DUO_SDK/u-boot-2021.10/build/cv1812cp_milkv_duo256m_sd/u-boot-raw.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo256m/uboot/u-boot-raw.bin

# duo sd
cp $PATH_DUO_SDK/ramdisk/build/cv1800b_milkv_duo_sd/workspace/cv1800b_milkv_duo_sd.dtb $PATH_DUO_PKGTOOL/prebuilt/milkv-duo/dtb/cv1800b_milkv_duo_sd.dtb
cp $PATH_DUO_SDK/ramdisk/build/cv1800b_milkv_duo_sd/workspace/multi.its $PATH_DUO_PKGTOOL/prebuilt/milkv-duo/dtb/multi.its
cp $PATH_DUO_SDK/fsbl/build/cv1800b_milkv_duo_sd/bl2.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo/fsbl/bl2.bin
cp $PATH_DUO_SDK/fsbl/build/cv1800b_milkv_duo_sd/blmacros.env $PATH_DUO_PKGTOOL/prebuilt/milkv-duo/fsbl/blmacros.env
cp $PATH_DUO_SDK/fsbl/build/cv1800b_milkv_duo_sd/chip_conf.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo/fsbl/chip_conf.bin
cp $PATH_DUO_SDK/fsbl/test/cv181x/ddr_param.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo/fsbl/ddr_param.bin
cp $PATH_DUO_SDK/fsbl/test/empty.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo/fsbl/empty.bin
cp $PATH_DUO_SDK/opensbi/build/platform/generic/firmware/fw_dynamic.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo/opensbi/fw_dynamic.bin
cp $PATH_DUO_SDK/u-boot-2021.10/build/cv1800b_milkv_duo_sd/u-boot-raw.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duo/uboot/u-boot-raw.bin

# duo S sd
cp $PATH_DUO_SDK/ramdisk/build/cv1813h_milkv_duos_sd/workspace/cv1813h_milkv_duos_sd.dtb $PATH_DUO_PKGTOOL/prebuilt/milkv-duos/dtb/cv1813h_milkv_duos_sd.dtb
cp $PATH_DUO_SDK/ramdisk/build/cv1813h_milkv_duos_sd/workspace/multi.its $PATH_DUO_PKGTOOL/prebuilt/milkv-duos/dtb/multi.its
cp $PATH_DUO_SDK/fsbl/build/cv1813h_milkv_duos_sd/bl2.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duos/fsbl/bl2.bin
cp $PATH_DUO_SDK/fsbl/build/cv1813h_milkv_duos_sd/blmacros.env $PATH_DUO_PKGTOOL/prebuilt/milkv-duos/fsbl/blmacros.env
cp $PATH_DUO_SDK/fsbl/build/cv1813h_milkv_duos_sd/chip_conf.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duos/fsbl/chip_conf.bin
cp $PATH_DUO_SDK/fsbl/test/cv181x/ddr_param.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duos/fsbl/ddr_param.bin
cp $PATH_DUO_SDK/fsbl/test/empty.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duos/fsbl/empty.bin
cp $PATH_DUO_SDK/opensbi/build/platform/generic/firmware/fw_dynamic.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duos/opensbi/fw_dynamic.bin
cp $PATH_DUO_SDK/u-boot-2021.10/build/cv1813h_milkv_duos_sd/u-boot-raw.bin $PATH_DUO_PKGTOOL/prebuilt/milkv-duos/uboot/u-boot-raw.bin

# Recording the commit ID of duo-sdk we make the prebuilds
# ......

# Do some cleanup ......