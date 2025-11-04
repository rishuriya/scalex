import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scalex/scalex.dart';

void main() {
  group('Responsive', () {
    testWidgets('should detect mobile device correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Set mobile width
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(size: const Size(375, 812)),
                child: Builder(
                  builder: (context) {
                    final responsive = Responsive(context);
                    expect(responsive.isMobile, true);
                    expect(responsive.isTablet, false);
                    expect(responsive.isDesktop, false);
                    expect(responsive.deviceType, DeviceType.mobile);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should detect tablet device correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Set tablet width
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(size: const Size(768, 1024)),
                child: Builder(
                  builder: (context) {
                    final responsive = Responsive(context);
                    expect(responsive.isMobile, false);
                    expect(responsive.isTablet, true);
                    expect(responsive.isDesktop, false);
                    expect(responsive.deviceType, DeviceType.tablet);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should detect desktop device correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Set desktop width
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(size: const Size(1920, 1080)),
                child: Builder(
                  builder: (context) {
                    final responsive = Responsive(context);
                    expect(responsive.isMobile, false);
                    expect(responsive.isTablet, false);
                    expect(responsive.isDesktop, true);
                    expect(responsive.deviceType, DeviceType.desktop);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should return fixed size on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Set desktop width
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(size: const Size(1920, 1080)),
                child: Builder(
                  builder: (context) {
                    final responsive = Responsive(context);
                    // On desktop, should return base size
                    final size = responsive.size(100);
                    expect(size, 100.0);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should scale on mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Set mobile width (375px vs base 393px)
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(size: const Size(375, 812)),
                child: Builder(
                  builder: (context) {
                    final responsive = Responsive(context);
                    // On mobile, should scale
                    final size = responsive.size(100);
                    // Scale factor: 375 / 393 ≈ 0.954
                    expect(size, closeTo(95.4, 0.1));
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should respect min/max constraints', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(size: const Size(375, 812)),
                child: Builder(
                  builder: (context) {
                    final responsive = Responsive(context);
                    // With constraints
                    final size = responsive.size(100, min: 90, max: 110);
                    expect(size, greaterThanOrEqualTo(90));
                    expect(size, lessThanOrEqualTo(110));
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should return fixed spacing on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(size: const Size(1920, 1080)),
                child: Builder(
                  builder: (context) {
                    final responsive = Responsive(context);
                    expect(responsive.xs, 4.0);
                    expect(responsive.sm, 8.0);
                    expect(responsive.md, 16.0);
                    expect(responsive.lg, 24.0);
                    expect(responsive.xl, 32.0);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should return fixed text sizes on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(size: const Size(1920, 1080)),
                child: Builder(
                  builder: (context) {
                    final responsive = Responsive(context);
                    expect(responsive.textXs, 12.0);
                    expect(responsive.textSm, 14.0);
                    expect(responsive.textBase, 16.0);
                    expect(responsive.textLg, 18.0);
                    expect(responsive.textXl, 20.0);
                    expect(responsive.textH1, 28.0);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should use custom config when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(size: const Size(375, 812)),
                child: Builder(
                  builder: (context) {
                    final customConfig = ScaleXConfig(
                      baseWidth: 400.0,
                      mobileBreakpoint: 600.0,
                      tabletBreakpoint: 1200.0,
                    );
                    final responsive = Responsive(context, config: customConfig);
                    expect(responsive.config.baseWidth, 400.0);
                    expect(responsive.config.mobileBreakpoint, 600.0);
                    expect(responsive.config.tabletBreakpoint, 1200.0);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });
  });
}

