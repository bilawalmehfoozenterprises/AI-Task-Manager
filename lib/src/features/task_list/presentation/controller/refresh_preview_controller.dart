import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_outcome.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_variant.dart';
import 'package:lifely/src/features/task_list/presentation/refresh_preview_options.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Screen-wide state for the refresh comparison: which animation is picked,
/// whether a refresh is running, and the one operation that may run at a time.
class RefreshPreviewController {
  RefreshPreviewController(
    this._logger, {
    this.operation = runRefreshPreview,
    this.timeout = refreshPreviewTimeout,
  });

  final Logger _logger;
  final Future<void> Function() operation;
  final Duration timeout;

  /// Applies to both tabs. A fresh Home starts with the tornado.
  final selected = signal(RefreshVariant.tornado);

  /// The variant used by the running cycle. Stays fixed until it ends.
  final latched = signal<RefreshVariant?>(null);

  /// How the last cycle ended. Reset when a new cycle starts.
  final outcome = signal<RefreshOutcome?>(null);

  /// Goes up by one each time the sheet asks for a preview.
  final previewRequests = signal(0);

  late final busy = computed(() => latched.value != null);

  int _token = 0;
  bool _disposed = false;

  /// Changes the next animation. Ignored while a cycle runs.
  bool select(RefreshVariant variant) {
    if (busy.value) return false;
    selected.value = variant;
    return true;
  }

  /// Asks the visible tab to run a preview, as if the user pulled.
  bool requestPreview() {
    if (busy.value) return false;
    previewRequests.value++;
    return true;
  }

  /// Runs one refresh. A second call while busy is ignored (cancelled).
  Future<RefreshOutcome> run() async {
    if (busy.value || _disposed) return .cancelled;
    final token = ++_token;
    latched.value = selected.value;
    outcome.value = null;
    final result = await _attempt();
    if (token != _token || _disposed) return .cancelled;
    return outcome.value = result;
  }

  Future<RefreshOutcome> _attempt() async {
    try {
      await operation().timeout(timeout);
      return .succeeded;
    } on Object catch (error, stackTrace) {
      _logger.severe(
        'Refresh preview failed',
        error: error,
        stackTrace: stackTrace,
      );
      return .failed;
    }
  }

  /// Call when the visual has finished closing.
  void finish() {
    if (!_disposed) latched.value = null;
  }

  void dispose() {
    _disposed = true;
    _token++;
    selected.dispose();
    latched.dispose();
    outcome.dispose();
    previewRequests.dispose();
    busy.dispose();
  }
}
