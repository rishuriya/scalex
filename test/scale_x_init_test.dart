import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalex/scalex.dart';

void main() {
  group('ScaleXInit', () {
    testWidgets('should initialize ScaleXHelper with config', (WidgetTester tester) async {
      const config = ScaleXConfig(
        baseWidth: 393.0,
        mobileBreakpoint: 640.0,
        tabletBreakpoint: 1024.0,
      );

      await tester.pumpWidget(
        ScaleXInit(
          config: config,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ScaleXHelper.isInitialized, true);
                expect(ScaleXHelper.config, config);
                expect(ScaleXHelper.screenWidth, isNotNull);
                expect(ScaleXHelper.screenHeight, isNotNull);
                expect(ScaleXHelper.scale, isNotNull);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should update screen size when MediaQuery changes', (WidgetTester tester) async {
      const config = ScaleXConfig(baseWidth: 393.0);

      await tester.binding.setSurfaceSize(const Size(375, 812));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScaleXInit(
            config: config,
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(ScaleXHelper.screenWidth, 375.0);
                  expect(ScaleXHelper.screenHeight, 812.0);
                  expect(ScaleXHelper.scale, closeTo(375.0 / 393.0, 0.01));
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should detect device type correctly after init', (WidgetTester tester) async {
      const config = ScaleXConfig(
        baseWidth: 393.0,
        mobileBreakpoint: 640.0,
        tabletBreakpoint: 1024.0,
      );

      // Test mobile
      await tester.binding.setSurfaceSize(const Size(375, 812));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScaleXInit(
            config: config,
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(ScaleXHelper.isMobile, true);
                  expect(ScaleXHelper.isTablet, false);
                  expect(ScaleXHelper.isDesktop, false);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      // Test tablet
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScaleXInit(
            config: config,
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(ScaleXHelper.isMobile, false);
                  expect(ScaleXHelper.isTablet, true);
                  expect(ScaleXHelper.isDesktop, false);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      // Test desktop
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1920, 1080)),
          child: ScaleXInit(
            config: config,
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  expect(ScaleXHelper.isMobile, false);
                  expect(ScaleXHelper.isTablet, false);
                  expect(ScaleXHelper.isDesktop, true);
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

  group('ScaleXHelper', () {
    test('should clear config correctly', () {
      ScaleXHelper.setConfig(const ScaleXConfig(baseWidth: 393.0));
      ScaleXHelper.setScreenSize(375, 812);
      
      expect(ScaleXHelper.isInitialized, true);
      
      ScaleXHelper.clearConfig();
      
      expect(ScaleXHelper.isInitialized, false);
      expect(ScaleXHelper.config, null);
      expect(ScaleXHelper.screenWidth, null);
      expect(ScaleXHelper.screenHeight, null);
      expect(ScaleXHelper.scale, null);
    });

    test('should return mobile as default device type when not initialized', () {
      ScaleXHelper.clearConfig();
      expect(ScaleXHelper.deviceType, DeviceType.mobile);
    });
  });
}

