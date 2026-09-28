import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/localization/string_hardcoded.dart';
import 'package:lifely/src/core/logging/logger.dart';

/// Sends every uncaught error to [logger], marked as fatal.
void registerErrorHandlers(Logger logger) {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.severe(
      'Flutter error',
      error: details.exception,
      stackTrace: details.stack,
      fatal: true,
    );
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.severe(
      'Platform error',
      error: error,
      stackTrace: stackTrace,
      fatal: true,
    );
    return true;
  };
  ErrorWidget.builder = (details) {
    logger.severe(
      'Widget build error',
      error: details.exception,
      stackTrace: details.stack,
    );
    return Scaffold(
      appBar: AppBar(title: Text('An error occurred'.hardcoded)),
      body: Center(child: Text(details.toString())),
    );
  };
}
