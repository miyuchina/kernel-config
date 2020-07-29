KERNEL    ?= ./kernel
CONFIGURE ?= ./configure
RULES     ?= $(wildcard rules/*)
PATCHES   ?= $(wildcard patches/*)

all: kernel-config

kernel-config: kernel/.config $(RULES)
	cp $< $@
	$(CONFIGURE)
	cp $@ $<
	+make -C $(KERNEL) oldconfig

kernel/.config: $(PATCHES)
	git -C $(KERNEL) apply --verbose $(addprefix ../,$^)
	+make -C $(KERNEL) defconfig

clean:
	git -C $(KERNEL) reset --hard
	+make -C $(KERNEL) mrproper
	rm -f kernel-config

.PHONY: all clean
