import 'package:flutter/material.dart';

/// Fixed palette of common car body colors (single source of truth).
const kCarColorOptions = <Color>[
  Color(0xFF000000), // black
  Color(0xFF424242), // dark gray
  Color(0xFFBDBDBD), // light gray
  Color(0xFFFFFFFF), // white
  Color(0xFFE91E63), // pink
  Color(0xFFE53935), // red (theme chrome leans scarlet)
  Color(0xFF880E4F), // burgundy
  Color(0xFF5D4037), // brown
  Color(0xFFFF9800), // orange
  Color(0xFFFDD835), // yellow
  Color(0xFF43A047), // green
  Color(0xFF1B5E20), // dark green
  Color(0xFF4FC3F7), // light blue / cyan
  Color(0xFF1E88E5), // blue
  Color(0xFF0D47A1), // dark blue
  Color(0xFF7B1FA2), // purple
];

/// Default when no car / no color is selected (matches first swatch).
const kFallbackCarColor = Color(0xFF000000);

/// Semantic UI colors shared across themes (delete, alerts).
abstract final class ThemeSemantics {
  static const destructive = Color(0xFFD32F2F);
  static const onDestructive = Color(0xFFFFFFFF);
  static const alertDue = Color(0xFFEF5350);
  static const alertSoon = Color(0xFFFFA726);
  static const alertNone = Color(0xFFE0E0E0);
  static const swatchBorder = Color(0xFFBDBDBD);
}

/// Chrome + accent tokens for one car-color theme.
///
/// Edit values here to tune how the app looks for each body color.
class CarThemePalette {
  const CarThemePalette({
    required this.carColor,
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.appBar,
    required this.onAppBar,
    required this.scaffold,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.chrome,
    required this.error,
    required this.onError,
    this.softChrome = false,
  });

  /// Body color from [kCarColorOptions].
  final Color carColor;

  final Brightness brightness;

  /// Buttons, FAB, selected indicators.
  final Color primary;
  final Color onPrimary;

  final Color appBar;
  final Color onAppBar;

  final Color scaffold;
  final Color surface;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;

  final Color primaryContainer;
  final Color onPrimaryContainer;

  /// Header / tab bar / nav bar strip (was hardcoded white).
  final Color chrome;

  final Color error;
  final Color onError;

  /// Bright accents (yellow/cyan): keep outline focus, dark label on primary.
  final bool softChrome;

  bool get isDark => brightness == Brightness.dark;
}

/// All car-color themes in one place.
///
/// Order matches [kCarColorOptions].
const kCarThemePalettes = <CarThemePalette>[
  // Black — dark UI, light type
  CarThemePalette(
    carColor: Color(0xFF000000),
    brightness: Brightness.dark,
    primary: Color(0xFF424242),
    onPrimary: Color(0xFFF5F5F5),
    appBar: Color(0xFF000000),
    onAppBar: Color(0xFFF5F5F5),
    scaffold: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFFBDBDBD),
    outline: Color(0xFF757575),
    primaryContainer: Color(0xFF2C2C2C),
    onPrimaryContainer: Color(0xFFF5F5F5),
    chrome: Color(0xFF1E1E1E),
    error: Color(0xFFEF5350),
    onError: Color(0xFF000000),
  ),
  // Dark gray — slate dark UI (lighter than black, clearly gray)
  CarThemePalette(
    carColor: Color(0xFF424242),
    brightness: Brightness.dark,
    primary: Color(0xFF9E9E9E),
    onPrimary: Color(0xFF121212),
    appBar: Color(0xFF424242),
    onAppBar: Color(0xFFFAFAFA),
    scaffold: Color(0xFF2A2A2A),
    surface: Color(0xFF333333),
    onSurface: Color(0xFFFAFAFA),
    onSurfaceVariant: Color(0xFFCFCFCF),
    outline: Color(0xFF8A8A8A),
    primaryContainer: Color(0xFF5C5C5C),
    onPrimaryContainer: Color(0xFFFAFAFA),
    chrome: Color(0xFF333333),
    error: Color(0xFFEF5350),
    onError: Color(0xFF000000),
  ),
  // Light gray — soft silver light UI
  CarThemePalette(
    carColor: Color(0xFFBDBDBD),
    brightness: Brightness.light,
    primary: Color(0xFFBDBDBD),
    onPrimary: Color(0xFF212121),
    appBar: Color(0xFFBDBDBD),
    onAppBar: Color(0xFF212121),
    scaffold: Color(0xFFEEEEEE),
    surface: Color(0xFFF7F7F7),
    onSurface: Color(0xFF212121),
    onSurfaceVariant: Color(0xFF616161),
    outline: Color(0xFF9E9E9E),
    primaryContainer: Color(0xFFE0E0E0),
    onPrimaryContainer: Color(0xFF424242),
    chrome: Color(0xFFF0F0F0),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    softChrome: true,
  ),
  // White — minimal white / near-white chrome, dark type
  CarThemePalette(
    carColor: Color(0xFFFFFFFF),
    brightness: Brightness.light,
    primary: Color(0xFFE8E8E8),
    onPrimary: Color(0xFF1A1A1A),
    appBar: Color(0xFFFFFFFF),
    onAppBar: Color(0xFF1A1A1A),
    scaffold: Color(0xFFFAFAFA),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF757575),
    outline: Color(0xFFBDBDBD),
    primaryContainer: Color(0xFFF0F0F0),
    onPrimaryContainer: Color(0xFF424242),
    chrome: Color(0xFFFFFFFF),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    softChrome: true,
  ),
  // Pink
  CarThemePalette(
    carColor: Color(0xFFE91E63),
    brightness: Brightness.light,
    primary: Color(0xFFE91E63),
    onPrimary: Color(0xFFFFFFFF),
    appBar: Color(0xFFE91E63),
    onAppBar: Color(0xFFFFFFFF),
    scaffold: Color(0xFFFCE4EC),
    surface: Color(0xFFFFFBFD),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF6D4C5B),
    outline: Color(0xFFBDBDBD),
    primaryContainer: Color(0xFFF8BBD0),
    onPrimaryContainer: Color(0xFF880E4F),
    chrome: Color(0xFFFFFFFF),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
  ),
  // Red → scarlet chrome (яркий алый акцент)
  CarThemePalette(
    carColor: Color(0xFFE53935),
    brightness: Brightness.light,
    primary: Color(0xFFFF1744),
    onPrimary: Color(0xFFFFFFFF),
    appBar: Color(0xFFFF1744),
    onAppBar: Color(0xFFFFFFFF),
    scaffold: Color(0xFFFFE8EC),
    surface: Color(0xFFFFF8F9),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF8A3A45),
    outline: Color(0xFFE57373),
    primaryContainer: Color(0xFFFF8A9B),
    onPrimaryContainer: Color(0xFF8B0000),
    chrome: Color(0xFFFFFFFF),
    error: Color(0xFFC62828),
    onError: Color(0xFFFFFFFF),
  ),
  // Burgundy — deep accent, still light surfaces
  CarThemePalette(
    carColor: Color(0xFF880E4F),
    brightness: Brightness.light,
    primary: Color(0xFF880E4F),
    onPrimary: Color(0xFFFFFFFF),
    appBar: Color(0xFF880E4F),
    onAppBar: Color(0xFFFFFFFF),
    scaffold: Color(0xFFFCE4EC),
    surface: Color(0xFFFFFBFD),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF6D4C5B),
    outline: Color(0xFFBDBDBD),
    primaryContainer: Color(0xFFF48FB1),
    onPrimaryContainer: Color(0xFF4A0026),
    chrome: Color(0xFFFFFFFF),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
  ),
  // Brown — warm coffee / chocolate
  CarThemePalette(
    carColor: Color(0xFF5D4037),
    brightness: Brightness.light,
    primary: Color(0xFF6D4C41),
    onPrimary: Color(0xFFFFFFFF),
    appBar: Color(0xFF4E342E),
    onAppBar: Color(0xFFFFF8F0),
    scaffold: Color(0xFFF3E9E0),
    surface: Color(0xFFFFF6EF),
    onSurface: Color(0xFF2C1810),
    onSurfaceVariant: Color(0xFF7A5648),
    outline: Color(0xFFBCAAA4),
    primaryContainer: Color(0xFFD7CCC8),
    onPrimaryContainer: Color(0xFF3E2723),
    chrome: Color(0xFFFFF6EF),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
  ),
  // Orange
  CarThemePalette(
    carColor: Color(0xFFFF9800),
    brightness: Brightness.light,
    primary: Color(0xFFFF9800),
    onPrimary: Color(0xFF1A1A1A),
    appBar: Color(0xFFFF9800),
    onAppBar: Color(0xFF1A1A1A),
    scaffold: Color(0xFFFFF3E0),
    surface: Color(0xFFFFFBF7),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF6D4C41),
    outline: Color(0xFFBDBDBD),
    primaryContainer: Color(0xFFFFE0B2),
    onPrimaryContainer: Color(0xFFE65100),
    chrome: Color(0xFFFFFFFF),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    softChrome: true,
  ),
  // Yellow — soft chrome (bright primary, dark labels)
  CarThemePalette(
    carColor: Color(0xFFFDD835),
    brightness: Brightness.light,
    primary: Color(0xFFFDD835),
    onPrimary: Color(0xFF1A1A1A),
    appBar: Color(0xFFFFF176),
    onAppBar: Color(0xFF1A1A1A),
    scaffold: Color(0xFFFFFDE7),
    surface: Color(0xFFFFFDF5),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF6D6A41),
    outline: Color(0xFFBDBDBD),
    primaryContainer: Color(0xFFFFF59D),
    onPrimaryContainer: Color(0xFFF57F17),
    chrome: Color(0xFFFFFFFF),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    softChrome: true,
  ),
  // Green — fresh / grass
  CarThemePalette(
    carColor: Color(0xFF43A047),
    brightness: Brightness.light,
    primary: Color(0xFF66BB6A),
    onPrimary: Color(0xFF0A2E0C),
    appBar: Color(0xFF43A047),
    onAppBar: Color(0xFFFFFFFF),
    scaffold: Color(0xFFE8F5E9),
    surface: Color(0xFFF1FBF2),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF4A7A4E),
    outline: Color(0xFF81C784),
    primaryContainer: Color(0xFFC8E6C9),
    onPrimaryContainer: Color(0xFF1B5E20),
    chrome: Color(0xFFF1FBF2),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
  ),
  // Dark green — forest (deeper surfaces & chrome)
  CarThemePalette(
    carColor: Color(0xFF1B5E20),
    brightness: Brightness.light,
    primary: Color(0xFF1B5E20),
    onPrimary: Color(0xFFE8F5E9),
    appBar: Color(0xFF0D3B12),
    onAppBar: Color(0xFFE8F5E9),
    scaffold: Color(0xFFD7E8D9),
    surface: Color(0xFFE4F0E5),
    onSurface: Color(0xFF0F1F10),
    onSurfaceVariant: Color(0xFF2E5C32),
    outline: Color(0xFF5A8F5E),
    primaryContainer: Color(0xFF81C784),
    onPrimaryContainer: Color(0xFF06240A),
    chrome: Color(0xFFE4F0E5),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
  ),
  // Light blue / cyan — soft chrome
  CarThemePalette(
    carColor: Color(0xFF4FC3F7),
    brightness: Brightness.light,
    primary: Color(0xFF4FC3F7),
    onPrimary: Color(0xFF1A1A1A),
    appBar: Color(0xFF81D4FA),
    onAppBar: Color(0xFF1A1A1A),
    scaffold: Color(0xFFE1F5FE),
    surface: Color(0xFFF5FCFF),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF456A7A),
    outline: Color(0xFFBDBDBD),
    primaryContainer: Color(0xFFB3E5FC),
    onPrimaryContainer: Color(0xFF01579B),
    chrome: Color(0xFFFFFFFF),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    softChrome: true,
  ),
  // Blue — bright sky
  CarThemePalette(
    carColor: Color(0xFF1E88E5),
    brightness: Brightness.light,
    primary: Color(0xFF42A5F5),
    onPrimary: Color(0xFFFFFFFF),
    appBar: Color(0xFF1E88E5),
    onAppBar: Color(0xFFFFFFFF),
    scaffold: Color(0xFFE3F2FD),
    surface: Color(0xFFF0F7FF),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF3F6A95),
    outline: Color(0xFF64B5F6),
    primaryContainer: Color(0xFFBBDEFB),
    onPrimaryContainer: Color(0xFF0D47A1),
    chrome: Color(0xFFF0F7FF),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
  ),
  // Dark blue — navy (deeper surfaces & chrome)
  CarThemePalette(
    carColor: Color(0xFF0D47A1),
    brightness: Brightness.light,
    primary: Color(0xFF0D47A1),
    onPrimary: Color(0xFFE3F2FD),
    appBar: Color(0xFF062A63),
    onAppBar: Color(0xFFE3F2FD),
    scaffold: Color(0xFFC5D8F0),
    surface: Color(0xFFD6E4F5),
    onSurface: Color(0xFF0A1628),
    onSurfaceVariant: Color(0xFF2A4570),
    outline: Color(0xFF5C7FB5),
    primaryContainer: Color(0xFF64B5F6),
    onPrimaryContainer: Color(0xFF001A4D),
    chrome: Color(0xFFD6E4F5),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
  ),
  // Purple
  CarThemePalette(
    carColor: Color(0xFF7B1FA2),
    brightness: Brightness.light,
    primary: Color(0xFF7B1FA2),
    onPrimary: Color(0xFFFFFFFF),
    appBar: Color(0xFF7B1FA2),
    onAppBar: Color(0xFFFFFFFF),
    scaffold: Color(0xFFF3E5F5),
    surface: Color(0xFFFCF7FD),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF5E4570),
    outline: Color(0xFFBDBDBD),
    primaryContainer: Color(0xFFE1BEE7),
    onPrimaryContainer: Color(0xFF4A148C),
    chrome: Color(0xFFFFFFFF),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
  ),
];

final Map<int, CarThemePalette> _paletteByArgb = {
  for (final p in kCarThemePalettes) p.carColor.toARGB32(): p,
};

/// Resolves theme tokens for a car body color (nearest known swatch).
CarThemePalette resolveCarThemePalette(Color? carColor) {
  final color = carColor ?? kFallbackCarColor;
  final exact = _paletteByArgb[color.toARGB32()];
  if (exact != null) return exact;

  // Custom / legacy ARGB: pick closest swatch by RGB distance.
  var best = kCarThemePalettes.first;
  var bestDist = double.infinity;
  for (final p in kCarThemePalettes) {
    final d = _colorDistance(color, p.carColor);
    if (d < bestDist) {
      bestDist = d;
      best = p;
    }
  }
  return best;
}

double _colorDistance(Color a, Color b) {
  final dr = a.r - b.r;
  final dg = a.g - b.g;
  final db = a.b - b.b;
  return dr * dr + dg * dg + db * db;
}
