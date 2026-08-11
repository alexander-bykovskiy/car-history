# Summary

<!-- What changed and why -->

## How to test

- [ ] `flutter pub get`
- [ ] `dart run build_runner build --delete-conflicting-outputs` (if codegen touched)
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] Manual check on device/emulator (describe steps)

## Backup ↔ runtime dual-path

Required when this PR changes schema, soft-delete / uniqueness, caps, or write
validation (including shared helpers in `core/` or `*_write_validation.dart`).

Otherwise check **N/A**.

- [ ] N/A — no write-rule / schema / merge changes
- [ ] Runtime path updated (`features/*/data` repository and/or use case)
- [ ] Matching `backup_import_*.dart` section updated (see pairing in
      `.cursor/rules/backup-runtime-dual-path.mdc`)
- [ ] Shared helpers reused — no copied normalize/match/cap/validation loops
- [ ] Contract tests on **both** sides
      (`test/features/settings/backup_importer_test.dart` /
      `backup_runtime_write_parity_test.dart` or sibling **and**
      feature write / validation test)
- [ ] `test/architecture/backup_dual_path_test.dart` still green (update it if
      helpers or backup sections were intentionally split)

## Notes

<!-- Screenshots, linked issues, breaking changes -->
