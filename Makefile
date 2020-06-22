CONFIGURE ?= ./configure
RULES ?= $(wildcard rules/*)

all: kernel-config

kernel-config: kernel/.config ${RULES}
	cp $< $@
	${CONFIGURE}
	cp $@ $<
	( cd kernel && make oldconfig )

kernel/.config:
	( cd kernel && make mrproper && make defconfig )

clean:
	( [ -d kernel ] && cd kernel && make mrproper )
	rm -f kernel-config

.PHONY: all clean
