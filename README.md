# ScaleX 🚀

**ScaleX** - The smart scaling solution for Flutter. Scale flawlessly across all devices without breaking desktop layouts.

> **Better than ScreenUtil** - Same simple syntax (`4.w`, `4.h`, `4.sp`), but smarter behavior that actually works on desktop and web.

## Why ScaleX?

- 🎯 **Simple syntax** - Just like ScreenUtil: `100.w`, `50.h`, `16.sp`
- 🧠 **Smart scaling** - Only scales on mobile/tablet, keeps desktop fixed
- 🌐 **Web-friendly** - Doesn't break desktop layouts like ScreenUtil does
- ⚡ **Lightweight** - Zero dependencies, pure Dart
- 🔧 **Configurable** - Easy breakpoints from your main widget
- 📏 **Min/Max constraints** - New! `40.spWithConstraints(min: 32, max: 48)` for precise control

## Features

- ✅ Simple syntax like `4.w`, `4.h`, `4.sp`, `4.r`
- ✅ **NEW!** Constraint-based scaling: `40.spWithConstraints(min: 32, max: 48)`
- ✅ Smart scaling - only scales on mobile/tablet, fixed sizes on desktop
- ✅ Works great for web and native apps
- ✅ Easy initialization from root widget
- ✅ Configurable breakpoints
- ✅ Type-safe extensions

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  scalex:
    path: packages/scalex
```

## Usage

### 1. Initialize in your main widget

```dart
import 'package:scalex/scalex.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaleXInit(
      config: ScaleXConfig(
        baseWidth: 393.0, // iPhone 14 Pro width
        mobileBreakpoint: 640.0,
        tabletBreakpoint: 1024.0,
        scaleOnDesktop: false, // Keep fixed sizes on desktop
      ),
      child: MaterialApp(
        // ... your app
      ),
    );
  }
}
```

### 2. Use simple extensions (just like ScreenUtil!)

```dart
// Width scaling - works exactly like ScreenUtil!
Container(
  width: 100.w,  // Scales on mobile/tablet, fixed on desktop
  height: 50.h,  // Scales on mobile/tablet, fixed on desktop
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16.sp), // Scales on mobile/tablet, fixed on desktop
  ),
)

// Responsive sizing
SizedBox(width: 20.r)
```

**That's it!** The simple syntax `4.w`, `4.h`, `4.sp`, `4.r` works exactly like `flutter_screenutil` but smarter.

### 3. Use constraints for precise control (NEW! ✨)

ScaleX now supports min/max constraints directly on the extensions:

```dart
// Font size with constraints
TextStyle(
  fontSize: 40.spWithConstraints(min: 32, max: 48),
)

// Width with constraints
Container(
  width: 200.wWithConstraints(min: 160, max: 240),
)

// Height with constraints
Container(
  height: 100.hWithConstraints(min: 80, max: 120),
)

// General responsive with constraints
SizedBox(
  width: 50.rWithConstraints(min: 40, max: 60),
)
```

**Before (old way):**
```dart
Responsive(context).size(40, min: 32, max: 48)
```

**After (new way - cleaner!):**
```dart
40.spWithConstraints(min: 32, max: 48)
```

Much cleaner and more readable! 🎉

### 4. (Optional) Use with BuildContext for more control

```dart
Widget build(BuildContext context) {
  return Container(
    width: context.rw(100),  // responsive width
    height: context.rh(50),  // responsive height
    child: Text(
      'Hello',
      style: TextStyle(fontSize: context.rsp(16)),
    ),
  );
}
```

**Note:** The simple extensions (`4.w`, `4.h`, `4.sp`) work everywhere and are the recommended way!

### 5. Use Responsive class directly

```dart
Widget build(BuildContext context) {
  final r = Responsive(context);
  
  return Container(
    width: r.size(100),
    padding: EdgeInsets.all(r.md),
    child: Text(
      'Hello',
      style: TextStyle(fontSize: r.textBase),
    ),
  );
}
```

## API Reference

### Extensions (Simple & Clean)

- `4.w` - Width scaling
- `4.h` - Height scaling
- `4.sp` - Font size scaling
- `4.r` - General responsive sizing

### Extensions with Constraints (NEW! ✨)

- `40.spWithConstraints(min: 32, max: 48)` - Font size with min/max
- `200.wWithConstraints(min: 160, max: 240)` - Width with min/max
- `100.hWithConstraints(min: 80, max: 120)` - Height with min/max
- `50.rWithConstraints(min: 40, max: 60)` - General responsive with min/max

### Context Extensions

- `context.rw(100)` - Responsive width
- `context.rh(50)` - Responsive height
- `context.rsp(16)` - Responsive font size
- `context.rr(20)` - Responsive general sizing
- `context.rrWithConstraints(200, min: 180, max: 220)` - With constraints

### Responsive Class

- `Responsive(context).size(baseSize, min: min, max: max)`
- `Responsive(context).xs`, `.sm`, `.md`, `.lg`, `.xl`
- `Responsive(context).textXs`, `.textSm`, `.textBase`, `.textLg`, `.textXl`, `.textH1`
- `Responsive(context).isMobile`, `.isTablet`, `.isDesktop`

## Why Better Than flutter_screenutil?

### The Desktop Problem

**ScreenUtil's Issue:**
ScreenUtil scales everything based on screen width, even on desktop. This creates a major problem:

- **Desktop screens vary wildly** (1366px → 2560px → 3840px+)
- **Width changes dramatically** between laptops and desktops
- **Scaling formula** (`currentWidth / designWidth`) produces inconsistent sizes
- **Example:** A 16px font on a 1366px laptop becomes 30px+ on a 4K monitor
- **Result:** Layouts look broken, text is too large, buttons are oversized

**ScaleX's Solution:**
- **Fixed sizes on desktop** - No scaling above the tablet breakpoint
- **Predictable layouts** - Your 16px font stays 16px on desktop
- **Consistent UX** - Desktop users see properly sized UI elements
- **Only scales on mobile/tablet** - Where screen sizes are more consistent

### Comparison Table

| Feature | ScreenUtil | ScaleX |
|---------|-----------|--------|
| Simple syntax (`4.w`, `4.h`) | ✅ | ✅ |
| Desktop-friendly | ❌ | ✅ |
| Web-optimized | ❌ | ✅ |
| Smart scaling | ❌ | ✅ |
| Fixed sizes on desktop | ❌ | ✅ |
| Min/Max constraints | ❌ | ✅ |
| Zero dependencies | ❌ | ✅ |

### Real-World Example

**ScreenUtil (broken on desktop):**
```dart
// On 1366px laptop
Text(fontSize: 16.sp)  // → 16px ✅

// On 2560px desktop
Text(fontSize: 16.sp)  // → 30px ❌ (too large!)
```

**ScaleX (works perfectly):**
```dart
// On 1366px laptop
Text(fontSize: 16.sp)  // → 16px ✅ (fixed on desktop)

// On 2560px desktop
Text(fontSize: 16.sp)  // → 16px ✅ (fixed on desktop)
```

### The Math Behind It

**ScreenUtil's formula:**
```
scaledSize = baseSize × (currentWidth / designWidth)
```

**Problem:** On desktop, `currentWidth` can be 2-3x larger than design width, making everything 2-3x larger!

**ScaleX's approach:**
```
if (isDesktop) {
  return baseSize;  // Fixed size
} else {
  return baseSize × (currentWidth / designWidth);  // Scale on mobile/tablet
}
```

**Result:** Consistent, predictable sizes across all devices! 🎯

## License

MIT
