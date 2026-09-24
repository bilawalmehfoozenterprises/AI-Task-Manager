import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';

/// Material 3 window size classes, picked by the window's width.
/// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
enum WindowSizeClass({
  /// Widths below this value belong to this class.
  required final double maxWidth,

  /// Recommended horizontal margin around the content.
  required final double margin,

  /// Recommended number of side-by-side panes.
  required final int panes,
}) {
  /// Phones in portrait.
  compact(maxWidth: 600, margin: Sizes.p16, panes: 1),

  /// Foldables and small tablets in portrait.
  medium(maxWidth: 840, margin: Sizes.p24, panes: 1),

  /// Tablets and foldables in landscape.
  expanded(maxWidth: 1200, margin: Sizes.p24, panes: 2),

  /// Desktop windows.
  large(maxWidth: 1600, margin: Sizes.p24, panes: 2),

  /// Very wide desktop windows.
  extraLarge(maxWidth: double.infinity, margin: Sizes.p24, panes: 2);

  static WindowSizeClass fromWidth(double width) =>
      values.firstWhere((sizeClass) => width < sizeClass.maxWidth);
}

extension WindowSizeClassContext on BuildContext {
  /// The window size class for the current screen width.
  WindowSizeClass get windowSizeClass =>
      .fromWidth(MediaQuery.sizeOf(this).width);
}
