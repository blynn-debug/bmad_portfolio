import 'package:flutter/material.dart';

import 'lobby/lobby_screen.dart';

/// 쇼케이스 박물관 앱의 루트 위젯.
///
/// Story 1.1 범위에서는 기본 테마와 로비 홈만 둔다. 내비게이션은 Story 1.2,
/// Custom 테마는 Story 1.7에서 도입된다.
class MuseumApp extends StatelessWidget {
  const MuseumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LobbyScreen(),
    );
  }
}
