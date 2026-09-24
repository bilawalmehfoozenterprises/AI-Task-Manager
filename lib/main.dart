import 'package:material_ui/material_ui.dart';
import 'package:todo_app/src/app_initializer.dart';

void main() async {
  runApp(await AppInitializer().initializeAndRun());
}
