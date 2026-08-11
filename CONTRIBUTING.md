# Contributing

Thanks for helping improve **car_history**. The app is offline-first Flutter and is preparing for store publication — GitHub issues, PRs, and Releases remain the main collaboration channels. See [docs/STORE_CHECKLIST.md](docs/STORE_CHECKLIST.md).

## Before you start

1. Read [ARCHITECTURE.md](ARCHITECTURE.md) — layering, CQRS-lite, transactions, DI.
2. Use a recent Flutter SDK matching `environment.sdk` in `pubspec.yaml`.
3. Do not commit secrets: signing keys, `.env`, `key.properties`, `*.jks` / `*.keystore`.

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Run on a device/emulator:

```bash
flutter run
```

## How to contribute

1. Open an issue first for larger changes (API/DB schema, UX flows, new features).
2. Keep PRs focused — one concern per PR when possible.
3. Follow existing feature layout under `lib/features/<feature>/` (domain / data / presentation).
4. Prefer thin vertical slices over broad refactors unrelated to the issue.
5. Update or add tests when behavior changes.
6. When changing DB write / merge rules: update **both** feature repositories and
   `backup_import_*.dart`, plus contract tests for **both** paths (see
   Architecture → Backup ↔ runtime write checklist and the checklist on
   `BackupImporter`). Skipping the importer side is a data-corruption risk.
7. Run `flutter analyze` and `flutter test` before opening a PR.

## Pull requests

- Describe **why** the change is needed and how to verify it.
- Link related issues.
- Screenshots or short recordings help for UI changes.
- Do not bump version / create release tags unless maintainers ask.

## Reporting bugs

Include:

- Flutter/Dart version (`flutter --version`)
- Platform (Android / iOS / desktop) and OS version
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs (no personal data from backups/exports)

## Security / private data

This app stores local car and expense data. If you find a vulnerability that could leak user data, prefer a private report to the maintainer instead of a public issue when possible.

## License

By contributing, you agree that your contributions are licensed under the
[PolyForm Noncommercial License 1.0.0](LICENSE).

Third parties may use, modify, and share the software only for **noncommercial**
purposes. Selling the software (or providing it for others to sell) is not allowed.
The copyright holder may still commercialize their own releases separately.
