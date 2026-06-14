import 'package:flutter/material.dart';

import 'exhibition_nav.dart';
import 'manifestations/lobby_manifestations.dart';

/// 쇼케이스 박물관 로비 메인 화면 (FR1, FR2, FR6).
///
/// 본문은 (1) 8개 전시실 내비게이션([ExhibitionNav], Story 1.2)과
/// (2) 발현물 영역([LobbyManifestations], Story 1.3)으로 구성된다. 발현물은
/// 실험실에서 "발현하기"를 실행할 때 누적되며, 영속은 Story 1.4에서 도입된다.
class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  /// 로비 AppBar 타이틀 (테스트와 공유하는 단일 출처).
  static const String appBarTitle = '쇼케이스 박물관';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appBarTitle)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            ExhibitionNav(),
            LobbyManifestations(),
          ],
        ),
      ),
    );
  }
}
