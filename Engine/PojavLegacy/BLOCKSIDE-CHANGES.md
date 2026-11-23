# Blockside engine and notices

The Java Edition runtime and native launcher foundation in this directory are based on PojavLauncher for iOS v2.2 (`d9877bc423a4a66124f79e7403779652685ace2c`). The upstream project is archived; its v2.2 source is the final release line that supports iOS 12/13. This Blockside fork is modified and independently branded. Source changes and their dates are tracked in this repository.

PojavLauncher and its applicable combined work are licensed under GNU GPL version 3. See [`LICENSE`](LICENSE) and the upstream [`README.md`](README.md) for notices and third-party licenses. The project must remain accompanied by its corresponding source when binaries are conveyed.

The legacy engine's minimum supported system is iOS 12.2. It requires a compatible JIT-enablement path for playable performance. The bundled Java runtimes and Minecraft libraries are not included in this source; the launcher obtains supported game files from their official distribution endpoints after the user signs in. Users need a valid Minecraft: Java Edition entitlement (or use the official demo mode where available).
