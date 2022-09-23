define Device/generic
  DEVICE_TITLE := Generic x86/64
  DEVICE_PACKAGES += kmod-bnx2 kmod-e1000e kmod-e1000 kmod-forcedeth kmod-igb \
  kmod-ixgbe kmod-r8169
  GRUB2_VARIANT := generic
endef
TARGET_DEVICES += generic

define Device/wylink_common
  GRUB2_VARIANT := generic
  DEVICE_PACKAGES += kmod-vmxnet3 kmod-sit kmod-tcp-bbr kmod-random-core open-vm-tools dmesg \
  kmod-fs-ext4 kmod-nls-cp936 kmod-nls-utf8 kmod-nls-cp437 ca-bundle ca-certificates \
  luci luci-app-commands luci-app-ttyd luci-app-uhttpd luci-app-filetransfer luci-app-ramfree \
  dnsmasq-full -dnsmasq tcpreplay-all iptables-mod-tproxy ip-full ipset iptables-utils iptables-mod-nat-extra \
  tar uuidgen bzip2 gzip unrar unzip xz-utils xz nano bash iconv curl wget fping openssh-sftp-server \
  block-mount fdisk e2fsprogs lsblk blkid swap-utils mount-utils screen lscpu
endef

define Device/wylink_usb
  DEVICE_PACKAGES += kmod-usb-core kmod-usb2 kmod-usb2-pci kmod-usb3 eject uhubctl
endef

define Device/wylink_usbstor
  DEVICE_PACKAGES += kmod-usb-storage kmod-usb-storage-extras kmod-usb-storage-uas \
  kmod-fs-exfat luci-app-hd-idle exfat-fsck exfat-mkfs
endef

define Device/wylink_usbnet
  DEVICE_PACKAGES += kmod-usb-net kmod-usb-net-rtl8152 kmod-usb-net-sr9700 kmod-usb-net-cdc-eem \
  kmod-usb-net-cdc-ether kmod-usb-wdm kmod-usb-net-cdc-ncm kmod-usb-net-cdc-mbim kmod-usb-net-cdc-subset
endef

define Device/wylink_blkcry
  DEVICE_PACKAGES += kmod-crypto-ecb kmod-crypto-xts kmod-crypto-cbc kmod-crypto-misc kmod-crypto-rmd160 kmod-crypto-md5 kmod-crypto-sha256 \
  kmod-crypto-sha512 kmod-crypto-rng kmod-crypto-echainiv kmod-crypto-fcrypt kmod-crypto-iv kmod-crypto-user cryptsetup libgcrypt
endef

define Device/wylink_nfs
  DEVICE_PACKAGES += kmod-fs-nfs-v3 kmod-fs-nfs-v4 luci-app-nfs luci-app-nlbwmon nfs-utils-libs nfs-utils
endef

define Device/wylink_vps
  DEVICE_TITLE := Wylink VPS x86/64
  $(call Device/wylink_common)
  $(call Device/wylink_nfs)
  DEVICE_PACKAGES += luci-app-aria2 luci-app-ntpc luci-app-privoxy ariang webui-aria2
endef
TARGET_DEVICES += wylink_vps

define Device/wylink_edge
  DEVICE_TITLE := Wylink EdgeRoute X64
  $(call Device/wylink_common)
  $(call Device/wylink_nfs)
  DEVICE_PACKAGES += luci-app-aria2 luci-app-ntpc luci-app-privoxy luci-app-vlmcsd luci-app-squid \
  ppp-mod-pppol2tp ppp-mod-pptp xl2tpd ariang webui-aria2
endef
TARGET_DEVICES += wylink_edge

define Device/wylink_core
  DEVICE_TITLE := Wylink CoreRoute X64
  $(call Device/wylink_common)
  $(call Device/wylink_usb)
  $(call Device/wylink_usbnet)
  DEVICE_PACKAGES += luci-app-adblock luci-app-https-dns-proxy luci-app-nft-qos luci-app-arpbind luci-app-vlmcsd \
  bind-host knot-host drill kmod-macvlan
endef
TARGET_DEVICES += wylink_core

define Device/wylink_nas
  DEVICE_TITLE := Wylink NAS X64
  $(call Device/wylink_common)
  $(call Device/wylink_usb)
  $(call Device/wylink_usbstor)
  $(call Device/wylink_blkcry)
  $(call Device/wylink_nfs)
  DEVICE_PACKAGES += kmod-block2mtd kmod-loop kmod-scsi-generic kmod-fs-xfs xfs-admin xfs-fsck xfs-growfs xfs-mkfs \
  luci-app-samba4 luci-app-vsftpd tgt shadow-groupadd shadow-groupdel shadow-groupmod shadow-useradd shadow-userdel shadow-usermod
endef
TARGET_DEVICES += wylink_nas

define Device/wylink_devel
  DEVICE_TITLE := Wylink Develop X64
  $(call Device/wylink_common)
  DEVICE_PACKAGES += wpad-basic-wolfssl iwinfo kmod-mac80211-hwsim
endef
TARGET_DEVICES += wylink_devel
