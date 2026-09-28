import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/localization/app_localizations.dart';

// extension to reduce boilerplate code for using localized text
extension LocalizationExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}

// extension for easy access to themdata
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}

// extension for easy access to texttheme
extension TextThemeExtension on BuildContext {
  TextTheme get txtTheme => Theme.of(this).textTheme;
}

// extension for easy access to colorscheme
extension ColorSchemeExtension on BuildContext {
  ColorScheme get color => Theme.of(this).colorScheme;
}
