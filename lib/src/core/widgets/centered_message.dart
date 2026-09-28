import 'package:material_ui/material_ui.dart';

class const CenteredMessage({super.key, required final String message})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
