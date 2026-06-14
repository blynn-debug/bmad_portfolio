import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bmad_flutter/core/models/stage_id.dart';
import 'package:bmad_flutter/shared/comparison_panel.dart';
import 'package:bmad_flutter/shared/comparison_view.dart';
import 'package:bmad_flutter/shared/manifest_button.dart';
import 'package:bmad_flutter/shared/preset_controls.dart';

Widget _harness({ValueChanged<double>? onManifest}) {
  return MaterialApp(
    home: ComparisonView(stageId: StageId.layout, onManifest: onManifest),
  );
}

void main() {
  group('ComparisonView', () {
    testWidgets('Material/Cupertino/Custom 3종 패널이 동시 렌더된다 (AC1, FR9)',
        (tester) async {
      await tester.pumpWidget(_harness());

      expect(find.byType(ComparisonPanel), findsNWidgets(3));
      // 패널 헤더 라벨 — 하단 프리셋 버튼(Material/Custom)과 텍스트가 겹치므로
      // ComparisonPanel 내부로 범위를 한정해 단언한다.
      Finder panelLabel(String text) => find.descendant(
            of: find.byType(ComparisonPanel),
            matching: find.text(text),
          );
      expect(panelLabel('Material'), findsOneWidget);
      expect(panelLabel('Cupertino'), findsOneWidget);
      expect(panelLabel('Custom'), findsOneWidget);
    });

    testWidgets('패널은 자체 튜닝 상태가 없는 StatelessWidget이다 (단일 SSOT)',
        (tester) async {
      await tester.pumpWidget(_harness());

      final ComparisonPanel panel =
          tester.widget<ComparisonPanel>(find.byType(ComparisonPanel).first);
      expect(panel, isA<StatelessWidget>());
    });

    testWidgets('슬라이더 조작 시 3패널이 동시에 실시간 반영된다 (AC2, FR11)',
        (tester) async {
      await tester.pumpWidget(_harness());

      double widthOf(ComparisonPlatform p) => tester
          .getSize(find.byKey(Key('comparison_box_${p.name}')))
          .width;

      final double m0 = widthOf(ComparisonPlatform.material);
      final double c0 = widthOf(ComparisonPlatform.cupertino);
      final double u0 = widthOf(ComparisonPlatform.custom);

      // 공통 슬라이더를 오른쪽으로 드래그 → _value 증가.
      await tester.drag(find.byType(Slider), const Offset(300, 0));
      await tester.pump();

      final double m1 = widthOf(ComparisonPlatform.material);
      final double c1 = widthOf(ComparisonPlatform.cupertino);
      final double u1 = widthOf(ComparisonPlatform.custom);

      // 세 패널 모두 동일하게 커진다(동일 값 주입 + 동시 반영).
      expect(m1, greaterThan(m0));
      expect(c1, greaterThan(c0));
      expect(u1, greaterThan(u0));
      expect(m1, equals(c1));
      expect(c1, equals(u1));
    });

    testWidgets('프리셋 적용 시 3패널이 즉시 반영되고 프리셋별 크기가 다르다 (AC3, FR15)',
        (tester) async {
      await tester.pumpWidget(_harness());

      double boxWidth() => tester
          .getSize(find.byKey(const Key('comparison_box_material')))
          .width;

      await tester.tap(find.byKey(const Key('preset_ios')));
      await tester.pump();
      final double iosWidth = boxWidth();

      await tester.tap(find.byKey(const Key('preset_custom')));
      await tester.pump();
      final double customWidth = boxWidth();

      // iOS(0.9) 프리셋이 Custom(0.25)보다 박스가 크다 — 값 차이가 눈에 보임.
      expect(iosWidth, greaterThan(customWidth));
    });

    testWidgets('onManifest 제공 + 조작 후 발현 → 콜백 호출 + pop (AC1, FR12)',
        (tester) async {
      double? manifested;
      // ComparisonView를 push해 pop 동작을 검증할 수 있는 하니스.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) => Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ComparisonView(
                        stageId: StageId.layout,
                        onManifest: (double v) => manifested = v,
                      ),
                    ),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // 조작 전: 발현 버튼 미노출(게이팅).
      await tester.tap(find.byType(ManifestButton), warnIfMissed: false);
      await tester.pump();
      expect(manifested, isNull);

      // 프리셋으로 조작 후 발현.
      await tester.tap(find.byKey(const Key('preset_ios')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(ManifestButton.label));
      await tester.pumpAndSettle();

      expect(manifested, TuningPreset.ios.value);
      // 발현 후 pop → ComparisonView가 사라진다.
      expect(find.byType(ComparisonView), findsNothing);
    });

    testWidgets('onManifest 미제공(1.6 경로) 시 발현 버튼 미노출', (tester) async {
      await tester.pumpWidget(_harness());

      await tester.drag(find.byType(Slider), const Offset(200, 0));
      await tester.pump();

      expect(find.byType(ManifestButton), findsNothing);
    });

    testWidgets('작은 화면 + 큰 텍스트 스케일에서 오버플로 없이 렌더된다', (tester) async {
      tester.view.physicalSize = const Size(320, 320);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(_harness(onManifest: (_) {}));

      expect(tester.takeException(), isNull);
    });
  });
}
