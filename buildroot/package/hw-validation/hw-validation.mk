################################################################################
#
# hw-validation
#
################################################################################

HW_VALIDATION_VERSION = local
HW_VALIDATION_SITE = $(call qstrip,$(BR2_PACKAGE_HW_VALIDATION_SRC_DIR))
HW_VALIDATION_SITE_METHOD = local
HW_VALIDATION_DEPENDENCIES = libgpiod2 host-pkgconf

$(eval $(cmake-package))
