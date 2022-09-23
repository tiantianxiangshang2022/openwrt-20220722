# This is wylink common sets

define Device/wylink-common
	DEVICE_PACKAGES := kmod-leds-gpio kmod-ledtrig-gpio kmod-nls-cp936 kmod-nls-utf8 kmod-nls-cp437 \
	luci-app-commands luci-app-filetransfer luci-app-ramfree luci-app-ttyd luci-app-vlmcsd luci-app-ledtrig-switch \
	openssh-sftp-server aircrack-ng reaver pixiewps screen nano bash
endef

define Device/wylink-usb3
	DEVICE_PACKAGES += kmod-usb-core kmod-usb2 kmod-usb3 kmod-usb-storage kmod-usb-storage-extras kmod-usb-storage-uas \
	kmod-fs-exfat block-mount luci-app-hd-idle fdisk lsblk blkid exfat-fsck exfat-mkfs mount-utils dmesg luci-app-ledtrig-usbport
endef

define Device/wylink-zram
	DEVICE_PACKAGES += kmod-fs-ext4 e2fsprogs zram-swap
endef

define Device/wylink-blkcry
	DEVICE_PACKAGES += kmod-crypto-ecb kmod-crypto-xts kmod-crypto-cbc kmod-crypto-misc kmod-crypto-rmd160 kmod-crypto-md5 kmod-crypto-sha256 \
	kmod-crypto-sha512 kmod-crypto-rng kmod-crypto-echainiv kmod-crypto-fcrypt kmod-crypto-iv kmod-crypto-user cryptsetup libgcrypt
endef

define Device/wylink-nand
	$(call Device/wylink-common)
	DEVICE_PACKAGES += luci -dnsmasq dnsmasq-full luci-proto-relay bridge ppp-mod-pptp fping curl wget
endef

define Device/wylink-nandstor
	$(call Device/wylink-common)
	$(call Device/wylink-usb3)
	$(call Device/wylink-zram)
	DEVICE_PACKAGES += kmod-block2mtd kmod-loop kmod-scsi-generic kmod-fs-nfs-v3 kmod-fs-nfs-v4 kmod-fs-xfs xfs-admin xfs-fsck xfs-growfs xfs-mkfs \
	luci luci-app-uhttpd luci-app-nfs luci-app-wol luci-app-samba4 luci-app-vsftpd \
	nfs-utils wakeonlan tgt eject lscpu uhubctl shadow-groupadd shadow-groupdel shadow-groupmod shadow-useradd shadow-userdel shadow-usermod
endef

define Device/wylink-crystor
	$(call Device/wylink-nandstor)
	$(call Device/wylink-blkcry)
endef

