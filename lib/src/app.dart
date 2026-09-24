import 'package:material_ui/material_ui.dart';
import 'package:todo_app/src/theme/dark_theme.dart';
import 'package:todo_app/src/localization/app_localizations.dart';

import 'package:todo_app/src/utils/extensions.dart';
import 'package:todo_app/src/features/todo_list/presentation/my_todo_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en', '')],
      onGenerateTitle: (BuildContext context) => context.loc.app_title,
      theme: ThemeData(),
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      home: const MyTodoScreen(),
    );
  }
}
