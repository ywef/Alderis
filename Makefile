export TARGET = iphone:latest:12.0

FRAMEWORK_OUTPUT_DIR = $(THEOS_OBJ_DIR)/xcode_derived/install/Library/Frameworks
export ADDITIONAL_CFLAGS = -fobjc-arc -Wextra -Wno-unused-parameter -F$(FRAMEWORK_OUTPUT_DIR)
export ADDITIONAL_LDFLAGS = -F$(FRAMEWORK_OUTPUT_DIR)

INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = Alderis

Alderis_XCODEFLAGS = DYLIB_INSTALL_NAME_BASE=/Library/Frameworks ARCHS="$(ARCHS)"

SUBPROJECTS = lcpshim

include $(THEOS_MAKE_PATH)/xcodeproj.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

internal-Alderis-stage::
	@# Copy postinst
	@mkdir -p $(THEOS_STAGING_DIR)/DEBIAN
	@cp postinst $(THEOS_STAGING_DIR)/DEBIAN

	@# Remove noisy files generated by Xcode
	@rm -r $(THEOS_STAGING_DIR)/Library/Frameworks/Alderis.framework/{Headers,Modules}

docs:
	$(ECHO_BEGIN)$(PRINT_FORMAT_MAKING) "Generating docs"; jazzy --module-version $(THEOS_PACKAGE_BASE_VERSION)$(ECHO_END)
	$(ECHO_NOTHING)rm -rf docs/screenshots/ docs/docsets/Alderis.docset/Contents/Resources/Documents/screenshots/$(ECHO_END)
	$(ECHO_NOTHING)cp -r screenshots/ docs/screenshots/$(ECHO_END)
	$(ECHO_NOTHING)cp -r screenshots/ docs/docsets/Alderis.docset/Contents/Resources/Documents/screenshots/$(ECHO_END)
	$(ECHO_NOTHING)rm -rf build docs/undocumented.json$(ECHO_END)

.PHONY: docs
