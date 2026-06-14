import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bmad_flutter/core/models/stage_id.dart';
import 'package:bmad_flutter/core/state/museum_state.dart';
import 'package:bmad_flutter/shared/comparison_view.dart';
import 'package:bmad_flutter/shared/manifest_button.dart';
import 'package:bmad_flutter/shared/stage_lab_screen.dart';

Widget _harness(MuseumState state, StageId stageId) {
  return ChangeNotifierProvider<MuseumState>.value(
    value: state,
    child: MaterialApp(
      home: StageLabScreen(stageId: stageId),
    ),
  );
}

void main() {
  group('StageLabScreen', () {
    testWidgets('슬라이더 조작 시 미리보기가 즉시 갱신된다 (AC1)', (tester) async {
      await tester.pumpWidget(_harness(MuseumState(), StageId.layout));

      final double before =
          tester.getSize(find.byKey(const Key('stage_lab_preview_box'))).width;
      await tester.drag(find.byType(Slider), const Offset(200, 0));
      await tester.pump();
      final double after =
          tester.getSize(find.byKey(const Key('stage_lab_preview_box'))).width;

      expect(after, greaterThan(before));
    });

    testWidgets('조작 전 발현 버튼 비활성 — 조작 후 발현 가능 (AC4)', (tester) async {
      final MuseumState state = MuseumState();
      await tester.pumpWidget(_harness(state, StageId.layout));
      await tester.pumpAndSettle();

      // 조작 전: 발현 시도해도 커밋되지 않음(게이팅).
      await tester.tap(find.byType(ManifestButton), warnIfMissed: false);
      await tester.pump();
      expect(state.isCleared(StageId.layout), isFalse);

      // 조작 후: 발현 가능.
      await tester.drag(find.byType(Slider), const Offset(200, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text(ManifestButton.label));
      await tester.pumpAndSettle();
      expect(state.isCleared(StageId.layout), isTrue);
    });

    testWidgets('발현 실행 — manifest 커밋 + 다음 스테이지 해제 + pop (AC2)', (tester) async {
      final MuseumState state = MuseumState();
      await tester.pumpWidget(_harness(state, StageId.layout));

      await tester.drag(find.byType(Slider), const Offset(200, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text(ManifestButton.label));
      await tester.pumpAndSettle();

      expect(state.isCleared(StageId.layout), isTrue);
      expect(state.isUnlocked(StageId.component), isTrue);
      // 발현 후 로비로 pop → 실험실 화면이 사라진다.
      expect(find.byType(StageLabScreen), findsNothing);
    });

    testWidgets('작은 화면 + 큰 텍스트 스케일에서 오버플로 없이 렌더된다', (tester) async {
      tester.view.physicalSize = const Size(320, 320);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(_harness(MuseumState(), StageId.layout));

      expect(tester.takeException(), isNull);
    });

    testWidgets('layout 스테이지: 3종 비교 버튼 노출 + 탭 시 ComparisonView 진입 (AC1)',
        (tester) async {
      await tester.pumpWidget(_harness(MuseumState(), StageId.layout));

      final Finder button = find.text(StageLabScreen.openComparisonLabel);
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.byType(ComparisonView), findsOneWidget);
    });

    testWidgets('비-layout 스테이지(component): 3종 비교 버튼 미노출', (tester) async {
      await tester.pumpWidget(_harness(MuseumState(), StageId.component));

      expect(find.text(StageLabScreen.openComparisonLabel), findsNothing);
    });

    testWidgets('3종 비교 진입 → 프리셋 조작 → 발현 → 튜닝값 커밋 + pop (AC1, FR12)',
        (tester) async {
      final MuseumState state = MuseumState();
      await tester.pumpWidget(_harness(state, StageId.layout));

      await tester.tap(find.text(StageLabScreen.openComparisonLabel));
      await tester.pumpAndSettle();
      expect(find.byType(ComparisonView), findsOneWidget);

      await tester.tap(find.byKey(const Key('preset_ios')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(ManifestButton.label));
      await tester.pumpAndSettle();

      expect(state.tuningValue(StageId.layout), isNotNull);
      expect(state.isCleared(StageId.layout), isTrue);
      // 발현 후 ComparisonView는 pop되고 실험실로 돌아온다.
      expect(find.byType(ComparisonView), findsNothing);
      expect(find.byType(StageLabScreen), findsOneWidget);
    });

    testWidgets('재입장 시 ComparisonView가 직전 발현 튜닝값으로 복원된다 (AC2, FR14)',
        (tester) async {
      final MuseumState state = MuseumState();
      state.manifestTuning(StageId.layout, 0.77);
      await tester.pumpWidget(_harness(state, StageId.layout));

      await tester.tap(find.text(StageLabScreen.openComparisonLabel));
      await tester.pumpAndSettle();

      final ComparisonView view =
          tester.widget<ComparisonView>(find.byType(ComparisonView));
      expect(view.initialValue, 0.77);
    });
  });
}
