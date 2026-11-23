# Blockside — iOS 12 Minecraft Companion

Blockside is a native Swift/UIKit launcher interface and local content manager for iPhone and iPad. It targets iOS 12.0 and uses no third-party dependencies.

## Important: what this app does

This project provides a launcher-style interface, local inventory, document import, backups, pack organization, and URL downloads. It does **not** contain Minecraft, install or authenticate with Mojang/Microsoft, or execute Java Edition. iOS does not provide a supported way for this app to launch the official Minecraft game engine as a bundled runtime. The Play action therefore reports that no compatible playable installation/runtime is connected; it never pretends to start a game. Imported files are cataloged in the app sandbox and are not automatically installed into Minecraft.

The app supports local `.mcworld`, `.mcpack`, `.mcaddon`, `.zip`, and image imports for organizing files. Importing a file does not imply that its contents are compatible or enabled in Minecraft. Downloads are user-specified URL downloads, not game downloads. Verify sources and compatibility before use.

## Build

Open `Blockside.xcodeproj` in Xcode, select an iOS 12 compatible iPhone/iPad simulator or device, and build. The deployment target is iOS 12.0. No signing team is required for simulator builds. Device installation requires normal Apple code signing.

### Building from Windows

Apple does not provide `xcodebuild` for Windows, and its Command Line Tools package does not include `xcodebuild`. Use a Mac with Xcode installed, or push this project to a GitHub repository and run the included `.github/workflows/ios-build.yml` workflow on a macOS runner. The workflow builds an unsigned iOS Simulator app; it does not produce a signed device app.

## Project structure

- `Blockside/AppDelegate.swift` — app entry point (no iOS 13 scene APIs)
- `Blockside/RootTabBarController.swift` — native tab navigation
- `Blockside/Views.swift` — reusable iOS 12 cards, colors, and controls
- `Blockside/HomeViewController.swift` — dashboard and honest Play status
- `Blockside/LibraryViewController.swift` — imports and local inventory
- `Blockside/PacksViewController.swift` — pack organization and compatibility labels
- `Blockside/DownloadsViewController.swift` — URLSession download list, retry, history
- `Blockside/ProfileViewController.swift` — local/offline profile (no official auth)
- `Blockside/SettingsViewController.swift` — theme, storage, and preferences
- `Blockside/LibraryStore.swift` — sandbox persistence and document imports

## Compatibility and privacy

The app uses UIKit, URLSession, UserDefaults, UIDocumentPickerViewController, and FileManager APIs available on iOS 12. Appearance is selected explicitly because system-wide dark appearance APIs are newer than iOS 12. Imported files stay in this app's Documents directory unless removed in the app. Network transfers only occur after a user supplies a URL.
