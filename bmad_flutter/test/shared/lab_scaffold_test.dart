import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bmad_flutter/shared/lab_scaffold.dart';
import 'package:bmad_flutter/shared/manifest_button.dart';

Widget _harness({
  required bool canManifest,
  required VoidCallback onManifest,
}) {
  return MaterialApp(
    home: LabScaffold(
      title: '데모 실험실',
      canManifest: canManifest,
      onManifest: onManifest,
      preview: const Text('PREVIEW_SLOT'),
      controls: const Text('CONTROLS_SLOT'),
    ),
  );
}

void main() {
  group('LabScaffold', () {
    testWidgets('preview/controls 슬롯과 타이틀이 렌더된다 (AC1, AC3)', (tester) async {
      await tester.pumpWidget(_harness(canManifest: false, onManifest: () {}));

      expect(find.widgetWithText(AppBar, '데모 실험실'), findsOneWidget);
      expect(find.text('PREVIEW_SLOT'), findsOneWidget);
      expect(find.text('CONTROLS_SLOT'), findsOneWidget);
      expect(find.byType(ManifestButton), findsOneWidget);
    });

    testWidgets('canManifest=false — 발현 버튼 탭 불가 (AC4)', (tester) async {
      int manifests = 0;
      await tester.pumpWidget(
        _harness(canManifest: false, onManifest: () => manifests++),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ManifestButton), warnIfMissed: false);
      await tester.pump();

      expect(manifests, 0);
    });

    testWidgets('canManifest=true — 발현 버튼 탭 시 onManifest 호출 (AC2)', (tester) async {
      int manifests = 0;
      await tester.pumpWidget(
        _harness(canManifest: true, onManifest: () => manifests++),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(ManifestButton.label));
      await tester.pump();

      expect(manifests, 1);
    });

    testWidgets('작은 화면 + 큰 텍스트 스케일에서 오버플로 없이 렌더된다', (tester) async {
      tester.view.physicalSize = const Size(320, 320);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(_harness(canManifest: true, onManifest: () {}));

      expect(tester.takeException(), isNull);
    });
  });
}
