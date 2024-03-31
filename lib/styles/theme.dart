import 'package:flutter/material.dart';

class whatsappThemeDark {
  static Color get appBarColor => const Color.fromRGBO(31, 44, 52, 1);
  static Color get greenColor => const Color.fromRGBO(3, 167, 130, 1);
  static Color get backgroundColor => const Color.fromRGBO(18, 27, 34, 1);
  static Color get blackColor => const Color.fromRGBO(20, 25, 33, 1);
  static Color get whiteColor => const Color.fromRGBO(255, 255, 255, 1);
  static Color get linkColor => const Color(0xFF53BDEB);
  static Color get chatBoxBackgroundColor =>
      const Color.fromRGBO(31, 44, 52, 1);
  static Color get chatBubbleBackgroundColor =>
      const Color.fromRGBO(0, 93, 75, 1);
}

class whatsappThemeLight {
  static Color get appBarColor => const Color.fromRGBO(0, 128, 105, 1);
  static Color get greenColor => const Color.fromRGBO(0, 128, 105, 1);
  static Color get backgroundColor => const Color.fromRGBO(255, 255, 255, 1);
  static Color get blackColor => const Color.fromRGBO(20, 25, 33, 1);
  static Color get whiteColor => const Color.fromRGBO(255, 255, 255, 1);
  static Color get linkColor => const Color(0xFF027EB5);
  static Color get chatBoxBackgroundColor =>
      const Color.fromRGBO(255, 255, 255, 1);
  static Color get chatBubbleBackgroundColor =>
      const Color.fromRGBO(231, 255, 220, 1);
}

ThemeData darkTheme = ThemeData(
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    modalBarrierColor: Colors.transparent,
    modalBackgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  highlightColor: whatsappThemeDark.linkColor,
  hintColor: whatsappThemeDark.whiteColor.withOpacity(0.6),
  cardColor: whatsappThemeDark.chatBoxBackgroundColor,
  splashColor: whatsappThemeDark.whiteColor.withOpacity(0.1),
  primaryColor: whatsappThemeDark.blackColor,
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(whatsappThemeDark.greenColor),
    trackColor: MaterialStateProperty.all(whatsappThemeDark.greenColor),
    trackBorderColor: MaterialStateProperty.all(whatsappThemeDark.greenColor),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: whatsappThemeDark.greenColor,
    selectionColor: whatsappThemeDark.greenColor.withOpacity(0.5),
    selectionHandleColor: whatsappThemeDark.greenColor,
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    bodyMedium: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    bodyLarge: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    displaySmall: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    displayMedium: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    displayLarge: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    titleSmall: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    titleMedium: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    titleLarge: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    labelSmall: TextStyle(
      color: whatsappThemeDark.whiteColor.withOpacity(0.8),
    ),
    labelMedium: TextStyle(
      color: whatsappThemeDark.whiteColor.withOpacity(0.8),
    ),
    labelLarge: TextStyle(
      color: whatsappThemeDark.whiteColor.withOpacity(0.8),
    ),
    headlineSmall: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    headlineMedium: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
    headlineLarge: TextStyle(
      color: whatsappThemeDark.whiteColor,
    ),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.black,
    background: whatsappThemeDark.backgroundColor,
    onBackground: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    color: whatsappThemeDark.appBarColor,
    titleTextStyle: TextStyle(
        color: whatsappThemeDark.whiteColor,
        fontSize: 22,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w500,
        letterSpacing: 1),
    iconTheme: IconThemeData(
      color: whatsappThemeDark.whiteColor,
      size: 25,
    ),
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    elevation: 0.0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: whatsappThemeDark.greenColor,
    foregroundColor: whatsappThemeDark.blackColor,
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorColor: whatsappThemeDark.greenColor,
    labelStyle: TextStyle(
        fontSize: 15.0,
        color: whatsappThemeDark.greenColor,
        fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(
      fontSize: 15.0,
      color: whatsappThemeDark.whiteColor,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: whatsappThemeDark.greenColor,
      foregroundColor: whatsappThemeDark.backgroundColor,
      splashFactory: NoSplash.splashFactory,
      elevation: 0,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    modalBarrierColor: Colors.transparent,
    modalBackgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  highlightColor: whatsappThemeLight.linkColor,
  hintColor: whatsappThemeLight.blackColor.withOpacity(0.6),
  cardColor: whatsappThemeLight.whiteColor,
  splashColor: whatsappThemeLight.blackColor.withOpacity(0.1),
  primaryColor: whatsappThemeLight.blackColor,
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(whatsappThemeLight.greenColor),
    trackColor: MaterialStateProperty.all(whatsappThemeLight.greenColor),
    trackBorderColor: MaterialStateProperty.all(whatsappThemeLight.greenColor),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: whatsappThemeLight.greenColor,
    selectionColor: whatsappThemeLight.greenColor.withOpacity(0.5),
    selectionHandleColor: whatsappThemeLight.greenColor,
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    bodyMedium: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    bodyLarge: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    displaySmall: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    displayMedium: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    displayLarge: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    titleSmall: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    titleMedium: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    titleLarge: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    labelSmall: TextStyle(
      color: whatsappThemeLight.blackColor.withOpacity(0.8),
    ),
    labelMedium: TextStyle(
      color: whatsappThemeLight.blackColor.withOpacity(0.8),
    ),
    labelLarge: TextStyle(
      color: whatsappThemeLight.blackColor.withOpacity(0.8),
    ),
    headlineSmall: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    headlineMedium: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
    headlineLarge: TextStyle(
      color: whatsappThemeLight.blackColor,
    ),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.black,
    onSecondary: Colors.white,
    background: whatsappThemeLight.whiteColor,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    color: whatsappThemeLight.appBarColor,
    titleTextStyle: TextStyle(
        color: whatsappThemeLight.whiteColor,
        fontSize: 22,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w500,
        letterSpacing: 1),
    iconTheme: IconThemeData(
      color: whatsappThemeLight.whiteColor,
      size: 25,
    ),
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    elevation: 0.0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: whatsappThemeLight.greenColor,
    foregroundColor: whatsappThemeLight.whiteColor,
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorColor: whatsappThemeLight.greenColor,
    labelStyle: TextStyle(
        fontSize: 15.0,
        color: whatsappThemeLight.whiteColor,
        fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(
      fontSize: 15.0,
      color: whatsappThemeLight.whiteColor.withOpacity(0.8),
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: whatsappThemeLight.greenColor,
      foregroundColor: whatsappThemeLight.backgroundColor,
      splashFactory: NoSplash.splashFactory,
      elevation: 0,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
  ),
);
