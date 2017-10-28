#
# Copyright (C) 2016 Jian Chang <aa65535@live.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksr-libev
PKG_VERSION:=3.0.6
PKG_RELEASE:=d4904568c0bd7e0861c0cbfeaa43740f404db214

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_SOURCE_URL:=https://github.com/shadowsocksrr/shadowsocksr-libev.git
PKG_SOURCE_VERSION:=$(PKG_RELEASE)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=chenhw2 <chenhw2@github.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocksr-libev/Default
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Lightweight Secured Socks5 Proxy $(2)
	URL:=https://github.com/shadowsocksrr/shadowsocksr-libev
	VARIANT:=$(1)
	DEPENDS:=$(3) +libpcre +libpthread
endef

Package/shadowsocksr-libev = $(call Package/shadowsocksr-libev/Default,openssl,(OpenSSL),+libopenssl +zlib)
Package/shadowsocksr-libev-mbedtls = $(call Package/shadowsocksr-libev/Default,mbedtls,(mbedTLS),+libmbedtls)

define Package/shadowsocksr-libev/description
shadowsocksr-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

Package/shadowsocksr-libev-mbedtls/description = $(Package/shadowsocksr-libev/description)

CONFIGURE_ARGS += --disable-ssp --disable-documentation --disable-assert

ifeq ($(BUILD_VARIANT),mbedtls)
	CONFIGURE_ARGS += --with-crypto-library=mbedtls
endif

define Package/shadowsocksr-libev/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local  $(1)/usr/bin/ssr-local
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir  $(1)/usr/bin/ssr-redir
endef

Package/shadowsocksr-libev-mbedtls/install = $(Package/shadowsocksr-libev/install)

$(eval $(call BuildPackage,shadowsocksr-libev))
$(eval $(call BuildPackage,shadowsocksr-libev-mbedtls))
