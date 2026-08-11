/// One-shot UI tip visibility flags.
abstract class TipPreferencesStore {
  Future<bool> shouldShowSwipeDeleteTip();
  Future<void> hideSwipeDeleteTip();
  Future<bool> shouldShowDoubleTapEditTip();
  Future<void> hideDoubleTapEditTip();
}
