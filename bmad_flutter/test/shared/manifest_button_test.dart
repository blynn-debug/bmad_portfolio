import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bmad_flutter/shared/manifest_button.dart';

Widget _harness({required bool visible, required VoidCallback onPressed}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: ManifestButton(visible: visible, onPressed: onPressed),
      ),
    ),
  );
}

void main() {
  group('ManifestButton', () {
    testWidgets('visible=true — 탭 시 onPressed 호출 (FR6)', (tester) async {
      int taps = 0;
      await tester.pumpWidget(_harness(visible: true, onPressed: () => taps++));
      await tester.pumpAndSettle();

      await tester.tap(find.text(ManifestButton.label));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('visible=false — 탭해도 onPressed 미호출 (게이팅 AC4)', (tester) async {
      int taps = 0;
      await tester.pumpWidget(_harness(visible: false, onPressed: () => taps++));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ManifestButton), warnIfMissed: false);
      await tester.pump();

      expect(taps, 0);
    });

    testWidgets('스케일/페이드 연출 위젯이 존재한다 (FR7)', (tester) async {
      await tester.pumpWidget(_harness(visible: true, onPressed: () {}));

      expect(find.byType(AnimatedOpacity), findsOneWidget);
      expect(find.byType(AnimatedScale), findsOneWidget);
    });
  });
}
