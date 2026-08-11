import 'package:flutter/material.dart';

import 'car_theme_config.dart';

export 'car_theme_config.dart';

/// Builds [ThemeData] from [CarThemePalette] for the selected car color.
ThemeData buildAppTheme(Color? carColorArgb) {
  final palette = resolveCarThemePalette(carColorArgb);

  final colorScheme = ColorScheme(
    brightness: palette.brightness,
    primary: palette.primary,
    onPrimary: palette.onPrimary,
    primaryContainer: palette.primaryContainer,
    onPrimaryContainer: palette.onPrimaryContainer,
    secondary: palette.primary,
    onSecondary: palette.onPrimary,
    secondaryContainer: palette.primaryContainer,
    onSecondaryContainer: palette.onPrimaryContainer,
    tertiary: palette.primary,
    onTertiary: palette.onPrimary,
    error: palette.error,
    onError: palette.onError,
    surface: palette.surface,
    onSurface: palette.onSurface,
    onSurfaceVariant: palette.onSurfaceVariant,
    outline: palette.outline,
    outlineVariant: palette.outline.withValues(alpha: 0.5),
    surfaceContainerHighest: palette.isDark
        ? const Color(0xFF2C2C2C)
        : palette.primaryContainer,
  );

  final inputFocusLabelColor =
      palette.softChrome ? palette.onSurface : palette.primary;
  final inputBorderColor = palette.outline;
  final chromeAlpha = palette.chrome.withValues(alpha: palette.isDark ? 0.92 : 0.5);

  return ThemeData(
    useMaterial3: true,
    brightness: palette.brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: palette.scaffold,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: inputFocusLabelColor,
      selectionColor: inputFocusLabelColor.withValues(alpha: 0.35),
      selectionHandleColor: inputFocusLabelColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.isDark
          ? palette.surface
          : palette.surface.withValues(alpha: 0.9),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return TextStyle(color: palette.error);
        }
        if (states.contains(WidgetState.focused)) {
          return TextStyle(color: inputFocusLabelColor);
        }
        return TextStyle(color: palette.onSurfaceVariant);
      }),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: inputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: inputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: palette.softChrome ? inputBorderColor : palette.primary,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: palette.error, width: 2),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: palette.appBar,
      foregroundColor: palette.onAppBar,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: palette.onAppBar),
      actionsIconTheme: IconThemeData(color: palette.onAppBar),
      titleTextStyle: TextStyle(
        color: palette.onAppBar,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: chromeAlpha,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      indicatorColor: palette.primary,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: palette.onPrimary);
        }
        return IconThemeData(color: palette.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          color: selected ? palette.onSurface : palette.onSurfaceVariant,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        );
      }),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: palette.primary,
      foregroundColor: palette.onPrimary,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: palette.softChrome ? palette.onSurface : palette.primary,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.onPrimary;
        }
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.primary;
        }
        return null;
      }),
    ),
    dividerColor: palette.outline.withValues(alpha: 0.4),
    cardColor: palette.surface,
  );
}
