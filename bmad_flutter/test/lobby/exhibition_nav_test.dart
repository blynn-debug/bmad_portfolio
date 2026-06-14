import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bmad_flutter/core/models/stage_id.dart';
import 'package:bmad_flutter/core/state/museum_state.dart';
import 'package:bmad_flutter/lobby/exhibition_nav.dart';
import 'package:bmad_flutter/shared/stage_lab_screen.dart';

Widget _harness(MuseumState state) {
  return ChangeNotifierProvider<MuseumState>.value(
    value: state,
    child: const MaterialApp(
      // ExhibitionNav는 로비의 스크롤 본문 안에 끼워지는 합성 위젯이므로
      // 테스트 하니스도 동일하게 스크롤 컨테이너로 감싼다.
      home: Scaffold(
        body: SingleChildScrollView(child: ExhibitionNav()),
      ),
    ),
  );
}

void main() {
  group('ExhibitionNav', () {
    testWidgets('8개 전시실 항목이 라벨과 함께 렌더된다 (AC1)', (tester) async {
      await tester.pumpWidget(_harness(MuseumState()));

      expect(find.byType(ListTile), findsNWidgets(8));
      for (final StageId stage in StageId.values) {
        expect(find.text(stage.label), findsOneWidget);
      }
    });

    testWidgets('초기 — layout만 열림, 나머지는 잠금 아이콘 (AC2)', (tester) async {
      await tester.pumpWidget(_harness(MuseumState()));

      // 잠긴 항목 7개 → lock 아이콘 7개.
      expect(find.byIcon(Icons.lock), findsNWidgets(7));
      // 열림·미클리어 항목 1개 → science 아이콘.
      expect(find.byIcon(Icons.science_outlined), findsOneWidget);
    });

    testWidgets('잠긴 항목 탭 — 내비게이션 없음 (AC2)', (tester) async {
      await tester.pumpWidget(_harness(MuseumState()));

      await tester.tap(find.text(StageId.component.label));
      await tester.pumpAndSettle();

      expect(find.byType(StageLabScreen), findsNothing);
    });

    testWidgets('열린 항목 탭 — 실험실 화면으로 진입 (AC3 경로)', (tester) async {
      await tester.pumpWidget(_harness(MuseumState()));

      await tester.tap(find.text(StageId.layout.label));
      await tester.pumpAndSettle();

      expect(find.byType(StageLabScreen), findsOneWidget);
    });

    testWidgets('layout 발현 시 component가 열리고 표시가 갱신된다 (AC3)', (tester) async {
      final MuseumState state = MuseumState();
      await tester.pumpWidget(_harness(state));

      state.manifest(StageId.layout);
      await tester.pump();

      // layout은 클리어 → check 아이콘, component는 열림 → science 아이콘.
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.science_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsNWidgets(6));
    });

    testWidgets('작은 화면 + 큰 텍스트 스케일에서 오버플로 없이 렌더된다', (tester) async {
      tester.view.physicalSize = const Size(320, 320);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(
        ChangeNotifierProvider<MuseumState>(
          create: (_) => MuseumState(),
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: ExhibitionNav()),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
