# lightroom-classic-recipe

A Nix flake that pins [`lightroom-classic-on-linux`](https://github.com/6im0n/lightroom-classic-on-linux), the script recipe for running Adobe Lightroom Classic (the local-catalog desktop application, not Lightroom CC) on Linux under Wine.

## Outputs

| Attribute                                                  | What you get                                                                                                                                     |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `packages.<system>.default`                                | The upstream recipe tree at the pinned revision: its scripts, documentation, helper sources and prebuilt Windows helper DLLs. No Adobe software. |
| `packages.<system>.default.passthru.version`, `.sourceRev` | The pinned version, and the upstream revision the tree was fetched at.                                                                           |

The tree is published for `x86_64-linux`, `aarch64-linux`, and `aarch64-darwin`, flake-lib's default host set. Its contents are the same on every system.

## Requirements and notes

- The flake provides the recipe, not the application. Adobe's installers are not in the tree: you download them from Adobe and place them under `resources/installers/` yourself. Lightroom Classic itself needs a valid Adobe licence.
- The recipe writes inside its own directory: the Wine prefix under `wineprefix/`, the installers you supply under `resources/installers/`. The store path is read-only, so copy the tree into a writable directory and drive `start.sh` from there. `start.sh` is an interactive menu whose steps have an order. Naming that directory after the pinned revision keeps a new revision from inheriting the previous revision's prefix and downloads.
- Setup needs network access at run time: the Creative Cloud online-installer route downloads Adobe's components as it installs.
- Upstream states these host requirements: 64-bit Linux with working Vulkan drivers, Wine 11.8 staging or newer, `winetricks`, `cabextract`, and vkd3d-proton for GPU acceleration (a Proton or GE-Proton runner also serves), around 10 GB free, and a C toolchain plus mingw-w64 only if you want to rebuild the helper DLLs.
- Presentation defaults to the Wayland driver on a Wayland session and to X11 otherwise. The menu can switch it. HDR is unverified upstream.
- Upstream documents `LR_DPI`, `LR_DRIVER` and `LR_MASKING` for the launcher environment, and reports AI masking working on CPU or AMD GPU, with AI Denoise on AMD. NVIDIA is untested.

See [LICENSE.md](LICENSE.md) for licensing and copyright, and [NOTICE.md](NOTICE.md) for the terms of upstream and distributed artifacts.
