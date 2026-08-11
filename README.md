# car_history

Offline-first Flutter app for tracking car fuelings, maintenance, catalogs, statistics, and backups.

**Status:** preparing for store publication (GitHub Releases / closed testing first). See [docs/STORE_CHECKLIST.md](docs/STORE_CHECKLIST.md).

## License

Source is public under the [PolyForm Noncommercial License 1.0.0](LICENSE).

This is **source-available / noncommercial**, not an OSI “open source” (MIT/Apache-style) license: you may use, study, modify, and share for **noncommercial** purposes. Selling the software (or providing it for others to sell) is not allowed. The copyright holder may still commercialize their own releases.

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution terms.

## Privacy

- Policy: [docs/PRIVACY.md](docs/PRIVACY.md)
- Public URL for store consoles: https://github.com/alexander-bykovskiy/car-history/blob/main/docs/PRIVACY.md

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for layering, CQRS-lite rules, transactions, and DI.

## Stack

- Flutter + Riverpod
- Local SQLite via Drift
- SharedPreferences for display units, currency, and tips

## Quick start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```

Use a Flutter SDK that satisfies `environment.sdk` in `pubspec.yaml`.

## Contributing

Bug reports, feature ideas, and PRs are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) and [ARCHITECTURE.md](ARCHITECTURE.md) before larger changes.

Security issues that could expose local user data: prefer a private report — see [SECURITY.md](SECURITY.md).
