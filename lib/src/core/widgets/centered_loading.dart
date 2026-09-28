import 'package:material_ui/material_ui.dart';

class const CenteredLoading({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
