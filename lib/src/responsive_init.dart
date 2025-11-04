import 'package:flutter/material.dart';
import 'responsive.dart';

/// Global helper class to store screen dimensions and config
///
/// This class allows extensions (like `.w`, `.h`, `.sp`) to access screen dimensions
/// without requiring BuildContext, similar to how flutter_screenutil works.
///
/// **Note:** This class is automatically initialized by [ScaleXInit] widget.
/// You typically don't need to interact with it directly.
class ScaleXHelper {
  static ScaleXConfig? _config;
  static double? _screenWidth;
  static double? _screenHeight;
  static double? _scale;
  
  /// Get the current config (null if not initialized)
  static ScaleXConfig? get config => _config;
  
  /// Get the current screen width (null if not initialized)
  static double? get screenWidth => _screenWidth;
  
  /// Get the current screen height (null if not initialized)
  static double? get screenHeight => _screenHeight;
  
  /// Get the current scale factor (null if not initialized)
  static double? get scale => _scale;
  
  /// Check if ScaleXHelper has been initialized
  ///
  /// Returns true if both config and screen dimensions are set.
  static bool get isInitialized => _config != null && _screenWidth != null;
  
  /// Set the configuration (typically called by ScaleXInit)
  static void setConfig(ScaleXConfig config) {
    _config = config;
  }
  
  /// Set the screen size (typically called by ScaleXInit)
  ///
  /// Automatically calculates the scale factor based on the current config.
  static void setScreenSize(double width, double height) {
    _screenWidth = width;
    _screenHeight = height;
    if (_config != null) {
      _scale = width / _config!.baseWidth;
    }
  }
  
  /// Clear all stored configuration and dimensions
  ///
  /// Useful for testing or resetting state.
  static void clearConfig() {
    _config = null;
    _screenWidth = null;
    _screenHeight = null;
    _scale = null;
  }
  
  /// Get device type based on stored width and config
  ///
  /// Returns [DeviceType.mobile] if not initialized (fallback).
  static DeviceType get deviceType {
    if (_screenWidth == null || _config == null) {
      return DeviceType.mobile; // Default fallback
    }
    if (_screenWidth! < _config!.mobileBreakpoint) return DeviceType.mobile;
    if (_screenWidth! < _config!.tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
  }
  
  /// Returns true if the device is a desktop
  static bool get isDesktop => deviceType == DeviceType.desktop;
  
  /// Returns true if the device is a mobile
  static bool get isMobile => deviceType == DeviceType.mobile;
  
  /// Returns true if the device is a tablet
  static bool get isTablet => deviceType == DeviceType.tablet;
}

/// Widget that initializes ScaleX configuration
///
/// This widget should wrap your app's root widget (typically MaterialApp) to enable
/// ScaleX extensions (`.w`, `.h`, `.sp`, `.r`) throughout your app.
///
/// Example:
/// ```dart
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return ScaleXInit(
///       config: ScaleXConfig(
///         baseWidth: 393.0,
///         mobileBreakpoint: 640.0,
///         tabletBreakpoint: 1024.0,
///         scaleOnDesktop: false,
///       ),
///       child: MaterialApp(
///         // ... your app
///       ),
///     );
///   }
/// }
/// ```
///
/// **Note:** This widget automatically updates the global [ScaleXHelper] with screen
/// dimensions, allowing extensions to work without BuildContext.
class ScaleXInit extends StatelessWidget {
  /// Configuration for responsive scaling
  final ScaleXConfig config;
  
  /// Child widget (typically your MaterialApp or root widget)
  final Widget child;

  /// Creates a new [ScaleXInit] widget
  ///
  /// [config] is required and specifies how ScaleX should behave.
  /// [child] is required and is typically your MaterialApp.
  const ScaleXInit({
    Key? key,
    required this.config,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions from MediaQuery
    final screenSize = MediaQuery.of(context).size;
    
    // Set the global config and screen size so extensions can access them
    ScaleXHelper.setConfig(config);
    ScaleXHelper.setScreenSize(screenSize.width, screenSize.height);
    
    return child;
  }
}

