# Mi's Kernel Configuration

Reproducible kernel config inspired by [gg7/gentoo-kernel-guide][kernel-guide].
Most of the work is done already by
`scripts/kconfig/merge_config.sh` and
`scripts/diffconfig` that comes with the Linux kernel,
albeit poorly documented.

Really, this project is either a glorified scaffolding for a Makefile,
or a stumbling attempt at compiling documentation.

## Configuring the kernel

Clone the Linux kernel and checkout your desired version:

```sh
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git kernel
$ ( cd kernel && git checkout v5.10.10 )
```

Configure your kernel by running:

```sh
$ make new_config
```

This runs `make menuconfig` within the kernel source tree,
saving the changed configuration in a new file.
You can then diff this new configuration
against the old (or default) configuration
by running:

```sh
$ make diff_config
IKCONFIG=y
IKCONFIG_PROC=y
```

Verify that these are the kernel options you want to set,
or run `make new_config` again to make further changes.
Once you're done, save the diff in a new file under `rules`:

```sh
$ make diff_config > rules/my_rules
```

**Alternatively:** write your own config fragment in a file under `rules`.
This might be helpful when you are given
a list of required kernel configuration options
in, say, an ebuild, or some obscure forum on the internet.

You can now run:

```sh
$ make
```

... to apply all the configurations under the `rules` directory.
The kernel itself can be compiled as usual:

```sh
$ cd kernel
$ make -j$(nproc)
$ sudo make modules_install
$ sudo make install
```

No configuration changes are persistent unless the diff is saved under `rules`.
If you mess up, running:

```sh
$ make clean
```

... will blow away all your changes
(including those in the kernel source tree)
and restore everything to a clean slate.

## Creating and applying kernel patches

Make your changes within the cloned kernel repository.
When you're done, run:

```sh
$ git diff > ../patches/my-kernel-patch.patch
```

`make clean` will restore the repository state and discard all your changes.
`make` will then apply all `patches/*.patch` files to a clean kernel working
tree.

## Additional options

A couple of environmental variables can influence `make`'s behavior:

| Variable | Default | Description |
| --- | --- | ---
| `RULES_DIR` | `./rules` | the directory under which your configuration fragments can be found. |
| `PATCHES_DIR` | `./patches` | the directory under which kernel patches can be found. |
| `KERNEL_DIR` | `./kernel` | where Linux kernel's git repository is. |
| `CONFIG_TARGET` | `menuconfig` | `make new_config` runs this target within `KERNEL_DIR`. |
| `ALL_TARGET` | `alldefconfig` | `make` runs this target within `KERNEL_DIR`. |

[kernel-guide]: https://github.com/gg7/gentoo-kernel-guide
