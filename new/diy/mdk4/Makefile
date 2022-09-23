# MDK4 is licenced under the GPLv3 or later.

include $(TOPDIR)/rules.mk

PKG_NAME:=mdk4
PKG_VERSION:=4.2
PKG_RELEASE:=1
PKG_LICENSE:=GPL-3.0

#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
#PKG_CAT:=bzcat
PKG_MAINTAINER:=Anonymous <guoguo@example.org>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
# PKG_BUILD_PARALLEL:=1
PKG_AUTOMAKE_PATHS:=src
PKG_FIXUP:=autoreconf

# include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

# CONFIGURE_PATH:=src
MAKE_PATH:=src

define Package/mdk4
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Wireless
  TITLE:=MDK is a proof-of-concept tool
  URL:=https://github.com/aircrack-ng/mdk4
  DEPENDS:=+libpcap +libnl-core +libnl-genl +libpthread
endef

define Package/mdk4/description
  MDK4 is a Wi-Fi testing tool from E7mer, ASPj of k2wrlz, it uses the osdep library from the aircrack-ng project to inject frames on several operating systems.
  MDK4 is a new version of MDK3.
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)
endef

# define Build/Compile
# 	$(MAKE) -C $(PKG_BUILD_DIR)
# endef

define Package/mdk4/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/mdk4 $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,mdk4))
