import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bmad_flutter/app.dart';
import 'package:bmad_flutter/core/models/stage_id.dart';
import 'package:bmad_flutter/core/state/museum_state.dart';
import 'package:bmad_flutter/lobby/exhibition_nav.dart';
import 'package:bmad_flutter/lobby/lobby_screen.dart';
import 'package:bmad_flutter/lobby/manifestations/lobby_manifestations.dart';

Widget _app() {
  return ChangeNotifierProvider<MuseumState>(
    create: (_) => MuseumState(),
    child: const MuseumApp(),
  );
}

void main() {
  group('LobbyScreen', () {
    testWidgets('AppBar에 "쇼케이스 박물관" 타이틀이 렌더된다 (AC1)', (tester) async {
      await tester.pumpWidget(_app());

      expect(
        find.widgetWithText(AppBar, LobbyScreen.appBarTitle),
        findsOneWidget,
      );
    });

    testWidgets('발현물 영역 안내 텍스트가 존재한다 (빈 상태)', (tester) async {
      await tester.pumpWidget(_app());

      expect(find.text(LobbyManifestations.emptyStateMessage), findsOneWidget);
    });

    testWidgets('전시실 내비(ExhibitionNav)가 로비 본문에 통합된다 (AC1)', (tester) async {
      await tester.pumpWidget(_app());

      expect(find.byType(ExhibitionNav), findsOneWidget);
      // ExhibitionNav가 8개 전시실 진입점을 렌더한다(발현물이 아니라 내비게이션).
      expect(find.byType(ListTile), findsNWidgets(StageId.values.length));
    });

    testWidgets('작은 화면 + 큰 텍스트 스케일에서 오버플로 없이 렌더된다', (tester) async {
      tester.view.physicalSize = const Size(320, 320);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(_app());

      expect(tester.takeException(), isNull);
      expect(find.text(LobbyManifestations.emptyStateMessage), findsOneWidget);
    });
  });
}
