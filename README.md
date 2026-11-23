# Blockside — Minecraft: Java Edition for iOS

Blockside is a custom iPhone/iPad launcher interface built around the PojavLauncher iOS v2.2 engine. The engine starts real Minecraft: Java Edition using an iOS ARM64 OpenJDK runtime and the upstream native rendering/input stack. It does not bundle Minecraft game files: a player signs in and obtains game assets from the official distribution services.

## iOS compatibility

The legacy engine line targets **iOS 12.2 and later**. PojavLauncher dropped iOS 12/13 support in later versions and its iOS repository was archived; the supported iOS 12 line is therefore a legacy base. This build includes Java 8 and Java 17 runtimes. Game versions requiring newer Java runtimes are outside this build's supported range. Device performance and RAM also limit which versions can run well.

The Java runtime uses JIT for usable game performance. iOS requires an appropriate JIT-enablement method; sideloading alone does not guarantee that JIT will be available. The compatible method depends on iOS version, signing method, and device setup.

## Build and install

The GitHub Actions workflow builds an iOS **device IPA** and uploads it as `Blockside-Java-Edition-iOS-12.2`. The artifact is a sideload package; it still needs a compatible signing and JIT setup for the target device. It is not a simulator app or a normal App Store install.

For a local macOS build, install Xcode, Java 8, CMake, `ldid`, GNU Make, and `wget`, then run:

```sh
cd Engine/PojavLegacy
BOOTJDK="$(/usr/libexec/java_home -v 1.8)/bin" gmake -j2 JOBS=2 RELEASE=1 package PLATFORM=2
```

The build downloads the required OpenJDK 8/17 runtime archives. The app downloads Minecraft version metadata, libraries, and assets at runtime after player sign-in.

## Interface and engine

`Blockside/` contains the earlier UIKit dashboard prototype. `Engine/PojavLegacy/` contains the active Java Edition engine and launcher. The dashboard redesign is being integrated into the engine's native iOS shell so the custom interface launches the real game.

The engine source is based on PojavLauncher iOS v2.2, commit `d9877bc423a4a66124f79e7403779652685ace2c`. It is licensed under GPL-3.0; see [`Engine/PojavLegacy/LICENSE`](Engine/PojavLegacy/LICENSE), [`Engine/PojavLegacy/README.md`](Engine/PojavLegacy/README.md), and [`Engine/PojavLegacy/BLOCKSIDE-CHANGES.md`](Engine/PojavLegacy/BLOCKSIDE-CHANGES.md). Third-party component notices are retained in the upstream README.
