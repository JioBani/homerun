import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4283194514),
      surfaceTint: Color(4283194514),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4292665855),
      onPrimaryContainer: Color(4278392651),
      secondary: Color(4284046962),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4292796921),
      onSecondaryContainer: Color(4279638828),
      tertiary: Color(4281819534),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4292011263),
      onTertiaryContainer: Color(4278197558),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294637823),
      onBackground: Color(4279900961),
      surface: Color(4294310651),
      onSurface: Color(4279704862),
      surfaceVariant: Color(4292601062),
      onSurfaceVariant: Color(4282337354),
      outline: Color(4285495674),
      outlineVariant: Color(4290758858),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020723),
      inverseOnSurface: Color(4293718771),
      inversePrimary: Color(4290102527),
      primaryFixed: Color(4292665855),
      onPrimaryFixed: Color(4278392651),
      primaryFixedDim: Color(4290102527),
      onPrimaryFixedVariant: Color(4281615481),
      secondaryFixed: Color(4292796921),
      onSecondaryFixed: Color(4279638828),
      secondaryFixedDim: Color(4290954717),
      onSecondaryFixedVariant: Color(4282467929),
      tertiaryFixed: Color(4292011263),
      onTertiaryFixed: Color(4278197558),
      tertiaryFixedDim: Color(4288793341),
      onTertiaryFixedVariant: Color(4279912821),
      surfaceDim: Color(4292205532),
      surfaceBright: Color(4294310651),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916150),
      surfaceContainer: Color(4293521392),
      surfaceContainerHigh: Color(4293126634),
      surfaceContainerHighest: Color(4292797413),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4281352308),
      surfaceTint: Color(4283194514),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4284707498),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282204757),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285494408),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4279584113),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283332518),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294637823),
      onBackground: Color(4279900961),
      surface: Color(4294310651),
      onSurface: Color(4279704862),
      surfaceVariant: Color(4292601062),
      onSurfaceVariant: Color(4282074182),
      outline: Color(4283916642),
      outlineVariant: Color(4285758590),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020723),
      inverseOnSurface: Color(4293718771),
      inversePrimary: Color(4290102527),
      primaryFixed: Color(4284707498),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4283062671),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285494408),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283915119),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283332518),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281622156),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205532),
      surfaceBright: Color(4294310651),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916150),
      surfaceContainer: Color(4293521392),
      surfaceContainerHigh: Color(4293126634),
      surfaceContainerHighest: Color(4292797413),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278918738),
      surfaceTint: Color(4283194514),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4281352308),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280099123),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282204757),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278199105),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4279584113),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294637823),
      onBackground: Color(4279900961),
      surface: Color(4294310651),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4292601062),
      onSurfaceVariant: Color(4280034599),
      outline: Color(4282074182),
      outlineVariant: Color(4282074182),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020723),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4293520383),
      primaryFixed: Color(4281352308),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4279773533),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282204757),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280757310),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4279584113),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278201939),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205532),
      surfaceBright: Color(4294310651),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916150),
      surfaceContainer: Color(4293521392),
      surfaceContainerHigh: Color(4293126634),
      surfaceContainerHighest: Color(4292797413),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4290102527),
      surfaceTint: Color(4290102527),
      onPrimary: Color(4280036705),
      primaryContainer: Color(4281615481),
      onPrimaryContainer: Color(4292665855),
      secondary: Color(4290954717),
      onSecondary: Color(4281020482),
      secondaryContainer: Color(4282467929),
      onSecondaryContainer: Color(4292796921),
      tertiary: Color(4288793341),
      onTertiary: Color(4278202969),
      tertiaryContainer: Color(4279912821),
      onTertiaryContainer: Color(4292011263),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279374616),
      onBackground: Color(4293124585),
      surface: Color(4279112725),
      onSurface: Color(4292797413),
      surfaceVariant: Color(4282337354),
      onSurfaceVariant: Color(4290758858),
      outline: Color(4287206036),
      outlineVariant: Color(4282337354),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797413),
      inverseOnSurface: Color(4281020723),
      inversePrimary: Color(4283194514),
      primaryFixed: Color(4292665855),
      onPrimaryFixed: Color(4278392651),
      primaryFixedDim: Color(4290102527),
      onPrimaryFixedVariant: Color(4281615481),
      secondaryFixed: Color(4292796921),
      onSecondaryFixed: Color(4279638828),
      secondaryFixedDim: Color(4290954717),
      onSecondaryFixedVariant: Color(4282467929),
      tertiaryFixed: Color(4292011263),
      onTertiaryFixed: Color(4278197558),
      tertiaryFixedDim: Color(4288793341),
      onTertiaryFixedVariant: Color(4279912821),
      surfaceDim: Color(4279112725),
      surfaceBright: Color(4281612859),
      surfaceContainerLowest: Color(4278783760),
      surfaceContainerLow: Color(4279704862),
      surfaceContainer: Color(4279968034),
      surfaceContainerHigh: Color(4280625964),
      surfaceContainerHighest: Color(4281349687),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4290497023),
      surfaceTint: Color(4290102527),
      onPrimary: Color(4278194499),
      primaryContainer: Color(4286549704),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4291218145),
      onSecondary: Color(4279309862),
      secondaryContainer: Color(4287402149),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4289187583),
      onTertiary: Color(4278196014),
      tertiaryContainer: Color(4285240260),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279374616),
      onBackground: Color(4293124585),
      surface: Color(4279112725),
      onSurface: Color(4294376701),
      surfaceVariant: Color(4282337354),
      onSurfaceVariant: Color(4291022030),
      outline: Color(4288390566),
      outlineVariant: Color(4286285191),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797413),
      inverseOnSurface: Color(4280625964),
      inversePrimary: Color(4281681274),
      primaryFixed: Color(4292665855),
      onPrimaryFixed: Color(4278193463),
      primaryFixedDim: Color(4290102527),
      onPrimaryFixedVariant: Color(4280496999),
      secondaryFixed: Color(4292796921),
      onSecondaryFixed: Color(4278915105),
      secondaryFixedDim: Color(4290954717),
      onSecondaryFixedVariant: Color(4281414984),
      tertiaryFixed: Color(4292011263),
      onTertiaryFixed: Color(4278194725),
      tertiaryFixedDim: Color(4288793341),
      onTertiaryFixedVariant: Color(4278204514),
      surfaceDim: Color(4279112725),
      surfaceBright: Color(4281612859),
      surfaceContainerLowest: Color(4278783760),
      surfaceContainerLow: Color(4279704862),
      surfaceContainer: Color(4279968034),
      surfaceContainerHigh: Color(4280625964),
      surfaceContainerHighest: Color(4281349687),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294769407),
      surfaceTint: Color(4290102527),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4290497023),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294769407),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4291218145),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294638335),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4289187583),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279374616),
      onBackground: Color(4293124585),
      surface: Color(4279112725),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4282337354),
      onSurfaceVariant: Color(4294180094),
      outline: Color(4291022030),
      outlineVariant: Color(4291022030),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797413),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4279576154),
      primaryFixed: Color(4293060351),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4290497023),
      onPrimaryFixedVariant: Color(4278194499),
      secondaryFixed: Color(4293060350),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4291218145),
      onSecondaryFixedVariant: Color(4279309862),
      tertiaryFixed: Color(4292471039),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4289187583),
      onTertiaryFixedVariant: Color(4278196014),
      surfaceDim: Color(4279112725),
      surfaceBright: Color(4281612859),
      surfaceContainerLowest: Color(4278783760),
      surfaceContainerLow: Color(4279704862),
      surfaceContainer: Color(4279968034),
      surfaceContainerHigh: Color(4280625964),
      surfaceContainerHighest: Color(4281349687),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [
  ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
