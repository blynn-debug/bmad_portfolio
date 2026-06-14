import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bmad_flutter/shared/preset_controls.dart';

Widget _harness(ValueChanged<double> onApply) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(child: PresetControls(onApply: onApply)),
    ),
  );
}

void main() {
  group('PresetControls', () {
    testWidgets('iOS/Material/Custom 프리셋은 서로 다른 값으로 onApply 호출 (FR15)',
        (tester) async {
      final List<double> applied = <double>[];
      await tester.pumpWidget(_harness(applied.add));

      await tester.tap(find.byKey(const Key('preset_ios')));
      await tester.tap(find.byKey(const Key('preset_material')));
      await tester.tap(find.byKey(const Key('preset_custom')));
      await tester.pump();

      expect(applied, <double>[
        TuningPreset.ios.value,
        TuningPreset.material.value,
        TuningPreset.custom.value,
      ]);
      // 세 프리셋 값은 서로 구분된다.
      expect(applied.toSet().length, 3);
    });

    testWidgets('리셋 버튼은 기본값으로 onApply 호출 (FR15)', (tester) async {
      double? applied;
      await tester.pumpWidget(_harness((double v) => applied = v));

      await tester.tap(find.byKey(const Key('preset_reset')));
      await tester.pump();

      expect(applied, PresetControls.defaultValue);
    });

    testWidgets('작은 화면 + 큰 텍스트 스케일에서 오버플로 없이 렌더된다', (tester) async {
      tester.view.physicalSize = const Size(320, 320);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(_harness((_) {}));

      expect(tester.takeException(), isNull);
    });
  });
}
