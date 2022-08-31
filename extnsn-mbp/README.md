# extnsn-mac

- <https://github.com/NixOS/nix>
- <https://github.com/nix-community/home-manager>
- <https://github.com/LnL7/nix-darwin>

## Install

```bash
# install nix package manager
sh <(curl -L https://nixos.org/nix/install)

# install nix-darwin
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer

# install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager
nix-channel --update
```
