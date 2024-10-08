import "package:flutter/material.dart";

//TODO : 컬러스키마 다시 제대로 제작해야함
class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff35C5F0),
      surfaceTint: Color(0xff0a6780),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb9eaff),
      onPrimaryContainer: Color(0xff001f29),
      secondary: Color(0xff2E3C6B),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd9e2ff),
      onSecondaryContainer: Color(0xff001944),
      tertiary: Color(0xff216487),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc7e7ff),
      onTertiaryContainer: Color(0xff001e2e),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xffffffff),
      onBackground: Color(0xff171c1f),
      surface: Color(0xffffffff),
      onSurface: Color(0xff171d1e),
      surfaceVariant: Color(0xffdbe4e6),
      onSurfaceVariant: Color(0xff3f484a),
      outline: Color(0xff6f797a),
      outlineVariant: Color(0xffbfc8ca),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inverseOnSurface: Color(0xffecf2f3),
      inversePrimary: Color(0xff89d0ed),
      primaryFixed: Color(0xffb9eaff),
      onPrimaryFixed: Color(0xff001f29),
      primaryFixedDim: Color(0xff89d0ed),
      onPrimaryFixedVariant: Color(0xff004d61),
      secondaryFixed: Color(0xffd9e2ff),
      onSecondaryFixed: Color(0xff001944),
      secondaryFixedDim: Color(0xffb0c6ff),
      onSecondaryFixedVariant: Color(0xff2e4578),
      tertiaryFixed: Color(0xffc7e7ff),
      onTertiaryFixed: Color(0xff001e2e),
      tertiaryFixedDim: Color(0xff92cef5),
      onTertiaryFixedVariant: Color(0xff004c6c),
      surfaceDim: Color(0xffd5dbdc),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee3e5),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff00495c),
      surfaceTint: Color(0xff0a6780),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff307d97),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2a4174),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5d74a9),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff004866),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3d7b9f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xffffffff),
      onBackground: Color(0xff171c1f),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff171d1e),
      surfaceVariant: Color(0xffdbe4e6),
      onSurfaceVariant: Color(0xff3b4446),
      outline: Color(0xff576162),
      outlineVariant: Color(0xff737c7e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inverseOnSurface: Color(0xffecf2f3),
      inversePrimary: Color(0xff89d0ed),
      primaryFixed: Color(0xff307d97),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff03647d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5d74a9),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff445b8f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff3d7b9f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff1e6285),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd5dbdc),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee3e5),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff002631),
      surfaceTint: Color(0xff0a6780),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00495c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff012051),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff2a4174),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002537),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff004866),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfff5fafd),
      onBackground: Color(0xff171c1f),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffdbe4e6),
      onSurfaceVariant: Color(0xff1c2527),
      outline: Color(0xff3b4446),
      outlineVariant: Color(0xff3b4446),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffd2f1ff),
      primaryFixed: Color(0xff00495c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00313f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff2a4174),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff102b5c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff004866),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003046),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd5dbdc),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee3e5),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xff89d0ed),
      surfaceTint: Color(0xff89d0ed),
      onPrimary: Color(0xff003544),
      primaryContainer: Color(0xff004d61),
      onPrimaryContainer: Color(0xffb9eaff),
      secondary: Color(0xffb0c6ff),
      onSecondary: Color(0xff142e60),
      secondaryContainer: Color(0xff2e4578),
      onSecondaryContainer: Color(0xffd9e2ff),
      tertiary: Color(0xff92cef5),
      onTertiary: Color(0xff00344c),
      tertiaryContainer: Color(0xff004c6c),
      onTertiaryContainer: Color(0xffc7e7ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff0f1416),
      onBackground: Color(0xffdee3e6),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffdee3e5),
      surfaceVariant: Color(0xff3f484a),
      onSurfaceVariant: Color(0xffbfc8ca),
      outline: Color(0xff899294),
      outlineVariant: Color(0xff3f484a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inverseOnSurface: Color(0xff2b3133),
      inversePrimary: Color(0xff0a6780),
      primaryFixed: Color(0xffb9eaff),
      onPrimaryFixed: Color(0xff001f29),
      primaryFixedDim: Color(0xff89d0ed),
      onPrimaryFixedVariant: Color(0xff004d61),
      secondaryFixed: Color(0xffd9e2ff),
      onSecondaryFixed: Color(0xff001944),
      secondaryFixedDim: Color(0xffb0c6ff),
      onSecondaryFixedVariant: Color(0xff2e4578),
      tertiaryFixed: Color(0xffc7e7ff),
      onTertiaryFixed: Color(0xff001e2e),
      tertiaryFixedDim: Color(0xff92cef5),
      onTertiaryFixedVariant: Color(0xff004c6c),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1e),
      surfaceContainer: Color(0xff1b2122),
      surfaceContainerHigh: Color(0xff252b2c),
      surfaceContainerHighest: Color(0xff303637),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xff8dd5f1),
      surfaceTint: Color(0xff89d0ed),
      onPrimary: Color(0xff001922),
      primaryContainer: Color(0xff519ab5),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffb6caff),
      onSecondary: Color(0xff00143a),
      secondaryContainer: Color(0xff7990c7),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff96d2fa),
      onTertiary: Color(0xff001826),
      tertiaryContainer: Color(0xff5b97bd),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff0f1416),
      onBackground: Color(0xffdee3e6),
      surface: Color(0xff0e1415),
      onSurface: Color(0xfff6fcfd),
      surfaceVariant: Color(0xff3f484a),
      onSurfaceVariant: Color(0xffc3ccce),
      outline: Color(0xff9ba5a6),
      outlineVariant: Color(0xff7b8587),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inverseOnSurface: Color(0xff252b2c),
      inversePrimary: Color(0xff004f63),
      primaryFixed: Color(0xffb9eaff),
      onPrimaryFixed: Color(0xff00141b),
      primaryFixedDim: Color(0xff89d0ed),
      onPrimaryFixedVariant: Color(0xff003c4c),
      secondaryFixed: Color(0xffd9e2ff),
      onSecondaryFixed: Color(0xff000f30),
      secondaryFixedDim: Color(0xffb0c6ff),
      onSecondaryFixedVariant: Color(0xff1c3466),
      tertiaryFixed: Color(0xffc7e7ff),
      onTertiaryFixed: Color(0xff00131f),
      tertiaryFixedDim: Color(0xff92cef5),
      onTertiaryFixedVariant: Color(0xff003a54),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1e),
      surfaceContainer: Color(0xff1b2122),
      surfaceContainerHigh: Color(0xff252b2c),
      surfaceContainerHighest: Color(0xff303637),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff6fbff),
      surfaceTint: Color(0xff89d0ed),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff8dd5f1),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffcfaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb6caff),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff8fbff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff96d2fa),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff0f1416),
      onBackground: Color(0xffdee3e6),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff3f484a),
      onSurfaceVariant: Color(0xfff3fcfe),
      outline: Color(0xffc3ccce),
      outlineVariant: Color(0xffc3ccce),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff002e3c),
      primaryFixed: Color(0xffc4edff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff8dd5f1),
      onPrimaryFixedVariant: Color(0xff001922),
      secondaryFixed: Color(0xffdfe6ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb6caff),
      onSecondaryFixedVariant: Color(0xff00143a),
      tertiaryFixed: Color(0xffd0eaff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff96d2fa),
      onTertiaryFixedVariant: Color(0xff001826),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1e),
      surfaceContainer: Color(0xff1b2122),
      surfaceContainerHigh: Color(0xff252b2c),
      surfaceContainerHighest: Color(0xff303637),
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
