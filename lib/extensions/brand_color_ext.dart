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
  extensions: const <ThemeExtension<dynamic>>[
    BrandColors(
      navy: Color.fromARGB(255, 0, 106, 255),
      navyDark: Color.fromARGB(255, 1, 46, 98),
      muted: Color(0xFF8A8AA8),
      accentGreen: Color(0xFF00D8A0),
    ),
  ],
);