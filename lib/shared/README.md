# Shared cross-feature code

- `domain/` — ports (`TransactionRunner`, `OdometerRepository`), shared shapes (`EnsuredCatalogItem`)
- `data/db/` — Drift schema (`AppDatabase`, seeds)
- `data/odometer_repository_impl.dart` — Drift implementation of `OdometerRepository`
- `presentation/` — shared UI (autocomplete fields, tips, catalog list, restore confirm, timeline tiles, `service_icons`, reminder trigger prepare / fields, unit short labels, `pickFormCurrencyCode`)

Car header chrome lives in `app/navigation/car_header_bar.dart` (composition root); the widget itself stays in `features/cars/presentation/widgets/selected_car_header.dart`.
