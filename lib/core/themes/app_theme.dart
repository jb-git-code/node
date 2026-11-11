import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Notion-style monochrome theme.
/// Only shades/tints of black and white (pure neutral greys) are used.
class AppTheme {
  AppTheme._();

  // ───────────────────────── LIGHT PALETTE ─────────────────────────
  static const Color _lBackground = Color(0xFFFFFFFF);
  static const Color _lSurface = Color(0xFFFFFFFF);
  static const Color _lSurfaceAlt = Color(0xFFF5F5F5); // hover / inputs / chips
  static const Color _lSurfaceHigh = Color(0xFFEBEBEB); // pressed / selected
  static const Color _lBorder = Color(0xFFE0E0E0);
  static const Color _lTextPrimary = Color(0xFF111111);
  static const Color _lTextSecondary = Color(0xFF6B6B6B);
  static const Color _lTextDisabled = Color(0xFFB0B0B0);
  static const Color _lInk = Color(0xFF111111); // primary actions
  static const Color _lError = Color(0xFFD92D20); // only non-greyscale color

  // ───────────────────────── DARK PALETTE ──────────────────────────
  static const Color _dBackground = Color(
    0xFF191919,
  ); // Notion dark (use 0xFF000000 for pure black)
  static const Color _dSurface = Color(0xFF202020);
  static const Color _dSurfaceAlt = Color(0xFF2A2A2A);
  static const Color _dSurfaceHigh = Color(0xFF353535);
  static const Color _dBorder = Color(0xFF383838);
  static const Color _dTextPrimary = Color(0xFFF2F2F2);
  static const Color _dTextSecondary = Color(0xFF9B9B9B);
  static const Color _dTextDisabled = Color(0xFF5E5E5E);
  static const Color _dInk = Color(0xFFF2F2F2);
  static const Color _dError = Color(0xFFFF6B63); // only non-greyscale color

  // ───────────────────────────── THEMES ────────────────────────────
  static ThemeData get lightTheme => _build(
    brightness: Brightness.light,
    background: _lBackground,
    surface: _lSurface,
    surfaceAlt: _lSurfaceAlt,
    surfaceHigh: _lSurfaceHigh,
    border: _lBorder,
    textPrimary: _lTextPrimary,
    textSecondary: _lTextSecondary,
    textDisabled: _lTextDisabled,
    ink: _lInk,
    onInk: Colors.white,
    error: _lError,
  );

  static ThemeData get darkTheme => _build(
    brightness: Brightness.dark,
    background: _dBackground,
    surface: _dSurface,
    surfaceAlt: _dSurfaceAlt,
    surfaceHigh: _dSurfaceHigh,
    border: _dBorder,
    textPrimary: _dTextPrimary,
    textSecondary: _dTextSecondary,
    textDisabled: _dTextDisabled,
    ink: _dInk,
    onInk: _dBackground,
    error: _dError,
  );

  // ─────────────────────────── SHARED BUILDER ──────────────────────
  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceAlt,
    required Color surfaceHigh,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required Color textDisabled,
    required Color ink,
    required Color onInk,
    required Color error,
  }) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    final textTheme = GoogleFonts.interTextTheme(
      base.textTheme,
    ).apply(bodyColor: textPrimary, displayColor: textPrimary);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: ink,
      onPrimary: onInk,
      secondary: ink,
      onSecondary: onInk,
      error: error,
      onError: onInk,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      surfaceTint: Colors.transparent, // no tinted elevation overlay
      outline: border,
      outlineVariant: border,
      surfaceContainerLowest: background,
      surfaceContainerLow: surface,
      surfaceContainer: surface,
      surfaceContainerHigh: surfaceAlt,
      surfaceContainerHighest: surfaceHigh,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: ink,
      onInverseSurface: onInk,
      inversePrimary: onInk,
    );

    final roundedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      textTheme: textTheme,
      primaryTextTheme: textTheme,

      // Flat, Notion-like feel: no ripples, no highlight flashes
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: surfaceAlt,
      hoverColor: surfaceAlt,
      focusColor: surfaceAlt,

      dividerColor: border,
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),

      iconTheme: IconThemeData(color: textPrimary, size: 22),

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border),
        ),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: textSecondary,
        textColor: textPrimary,
        selectedColor: textPrimary,
        selectedTileColor: surfaceAlt,
        shape: roundedShape,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        hintStyle: TextStyle(color: textSecondary),
        labelStyle: TextStyle(color: textSecondary),
        floatingLabelStyle: TextStyle(color: textPrimary),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: inputBorder(border),
        enabledBorder: inputBorder(border),
        disabledBorder: inputBorder(border.withValues(alpha: 0.5)),
        focusedBorder: inputBorder(ink, 1.5),
        errorBorder: inputBorder(error),
        focusedErrorBorder: inputBorder(error, 1.5),
        errorStyle: TextStyle(color: error),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ink,
        selectionColor: ink.withValues(alpha: 0.2),
        selectionHandleColor: ink,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: onInk,
          disabledBackgroundColor: surfaceHigh,
          disabledForegroundColor: textDisabled,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(64, 48),
          shape: roundedShape,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: onInk,
          disabledBackgroundColor: surfaceHigh,
          disabledForegroundColor: textDisabled,
          minimumSize: const Size(64, 48),
          shape: roundedShape,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          disabledForegroundColor: textDisabled,
          side: BorderSide(color: border),
          minimumSize: const Size(64, 48),
          shape: roundedShape,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textPrimary,
          disabledForegroundColor: textDisabled,
          shape: roundedShape,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: textPrimary),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ink,
        foregroundColor: onInk,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: roundedShape,
      ),

      // Selection controls
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? ink : Colors.transparent,
        ),
        checkColor: WidgetStatePropertyAll(onInk),
        side: BorderSide(color: textSecondary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? ink : textSecondary,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? onInk : textSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? ink : surfaceHigh,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? ink : border,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: ink,
        inactiveTrackColor: surfaceHigh,
        thumbColor: ink,
        overlayColor: ink.withValues(alpha: 0.1),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ink,
        linearTrackColor: surfaceHigh,
        circularTrackColor: surfaceHigh,
      ),

      // Chips & tabs
      chipTheme: ChipThemeData(
        backgroundColor: surfaceAlt,
        selectedColor: ink,
        disabledColor: surfaceAlt,
        labelStyle: TextStyle(color: textPrimary),
        secondaryLabelStyle: TextStyle(color: onInk),
        checkmarkColor: onInk,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: textPrimary,
        unselectedLabelColor: textSecondary,
        indicatorColor: ink,
        dividerColor: border,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      // Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: textPrimary,
        unselectedItemColor: textSecondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: surfaceHigh,
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            color: s.contains(WidgetState.selected)
                ? textPrimary
                : textSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: s.contains(WidgetState.selected)
                ? textPrimary
                : textSecondary,
          ),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
      ),

      // Overlays
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalBackgroundColor: surface,
        showDragHandle: true,
        dragHandleColor: border,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: TextStyle(color: onInk),
        actionTextColor: onInk,
        behavior: SnackBarBehavior.floating,
        shape: roundedShape,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: ink,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(color: onInk, fontSize: 12),
      ),
    );
  }
}
