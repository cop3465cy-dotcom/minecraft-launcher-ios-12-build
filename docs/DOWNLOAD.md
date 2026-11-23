# Downloads and releases

## Current build

The latest successful workflow uploads an artifact named **Blockside-Java-Edition-iOS-12.2**. Open [GitHub Actions](https://github.com/cop3465cy-dotcom/minecraft-launcher-ios-12-build/actions), choose a successful run, and download the artifact. Extract it to get `Blockside-Java-Edition.ipa`.

The repository is currently private, so you need GitHub access to download Actions artifacts. A maintainer can publish a public release after making the repository public and reviewing the source and licensing.

## Installing a download

The IPA is a device package for sideloading. Use AltStore or another compatible sideloader to sign and install it on your device, then enable JIT for gameplay. It is not an App Store package or a one-tap OTA install. Follow [Install on iPhone or iPad](INSTALL.md).

## Checksums

For a downloaded IPA, a maintainer can calculate SHA-256 locally:

```powershell
Get-FileHash .\Blockside-Java-Edition.ipa -Algorithm SHA256
```

Compare the value to a checksum published alongside that exact release. Do not install an IPA if its checksum differs.
