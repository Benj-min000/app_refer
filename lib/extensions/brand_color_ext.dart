import 'package:flutter/material.dart';

@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  final Color? navy;
  final Color? navyDark;
  final Color? muted;
  final Color? accentGreen;

  const BrandColors({
    this.navy,
    this.navyDark,
    this.muted,
    this.accentGreen,
  });

  @override
  BrandColors copyWith({
    Color? navy,
    Color? navyDark,
    Color? muted,
    Color? accentGreen,
  }) {
    return BrandColors(
      navy: navy ?? this.navy,
      navyDark: navyDark ?? this.navyDark,
      muted: muted ?? this.muted,
      accentGreen: accentGreen ?? this.accentGreen,
    );
  }

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) {
    if (other is! BrandColors) return this;
    return BrandColors(
      navy: Color.lerp(navy, other.navy, t),
      navyDark: Color.lerp(navyDark, other.navyDark, t),
      muted: Color.lerp(muted, other.muted, t),
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t),
    );
  }
}

extension BrandColorsExtension on BuildContext {
  BrandColors get brandColors => Theme.of(this).extension<BrandColors>()!;
}

// -- Light Theme ---------------------------------------------------------------

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF6F6FB),
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
    surfaceBright: Color(0xFFF0F0FA),
    primary: Colors.redAccent,
    onPrimary: Colors.white,
    outline: Color(0xFFE8E8F0),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFFE8E8F0)),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFFE8E8F0),
    thickness: 1,
  ),
  extensions: const <ThemeExtension<dynamic>>[
    BrandColors(
      navy: Colors.redAccent,
      navyDark: Color(0xFFB71C1C),
      muted: Color(0xFFAAAAAA),
      accentGreen: Color(0xFF00C48C),
    ),
  ],
);

// -- Dark Theme ----------------------------------------------------------------

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1D1D36),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF13131F),
    surfaceBright: Color.fromARGB(255, 36, 36, 60),
    primary: Color.fromARGB(255, 70, 109, 235),
    onPrimary: Colors.white,
    outline: Color(0xFF1E1E30),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF13131F),
    foregroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF13131F),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFF1E1E30)),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFF1E1E30),
    thickness: 1,
  ),
  extensions: const <ThemeExtension<dynamic>>[
    BrandColors(
      navy: Color.fromARGB(255, 0, 106, 255),
      navyDark: Color.fromARGB(255, 1, 46, 98),
      muted: Color(0xFF8A8AA8),
      accentGreen: Color(0xFF00D8A0),
    ),
  ],
);
