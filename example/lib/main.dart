import 'package:flutter/material.dart';
import 'package:scalex/scalex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        title: 'Responsive Helper Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Helper Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(r.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Type: ${r.deviceType.name}',
              style: TextStyle(fontSize: r.textBase),
            ),
            SizedBox(height: r.lg),
            Text(
              'Using simple extensions: 200.w, 100.h, 16.sp',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(height: r.md),
            Container(
              width: 200.w,
              height: 100.h,
              color: Colors.blue,
              child: Center(
                child: Text(
                  '200w x 100h',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: r.lg),
            Text(
              'Using Responsive class',
              style: TextStyle(fontSize: r.textLg),
            ),
            SizedBox(height: r.md),
            Container(
              width: r.size(150),
              height: r.size(80),
              padding: EdgeInsets.all(r.sm),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(r.size(8, min: 6, max: 10)),
              ),
              child: Text(
                '150 x 80',
                style: TextStyle(
                  fontSize: r.textBase,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: r.lg),
            Text(
              'Predefined spacing',
              style: TextStyle(fontSize: r.textLg),
            ),
            SizedBox(height: r.sm),
            Row(
              children: [
                _SpacingBox(r.xs, Colors.red),
                SizedBox(width: r.sm),
                _SpacingBox(r.sm, Colors.orange),
                SizedBox(width: r.sm),
                _SpacingBox(r.md, Colors.yellow),
                SizedBox(width: r.sm),
                _SpacingBox(r.lg, Colors.green),
                SizedBox(width: r.sm),
                _SpacingBox(r.xl, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SpacingBox extends StatelessWidget {
  final double size;
  final Color color;

  const _SpacingBox(this.size, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: color,
    );
  }
}

