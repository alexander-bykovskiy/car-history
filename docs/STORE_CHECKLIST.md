# Store publication checklist

Status: **preparing for store** (not yet submitted). Use this when filling Google Play Console and App Store Connect.

## Privacy Policy URL

Use the rendered GitHub page (preferred over `raw.githubusercontent.com`):

[Privacy policy on GitHub](https://github.com/alexander-bykovskiy/car-history/blob/main/docs/PRIVACY.md)

Source file: [PRIVACY.md](PRIVACY.md). Settings opens this public URL in the
device browser (no offline in-app copy).

If a store rejects a GitHub blob URL, publish the same markdown via GitHub Pages and update this checklist and `kPrivacyPolicyUrl`.

## Google Play — Data safety (suggested answers)

- **Does your app collect or share user data?** No (data stays on device; no collection to developer servers).
- **Data types on device only:** app activity / financial info (expenses) / photos (optional car photo) / other personal — all **not collected** by the developer; processed locally.
- **Encryption in transit:** N/A for app data (no developer backend). User-initiated backup files are written by the user.
- **Account creation:** No.
- **Independent security review:** No (unless you obtain one later).

Confirm wording against the current Play Console questionnaire; policies change.

## App Store — Privacy Nutrition Labels (suggested)

- **Data Not Collected** if you ship without analytics/crash SDKs and without account sync (current codebase).
- If you later add analytics or accounts, update [PRIVACY.md](PRIVACY.md) and labels before release.

## iOS Info.plist

- [x] `NSPhotoLibraryUsageDescription` — gallery pick for car photo (required if `image_picker` gallery is used).
- Camera usage key: **not** required while camera source is unused.

## Android

- Prefer system Photo Picker; avoid broad storage permissions unless a dependency forces them.
- Review `image_picker` / target SDK notes before each store upload.

## Signing & secrets

- Do **not** commit `key.properties`, keystores, or `.env`.
- Use Play App Signing / local release keystore outside the repo.

## Pre-upload smoke

- [ ] Fresh install → create car → fueling → maintenance → reminder
- [ ] Export backup → import on clean install (or second device)
- [ ] Privacy settings item opens the GitHub policy URL in the browser
- [ ] TalkBack / VoiceOver: main tabs, FAB, delete confirm
- [ ] Photo pick respects size limit messaging
- [ ] List error states show localized text (not raw exceptions)

## Versioning

Bump `pubspec.yaml` version when cutting a store-candidate build. See release notes / GitHub Releases.
