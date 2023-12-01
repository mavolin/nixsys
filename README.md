<div align="center">
<h1>nixsys</h1>

[![License MIT](https://img.shields.io/github/license/mavolin/nixsys)](./LICENSE)
</div>

---

## About

This is my NixOS configuration that I use for my personal laptop.

The most general settings can be changed by editing [base.nix](./base.nix).

Note that this configuration will not build if you clone it, since `user/programs/git-settings.nix` is missing.
See [git.nix](./user/programs/git.nix) for more information about this file.

The [flake.lock](./flake.lock) in this repo will only be updated alongside other changes.
I will not create a new commit just because I updated my system.

## License

Available under the [MIT License](./LICENSE).
