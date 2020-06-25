# Mi's Kernel Configuration

Reproducible kernel config inspired by [gg7/gentoo-kernel-guide][kernel-guide].

Define your rules (omitting `CONFIG_` prefix):

```sh
# rules/custom.sh

# /proc/config.gz
IKCONFIG=y
IKCONFIG_PROC=y
```

Clone the Linux kernel and checkout your desired version:

```sh
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git kernel
$ ( cd kernel && git checkout v5.8.0-r2 )
```

Apply your own config:

```sh
$ make
```

Compile your kernel as usual:

```sh
$ cd kernel
$ make -j$(nprocs)
$ sudo make modules_install
$ sudo make install
```

You're done!

[kernel-guide]: https://github.com/gg7/gentoo-kernel-guide
