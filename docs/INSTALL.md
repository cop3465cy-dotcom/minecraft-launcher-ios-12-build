# Install Blockside on iPhone or iPad

Blockside is distributed as a sideloadable IPA. The file from GitHub Actions is **not signed with this project's Apple developer certificate**. A sideloading app signs it for your device. It is not a direct App Store or web-OTA install.

## Before you start

- An iPhone or iPad running iOS/iPadOS **12.2 or later**.
- A Windows PC or Mac for the initial AltStore setup.
- AltServer from [altstore.io](https://altstore.io/) and AltStore Classic on your device.
- The Blockside IPA from [GitHub Releases](https://github.com/cop3465cy-dotcom/minecraft-launcher-ios-12-build/releases) or a workflow artifact from [Actions](https://github.com/cop3465cy-dotcom/minecraft-launcher-ios-12-build/actions).
- A Minecraft Java Edition account with access to the game, or use the official demo mode where available.

AltStore's current support information lists iOS 12.2 as its minimum. Sideloading and JIT options can differ across iOS versions; check the official [AltStore FAQ](https://faq.altstore.io/) and [Pojav iOS v2.2 setup notes](https://github.com/PojavLauncherTeam/PojavLauncher_iOS/tree/v2.2) if a menu shown here differs on your device.

## 1. Download the IPA

### From a published release

1. On your iPhone/iPad or computer, open the repository's [Releases page](https://github.com/cop3465cy-dotcom/minecraft-launcher-ios-12-build/releases).
2. Open the release you want and download `Blockside-Java-Edition.ipa`.
3. If downloaded to a computer, transfer it to your iPhone/iPad using AirDrop, iCloud Drive, or a USB file-transfer method. Save it somewhere visible in the Files app.

### From GitHub Actions

1. Open [Actions](https://github.com/cop3465cy-dotcom/minecraft-launcher-ios-12-build/actions) and choose a successful **Blockside Java Edition iOS build** run.
2. Under **Artifacts**, download `Blockside-Java-Edition-iOS-12.2` and extract the ZIP on your computer.
3. Transfer `Blockside-Java-Edition.ipa` to the device as above.

Private repositories require GitHub access to download builds. A published release from a public repository is the simpler route for public distribution.

## 2. Install AltStore

1. Install AltServer on your computer from [altstore.io](https://altstore.io/). On Windows, follow AltStore's official guide for the required Apple software and keep AltServer running.
2. Connect the iPhone/iPad to the computer using USB. Unlock the device, tap **Trust** if asked, and enter the passcode.
3. From AltServer's menu, choose **Install AltStore** and select your device. Sign in only in the official AltServer application.
4. On the device, if prompted, open **Settings → General → VPN & Device Management** and trust the developer profile for your Apple Account.

AltStore uses your Apple Account for personal sideload signing. With a free developer account, Apple imposes limits and the installed app may need refreshing periodically. See [AltStore's official FAQ](https://faq.altstore.io/).

## 3. Install Blockside

1. Open AltStore on your iPhone/iPad and select **My Apps**.
2. Tap **+** and select `Blockside-Java-Edition.ipa` in Files.
3. Keep AltStore open while it signs and installs the app. If asked, connect to AltServer on the same Wi-Fi or use USB.
4. Open **Blockside** from the Home Screen.

## 4. Enable JIT

The Java engine depends on JIT (just-in-time compilation) for usable performance. Installing the IPA does not guarantee JIT is active. Pojav's iOS v2.2 support table lists an AltStore/AltServer path for iOS 12.2+, which needs an external computer and Wi-Fi. The exact steps are device and iOS dependent.

1. Keep AltServer running on the computer and connect the device as described by the [Pojav iOS v2.2 JIT guide](https://github.com/PojavLauncherTeam/PojavLauncher_iOS/tree/v2.2).
2. Use the JIT enablement action supported by your AltStore/AltServer version.
3. Keep Blockside in the foreground until JIT is enabled. Force-quitting the app or iOS reclaiming it may end the JIT session.

If you cannot enable JIT on your OS version, the launcher may open but gameplay may be too slow or fail. Consult the official [AltStore JIT guide](https://faq.altstore.io/altstore-classic/enabling-jit) and Pojav's version-specific documentation; don't install profiles or signing tools from unknown websites.

## 5. Sign in and install a game version

1. Open the account area and sign in through the launcher’s official Microsoft authentication flow, or select demo/offline mode if the engine offers it.
2. Select a compatible game version and let the launcher download its files.
3. Press **Play Java Edition** after downloads finish and JIT is enabled.

Only install game files you are entitled to use. Blockside does not ship Minecraft assets or a Microsoft account.

## Troubleshooting

- **The device says the app cannot be installed:** check that it runs iOS 12.2+, the IPA finished downloading, and AltStore/AltServer is up to date and trusted.
- **The app opens but Java will not start or is extremely slow:** re-enable JIT using the method for your iOS version; check free storage and memory; try a lighter compatible game version.
- **The game version requires Java 21:** it is outside this build's Java 8/17 runtime support. Minecraft Java 1.20.5 and later require Java 21.
- **AltStore cannot find the IPA:** save it into Files on the device, then select it with the `+` button in My Apps.
- **An account or download fails:** check network access and use the official account flow. Never send passwords, session tokens, or recovery codes to the project maintainers.
