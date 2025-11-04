import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalex/scalex.dart';

void main() {
  group('ResponsiveExtension', () {
    testWidgets('should return base value when not initialized', (WidgetTester tester) async {
      // Clear any existing config
      ScaleXHelper.clearConfig();
      
      // Test that extensions return base value when not initialized
      expect(100.w, 100.0);
      expect(50.h, 50.0);
      expect(16.sp, 16.0);
      expect(20.r, 20.0);
    });

    testWidgets('should scale width on mobile', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScaleXInit(
            config: const ScaleXConfig(baseWidth: 393.0),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  // Scale factor: 375 / 393 ≈ 0.954
                  expect(100.w, closeTo(95.4, 0.1));
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should return fixed width on desktop', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1920, 1080)),
          child: ScaleXInit(
            config: const ScaleXConfig(baseWidth: 393.0),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  // On desktop, should return base value
                  expect(100.w, 100.0);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should scale height on mobile', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScaleXInit(
            config: const ScaleXConfig(baseWidth: 393.0),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  // Height should scale based on height ratio
                  final heightValue = 50.h;
                  expect(heightValue, isA<double>());
                  expect(heightValue, greaterThan(0));
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should return fixed height on desktop', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1920, 1080)),
          child: ScaleXInit(
            config: const ScaleXConfig(baseWidth: 393.0),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  // On desktop, should return base value
                  expect(50.h, 50.0);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should scale font size on mobile', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScaleXInit(
            config: const ScaleXConfig(baseWidth: 393.0),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  // Scale factor: 375 / 393 ≈ 0.954
                  expect(16.sp, closeTo(15.27, 0.1));
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should return fixed font size on desktop', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1920, 1080)),
          child: ScaleXInit(
            config: const ScaleXConfig(baseWidth: 393.0),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  // On desktop, should return base value
                  expect(16.sp, 16.0);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should respect constraints with wWithConstraints', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScaleXInit(
            config: const ScaleXConfig(baseWidth: 393.0),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  final value = 100.wWithConstraints(min: 90, max: 110);
                  expect(value, greaterThanOrEqualTo(90));
                  expect(value, lessThanOrEqualTo(110));
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should respect constraints with hWithConstraints', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScaleXInit(
            config: const ScaleXConfig(baseWidth: 393.0),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  final value = 50.hWithConstraints(min: 40, max: 60);
                  expect(value, greaterThanOrEqualTo(40));
                  expect(value, lessThanOrEqualTo(60));
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should respect constraints with spWithConstraints', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScaleXInit(
            config: const ScaleXConfig(baseWidth: 393.0),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  final value = 40.spWithConstraints(min: 32, max: 48);
                  expect(value, greaterThanOrEqualTo(32));
                  expect(value, lessThanOrEqualTo(48));
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should respect constraints with rWithConstraints', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScaleXInit(
            config: const ScaleXConfig(baseWidth: 393.0),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  final value = 200.rWithConstraints(min: 180, max: 220);
                  expect(value, greaterThanOrEqualTo(180));
                  expect(value, lessThanOrEqualTo(220));
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });
  });
}

