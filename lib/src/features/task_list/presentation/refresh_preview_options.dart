/// Turns the refresh comparison on:
/// `flutter run --dart-define=ENABLE_REFRESH_COMPARISON=true`.
const refreshComparisonEnabled = bool.fromEnvironment(
  'ENABLE_REFRESH_COMPARISON',
);

/// How long the fake preview operation takes.
const refreshPreviewDuration = Duration(milliseconds: 900);

/// A preview can never hang the screen longer than this.
const refreshPreviewTimeout = Duration(seconds: 10);

const refreshSettleDuration = Duration(milliseconds: 180);
const refreshCancelDuration = Duration(milliseconds: 200);
const refreshCompleteDuration = Duration(milliseconds: 600);
const refreshCollapseDuration = Duration(milliseconds: 220);

/// The preview only waits. It never reads or writes tasks.
Future<void> runRefreshPreview() => Future.delayed(refreshPreviewDuration);

const refreshRiveAsset = 'assets/animations/task_refresh_comparison.riv';
const refreshRiveStateMachine = 'Refresh';
