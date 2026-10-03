import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/features/task_list/presentation/refresh_preview_options.dart';
import 'package:rive/rive.dart';

/// Loads the comparison .riv once for the whole Home screen.
/// Players only borrow the file; this class disposes it.
class RefreshRiveFile {
  RefreshRiveFile(this._logger);

  final Logger _logger;
  Future<File?>? _loading;
  bool _disposed = false;

  /// Null when the asset could not be loaded (the caller shows a fallback).
  Future<File?> load() => _loading ??= _load();

  Future<File?> _load() async {
    try {
      await RiveNative.init();
      final file = await File.asset(refreshRiveAsset, riveFactory: .rive);
      if (_disposed) file?.dispose();
      return _disposed ? null : file;
    } on Object catch (error, stackTrace) {
      _logger.severe(
        'Refresh animation failed to load',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    (await _loading)?.dispose();
  }
}
