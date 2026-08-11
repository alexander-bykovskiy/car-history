import 'dart:async';

import 'package:car_history/features/events/presentation/dual_source_paged_controller.dart';
import 'package:car_history/shared/presentation/paged_event_list_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PagedEventListController', () {
    test('reload ignores stale generation when a newer reload starts', () async {
      final gate = Completer<void>();
      var loadCount = 0;
      final controller = PagedEventListController<int>(
        pageSize: 10,
        loadPage: ({DateTime? beforeAt, int? beforeId}) async {
          loadCount++;
          if (loadCount == 1) {
            await gate.future;
            return [1];
          }
          return [2, 3];
        },
        loadMonthTotals: () async => {},
        watchChanges: () => const Stream<void>.empty(),
        dateOf: (id) => DateTime(2024, 1, id),
        idOf: (id) => id,
      );

      final first = controller.reload(resetScroll: true);
      await Future<void>.delayed(Duration.zero);
      final second = controller.reload(resetScroll: true);
      gate.complete();
      await Future.wait([first, second]);

      expect(controller.items, [2, 3]);
      expect(controller.error, isNull);
      controller.dispose();
    });

    test('reload stores error from failed load', () async {
      final controller = PagedEventListController<int>(
        pageSize: 10,
        loadPage: ({DateTime? beforeAt, int? beforeId}) async {
          throw StateError('boom');
        },
        loadMonthTotals: () async => {},
        watchChanges: () => const Stream<void>.empty(),
        dateOf: (id) => DateTime(2024, 1, id),
        idOf: (id) => id,
      );

      await controller.reload(resetScroll: true);
      expect(controller.error, isA<StateError>());
      expect(controller.initialLoading, isFalse);
      controller.dispose();
    });
  });

  group('DualSourcePagedController', () {
    DualSourcePagedController<int, int> buildController({
      required Future<List<int>> Function({DateTime? beforeAt, int? beforeId})
          loadPageA,
      required Future<List<int>> Function({DateTime? beforeAt, int? beforeId})
          loadPageB,
      int pageSizeA = 10,
      int pageSizeB = 10,
    }) {
      return DualSourcePagedController<int, int>(
        pageSizeA: pageSizeA,
        pageSizeB: pageSizeB,
        loadPageA: loadPageA,
        loadPageB: loadPageB,
        loadMonthTotalsA: () async => {},
        loadMonthTotalsB: () async => {},
        watchChangesA: () => const Stream<void>.empty(),
        watchChangesB: () => const Stream<void>.empty(),
        dateOfA: (id) => DateTime(2024, 1, id),
        dateOfB: (id) => DateTime(2024, 2, id),
        idOfA: (id) => id,
        idOfB: (id) => id,
      );
    }

    test('mergedEvents sorts newest first across sources', () async {
      final controller = buildController(
        loadPageA: ({DateTime? beforeAt, int? beforeId}) async => [1],
        loadPageB: ({DateTime? beforeAt, int? beforeId}) async => [2],
      );

      await controller.reload(resetScroll: true);
      final merged = controller.mergedEvents;
      expect(merged.length, 2);
      expect(merged.first.map(a: (_) => 'a', b: (_) => 'b'), 'b');
      controller.dispose();
    });

    test('reload ignores stale generation when a newer reload starts', () async {
      final gate = Completer<void>();
      var loadCountA = 0;
      final controller = buildController(
        loadPageA: ({DateTime? beforeAt, int? beforeId}) async {
          loadCountA++;
          if (loadCountA == 1) {
            await gate.future;
            return [1];
          }
          return [10, 11];
        },
        loadPageB: ({DateTime? beforeAt, int? beforeId}) async => [20],
      );

      final first = controller.reload(resetScroll: true);
      await Future<void>.delayed(Duration.zero);
      final second = controller.reload(resetScroll: true);
      gate.complete();
      await Future.wait([first, second]);

      expect(controller.itemsA, [10, 11]);
      expect(controller.itemsB, [20]);
      expect(controller.error, isNull);
      expect(controller.initialLoading, isFalse);
      controller.dispose();
    });

    test('reload stores error from failed load', () async {
      final controller = buildController(
        loadPageA: ({DateTime? beforeAt, int? beforeId}) async {
          throw StateError('boom');
        },
        loadPageB: ({DateTime? beforeAt, int? beforeId}) async => [2],
      );

      await controller.reload(resetScroll: true);
      expect(controller.error, isA<StateError>());
      expect(controller.initialLoading, isFalse);
      controller.dispose();
    });

    test('loadMore appends pages and updates hasMore flags', () async {
      var pageACalls = 0;
      var pageBCalls = 0;
      final controller = buildController(
        pageSizeA: 2,
        pageSizeB: 2,
        loadPageA: ({DateTime? beforeAt, int? beforeId}) async {
          pageACalls++;
          if (beforeAt == null) return [3, 2];
          return [1];
        },
        loadPageB: ({DateTime? beforeAt, int? beforeId}) async {
          pageBCalls++;
          if (beforeAt == null) return [6, 5];
          return [4];
        },
      );

      await controller.reload(resetScroll: true);
      expect(controller.itemsA, [3, 2]);
      expect(controller.itemsB, [6, 5]);
      expect(controller.hasMoreA, isTrue);
      expect(controller.hasMoreB, isTrue);

      await controller.loadMore();
      expect(pageACalls, 2);
      expect(pageBCalls, 2);
      expect(controller.itemsA, [3, 2, 1]);
      expect(controller.itemsB, [6, 5, 4]);
      expect(controller.hasMoreA, isFalse);
      expect(controller.hasMoreB, isFalse);
      expect(controller.loadingMore, isFalse);
      controller.dispose();
    });

    test('stale loadMore is ignored after newer reload', () async {
      final loadMoreGate = Completer<void>();
      var pageACalls = 0;
      final controller = buildController(
        pageSizeA: 1,
        pageSizeB: 10,
        loadPageA: ({DateTime? beforeAt, int? beforeId}) async {
          pageACalls++;
          if (beforeAt != null) {
            await loadMoreGate.future;
            return [99];
          }
          if (pageACalls == 1) return [1];
          return [2];
        },
        loadPageB: ({DateTime? beforeAt, int? beforeId}) async => [10],
      );

      await controller.reload(resetScroll: true);
      expect(controller.itemsA, [1]);

      final more = controller.loadMore();
      await Future<void>.delayed(Duration.zero);
      final reload = controller.reload(resetScroll: true);
      await reload;
      loadMoreGate.complete();
      await more;

      expect(controller.itemsA, [2]);
      expect(controller.itemsA, isNot(contains(99)));
      expect(controller.error, isNull);
      controller.dispose();
    });
  });
}
