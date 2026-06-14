import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bmad_flutter/core/models/stage_id.dart';
import 'package:bmad_flutter/core/state/museum_state.dart';
import 'package:bmad_flutter/lobby/manifestations/lobby_manifestations.dart';

Widget _harness(MuseumState state) {
  return ChangeNotifierProvider<MuseumState>.value(
    value: state,
    child: const MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: LobbyManifestations()),
      ),
    ),
  );
}

void main() {
  group('LobbyManifestations', () {
    testWidgets('발현 0개 — 빈 상태 안내 표시, 발현물 카드 없음', (tester) async {
      await tester.pumpWidget(_harness(MuseumState()));

      expect(
        find.text(LobbyManifestations.emptyStateMessage),
        findsOneWidget,
      );
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('발현 시 해당 스테이지 발현물 카드가 나타난다 (FR6)', (tester) async {
      final MuseumState state = MuseumState();
      await tester.pumpWidget(_harness(state));

      state.manifest(StageId.layout);
      await tester.pump();

      expect(find.byType(Card), findsOneWidget);
      expect(find.text(StageId.layout.label), findsOneWidget);
      expect(find.text(LobbyManifestations.manifestedLabel), findsOneWidget);
      expect(find.text(LobbyManifestations.emptyStateMessage), findsNothing);
      // 발현물 카드는 ListTile이 아니다(로비 ListTile 카운트 회귀 가드).
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('여러 스테이지 발현 시 카드가 누적된다', (tester) async {
      final MuseumState state = MuseumState();
      await tester.pumpWidget(_harness(state));

      state.manifest(StageId.layout);
      state.manifest(StageId.component);
      await tester.pump();

      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('manifestTuning 발현 시 튜닝값 지표가 표시된다 (FR12)', (tester) async {
      final MuseumState state = MuseumState();
      await tester.pumpWidget(_harness(state));

      state.manifestTuning(StageId.layout, 0.6);
      await tester.pump();

      expect(find.byKey(const Key('manifest_tuning_layout')), findsOneWidget);
      expect(find.text('튜닝 60%'), findsOneWidget);
    });

    testWidgets('재발현 시 튜닝값 지표가 재반영된다 (FR14)', (tester) async {
      final MuseumState state = MuseumState();
      await tester.pumpWidget(_harness(state));

      state.manifestTuning(StageId.layout, 0.3);
      await tester.pump();
      final double before = tester
          .getSize(
            find.descendant(
              of: find.byKey(const Key('manifest_tuning_layout')),
              matching: find.byType(Container),
            ),
          )
          .width;

      state.manifestTuning(StageId.layout, 0.9);
      await tester.pump();
      final double after = tester
          .getSize(
            find.descendant(
              of: find.byKey(const Key('manifest_tuning_layout')),
              matching: find.byType(Container),
            ),
          )
          .width;

      expect(after, greaterThan(before));
      expect(find.text('튜닝 90%'), findsOneWidget);
    });

    testWidgets('제네릭 manifest(튜닝값 없음)는 지표 없이 카드만 표시', (tester) async {
      final MuseumState state = MuseumState();
      await tester.pumpWidget(_harness(state));

      state.manifest(StageId.layout);
      await tester.pump();

      expect(find.byType(Card), findsOneWidget);
      expect(find.byKey(const Key('manifest_tuning_layout')), findsNothing);
    });

    testWidgets('작은 화면 + 큰 텍스트 스케일에서 발현물 카드가 오버플로 없이 렌더된다', (tester) async {
      tester.view.physicalSize = const Size(320, 320);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      final MuseumState state = MuseumState();
      await tester.pumpWidget(_harness(state));
      state.manifest(StageId.layout);
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
