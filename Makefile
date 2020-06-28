CONFIGURE ?= ./configure
RULES ?= $(wildcard rules/*)

all: kernel-config

kernel-config: kernel/.config ${RULES}
	cp $< $@
	${CONFIGURE}
	cp $@ $<
	( cd kernel && make oldconfig )

kernel/.config:
	( cd kernel \
	    && git apply ../patches/* \
	    && make mrproper \
	    && make defconfig \
	)

clean:
	( [ -d kernel ] && cd kernel && git reset --hard && make mrproper )
	rm -f kernel-config

.PHONY: all clean
