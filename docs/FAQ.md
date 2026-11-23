# Frequently asked questions

### Is this a real Minecraft launcher?

Yes. The IPA is built from the PojavLauncher iOS v2.2 Java Edition engine, with a Blockside-designed interface. The engine runs the actual Java client using its iOS runtime and graphics stack. Gameplay has not yet been verified on a physical device.

### Is Minecraft included?

No. The launcher obtains game files after sign-in. You need a valid entitlement or the official demo where available.

### Can I install it by opening a web link?

Not with the current build. The IPA is not signed with a registered-device Apple provisioning profile. Download it and install through a sideloading app such as AltStore, which signs it for your device. Direct OTA installation needs a suitable Apple-signed package and provisioning profile.

### Does it work on iOS 12?

It targets iOS 12.2 and later. iOS 12.0 and 12.1 are unsupported. JIT setup varies by OS and device and may require a computer.

### Which Minecraft versions work?

The IPA includes Java 8 and Java 17. Minecraft 1.20.5 and later require Java 21, so they are not supported by this build.

### Why does the app need JIT?

The Java virtual machine uses just-in-time compilation for usable game performance. iOS restricts JIT and requires a compatible enablement setup. Follow the Pojav iOS v2.2 guide for the method that matches your device.

### Is it official or endorsed by Mojang/Microsoft?

No. Blockside is an independent community project and is not affiliated with or endorsed by Mojang or Microsoft.

### Where are actual screenshots?

The gallery currently contains concept illustrations, clearly labeled as such. We have not captured gameplay or UI screenshots from a physical iOS device yet. See [Media notes](MEDIA.md) before publishing images.
