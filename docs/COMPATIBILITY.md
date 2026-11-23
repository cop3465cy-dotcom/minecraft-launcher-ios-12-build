# Compatibility and limitations

## Platform and engine

| Area | This project supports |
| --- | --- |
| iOS/iPadOS | 12.2 and later; the project uses the archived Pojav iOS v2.2 line |
| CPU/runtime | iOS ARM64 devices; bundled Java 8 and Java 17 |
| Game | Minecraft: Java Edition versions compatible with those runtimes and the engine's graphics stack |
| JIT | Required for usable performance; requires a JIT-enablement method compatible with the device and iOS version |
| Installation | Sideload through a compatible signing tool. The CI IPA is not signed with a Blockside Apple developer certificate |
| Game ownership | Minecraft game files are retrieved after sign-in; no game assets or account are included |

## Java version boundary

Minecraft Java Edition 1.20.5 changed its requirement to Java 21. This build bundles Java 8 and Java 17 only, so 1.20.5 and later are outside its supported range unless the engine and runtime are updated. Mod loaders and individual game releases can have additional requirements.

## JIT and performance

The launcher runs a Java virtual machine on iOS. JIT is needed for acceptable speeds. iOS does not generally allow arbitrary apps to use JIT without an appropriate enablement path. Pojav's iOS v2.2 documentation lists device and OS-dependent methods; read that documentation before installing. Sideloading by itself is not proof that JIT will work.

Older iPhones and iPads may have limited memory, thermal headroom, graphics compatibility, and storage. The game can run slowly or crash even if the launcher installs. This project has been built in CI but gameplay has not yet been validated across physical devices.

## Feature scope

Blockside supplies its custom home dashboard and branding around the Pojav iOS launcher. Game version launch, accounts, Java runtimes, game downloads, controls, and file access come from the legacy engine. This repository does not claim an independent modern mod marketplace, cloud world backup service, universal add-on compatibility, or official Mojang support.

## Keep in mind

- iOS 12.0 and 12.1 are below the engine's minimum.
- Minecraft Java versions requiring Java 21 are not supported by the bundled runtimes.
- Packs and mods can break or exceed device capabilities; compatibility is not guaranteed.
- Use official account sign-in and only game files you are entitled to use.
