import 'package:material_ui/material_ui.dart';
import 'package:todo_app/src/constants/app_sizes.dart';
import 'package:todo_app/src/theme/colors.dart';

const _shape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(Sizes.p4)),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  // [Color Scheme]
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: darkPrimaryColor,
    onPrimary: darkOnPrimaryColor,
    secondary: darkSecondaryColor,
    onSecondary: darkOnSecondaryColor,
    error: darkErrorColor,
    onError: darkOnErrorColor,
    surface: darkSurfaceColor,
    onSurface: darkOnSurfaceColor,
    surfaceContainerHigh: Color.fromARGB(255, 46, 46, 46),
  ),

  // [List Tile Theme]
  listTileTheme: const ListTileThemeData(
    tileColor: darkSecondaryColor,
    titleTextStyle: TextStyle(
      color: darkOnSurfaceColor,
      fontWeight: FontWeight.normal,
      decorationThickness: 2,
    ),
    subtitleTextStyle: TextStyle(color: darkOnSecondaryColor),
    shape: _shape,
  ),

  // [Check Box Theme]
  checkboxTheme: const CheckboxThemeData(shape: CircleBorder()),

  // [Elevate Button Theme]
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(darkPrimaryColor),
      foregroundColor: WidgetStatePropertyAll(darkOnPrimaryColor),
      shape: WidgetStatePropertyAll(_shape),
    ),
  ),

  // [Dialog theme]
  dialogTheme: const DialogThemeData(
    shape: _shape,
    backgroundColor: darkSecondaryColor,
    contentTextStyle: TextStyle(color: darkOnSecondaryColor),
  ),

  // [Date Picker Theme]
  datePickerTheme: const DatePickerThemeData(
    backgroundColor: darkSecondaryColor,
  ),

  // [Icon Button Theme]
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.zero),
      shape: WidgetStatePropertyAll(_shape),
    ),
  ),

  // [Text Field Theme]
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),

  // [Card Theme]
  cardTheme: const CardThemeData(color: darkSecondaryColor, shape: _shape),

  // [Text Button Theme]
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(darkOnPrimaryColor),
    ),
  ),
);
