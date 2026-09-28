import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/localization/app_localizations.dart';
import 'package:lifely/src/core/theme/dark_theme.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';

/// The root widget: theme, translations, and routing.
class const LifelyApp({super.key, required final GoRouter router})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en')],
      onGenerateTitle: (context) => context.loc.app_title,
      theme: ThemeData(),
      darkTheme: darkTheme,
      themeMode: .dark,
    );
  }
}
