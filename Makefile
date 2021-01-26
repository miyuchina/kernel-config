RULES_DIR      ?= ./rules
PATCHES_DIR    ?= ./patches
KERNEL_DIR     ?= ./kernel
CONFIG_TARGET  ?= menuconfig
ALL_TARGET     ?= alldefconfig

MERGE_KCONFIG  := $(KERNEL_DIR)/scripts/kconfig/merge_config.sh
DIFF_KCONFIG   := $(KERNEL_DIR)/scripts/diffconfig
RULES          := $(wildcard $(RULES_DIR)/*)
PATCHES        := $(wildcard $(PATCHES_DIR)/*)
CONFIG         := $(KERNEL_DIR)/.config
PATCHED_CONFIG := $(KERNEL_DIR)/.patched_config
NEW_CONFIG     := $(KERNEL_DIR)/.new_config


all: $(CONFIG)


diff_config:
	@[ -f "$(NEW_CONFIG)" ] && \
	    $(DIFF_KCONFIG) -m $(CONFIG) $(NEW_CONFIG)


new_config: $(CONFIG)
	[ -f "$(NEW_CONFIG)" ] || cp $(CONFIG) $(NEW_CONFIG)
	$(MAKE) -C $(KERNEL_DIR) \
	    KCONFIG_CONFIG=$(notdir $(NEW_CONFIG)) \
	    $(CONFIG_TARGET)


$(CONFIG): $(PATCHED_CONFIG) $(RULES)
	KCONFIG_CONFIG=$@ $(MERGE_KCONFIG) -m -r $^
	$(MAKE) -C $(KERNEL_DIR) \
	    KCONFIG_CONFIG=$(notdir $@) \
	    KCONFIG_ALLCONFIG=$(notdir $@) \
	    $(ALL_TARGET)


$(PATCHED_CONFIG): $(PATCHES)
	[ -z "$(PATCHES)" ] || \
	    git -C $(KERNEL_DIR) apply --verbose $(addprefix ../,$^)
	$(MAKE) -C $(KERNEL_DIR) KCONFIG_CONFIG=$(notdir $@) defconfig


clean:
	git -C $(KERNEL_DIR) reset --hard
	git -C $(KERNEL_DIR) clean -fdx


.PHONY: all clean new_config diff_config
