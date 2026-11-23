# Build from source

## Automated build

The [iOS build workflow](../.github/workflows/ios-build.yml) runs on a macOS GitHub Actions runner. It installs Java 8 and native tools, builds the Pojav iOS v2.2 app for iOS devices, and uploads `Blockside-Java-Edition-iOS-12.2` as an artifact. The first full build takes several minutes because it compiles native code and downloads the Java runtimes.

To run it manually, open **Actions → Blockside Java Edition iOS build → Run workflow**. The repository must have Actions enabled.

## Local macOS build

Requirements: macOS with Xcode command line tools, Java 8, CMake, GNU Make, `wget`, and `ldid`.

```sh
brew install cmake ldid make wget
cd Engine/PojavLegacy
export BOOTJDK="$(/usr/libexec/java_home -v 1.8)/bin"
gmake -j2 JOBS=2 RELEASE=1 package PLATFORM=2
```

The device IPA is written to `Engine/PojavLegacy/artifacts/net.kdt.pojavlauncher-2.2-ios.ipa`. The build fetches the Java 8 and Java 17 iOS runtime archives from the configured public runtime source.

## Output and signing

CI creates an iOS device IPA with the project's build signing step. It is not signed using a Blockside Apple Developer distribution certificate or a device-specific provisioning profile. To install, use a compatible sideloader that signs for the target device. Do not describe this output as an App Store-signed build or as ready for direct OTA installation.

## Source layout

- `Engine/PojavLegacy/` — active iOS launcher, Java/native engine, UI integration, upstream notices.
- `Blockside/` and `Blockside.xcodeproj/` — earlier standalone UIKit prototype, not the active game build.
- `.github/workflows/ios-build.yml` — device IPA build and artifact upload.
- `docs/` — installation, compatibility, publication, and media guides.
