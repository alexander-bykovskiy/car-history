# Architecture

Offline-first Flutter app for car history (fuelings, maintenance, catalogs, statistics, backup).

## Layout

```bash
lib/
  app/di/          # Riverpod composition root (providers + overrides)
  app/navigation/  # Cross-feature open helpers + car header chrome
  bootstrap/       # DB seed resolution + AppDependencies factory
  core/            # Pure helpers (units, odometer sequence math, parsing, reminder alerts, car limits)
  shell/           # Main navigation shell (tabs, data page)
  shared/          # Cross-feature Drift DB, TransactionRunner, OdometerRepository,
                   # ExpensesChangeSource, shared UI / domain ports
  features/        # Feature-first Clean Architecture slices
  theme/           # App ThemeData
  l10n/            # Generated localizations
```

Each feature typically has:

- `domain/` — entities, repository ports, use cases
- `data/` — Drift repository implementations, mappers, adapters
- `di/` — Riverpod wiring for ensurers / use cases (when presentation must not import data adapters)
- `presentation/` — pages, form controllers / notifiers

## Cross-feature navigation

Composition-root helpers in `app/navigation/` open feature **pages** and event editors:

- `app/navigation/open_event_forms.dart` — fueling / maintenance editors from Data tabs
- `app/navigation/open_settings_routes.dart` — settings hub destinations (cars, catalogs, …)
- `app/navigation/open_reminders_page.dart` — reminders list from header / statistics / settings
- `app/navigation/car_header_bar.dart` — selected-car chrome for Data / Statistics

Feature modules must **not** import sibling feature **pages** for `Navigator.push`, and must **not** import `shell/` for open helpers. Allowed instead:

- Import sibling **domain** types / repository ports (e.g. events timeline).
- Import catalog **autocomplete widgets** only
  (`features/catalog/presentation/widgets/*_autocomplete_field.dart`) from forms.
- Import fueling / maintenance **timeline tile builders** only from the
  composition-only `events` feature
  (`features/*/presentation/widgets/*_timeline_tile.dart`) so the merged
  “All events” list can reuse the same row UI without owning a data layer.
- Import shared form helpers (`shared/presentation/`, e.g. reminder trigger prepare).
- Import prefs from `features/settings/di/`, not from settings presentation.

`EventTimelineTabShell` (`shared/presentation/event_timeline/`) is feature-free:
callers pass `carId` / `carSelectionLoading` (resolved from `selectedCarProvider`
in the feature tab), not cars DI from shared.

**Intra-feature** navigation (e.g. `cars_page` → `car_form_page`) may use direct
`Navigator.push` of pages in the same feature. Do not add `app/navigation` helpers
for that; helpers are only for cross-feature hops.

## Commands vs queries

- **Commands** (create / update / delete / restore) for DB-backed domain entities: always go through a **use case**, wired via Riverpod providers. The use case is the single place for orchestration, validation mapping, and multi-table side effects.
- **Queries** (watch / list / search / page): UI may call the **repository** directly (streams/futures). Do not wrap every read in a use case.

### Command result layers

Write paths use two typed layers (not three parallel UI enums):

1. **Repository** — persistence / row validation codes (e.g. `FuelingSaveResult` for create/update/invalid*).
2. **Use case** — orchestration failures including catalog ensure (`SaveFuelingFailure`), mapped from repo codes via a thin `map*SaveResultToFailure` helper when needed.
3. **Presentation** — maps the **use-case failure** to field errors / snackbars / l10n. Prefer reusing the use-case failure enum in form notifiers (as fueling does with `SaveFuelingFailure`) instead of introducing a third mirror enum. Fueling / maintenance map failures via `*_failure_messages.dart` helpers.

**Pass-through exception (reminders / thin catalog writes):** when the use case is a thin pass-through with no extra orchestration failures beyond repository codes, presentation may map the repository `*SaveResult` directly (as `ReminderFormNotifier` does with `ReminderSaveResult`). Introduce a use-case `*Failure` enum only when orchestration adds failure modes the repository does not express.

Reference slices: `features/fueling`, `features/maintenance`, `features/cars` (save car = brand ensure via `CarBrandRepository.findOrCreate` + car write; cars-owned brand catalog, not a fueling/maintenance-style ensurer port).

### Exceptions (not use-case commands)

- **Preferences**: unit / currency / tip / locale stores and last part unit (`LastPartUnitStore`) write via Riverpod `AsyncNotifier` → store. Selected car id is owned by `PrefsCarSelectionStore` in `features/cars/data`. Do not add pass-through use cases for SharedPreferences.
- **Statistics**: read-only; presentation controllers may call `StatisticsRepository` and `ExpensesChangeSource` directly.

### Catalog / reminder write use cases

Catalog and reminder CRUD use cases are intentionally thin pass-throughs to repositories. They exist so **every DB command** goes through the same entry point (providers → use case → repository), even when there is no multi-step orchestration. Prefer keeping them over calling repositories from presentation for writes. Multi-step catalog writes (entity + car junction, gas-station chain/location) still wrap the repository call in `TransactionRunner` inside the use case.

### Catalog data layer styles

Keep **exactly three** implementation styles in `features/catalog/data/` — do not invent a fourth parallel stack:

1. **Car-scoped named catalogs** (fuel type, part): one shared
   `NamedCatalogCarScopedStore` + `buildNamedCatalogCarScopedStore`
   (`named_catalog_car_scoped_store.dart`). Domain write surface is
   `NamedCatalogCarScopedWrites` (includes `ensureForCar`). Table-specific
   Drift I/O lives in `named_catalog_car_scoped_drift.dart`
   (`buildFuelTypeCarScopedStore` / `buildPartCarScopedStore`) — thin
   repository impls wrap those factories. Do **not** reintroduce a split
   ops / factory / drift_bundle layer beside the store.
2. **Simple named catalogs** (part unit, service, service center): one shared
   `NamedCatalogSimpleStore` + `buildNamedCatalogSimpleStore`
   (`named_catalog_simple_store.dart`). Table-specific Drift I/O lives in
   `named_catalog_simple_drift.dart` (`buildPartUnitSimpleStore` /
   `buildServiceSimpleStore` / `buildServiceCenterSimpleStore`). Thin
   repository impls wrap those factories; extra fields (service `iconKey`,
   service-center `address`) stay on repo create/update/restore overrides.
   Service centers set `requireWriteOverrides: true` so name-only
   create/update/restore/ensure without overrides throw instead of silently
   dropping `address`. Shared write helpers in `named_catalog_write_helpers.dart`
   (`ensureNamedCatalogSimple`, match/restore helpers) remain the
   orchestration primitives. No car junction.
3. **Gas stations** (chain + location): dedicated `gas_station_query_store` /
   `gas_station_write_store` / `gas_station_ensure` — justified by the
   two-table model; do not force this through `NamedCatalogCarScopedStore`.
   Create vs ensure share soft-delete match classification
   (`SoftDeleteMatchKind` / `catalogCreateConflictResult` in
   `catalog_save_result.dart`) and `GasStationWriteStore.findLocationMatching`;
   they differ only on soft-deleted policy (confirm vs auto-restore).

Car-scoped ensure API is always `ensureForCar(rawName, carId)` on the repository
**and** on feature ensurer ports that wrap it (`FuelTypeEnsurer`, `PartEnsurer`).
Simple catalogs keep `ensure(rawName)`. Do not mix the two names for the same
semantics.

Fuel type / part ↔ car junction queries share `NamedCatalogCarScope` in catalog data (list-for-car without N+1).

Reminder completion is written via `SaveReminderUseCase` (`ReminderInput.isCompleted`), not a separate set-completed command.

**ReminderLinker exception:** UI reminder CRUD goes through `SaveReminderUseCase`.
Maintenance reminder sync / soft-delete on maintenance delete uses `ReminderLinker`
(`features/maintenance/domain/repositories/reminder_linker.dart`) →
`ReminderRepository` **directly** (via `ReminderLinkerAdapter`), not via
`SaveReminderUseCase`. That is intentional:
sync and delete participate in the outer `SaveMaintenanceUseCase` /
`DeleteMaintenanceUseCase` / `TransactionRunner` scope,
and nesting the reminder use case would duplicate abort semantics. Call
`ReminderRepository` from a linker **only** inside that maintenance transaction —
do not use this pattern for standalone reminder writes from presentation.
On sync update, the linker **preserves** `existing.isCompleted` (maintenance UI
does not own completion status).

Fueling gas-station ensure: when the user entered a non-empty station name and
ensure returns null, `SaveFuelingUseCase` aborts with
`SaveFuelingFailure.gasStationEnsureFailed` (same abort style as empty fuel
type). Do not silently save the fueling with `gasStationId = null`.

Fueling / maintenance catalog ensure ports live in each feature's
`catalog_ports.dart`. Shared ensure result shape is
`EnsuredCatalogItem` (`shared/domain/ensured_catalog_item.dart`).
Outcome → DTO mapping (`ensuredCatalogItemFromSave`) lives in
`catalog/domain/ensurer_outcome_mapping.dart` so sibling feature data
adapters do not import `catalog/data`.

### Events (composition-only)

`features/events` has no data layer. Presentation aggregates fueling + maintenance repository queries (dual-source timeline). Navigation into editors goes through `app/navigation` helpers. Events DI re-exports read ports from `app/di` (not sibling feature `di/`).
Shared list chrome (scroll threshold, viewport fill, month grouping) lives in
`EventTimelinePagedShell` (`shared/presentation/event_timeline/`); single-source
tabs use `PagedEventTimelineList`, All Events uses the same shell with
`DualSourcePagedController`.

## Transactions

Multi-step writes that must stay consistent use `TransactionRunner`
(`shared/domain/transaction_runner.dart`), implemented by `DriftTransactionRunner`.

**When to use `TransactionRunner`:**

- Required for multi-table / multi-step commands (ensure catalog + write event, entity + junction, delete chain + locations, maintenance + parts + reminders).
- **Not** required for single-table create/update/delete (e.g. `DeleteFuelingUseCase`, single-row gas-station chain rename). Do not wrap single writes only for signature symmetry.
- **Delete rule of thumb:** `DeleteMaintenanceUseCase` and `DeleteGasStationChainUseCase` use a transaction (row + reminder soft-delete / chain + locations). `RestoreGasStationChainUseCase` also uses a transaction (chain + cascade location undelete). `DeleteFuelingUseCase` does not (single table).

Inside a use case, domain failures after partial writes must **abort** the
transaction (throw `TransactionAbort<T>`) so Drift rolls back. Returning a failure
result without aborting would commit side effects (e.g. soft-deleted reminders,
orphan catalog brands).

Canonical examples:

- `SaveMaintenanceUseCase` — catalog ensure + reminder sync + maintenance + parts
- `SaveFuelingUseCase` — fuel type / gas station ensure + fueling
- `SaveCarUseCase` — brand ensure + car create/update (limitReached rolls back brand)
- Catalog multi-step saves/deletes (fuel type / part ↔ cars, `DeleteGasStationChain`) — thin use case + `TransactionRunner`
- Gas-station chain soft-delete cascades to all locations; `restoreChain` undeletes
  those soft-deleted locations in the same write path (symmetric with delete)
- Single-table: `DeleteFuelingUseCase`, `SaveGasStationChainUseCase` create/update — no tx

`ReminderLinker` must not swallow create/update failures; failed sync aborts the
maintenance transaction via `SaveMaintenanceFailure.reminderSyncFailed`.

Repositories perform plain writes; they do **not** open nested transactions when
the use case already owns the outer `TransactionRunner` scope.

**Gas station ensure:** `GasStationRepository.ensureFromInput` (chain + location) must run inside an outer use-case transaction (e.g. `SaveFuelingUseCase`). Do not call it as a standalone write without a surrounding `TransactionRunner`.

**Exception:** bulk backup import may open a single `_db.transaction` inside
`BackupImporter` (bypassing feature repositories). Do not use that pattern for
ordinary feature writes. Import merge / soft-delete / uniqueness must stay aligned
with runtime repos: active named-catalog unique names, `Fuelings.gasStationId` =
location id, car count cap (`kMaxCars`), car photo soft limit. When changing
schema or write rules, update both feature repositories and `backup_import_*.dart`.

### Backup ↔ runtime write checklist

When changing schema or write/merge rules, update **both** paths and cover with
tests before merge:

1. Feature repository / use case under `features/*/data` (runtime writes).
2. Matching section in `features/settings/data/backup/backup_import_*.dart`.
3. Shared constants / helpers stay shared — do not copy magic numbers or
   normalize/match loops into the importer:
   - Caps: `kMaxCars`, `kMaxCarPhotoBytes` (via `isCarPhotoTooLarge` in
     `features/cars/domain/car_write_validation.dart`)
   - Names: `NameNormalizer`, `matchNamedCatalogRow` / `findNamedCatalogMatch`
     (`core/named_match.dart`)
   - Optional free text (empty → null): `OptionalString.normalize`
   - Gas-station addresses: `GasStationAddress.normalize` / `.same` /
     `.findLocationIn` (`backup_import_gas_stations.dart`; `.same` is used
     inside `.findLocationIn`)
   - Event numeric rules: `validateFuelingWrite` / `validateMaintenanceWrite` /
     `validateReminderWrite`
4. Contract tests: runtime rule test **and** backup import test for the same
   invariant (see `test/features/settings/backup_importer_test.dart` and feature
   write tests). Cursor rule: `.cursor/rules/backup-runtime-dual-path.mdc`
   (includes runtime ↔ backup file pairing). PR template
   (`.github/PULL_REQUEST_TEMPLATE.md`) has a dual-path checklist — mark N/A
   when the change does not touch write rules / schema / merge.

## Dependency injection

- Single root `ProviderScope` in `main.dart` (nested scopes break overrides).
- Bootstrap via `AppDependencies.create()` (`bootstrap/app_dependencies.dart`).
- Composition root: `app/di/app_providers.dart` re-exports
  `app_repository_providers.dart` (DB ports throw until overridden), prefs /
  car-selection store defaults from feature di
  (`features/settings/di/preference_store_providers.dart`,
  `features/cars/di/car_selection_store_provider.dart`), and app-chrome
  `selectedCarProvider` (`app/di/selected_car_provider.dart`).
- Cross-feature UI (shell tabs, statistics, reminders, catalog bind, `main.dart`,
  `app/navigation`) must import `selectedCarProvider` from `app/di`, not from
  `features/cars/di`. Cars feature DI re-exports it for intra-feature pages.
- Feature use-case / ensurer providers live in `features/*/di/`. Presentation must not import `data/` adapters for wiring.
- Feature `di/` may re-export repository ports from `app/di/app_providers.dart` so pages avoid scattering composition-root imports for reads. Re-export **only** ports that feature presentation / DI actually uses (no unused sibling signals).
- Prefs / backup providers live in `features/settings/di/` (not under presentation).
  Cross-feature UI may import `features/settings/di/preferences_providers.dart`
  (units, currency, tips, locale, last part unit) — settings is the intentional
  prefs hub for this app size. Do **not** import settings `presentation/` for
  prefs. `LastPartUnitStore` is wired under settings DI even though only
  maintenance consumes it; do not invent a second prefs DI root without a real
  split of settings vs backup.
- Do **not** route bulk backup import through feature repositories “for purity”
  (see Backup ↔ runtime write checklist). Prefer keeping dual-path discipline
  over a large backup↔repository unification.
- Cross-feature open helpers and car header chrome live in `app/navigation/` (composition root). Do not import sibling feature pages for `Navigator.push`. Do not import `SelectedCarHeader` from sibling features; use `app/navigation/car_header_bar.dart`.

## Persistence

- SQLite via Drift (`shared/data/db/app_database.dart`).
- Schema upgrades: `onUpgrade` orchestration lives in
  `shared/data/db/migrations/schema_upgrades.dart` (part of `AppDatabase`);
  legacy migrators in `migrations/legacy_migrators.dart`; seeds in
  `seeds/database_seeds.dart` (all `part of` the database library).
- Cross-event odometer queries: `OdometerRepository` port
  (`shared/domain/odometer_repository.dart`), Drift impl `OdometerRepositoryImpl`.
- Units: domain types in `core/units.dart`; persistence via `UnitPreferencesStore`.
  Import unit **types** from `core/units.dart`, not via settings preference providers.
- Backup: `BackupRepository` + `ExportBackupUseCase` / `ShareBackupUseCase` /
  `ImportBackupUseCase` (`features/settings`). Export can save via the system
  file dialog or share the JSON through the platform share sheet. Import
  sections are split under
  `features/settings/data/backup/backup_import_*.dart` with a thin facade
  (`backup_import_events.dart` → reminders / fuelings / maintenances;
  `backup_import_named_catalogs.dart` → services/centers + gas stations).
  Failures use typed `BackupFailure` (not string codes). Import bypasses feature
  repos (see Transactions exception); keep importer invariants aligned with
  runtime write rules when the schema changes. Event import requires resolvable
  catalog FKs that runtime ensure would create (`fuelTypeId`, `serviceId`,
  `partId`); optional FKs (`gasStationId`, `reminderId`, `unitId`) may be null
  only when absent in the backup — a present but unmapped id is skipped
  (`counters.skipped`), not silently nulled.
- Soft car count cap: `kMaxCars` in `core/car_limits.dart` (shared by cars + backup import).
- Car photo BLOB soft limit: `kMaxCarPhotoBytes` in `core/car_photo_limits.dart`,
  enforced via `isCarPhotoTooLarge` (`features/cars/domain/car_write_validation.dart`)
  in `CarRepository` create/update, gallery pick UX, and backup import
  (oversized import photos are dropped to null). Gallery pick still uses
  `ImagePicker` maxWidth/quality before the byte check.
- Currency / tips: `CurrencyPreferencesStore` / `TipPreferencesStore`.
- Last part unit: `LastPartUnitStore` (`PrefsLastPartUnitStore`).
- Locale preference: `AppLocaleOption` in settings domain is Flutter-free
  (`languageCode` only); `MaterialApp.locale` maps the code in `main.dart`.
- Seed default car color: bootstrap reads `kCarColorOptions` from
  `theme/car_theme_config.dart` (not presentation widgets).
- `ExpensesChangeSource` port lives in `shared/domain`. Bootstrap installs
  `MergedExpensesChangeSource` from `features/statistics/data` (composition of
  fueling + maintenance change streams — not in `shared/`, so shared does not
  depend on feature ports). Reminder alert invalidation
  (`ReminderRepository.watchAlertLevel`) reuses the same change source so
  fueling/maintenance writes refresh odometer-based alerts without raw table
  watches in reminders data.
- Active named-catalog names are unique in SQLite via partial unique indexes
  (`lower(trim(name)) WHERE is_deleted = 0`; locations:
  `(chain_id, lower(trim(coalesce(address,''))))`). Soft-deleted rows may share
  names with each other and with an active row; restore/create conflict handling
  stays in `findNamedCatalogMatch` + `named_catalog_write_helpers.dart`.
  Name match helpers prefer an **active** row over a soft-deleted one with the
  same normalized name (runtime and backup import). Prefer restoring through a
  single `restore(..., fields)` call rather than restore + separate update.
- Gas-station location addresses use `GasStationAddress.normalize` /
  `.findLocationIn` on **every** write path (ensure, update, restore, backup
  import insert) so blank strings become SQL null and stay aligned with the
  uniqueness index. Ensure resolves matches via
  `GasStationWriteStore.findLocationMatching` (which calls `.findLocationIn`);
  backup import may call `.findLocationIn` directly. Like named-catalog name
  match, `findLocationIn` prefers an **active** location over a soft-deleted
  one with the same chain + address.
  Service-center addresses use the same empty→null rule via
  `OptionalString.normalize`.
- Gas-station **create** (UI catalog) returns `needsRestoreConfirm` for
  soft-deleted name/address conflicts. **ensure** (fueling pick / sync) still
  auto-restores — do not wire create through ensure.
- Service centers are catalog-only (no FK from events). `hasReferences` is
  always false → runtime delete is always hard delete. Soft-deleted center
  rows appear only via backup import; catalog UI keeps restore for that path
  (not because runtime soft-deletes centers).
- Service backup merge matches by name only and **skips** updating `iconKey` on
  an existing active row (import keeps the runtime icon). Soft-deleted → active
  restore still does not rewrite `iconKey`.
- Service-center backup merge matches by name only. An **active** match skips
  updating `address` (keeps runtime address, same policy as service `iconKey`).
  Soft-deleted → active restore **applies** the backup address (aligned with
  runtime `restore(..., address:)`).
- `Fuelings.gasStationId` stores a **location** id (`GasStationLocations`), not a chain id.
- Privacy policy: `docs/PRIVACY.md` (public GitHub URL). Settings opens it in
  the device browser via `openPrivacyPolicy` — no in-app policy page.

## UI conventions

- Forms bind widgets; submit/validation preparation lives in presentation `*_form_prepare.dart` files (pure helpers such as `prepare*Save`, not ChangeNotifier classes). Reference: fueling, maintenance, **car** (`prepareCarSave`).
- Reminder date / odometer / remind-before UI is shared via
  `ReminderTriggerFields` (`shared/presentation/reminder_trigger_fields.dart`);
  prepare/session stay in `reminder_trigger_form.dart` /
  `reminder_trigger_session.dart`. Do not duplicate the switch + field layout
  in feature form pages.
- Form session state (load / field sync / save / delete) lives in a `*FormNotifier` (`ChangeNotifier`) where the form is non-trivial; reference: maintenance, fueling, reminder, **car**.
- `*FormNotifier` must **not** take `WidgetRef`. The page reads providers and passes use cases / repositories into notifier methods.
- Fueling / maintenance form delete returns the same `*FormSubmitOutcome` sealed type as save (not `bool`). Unexpected throws from save/delete map to `*FormSubmitUnexpected` and the page shows `formActionFailed` via SnackBar. Domain field vs snack split stays feature-specific (maintenance non-field failures use `snack(SaveMaintenanceFailure)`).
- Write validation for persisted entities lives in feature domain helpers
  (`features/fueling/domain/fueling_write_validation.dart`,
  `features/maintenance/domain/maintenance_write_validation.dart`,
  `features/reminders/domain/reminder_write_validation.dart`,
  `features/cars/domain/car_write_validation.dart`);
  repository `_validate` / write path, presentation `prepare*` / pick helpers
  (after parse / unit conversion), and backup import all call them. Do not
  duplicate numeric domain rules in the page or importer.
  Reminder **trigger** rules (empty trigger / remind-before / non-negative
  `dueOdometerKm`) live in
  `core/reminder_trigger_write_validation.dart` so shared form prepare can
  close the same loop without `shared` → `features` imports; feature
  `validateReminderWrite` adds title and maps to `ReminderSaveResult`.
  Keep form, repository, and backup on this helper — do not reintroduce a
  UI-only numeric gate that backup/repo skip.
- Catalog create/update UI outcomes share `handleCatalogSaveResult` /
  `handleCatalogSaveResultForItem`
  (`features/catalog/presentation/catalog_save_result_handler.dart`).
  Dialog submit wiring (mounted check + messages + restore) goes through
  `submitCatalogDialogSave` / `submitCatalogDialogSaveForItem`
  (`features/catalog/presentation/catalog_dialog_submit.dart`).
- Form currency selection is local to the form; app-wide default currency is changed only in Settings. Shared pick helper: `pickFormCurrencyCode` (`shared/presentation/currency_code_field_button.dart`).
- Shared dialogs (delete confirm, catalog restore confirm, odometer sequence warning)
  live in `shared/presentation/`.
- List tip banners share `ListTipBanner` (`swipe_delete_tip` / `double_tap_edit_tip`).
- Guard against double-submit (`_saving`) before any async work on save
  (including catalog name dialogs).
- Event odometer sequence check: `shared/domain/event_odometer_warning.dart`
  (depends on `OdometerRepository`; pure math stays in `core/odometer_sequence.dart`).
  Form notifiers call `confirmEventOdometerIfNeeded` (same file) rather than
  inlining the warning + confirm branch.
- Catalog create/update outcome codes share `CatalogSaveResult`
  (`features/catalog/domain/entities/catalog_save_result.dart`) for named
  catalogs, places, and services (no per-entity typedef aliases).
  `restored` means ensure already undeleted a match; `needsRestoreConfirm`
  means create/update found a soft-deleted name conflict (UI asks first).
- Presentation imports unit **types** from `core/units.dart`, not from settings data.
- User-facing list/bootstrap errors use l10n (`listLoadError` / `appStartFailed`); do not show raw exceptions.

## Testing

- Prefer in-memory Drift (`NativeDatabase.memory()`) for repository / use-case tests.
- Domain pure helpers (`core/`, timeline merge, `prepare*`, write validators) have unit tests without Flutter where possible.
- Use-case tests should cover `TransactionAbort` rollbacks (catalog ensure + failed write) and multi-table deletes (maintenance + reminder, gas-station chain).
- Backup import contract tests must stay aligned with runtime write caps / merge rules (see Backup ↔ runtime write checklist above).
- Dual-path hygiene: `test/architecture/backup_dual_path_test.dart` fails if
  backup import stops importing / calling the shared write validators, car
  caps / `isCarPhotoTooLarge`, named-catalog match helpers, or gas-station
  address helpers (`backup_import_gas_stations.dart`) — or if runtime event
  repos, car brand/car repositories, simple/car-scoped catalog writes, or gas
  write/ensure stores stop calling the same helpers. It also asserts the
  runtime ↔ backup pairing files exist and that the PR template / Cursor rule
  still document the checklist. Keep both sides of each checklist item asserted
  (backup section + matching runtime path). See the pairing table in
  `.cursor/rules/backup-runtime-dual-path.mdc`.
- Dual-path **behavior** parity:
  `test/features/settings/backup_runtime_write_parity_test.dart` asserts that
  payloads rejected by `validateFuelingWrite` / `validateMaintenanceWrite` /
  `validateReminderWrite` are also skipped by backup import (not only that
  helpers are imported).
- Events composition: `test/architecture/events_composition_test.dart` fails if
  `AllEventsTab` / `FuelingsTab` / `MaintenanceTab` stop routing opens through
  `app/navigation/open_event_forms.dart` (or start importing sibling form pages).
  Widget smoke coverage lives in
  `test/app/navigation/open_event_forms_test.dart` and
  `test/features/events/all_events_open_forms_test.dart`.
- Presentation commands: `test/architecture/presentation_commands_test.dart`
  fails if feature presentation calls repository write methods directly
  (`create` / `update` / `delete` / `restore` / `ensure` / `ensureForCar` /
  `ensureFromInput`) instead of use cases — including locals named `*Repo` /
  `*Repository` / `repository` (not only `repository.` / `*RepositoryProvider`).
- Layer boundaries: `test/architecture/layer_boundaries_test.dart` fails if
  `features/*/presentation` imports feature `data/`, sibling `presentation/pages/`,
  sibling presentation outside the autocomplete / events timeline-tile allowlist,
  or `shell/`; also if `domain`/`core` import Flutter, `shared` imports `features/`,
  `domain` imports `data/`, `data` imports `presentation/`,
  or `*_form_notifier.dart` imports `flutter_riverpod`.
- Catalog car-scoped data style:
  `test/architecture/catalog_car_scoped_store_test.dart` fails if the retired
  `named_catalog_car_scoped_{ops,factory,drift_bundle}.dart` files reappear, or
  if fuel type / part repositories stop depending on
  `named_catalog_car_scoped_store.dart` / `named_catalog_car_scoped_drift.dart`.
- Catalog simple-named data style:
  `test/architecture/catalog_simple_store_test.dart` fails if part unit /
  service / service center repositories stop depending on
  `NamedCatalogSimpleStore` / `named_catalog_simple_drift.dart`, if
  `restore` bypasses `_store.restore`, or if service centers drop
  `requireWriteOverrides` / repo write overrides for address.
