################################################################################
#
# nfr-dash
#
################################################################################

NFR_DASH_VERSION = local
NFR_DASH_SITE = $(BR2_EXTERNAL_NFR26_PATH)/..
NFR_DASH_SITE_METHOD = local
NFR_DASH_DEPENDENCIES = mesa3d libdrm libgpiod2 host-pkgconf $(BR2_CMAKE_HOST_DEPENDENCY)

NFR_DASH_OKAY_DIR = $(call qstrip,$(BR2_PACKAGE_NFR_DASH_OKAY_ENGINE_DIR))/okay
NFR_DASH_BUILD_TYPE = $(call qstrip,$(BR2_PACKAGE_NFR_DASH_BUILD_TYPE))

# Mirrors the configure step of `okay build --target rpi` (okay/scripts/tools/build_util.py)
define NFR_DASH_CONFIGURE_CMDS
	$(BR2_CMAKE) -S $(NFR_DASH_OKAY_DIR) -B $(@D)/build \
		-DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/share/buildroot/toolchainfile.cmake \
		-DCMAKE_BUILD_TYPE=$(NFR_DASH_BUILD_TYPE) \
		-DOKAY_BUILD_TYPE=$(NFR_DASH_BUILD_TYPE) \
		-DPROJECT=dash \
		-DOKAY_PROJECT_NAME=dash \
		-DOKAY_TARGET=rpi \
		-DOKAY_PLATFORM=rpi \
		-DOKAY_PROJECT_ROOT_DIR=$(@D)/dash \
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5
endef

define NFR_DASH_BUILD_CMDS
	$(BR2_CMAKE) --build $(@D)/build --target dash -j$(PARALLEL_JOBS)
endef

# The engine resolves assets relative to the working directory: engine/assets and game/assets
define NFR_DASH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/dash $(TARGET_DIR)/opt/dash/dash
	rm -rf $(TARGET_DIR)/opt/dash/engine $(TARGET_DIR)/opt/dash/game
	mkdir -p $(TARGET_DIR)/opt/dash/engine $(TARGET_DIR)/opt/dash/game
	cp -r $(NFR_DASH_OKAY_DIR)/assets $(TARGET_DIR)/opt/dash/engine/assets
	cp -r $(@D)/dash/assets $(TARGET_DIR)/opt/dash/game/assets
endef

define NFR_DASH_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(NFR_DASH_PKGDIR)/S99dash $(TARGET_DIR)/etc/init.d/S99dash
endef

$(eval $(generic-package))
