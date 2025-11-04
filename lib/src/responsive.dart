import 'package:flutter/material.dart';

/// Device type enumeration for responsive design
enum DeviceType {
  /// Mobile device (typically < 640px width)
  mobile,
  
  /// Tablet device (typically 640px - 1024px width)
  tablet,
  
  /// Desktop device (typically > 1024px width)
  desktop,
}

/// Configuration for ScaleX scaling behavior
///
/// This class allows you to customize how ScaleX scales your UI across different devices.
///
/// Example:
/// ```dart
/// ScaleXConfig(
///   baseWidth: 393.0, // iPhone 14 Pro width
///   mobileBreakpoint: 640.0,
///   tabletBreakpoint: 1024.0,
///   scaleOnDesktop: false, // Keep fixed sizes on desktop
/// )
/// ```
class ScaleXConfig {
  /// Base width for scaling calculations (typically iPhone 14 Pro width: 393.0)
  ///
  /// All scaling calculations use this as the baseline. For example, if baseWidth is 393.0
  /// and current screen width is 375.0, the scale factor will be 375/393 ≈ 0.954.
  final double baseWidth;
  
  /// Breakpoint for mobile devices (default: 640.0)
  ///
  /// Screens with width < mobileBreakpoint are considered mobile devices.
  final double mobileBreakpoint;
  
  /// Breakpoint for tablet devices (default: 1024.0)
  ///
  /// Screens with width >= mobileBreakpoint and < tabletBreakpoint are considered tablets.
  /// Screens with width >= tabletBreakpoint are considered desktop.
  final double tabletBreakpoint;
  
  /// Enable scaling on desktop (default: false)
  ///
  /// When false (default), desktop devices receive fixed sizes without scaling.
  /// When true, desktop devices will also scale based on screen width.
  ///
  /// **Note:** Setting this to true may cause layouts to look broken on large desktop screens.
  final bool scaleOnDesktop;

  /// Creates a new [ScaleXConfig]
  ///
  /// All parameters are optional and have sensible defaults.
  const ScaleXConfig({
    this.baseWidth = 393.0,
    this.mobileBreakpoint = 640.0,
    this.tabletBreakpoint = 1024.0,
    this.scaleOnDesktop = false,
  });
}

/// Main Responsive class that provides smart scaling
///
/// This class provides methods and properties for responsive sizing that intelligently
/// scales on mobile/tablet devices while keeping desktop sizes fixed.
///
/// Example:
/// ```dart
/// Widget build(BuildContext context) {
///   final r = Responsive(context);
///   
///   return Container(
///     width: r.size(100, min: 80, max: 120),
///     padding: EdgeInsets.all(r.md),
///     child: Text(
///       'Hello',
///       style: TextStyle(fontSize: r.textBase),
///     ),
///   );
/// }
/// ```
class Responsive {
  /// The build context used to access MediaQuery
  final BuildContext context;
  
  /// The configuration for scaling behavior
  final ScaleXConfig config;
  
  /// The current screen width
  late final double width;
  
  /// The current screen height
  late final double height;

  /// Creates a new [Responsive] instance
  ///
  /// If [config] is not provided, uses default [ScaleXConfig].
  ///
  /// Example:
  /// ```dart
  /// final responsive = Responsive(context);
  /// // or with custom config
  /// final responsive = Responsive(
  ///   context,
  ///   config: ScaleXConfig(baseWidth: 400.0),
  /// );
  /// ```
  Responsive(this.context, {ScaleXConfig? config})
      : config = config ?? ScaleXConfig(),
        width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

  /// Base scale factor (scales everything proportionally)
  ///
  /// Calculated as: `width / config.baseWidth`
  ///
  /// Example: If baseWidth is 393.0 and current width is 375.0, scale = 375/393 ≈ 0.954
  double get scale => width / config.baseWidth;

  /// Calculates responsive size with optional min/max constraints
  ///
  /// **Behavior:**
  /// - On desktop (by default): Returns `baseSize` without scaling
  /// - On mobile/tablet: Scales `baseSize` by the scale factor
  /// - If `min` and `max` are provided: Clamps the result between min and max
  ///
  /// Example:
  /// ```dart
  /// final size = responsive.size(100); // Scales on mobile/tablet, fixed on desktop
  /// final constrained = responsive.size(100, min: 80, max: 120); // With constraints
  /// ```
  ///
  /// Returns the calculated size, clamped to [min] and [max] if provided.
  double size(double baseSize, {double? min, double? max}) {
    // On desktop, return fixed base size (unless scaleOnDesktop is true)
    if (isDesktop && !config.scaleOnDesktop) {
      return baseSize;
    }
    
    // On mobile and tablet, apply scaling
    final scaled = baseSize * scale;
    if (min != null && max != null) {
      return scaled.clamp(min, max);
    }
    return scaled;
  }

  /// Predefined spacing that just works
  /// Only scales on mobile and tablet, returns fixed values on desktop
  double get xs => isDesktop && !config.scaleOnDesktop ? 4.0 : size(4, min: 4, max: 6);
  double get sm => isDesktop && !config.scaleOnDesktop ? 8.0 : size(8, min: 8, max: 12);
  double get md => isDesktop && !config.scaleOnDesktop ? 16.0 : size(16, min: 14, max: 20);
  double get lg => isDesktop && !config.scaleOnDesktop ? 24.0 : size(24, min: 20, max: 32);
  double get xl => isDesktop && !config.scaleOnDesktop ? 32.0 : size(32, min: 28, max: 48);

  /// Typography
  /// Only scales on mobile and tablet, returns fixed values on desktop
  double get textXs => isDesktop && !config.scaleOnDesktop ? 12.0 : size(12, min: 11, max: 13);
  double get textSm => isDesktop && !config.scaleOnDesktop ? 14.0 : size(14, min: 13, max: 15);
  double get textBase => isDesktop && !config.scaleOnDesktop ? 16.0 : size(16, min: 15, max: 17);
  double get textLg => isDesktop && !config.scaleOnDesktop ? 18.0 : size(18, min: 17, max: 20);
  double get textXl => isDesktop && !config.scaleOnDesktop ? 20.0 : size(20, min: 19, max: 24);
  double get textH1 => isDesktop && !config.scaleOnDesktop ? 28.0 : size(28, min: 24, max: 32);

  /// Device type detection
  DeviceType get deviceType {
    if (width < config.mobileBreakpoint) return DeviceType.mobile;
    if (width < config.tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Conditional sizing by device type
  double sizeMobile(double mobile, {double? tablet, double? desktop}) {
    switch (deviceType) {
      case DeviceType.mobile:
        return size(mobile, min: mobile * 0.9, max: mobile * 1.1);
      case DeviceType.tablet:
        return tablet ?? mobile * 1.5;
      case DeviceType.desktop:
        return desktop ?? mobile * 2;
    }
  }
}

/// Extension for easy access
extension ResponsiveContext on BuildContext {
  Responsive get r => Responsive(this);
}

