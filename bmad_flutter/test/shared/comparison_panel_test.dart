import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bmad_flutter/shared/comparison_panel.dart';

Widget _harness(ComparisonPlatform platform, double value) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 140,
        child: ComparisonPanel(platform: platform, value: value),
      ),
    ),
  );
}

ScrollPhysics? _listPhysicsOf(WidgetTester tester, ComparisonPlatform platform) {
  final ListView list = tester.widget<ListView>(
    find.byKey(Key('comparison_list_${platform.name}')),
  );
  return list.physics;
}

void main() {
  group('ComparisonPanel', () {
    testWidgets('3종 패널이 모두 예외 없이 렌더된다 (AR1 공존)', (tester) async {
      for (final ComparisonPlatform platform in ComparisonPlatform.values) {
        await tester.pumpWidget(_harness(platform, 0.5));
        expect(tester.takeException(), isNull);
        expect(find.text(platform.label), findsOneWidget);
      }
    });

    testWidgets('Cupertino 패널이 CupertinoApp 없이 CupertinoSwitch를 렌더한다 (AR1)',
        (tester) async {
      // 루트는 MaterialApp 하나. CupertinoApp 중첩 없이 Cupertino 위젯이 공존.
      await tester.pumpWidget(_harness(ComparisonPlatform.cupertino, 0.7));

      expect(find.byType(CupertinoApp), findsNothing);
      expect(find.byType(CupertinoSwitch), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Material 패널은 Switch를 렌더한다 (FR10 위젯 차이)', (tester) async {
      await tester.pumpWidget(_harness(ComparisonPlatform.material, 0.7));

      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(CupertinoSwitch), findsNothing);
    });

    testWidgets('스크롤 물리: Material=clamping, Cupertino/Custom=bouncing (FR10)',
        (tester) async {
      await tester.pumpWidget(_harness(ComparisonPlatform.material, 0.5));
      expect(
        _listPhysicsOf(tester, ComparisonPlatform.material),
        isA<ClampingScrollPhysics>(),
      );

      await tester.pumpWidget(_harness(ComparisonPlatform.cupertino, 0.5));
      expect(
        _listPhysicsOf(tester, ComparisonPlatform.cupertino),
        isA<BouncingScrollPhysics>(),
      );

      await tester.pumpWidget(_harness(ComparisonPlatform.custom, 0.5));
      expect(
        _listPhysicsOf(tester, ComparisonPlatform.custom),
        isA<BouncingScrollPhysics>(),
      );
    });

    testWidgets('값이 박스 크기에 반영된다 (FR11)', (tester) async {
      const Key boxKey = Key('comparison_box_material');

      await tester.pumpWidget(_harness(ComparisonPlatform.material, 0.2));
      final double small = tester.getSize(find.byKey(boxKey)).width;

      await tester.pumpWidget(_harness(ComparisonPlatform.material, 0.9));
      final double large = tester.getSize(find.byKey(boxKey)).width;

      expect(large, greaterThan(small));
    });

    testWidgets('작은 화면 + 큰 텍스트 스케일에서 오버플로 없이 렌더된다', (tester) async {
      tester.view.physicalSize = const Size(320, 320);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(_harness(ComparisonPlatform.cupertino, 0.5));

      expect(tester.takeException(), isNull);
    });
  });
}
