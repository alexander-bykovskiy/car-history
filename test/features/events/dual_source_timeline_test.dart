import 'package:car_history/features/events/domain/dual_source_timeline.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dualSourceCutoff', () {
    test('picks the later of two cutoffs', () {
      final a = DateTime(2024, 6, 10);
      final b = DateTime(2024, 6, 5);
      expect(dualSourceCutoff(sourceACutoff: a, sourceBCutoff: b), a);
      expect(dualSourceCutoff(sourceACutoff: b, sourceBCutoff: a), a);
    });

    test('returns the only non-null cutoff', () {
      final a = DateTime(2024, 1, 1);
      expect(dualSourceCutoff(sourceACutoff: a, sourceBCutoff: null), a);
      expect(dualSourceCutoff(sourceACutoff: null, sourceBCutoff: a), a);
      expect(dualSourceCutoff(sourceACutoff: null, sourceBCutoff: null), isNull);
    });
  });

  group('dualSourceVisibleEvents', () {
    test('keeps events on or after cutoff', () {
      final events = [
        DateTime(2024, 6, 20),
        DateTime(2024, 6, 10),
        DateTime(2024, 6, 5),
        DateTime(2024, 5, 1),
      ];
      final visible = dualSourceVisibleEvents(
        mergedNewestFirst: events,
        dateOf: (d) => d,
        cutoff: DateTime(2024, 6, 10),
      );
      expect(visible, [
        DateTime(2024, 6, 20),
        DateTime(2024, 6, 10),
      ]);
    });

    test('returns all when cutoff is null', () {
      final events = [DateTime(2024, 1, 2), DateTime(2024, 1, 1)];
      expect(
        dualSourceVisibleEvents(
          mergedNewestFirst: events,
          dateOf: (d) => d,
          cutoff: null,
        ),
        events,
      );
    });
  });

  group('sortTimelineNewestFirst', () {
    test('orders by date, then type, then id', () {
      final day = DateTime(2024, 3, 1);
      final items = [
        (at: day, type: 1, id: 1),
        (at: day, type: 0, id: 2),
        (at: day.add(const Duration(days: 1)), type: 0, id: 3),
        (at: day, type: 0, id: 9),
      ];
      final sorted = sortTimelineNewestFirst(
        events: items,
        dateOf: (e) => e.at,
        typeOrder: (e) => e.type,
        idOf: (e) => e.id,
      );
      expect(sorted.map((e) => e.id).toList(), [3, 9, 2, 1]);
    });
  });

  group('mergeMonthTotals', () {
    test('merges overlapping months per currency without cross-sum', () {
      final merged = mergeMonthTotals(
        {
          (2024, 1): {'EUR': 10},
          (2024, 2): {'EUR': 5},
        },
        {
          (2024, 2): {'EUR': 3, 'RSD': 100},
          (2024, 3): {'RSD': 7},
        },
      );
      expect(merged[(2024, 1)], {'EUR': 10});
      expect(merged[(2024, 2)], {'EUR': 8, 'RSD': 100});
      expect(merged[(2024, 3)], {'RSD': 7});
    });
  });

  group('pageCursorCutoff', () {
    test('null when no more pages or empty', () {
      expect(
        pageCursorCutoff(
          hasMore: false,
          items: [DateTime(2024)],
          dateOf: (d) => d,
        ),
        isNull,
      );
      expect(
        pageCursorCutoff<DateTime>(
          hasMore: true,
          items: const [],
          dateOf: (d) => d,
        ),
        isNull,
      );
    });

    test('uses last item date when hasMore', () {
      final items = [DateTime(2024, 6, 20), DateTime(2024, 6, 1)];
      expect(
        pageCursorCutoff(hasMore: true, items: items, dateOf: (d) => d),
        DateTime(2024, 6, 1),
      );
    });
  });
}
