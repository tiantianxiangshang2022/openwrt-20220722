# This is wylink common sets

define Device/wylink-common
	DEVICE_PACKAGES := kmod-nls-utf8 \
	luci luci-app-commands luci-app-ramfree openssh-sftp-server
endef

define Device/wylink-usb
	DEVICE_PACKAGES += kmod-usb-core kmod-usb2 kmod-usb-storage \
	kmod-fs-exfat fdisk lsblk blkid exfat-fsck exfat-mkfs dmesg block-mount
endef

define Device/wylink-usb3
	$(Device/wylink-usb)
	DEVICE_PACKAGES += kmod-usb3
endef

define Device/wylink-zram
	DEVICE_PACKAGES += kmod-fs-ext4 e2fsprogs zram-swap
endef

define Device/wylink-witool
	DEVICE_PACKAGES += aircrack-ng reaver
endef

define Device/wylink-nfs
	DEVICE_PACKAGES += kmod-fs-nfs-v3 mount-utils nfs-utils block-mount
endef

define Device/wylink-lge8m
	$(Device/wylink-common)
	$(Device/wylink-witool)
	DEVICE_PACKAGES += luci-app-filetransfer luci-app-ttyd
endef

define Device/wylink-lite
	$(Device/wylink-common)
	$(Device/wylink-witool)
	$(Device/wylink-nfs)
endef

define Device/wylink-litweb
	$(Device/wylink-lge8m)
	DEVICE_PACKAGES += luci-app-uhttpd
endef

define Device/wylink-tiny
	$(Device/wylink-litweb)
	$(Device/wylink-nfs)
endef

define Device/wylink-cwpks
	$(Device/wylink-tiny)
	DEVICE_PACKAGES += kmod-nls-cp936 kmod-nls-cp437 \
	luci-proto-relay luci-app-vlmcsd \
	bridge screen nano bash fping curl wget
endef

define Device/wylink-nand
	$(Device/wylink-cwpks)
	$(Device/wylink-zram)
	$(Device/wylink-usb3)
	DEVICE_PACKAGES += kmod-fs-nfs-v4 ppp-mod-pptp -dnsmasq dnsmasq-full luci-app-hd-idle
endef
