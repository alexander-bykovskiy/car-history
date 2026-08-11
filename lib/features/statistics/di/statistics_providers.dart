/// Statistics DI: re-exports read ports from the composition root.
library;

export '../../../app/di/app_providers.dart'
    show expensesChangeSourceProvider, statisticsRepositoryProvider;
