include piclfs.mk
-include device.mk

START_BUILD_TIME := $(shell date +%s)
define PRINT_BUILD_TIME
@time_end=`date +%s` ; time_exec=`awk -v "TS=${START_BUILD_TIME}" -v "TE=$$time_end" 'BEGIN{TD=TE-TS;printf "%02dh:%02dm:%02ds\n",TD/(60*60)%24,TD/(60)%60,TD%60}'` ; $(STEP) "'$@' Build Time: $${time_exec}"
endef

START_TOTAL_BUILD_TIME := $(shell date +%s)
define PRINT_TOTAL_BUILD_TIME
@time_end=`date +%s` ; time_exec=`awk -v "TS=${START_TOTAL_BUILD_TIME}" -v "TE=$$time_end" 'BEGIN{TD=TE-TS;printf "%02dh:%02dm:%02ds\n",TD/(60*60)%24,TD/(60)%60,TD%60}'` ; $(STEP) "Total Build Time: $${time_exec}"
endef

help:
	@scripts/banner.sh
	@echo
	@echo -e '  \e[7mBuild\e[0m'
	@echo -e '    \e[1mall\e[0m                    - Build PiCLFS with toolchain'
	@echo -e '    \e[1mtoolchain\e[0m              - Build toolchain'
	@echo -e '    \e[1msystem\e[0m                 - Build PiCLFS'
	@echo -e '    \e[1mkernel\e[0m                 - Build PiCLFS kernel'
	@echo -e '    \e[1mimage\e[0m                  - Generate PiCLFS image'
	@echo
	@echo -e '  \e[7mCleaning\e[0m'
	@echo -e '    \e[1mclean\e[0m                  - Delete all files created by build'
	@echo
	@echo -e '  \e[7mMiscellaneous\e[0m'
	@echo -e '    \e[1m<name>_defconfig\e[0m       - Load configuration file'
	@echo -e '    \e[1mlist-defconfigs\e[0m        - Show configuration file list'
	@echo -e '    \e[1msetting\e[0m                - Show build settings'
	@echo -e '    \e[1mflash\e[0m                  - Flash an SD Card'
	@echo

all:
	@make check
	@make settings
	@make toolchain
	@make system
	@make kernel
	@make image
	$(PRINT_TOTAL_BUILD_TIME)

toolchain:
	@make check
	@$(STEP) "Create toolchain directory."
	@rm -rf $(BUILD_DIR) $(TOOLS_DIR)
	@mkdir -pv $(LOG_DIR) $(BUILD_DIR) $(TOOLS_DIR)
	@rm -rf $(LOG_DIR)/toolchain.packages
	@make staging -C $(PACKAGES_DIR)/skeleton
	@make toolchain -C $(PACKAGES_DIR)/file
	@make toolchain -C $(PACKAGES_DIR)/gawk
	@make toolchain -C $(PACKAGES_DIR)/m4
	@make toolchain -C $(PACKAGES_DIR)/ncurses
	@make toolchain -C $(PACKAGES_DIR)/binutils
	@make toolchain -C $(PACKAGES_DIR)/gmp
	@make toolchain -C $(PACKAGES_DIR)/mpfr
	@make toolchain -C $(PACKAGES_DIR)/mpc
	@make toolchain -C $(PACKAGES_DIR)/gcc/initial
	@make staging -C $(PACKAGES_DIR)/linux
	@make staging -C $(PACKAGES_DIR)/glibc
	@make toolchain -C $(PACKAGES_DIR)/gcc/final
	@make toolchain -C $(PACKAGES_DIR)/pkgconf
	@make toolchain -C $(PACKAGES_DIR)/mke2img
	@make toolchain -C $(PACKAGES_DIR)/makedevs
	@make toolchain -C $(PACKAGES_DIR)/genext2fs
	@make toolchain -C $(PACKAGES_DIR)/mkknlimg
	@make toolchain -C $(PACKAGES_DIR)/libconfuse
	@make toolchain -C $(PACKAGES_DIR)/genimage
	@make toolchain -C $(PACKAGES_DIR)/libcap
	@make toolchain -C $(PACKAGES_DIR)/fakeroot
	@make toolchain -C $(PACKAGES_DIR)/mtools
	@make toolchain -C $(PACKAGES_DIR)/mkpasswd
	@make toolchain -C $(PACKAGES_DIR)/zlib
	@make toolchain -C $(PACKAGES_DIR)/libxml2
	@make toolchain -C $(PACKAGES_DIR)/gettext
	@make toolchain -C $(PACKAGES_DIR)/libtool
	@make toolchain -C $(PACKAGES_DIR)/autoconf
	@make toolchain -C $(PACKAGES_DIR)/automake
	@make toolchain -C $(PACKAGES_DIR)/flex
	@make toolchain -C $(PACKAGES_DIR)/bison
	@make toolchain-staging
	$(PRINT_BUILD_TIME)

toolchain-staging:
	@make check
	@rm -rf $(BUILD_DIR)
	@mkdir -pv $(LOG_DIR) $(BUILD_DIR)
	@rm -rf $(LOG_DIR)/staging.packages
	@make staging -C $(PACKAGES_DIR)/zlib
	@make staging -C $(PACKAGES_DIR)/binutils
	@make staging -C $(PACKAGES_DIR)/gmp
	@make staging -C $(PACKAGES_DIR)/mpfr
	@make staging -C $(PACKAGES_DIR)/mpc
	@make staging -C $(PACKAGES_DIR)/gcc
	@make staging -C $(PACKAGES_DIR)/ncurses
	@make staging -C $(PACKAGES_DIR)/readline
	@make staging -C $(PACKAGES_DIR)/libffi
	@make staging -C $(PACKAGES_DIR)/pcre
	@make staging -C $(PACKAGES_DIR)/glib
	@make staging -C $(PACKAGES_DIR)/xz
	@make staging -C $(PACKAGES_DIR)/util-linux
	@make staging -C $(PACKAGES_DIR)/libpipeline
	@make staging -C $(PACKAGES_DIR)/gdbm
	@make staging -C $(PACKAGES_DIR)/libcap
	@make staging -C $(PACKAGES_DIR)/openssl
	$(PRINT_BUILD_TIME)

system:
	@make check
	@$(STEP) "Create toolchain directory."
	@rm -rf $(BUILD_DIR) $(ROOTFS_DIR)
	@mkdir -pv $(LOG_DIR) $(BUILD_DIR) $(ROOTFS_DIR)
	@rm -rf $(LOG_DIR)/system.packages
	@make system -C $(PACKAGES_DIR)/skeleton
	@make system -C $(PACKAGES_DIR)/linux
	@make system -C $(PACKAGES_DIR)/man-pages
	@make system -C $(PACKAGES_DIR)/zlib
	@make system -C $(PACKAGES_DIR)/file
	@make system -C $(PACKAGES_DIR)/ncurses
	@make system -C $(PACKAGES_DIR)/readline
	@make system -C $(PACKAGES_DIR)/m4
	@make system -C $(PACKAGES_DIR)/bc
	@make system -C $(PACKAGES_DIR)/binutils
	@make system -C $(PACKAGES_DIR)/gmp
	@make system -C $(PACKAGES_DIR)/mpfr
	@make system -C $(PACKAGES_DIR)/mpc
	@make system -C $(PACKAGES_DIR)/gcc
	@make system -C $(PACKAGES_DIR)/bzip2
	@make system -C $(PACKAGES_DIR)/libffi
	@make system -C $(PACKAGES_DIR)/pcre
	@make system -C $(PACKAGES_DIR)/glib
	@make system -C $(PACKAGES_DIR)/pkg-config
	@make system -C $(PACKAGES_DIR)/sed
	@make system -C $(PACKAGES_DIR)/shadow
	@make system -C $(PACKAGES_DIR)/psmisc
	@make system -C $(PACKAGES_DIR)/iana-etc
	@make system -C $(PACKAGES_DIR)/bison
	@make system -C $(PACKAGES_DIR)/flex
	@make system -C $(PACKAGES_DIR)/grep
	@make system -C $(PACKAGES_DIR)/bash
	@make system -C $(PACKAGES_DIR)/libtool
	@make system -C $(PACKAGES_DIR)/gdbm
	@make system -C $(PACKAGES_DIR)/gperf
	@make system -C $(PACKAGES_DIR)/inetutils
	@make system -C $(PACKAGES_DIR)/autoconf
	@make system -C $(PACKAGES_DIR)/automake
	@make system -C $(PACKAGES_DIR)/xz
	@make system -C $(PACKAGES_DIR)/kmod
	@make system -C $(PACKAGES_DIR)/gettext
	@make system -C $(PACKAGES_DIR)/procps-ng
	@make system -C $(PACKAGES_DIR)/util-linux
	@make system -C $(PACKAGES_DIR)/e2fsprogs
	@make system -C $(PACKAGES_DIR)/coreutils
	@make system -C $(PACKAGES_DIR)/diffutils
	@make system -C $(PACKAGES_DIR)/gawk
	@make system -C $(PACKAGES_DIR)/findutils
	@make system -C $(PACKAGES_DIR)/less
	@make system -C $(PACKAGES_DIR)/gzip
	@make system -C $(PACKAGES_DIR)/iproute2
	@make system -C $(PACKAGES_DIR)/kbd
	@make system -C $(PACKAGES_DIR)/libpipeline
	@make system -C $(PACKAGES_DIR)/make
	@make system -C $(PACKAGES_DIR)/patch
	@make system -C $(PACKAGES_DIR)/sysklogd
	@make system -C $(PACKAGES_DIR)/sysvinit
	@make system -C $(PACKAGES_DIR)/eudev
	@make system -C $(PACKAGES_DIR)/tar
	@make system -C $(PACKAGES_DIR)/texinfo
	@make system -C $(PACKAGES_DIR)/vim
	@make system -C $(PACKAGES_DIR)/tzdata
	@make system -C $(PACKAGES_DIR)/bootscripts
	@make system -C $(PACKAGES_DIR)/lsb-release
	@make system -C $(PACKAGES_DIR)/libcap
	@make system -C $(PACKAGES_DIR)/openssl
	@make system -C $(PACKAGES_DIR)/openssh
	@make system -C $(PACKAGES_DIR)/ntp
	@make system -C $(PACKAGES_DIR)/glibc
	$(PRINT_BUILD_TIME)

kernel:
	@make check
	@rm -rf $(BUILD_DIR) $(KERNEL_DIR)
	@mkdir -pv $(BUILD_DIR) $(KERNEL_DIR)
	@make kernel -C $(PACKAGES_DIR)/linux
	$(PRINT_BUILD_TIME)

image:
	@make check
	@$(STEP) "Generate PiCLFS image"
	@rm -rf $(BUILD_DIR) $(IMAGES_DIR)
	@mkdir -pv $(BUILD_DIR) $(IMAGES_DIR)
	@cp $(WORKSPACE_DIR)/support/device_table.txt $(BUILD_DIR)/_device_table.txt
	@if [ -d $(ROOTFS_DIR)/var/log/lastlog ] ; then \
	    echo "/var/log/lastlog	d	664	13	13	-	-	-	-	-" >> $(BUILD_DIR)/_device_table.txt ; \
	fi;
	@if [ -d $(ROOTFS_DIR)/var/lib/ntp ] ; then \
	    echo "/var/lib/ntp	d	755	87	87	-	-	-	-	-" >> $(BUILD_DIR)/_device_table.txt ; \
	fi;
	@if [ -d $(ROOTFS_DIR)/var/lib/sshd ] ; then \
	    echo "/var/lib/sshd	d	700	0	2	-	-	-	-	-" >> $(BUILD_DIR)/_device_table.txt ; \
	fi;
	@if [ -d $(ROOTFS_DIR)/usr/libexec/dbus-daemon-launch-helper ] ; then \
	    echo "/usr/libexec/dbus-daemon-launch-helper	d	4750	0	18	-	-	-	-	-" >> $(BUILD_DIR)/_device_table.txt ; \
	fi;
	@echo '#!/bin/sh' > $(BUILD_DIR)/_fakeroot.fs
	@echo 'set -e' >> $(BUILD_DIR)/_fakeroot.fs
	@echo 'chown -h -R 0:0 $(ROOTFS_DIR)' >> $(BUILD_DIR)/_fakeroot.fs
	@echo '$(TOOLS_DIR)/usr/bin/makedevs -d $(BUILD_DIR)/_device_table.txt $(ROOTFS_DIR)' >> $(BUILD_DIR)/_fakeroot.fs
	@echo '$(TOOLS_DIR)/usr/bin/mke2img -d $(ROOTFS_DIR) -G 4 -R 1 -B 150000 -I 150000 -o $(IMAGES_DIR)/rootfs.ext2' >> $(BUILD_DIR)/_fakeroot.fs
	@chmod a+x $(BUILD_DIR)/_fakeroot.fs
	@$(TOOLS_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.fs
	@ln -svf rootfs.ext2 $(IMAGES_DIR)/rootfs.ext4
	@mkdir -p $(IMAGES_DIR)/kernel-marked
	@for dtb in $(CONFIG_LINUX_KERNEL_INTREE_DTS_NAME) ; do \
		cp -v $(KERNEL_DIR)/$${dtb}.dtb $(IMAGES_DIR) ; \
	done
	@$(TOOLS_DIR)/usr/bin/mkknlimg $(KERNEL_DIR)/zImage $(IMAGES_DIR)/kernel-marked/zImage
	@cat $(PACKAGES_DIR)/firmware/rpi-firmware.part* | tar zxf -  -C $(BUILD_DIR)
	@mkdir -v $(IMAGES_DIR)/rpi-firmware
	@install -Dv -m 0644 $(BUILD_DIR)/firmware-master/boot/bootcode.bin $(IMAGES_DIR)/rpi-firmware/bootcode.bin
	@install -Dv -m 0644 $(BUILD_DIR)/firmware-master/boot/start"".elf $(IMAGES_DIR)/rpi-firmware/start.elf
	@install -Dv -m 0644 $(BUILD_DIR)/firmware-master/boot/fixup"".dat $(IMAGES_DIR)/rpi-firmware/fixup.dat
	@if [ "$(CONFIG_NAME)" = "raspberrypi3" ] ; then \
   cp -Rv $(BUILD_DIR)/firmware-master/boot/overlays $(IMAGES_DIR)/rpi-firmware/overlays; \
	fi;
	@install -Dv -m 0644 $(PACKAGES_DIR)/firmware/config.txt $(IMAGES_DIR)/rpi-firmware/config.txt
	@if [ "$(CONFIG_NAME)" = "raspberrypi3" ] ; then \
		if ! grep -qE '^dtoverlay=' "$(IMAGES_DIR)/rpi-firmware/config.txt" ; then \
			$(STEP) "Adding 'dtoverlay=pi3-miniuart-bt' to config.txt (fixes ttyAMA0 serial console)." ; \
			echo "# fixes rpi3 ttyAMA0 serial console" >> $(IMAGES_DIR)/rpi-firmware/config.txt ; \
			echo "dtoverlay=pi3-miniuart-bt" >> $(IMAGES_DIR)/rpi-firmware/config.txt ; \
		fi ; \
	fi;
	@echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait ip=dhcp rootdelay=5" > $(IMAGES_DIR)/rpi-firmware/cmdline.txt
	rm -rf $(BUILD_DIR)/firmware-master
	@$(TOOLS_DIR)/usr/bin/genimage \
  --rootpath "$(ROOTFS_DIR)" \
  --tmppath "$(BUILD_DIR)/genimage.tmp" \
  --inputpath "$(IMAGES_DIR)" \
  --outputpath "$(IMAGES_DIR)" \
  --config "$(WORKSPACE_DIR)/support/genimage/$(CONFIG_NAME).cfg"
	$(PRINT_BUILD_TIME)

%_defconfig:
	@if [ -f device/$@ ] ; then \
		cp device/$@ device.mk ; \
		$(SUCCESS) "[ SUCCESS ] Load $@." ; \
	else \
		$(ERROR) "[!! ERROR !!] '$@' configuration file does not exist..." ; \
	fi;

check:
	@if ! [ -f device.mk ] ; then \
		echo ; \
		$(ERROR) "[!! ERROR !!] Please make defconfig before building." ; \
		echo ; \
		$(ERROR) "[ Example ] $ make raspberrypi2_defconfig" ; \
		echo ; \
		exit 1 ; \
	fi;

list-defconfigs:
	@first=true; \
	for defconfig in $(WORKSPACE_DIR)/device/*_defconfig; do \
		[ -f "$${defconfig}" ] || continue; \
		if $${first}; then \
			echo -e '\e[1mBuilt-in configs:\e[0m' ; \
			first=false; \
		fi; \
		defconfig="$${defconfig##*/}"; \
		printf "  %-35s - Build for %s\n" "$${defconfig}" "$${defconfig%_defconfig}"; \
	done; \
	$${first} || printf "\n"

settings:
	@scripts/banner.sh
	@echo
	@echo -e '\e[1m\e[31m>> Build Settings:\e[0m'
	@echo -e '\e[1mSHELL:\e[0m $(SHELL)'
	@echo -e '\e[1mCONFIG_HOST:\e[0m $(CONFIG_HOST)'
	@echo -e '\e[1mCONFIG_TARGET:\e[0m $(CONFIG_TARGET)'
	@echo -e '\e[1mCONFIG_HOSTNAME:\e[0m $(CONFIG_HOSTNAME)'
	@echo -e '\e[1mCONFIG_ROOT_PASSWD:\e[0m $(CONFIG_ROOT_PASSWD)'
	@echo -e '\e[1mCONFIG_LOCAL_TIMEZONE:\e[0m $(CONFIG_LOCAL_TIMEZONE)'
	@echo -e '\e[1mCONFIG_PKG_VERSION:\e[0m $(CONFIG_PKG_VERSION)'
	@echo -e '\e[1mCONFIG_BUG_URL:\e[0m $(CONFIG_BUG_URL)'
	@echo -e '\e[1mCONFIG_PARALLEL_JOBS:\e[0m $(CONFIG_PARALLEL_JOBS)'
	@echo -e '\e[1mWORKSPACE_DIR:\e[0m $(WORKSPACE_DIR)'
	@echo -e '\e[1mPACKAGES_DIR:\e[0m $(PACKAGES_DIR)'
	@echo -e '\e[1mSCRIPTS_DIR:\e[0m $(SCRIPTS_DIR)'
	@echo -e '\e[1mOUTPUT_DIR:\e[0m $(OUTPUT_DIR)'
	@echo -e '\e[1mBUILD_DIR:\e[0m $(BUILD_DIR)'
	@echo -e '\e[1mTOOLS_DIR:\e[0m $(TOOLS_DIR)'
	@echo -e '\e[1mKERNEL_DIR:\e[0m $(KERNEL_DIR)'
	@echo -e '\e[1mROOTFS_DIR:\e[0m $(ROOTFS_DIR)'
	@echo -e '\e[1mIMAGES_DIR:\e[0m $(IMAGES_DIR)'
	@echo -e '\e[1mSYSROOT_DIR:\e[0m $(SYSROOT_DIR)'
	@echo -e '\e[1mPATH:\e[0m $(PATH)'
	@echo -e '\e[1mEXTRACT:\e[0m $(EXTRACT)'
	@echo -e '\e[1mSTEP:\e[0m $(STEP)'
	@echo -e '\e[1mSUCCESS:\e[0m $(SUCCESS)'
	@echo -e '\e[1mERROR:\e[0m $(ERROR)'
	@echo
	@echo -e '\e[1m\e[31m>> Device Settings:\e[0m'
	@echo -e '\e[1mCONFIG_NAME:\e[0m $(CONFIG_NAME)'
	@echo -e '\e[1mCONFIG_ABI:\e[0m $(CONFIG_ABI)'
	@echo -e '\e[1mCONFIG_CPU:\e[0m $(CONFIG_CPU)'
	@echo -e '\e[1mCONFIG_FPU:\e[0m $(CONFIG_FPU)'
	@echo -e '\e[1mCONFIG_FLOAT:\e[0m $(CONFIG_FLOAT)'
	@echo -e '\e[1mCONFIG_MODE:\e[0m $(CONFIG_MODE)'
	@echo -e '\e[1mCONFIG_LINUX_KERNEL_DEFCONFIG:\e[0m $(CONFIG_LINUX_KERNEL_DEFCONFIG)'
	@echo -e '\e[1mCONFIG_LINUX_KERNEL_INTREE_DTS_NAME:\e[0m $(CONFIG_LINUX_KERNEL_INTREE_DTS_NAME)'
	@echo

flash:
	@install -Dv -m 0755 $(WORKSPACE_DIR)/scripts/image-usb-stick $(TOOLS_DIR)/usr/bin/image-usb-stick
	@sudo $(TOOLS_DIR)/usr/bin/image-usb-stick $(IMAGES_DIR)/sdcard.img
	@sudo -k
	$(PRINT_BUILD_TIME)

clean:
	@rm -rf device.mk $(OUTPUT_DIR) $(LOG_DIR)
	$(PRINT_BUILD_TIME)

.PHONY: toolchain toolchain-staging system kernel image clean
