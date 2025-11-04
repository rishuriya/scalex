import 'package:flutter/material.dart';
import 'responsive.dart';
import 'responsive_init.dart';

/// Extension on [num] to provide easy access to responsive sizing
/// Similar to flutter_screenutil but smarter for web/desktop
/// 
/// Works by accessing global screen dimensions set by ResponsiveInit
extension ResponsiveExtension on num {
  /// Width scaling (horizontal)
  /// Scales based on screen width, but returns fixed value on desktop
  /// 
  /// Usage: `100.w` - scales 100 based on screen width
  double get w {
    if (!ScaleXHelper.isInitialized) {
      // Fallback if not initialized
      return toDouble();
    }
    
    final config = ScaleXHelper.config!;
    final scale = ScaleXHelper.scale!;
    
    // On desktop, return fixed base size (unless scaleOnDesktop is true)
    if (ScaleXHelper.isDesktop && !config.scaleOnDesktop) {
      return toDouble();
    }
    
    // On mobile and tablet, apply scaling
    return toDouble() * scale;
  }

  /// Height scaling (vertical)
  /// Scales based on screen height, but returns fixed value on desktop
  /// 
  /// Usage: `50.h` - scales 50 based on screen height
  double get h {
    if (!ScaleXHelper.isInitialized) {
      return toDouble();
    }
    
    final config = ScaleXHelper.config!;
    final screenHeight = ScaleXHelper.screenHeight!;
    
    // On desktop, return fixed base size (unless scaleOnDesktop is true)
    if (ScaleXHelper.isDesktop && !config.scaleOnDesktop) {
      return toDouble();
    }
    
    // Use height-based scaling for height
    final heightScale = screenHeight / (config.baseWidth * 1.78); // Approximate aspect ratio
    return toDouble() * heightScale;
  }

  /// Font size scaling
  /// Scales based on screen width, but returns fixed value on desktop
  /// 
  /// Usage: `16.sp` - scales 16 based on screen width
  double get sp {
    return w; // Same as width scaling
  }

  /// Responsive sizing (general purpose)
  /// Same as .w but more semantic
  /// 
  /// Usage: `20.r` - scales 20 responsively
  double get r {
    return w; // Same as width scaling
  }

  /// Responsive sizing with min/max constraints
  /// 
  /// Usage: `200.rWithConstraints(min: 180, max: 220)`
  double rWithConstraints({required double min, required double max}) {
    if (!ScaleXHelper.isInitialized) {
      return toDouble().clamp(min, max);
    }
    
    final config = ScaleXHelper.config!;
    final scale = ScaleXHelper.scale!;
    
    // On desktop, return fixed base size (unless scaleOnDesktop is true)
    if (ScaleXHelper.isDesktop && !config.scaleOnDesktop) {
      return toDouble().clamp(min, max);
    }
    
    // On mobile and tablet, apply scaling with constraints
    final scaled = toDouble() * scale;
    return scaled.clamp(min, max);
  }

  /// Width scaling with min/max constraints
  /// 
  /// Usage: `100.wWithConstraints(min: 80, max: 120)`
  double wWithConstraints({required double min, required double max}) {
    return rWithConstraints(min: min, max: max);
  }

  /// Height scaling with min/max constraints
  /// 
  /// Usage: `50.hWithConstraints(min: 40, max: 60)`
  double hWithConstraints({required double min, required double max}) {
    if (!ScaleXHelper.isInitialized) {
      return toDouble().clamp(min, max);
    }
    
    final config = ScaleXHelper.config!;
    final screenHeight = ScaleXHelper.screenHeight!;
    
    // On desktop, return fixed base size (unless scaleOnDesktop is true)
    if (ScaleXHelper.isDesktop && !config.scaleOnDesktop) {
      return toDouble().clamp(min, max);
    }
    
    // Use height-based scaling for height
    final heightScale = screenHeight / (config.baseWidth * 1.78);
    final scaled = toDouble() * heightScale;
    return scaled.clamp(min, max);
  }

  /// Font size scaling with min/max constraints
  /// 
  /// Usage: `40.spWithConstraints(min: 32, max: 48)`
  double spWithConstraints({required double min, required double max}) {
    return rWithConstraints(min: min, max: max);
  }
}

/// Improved extension that uses BuildContext from widget tree
class ResponsiveExtensionWithContext {
  final BuildContext context;
  
  ResponsiveExtensionWithContext(this.context);
  
  /// Get the Responsive instance for this context
  Responsive get _responsive {
    // Use config from ScaleXHelper if available, otherwise use default
    final config = ScaleXHelper.config;
    return Responsive(context, config: config);
  }
  
  /// Width scaling (horizontal)
  /// Scales based on screen width, but returns fixed value on desktop
  double w(num value) {
    return _responsive.size(value.toDouble());
  }

  /// Height scaling (vertical)
  /// Scales based on screen height, but returns fixed value on desktop
  double h(num value) {
    final responsive = _responsive;
    final scale = responsive.height / (responsive.config.baseWidth * 1.78);
    if (responsive.isDesktop && !responsive.config.scaleOnDesktop) {
      return value.toDouble();
    }
    return value.toDouble() * scale;
  }

  /// Font size scaling
  /// Scales based on screen width, but returns fixed value on desktop
  double sp(num value) {
    return w(value);
  }

  /// Responsive sizing (general purpose)
  /// Same as .w but more semantic
  double r(num value) {
    return w(value);
  }

  /// Responsive sizing with min/max constraints
  double rWithConstraints(num value, {required double min, required double max}) {
    return _responsive.size(value.toDouble(), min: min, max: max);
  }
}

/// Extension on BuildContext for easy access to responsive helpers
/// This is the recommended way to use responsive sizing
extension ResponsiveContextExtension on BuildContext {
  /// Get responsive extension with context
  /// 
  /// Usage:
  /// ```dart
  /// context.responsive.w(100)  // responsive width
  /// context.responsive.h(50)    // responsive height
  /// context.responsive.sp(16)   // responsive font size
  /// ```
  ResponsiveExtensionWithContext get responsive {
    return ResponsiveExtensionWithContext(this);
  }
  
  /// Quick access to responsive width
  /// 
  /// Usage: `context.rw(100)`
  double rw(num value) => responsive.w(value);
  
  /// Quick access to responsive height
  /// 
  /// Usage: `context.rh(50)`
  double rh(num value) => responsive.h(value);
  
  /// Quick access to responsive font size
  /// 
  /// Usage: `context.rsp(16)`
  double rsp(num value) => responsive.sp(value);
  
  /// Quick access to responsive sizing (general purpose)
  /// 
  /// Usage: `context.rr(20)`
  double rr(num value) => responsive.r(value);
  
  /// Quick access to responsive sizing with constraints
  /// 
  /// Usage: `context.rrWithConstraints(200, min: 180, max: 220)`
  double rrWithConstraints(num value, {required double min, required double max}) {
    return responsive.rWithConstraints(value, min: min, max: max);
  }
}

