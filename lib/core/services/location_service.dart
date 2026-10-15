import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../router/app_router.dart';

part 'location_service.g.dart';

@riverpod
LocationService locationService(Ref ref) {
  return LocationService();
}

/// Helper observer that waits for the app to go into the background and return to foreground (resumed).
class _AppResumeObserver with WidgetsBindingObserver {
  final Completer<void> _completer = Completer<void>();
  bool _didPause = false;
  bool _disposed = false;

  _AppResumeObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> get onResume => _completer.future;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _didPause = true;
    } else if (state == AppLifecycleState.resumed && _didPause) {
      if (!_completer.isCompleted) {
        _completer.complete();
      }
    }
  }

  void dispose() {
    if (!_disposed) {
      _disposed = true;
      WidgetsBinding.instance.removeObserver(this);
    }
  }
}

class LocationService {
  Future<bool> checkAndRequestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<bool> isPermissionDeniedForever() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.deniedForever;
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  void _showDeniedSnackBar() {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null && ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Permission denied: Location fetching failed'),
        ),
      );
    }
  }

  Future<Position?> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showDeniedSnackBar();
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      final observer = _AppResumeObserver();
      try {
        final opened = await Geolocator.openAppSettings();
        if (!opened) {
          _showDeniedSnackBar();
          return null;
        }

        // Wait until user returns to the app from settings
        await observer.onResume;
      } finally {
        observer.dispose();
      }

      // Check permission on return from settings
      permission = await Geolocator.checkPermission();
      final hasPermission = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;

      if (!hasPermission) {
        _showDeniedSnackBar();
        return null;
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
      } catch (e) {
        return null;
      }
    }

    _showDeniedSnackBar();
    return null;
  }
}
