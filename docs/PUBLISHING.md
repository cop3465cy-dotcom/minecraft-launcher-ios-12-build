# Publishing Blockside

This checklist prepares a release for a maintainer. It does not make the repository public or publish a release automatically.

## Before publishing the repository

1. Review the source, history, issue templates, Actions logs, and repository secrets for private information. Never commit signing keys, provisioning profiles, account data, or personal device identifiers.
2. Review [`LICENSE`](../LICENSE), [`Engine/PojavLegacy/LICENSE`](../Engine/PojavLegacy/LICENSE), upstream acknowledgements, third-party notices, and GPL-3.0 source obligations.
3. Keep the app description clear that Blockside is unofficial, runs the Pojav iOS engine, requires iOS 12.2+ and JIT, and does not include Minecraft files.
4. Replace concept previews with screenshots captured from a real, working device before labeling them as screenshots. See [Media notes](MEDIA.md).
5. In GitHub, open **Settings → General → Danger Zone → Change repository visibility** and make the repository public only after reviewing all content.
6. Still in **Settings → General**, upload `docs/assets/blockside-cover.png` as the repository social preview image.

## Build a draft release

From a clean `master` checkout, choose a version and push an annotated tag. For example:

```sh
git tag -a v0.1.0 -m "Blockside 0.1.0"
git push origin v0.1.0
```

The workflow builds the device IPA and attaches it to a **draft GitHub Release**. A maintainer should:

1. Open **Releases** and review the draft notes and IPA asset.
2. Confirm compatibility claims, install steps, source availability, and any known issues.
3. Add the matching source archive or link to the exact source tag. The source must correspond to the distributed binary under GPL-3.0.
4. Publish the release when it is ready.

The IPA is for sideloading and is not a direct OTA installation package. Do not call it signed for public installation. Each user needs a compatible installation/signing setup.

## Publish the documentation site (optional)

The `docs/` directory contains a small project page and guides. If GitHub Pages is available for the repository:

1. Open **Settings → Pages**.
2. Under **Build and deployment**, choose **Deploy from a branch**.
3. Choose `master` and `/docs`, then save.
4. Wait for GitHub Pages to finish, open the generated site URL, and check it on phone and desktop.

The download button points to the latest GitHub Release. It will work after a release is published and the repository is publicly reachable.

## Do not claim

- App Store approval, Apple signing, direct OTA installation, or device-tested gameplay when those have not happened.
- Compatibility with Java 21 versions using this Java 8/17 build.
- Mojang/Microsoft affiliation, official status, or included game ownership.
