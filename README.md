# dotfiles

Sergtco's Nix flake for provisioning NixOS and macOS (nix-darwin) machines,
plus a set of self-contained, wrapped CLI/desktop tools.

The flake is built with [flake-parts](https://github.com/hercules-ci/flake-parts)
and [import-tree](https://github.com/vic/import-tree) — every `.nix` file under
`modules/` is auto-imported, so adding a module is as simple as dropping a file
in the right place. Dotfiles are managed with [hjem](https://github.com/feel-co/hjem),
and standalone tools are packaged with
[nix-wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules).

## Hosts

| Host        | Platform     | Role                         |
| ----------- | ------------ | ---------------------------- |
| `sergt-pc`  | NixOS        | Desktop (gaming, VR, AI)     |
| `lep-tep`   | NixOS        | Laptop                       |
| `work`      | nix-darwin   | macOS MacBook (`MacBook-Pro-user`) |

## Layout

```
flake.nix              # inputs + flake-parts entrypoint
modules/
  flake-parts.nix      # systems, nixpkgs config, overlays (NUR, unstable)
  hosts/               # per-machine configurations
    sergt-pc/          #   NixOS desktop
    lep-tep/           #   NixOS laptop
    work/              #   nix-darwin MacBook
  features/            # composable feature modules (see below)
  wrapped/             # nix-wrapper-modules packages (exported as flake packages)
config/                # raw config files (niri, neovim)
scripts/               # helper shell scripts
vicinae-scripts/       # vicinae launcher scripts
kbd/                   # keyboard layouts
wallpaper/             # wallpapers
```

### Features

Each host imports the feature modules it needs. Available features:

- `base` — shared options (e.g. `preferences.user.name`)
- `desktop` — [niri](https://github.com/YaLTeR/niri) Wayland session, waybar, vicinae, mimeapps
- `gaming` — Steam + Proton GE, MangoHud
- `vr` — WiVRn / Monado VR runtime
- `ai` — Ollama (ROCm)
- `programming` — dev toolchains
- `virtualization` — VMs / containers
- `music` — audio stack
- `vpn` / `zapret` — networking & DPI bypass
- `fonts`, `themes`, `no-rgb`, `kanata`, `nix`

### Wrapped tools

Self-contained packages exported by the flake, each configured via
`nix-wrapper-modules`:

`alacritty` · `cyberdeck` · `env` · `fish` · `fnott` · `git` · `helium` ·
`hypridle` · `neovim` (+ `neovimDev`) · `niri` · `tmux` · `waybar` · `zsh`

Build any of them directly:

```sh
nix build .#neovim
nix run .#fish
```

## Usage

**NixOS** — rebuild a host:

```sh
sudo nixos-rebuild switch --flake .#sergt-pc
# or: .#lep-tep
```

**macOS (nix-darwin):**

```sh
darwin-rebuild switch --flake .#MacBook-Pro-user
```

Update inputs:

```sh
nix flake update
```

## Requirements

- Nix with flakes enabled (`experimental-features = nix-command flakes`)
- On macOS: [nix-darwin](https://github.com/nix-darwin/nix-darwin)
