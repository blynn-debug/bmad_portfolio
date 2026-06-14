import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 3종 비교 패널이 렌더할 플랫폼 디자인 철학 (FR9, FR10).
///
/// 아키텍처 문서의 `Platform`을 구체화한 이름이다 — `dart:io`의 `Platform`과
/// 혼동을 피하기 위해 항상 [ComparisonPlatform]을 사용한다(UI 식별 전용,
/// 직렬화/외부 노출 없음).
enum ComparisonPlatform { material, cupertino, custom }

/// 패널 헤더에 표시하는 플랫폼 라벨.
extension ComparisonPlatformLabel on ComparisonPlatform {
  String get label {
    switch (this) {
      case ComparisonPlatform.material:
        return 'Material';
      case ComparisonPlatform.cupertino:
        return 'Cupertino';
      case ComparisonPlatform.custom:
        return 'Custom';
    }
  }
}

/// 3종 비교 스플릿 뷰의 단일 패널 (FR10, FR11, AR1 🔴 PoC).
///
/// 단일 루트 `MaterialApp`(앱 `app.dart`) 아래에서, 각 패널은 **자신의 테마
/// 조상만** 책임진다 — material/custom은 [Theme], cupertino는 [CupertinoTheme].
/// 별도의 중첩 `CupertinoApp`/`MaterialApp` 없이 Material 위젯과 Cupertino
/// 위젯이 동일 위젯 트리에서 공존하는 구조를 검증한다(AR1).
///
/// 동일한 [value]를 받아 동일 레이아웃(헤더 + 값 박스 + 스크롤 리스트 + 토글)을
/// 그리되, **플랫폼 스타일만** 다르다:
/// - 스크롤 물리: material = clamping, cupertino/custom = bouncing (FR10)
/// - 토글 위젯: material = [Switch], cupertino = [CupertinoSwitch] (FR10)
///
/// 튜닝값(소스 오브 트루스)은 부모([ComparisonView])가 보유하고 3패널에 동일
/// 값으로 주입한다 — 패널은 자체 튜닝 상태가 없는 [StatelessWidget]이다(FR11).
class ComparisonPanel extends StatelessWidget {
  const ComparisonPanel({
    super.key,
    required this.platform,
    required this.value,
  });

  /// 이 패널이 표현하는 플랫폼.
  final ComparisonPlatform platform;

  /// 공통 튜닝값(0.0~1.0). 부모가 단일 보유하고 3패널에 동일 주입(FR11).
  final double value;

  static const String scrollHint = '스크롤해 물리 비교';

  /// 값 박스 측정용 키(테스트가 [value] 반영을 확인).
  Key get boxKey => Key('comparison_box_${platform.name}');

  /// 스크롤 물리 검사용 키(테스트가 physics 종류를 확인).
  Key get listKey => Key('comparison_list_${platform.name}');

  /// 플랫폼별 스크롤 물리 — 호스트 OS와 무관하게 결정적으로 지정(FR10).
  ScrollPhysics get _listPhysics {
    switch (platform) {
      case ComparisonPlatform.material:
        return const ClampingScrollPhysics();
      case ComparisonPlatform.cupertino:
      case ComparisonPlatform.custom:
        return const BouncingScrollPhysics();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 값에 비례해 변하는 박스 — 협소한 1/3 폭 패널에서도 넘치지 않도록 작게.
    final double side = 16 + value * 40;

    final Widget content = _PanelBody(
      platform: platform,
      value: value,
      side: side,
      boxKey: boxKey,
      listKey: listKey,
      listPhysics: _listPhysics,
    );

    // 패널별 테마 격리(AR1 PoC) — 중첩 App 없이 테마 조상만 덧씌운다.
    switch (platform) {
      case ComparisonPlatform.material:
        return Theme(
          data: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
          child: content,
        );
      case ComparisonPlatform.cupertino:
        return CupertinoTheme(
          data: const CupertinoThemeData(primaryColor: CupertinoColors.activeBlue),
          child: content,
        );
      case ComparisonPlatform.custom:
        return Theme(
          data: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
          child: content,
        );
    }
  }
}

/// 세 패널이 공유하는 동일 레이아웃 본체 — 플랫폼 스타일만 주입으로 달라진다.
class _PanelBody extends StatelessWidget {
  const _PanelBody({
    required this.platform,
    required this.value,
    required this.side,
    required this.boxKey,
    required this.listKey,
    required this.listPhysics,
  });

  final ComparisonPlatform platform;
  final double value;
  final double side;
  final Key boxKey;
  final Key listKey;
  final ScrollPhysics listPhysics;

  Color _boxColor(BuildContext context) {
    switch (platform) {
      case ComparisonPlatform.material:
        return Theme.of(context).colorScheme.primaryContainer;
      case ComparisonPlatform.cupertino:
        return CupertinoTheme.of(context).primaryColor;
      case ComparisonPlatform.custom:
        return Theme.of(context).colorScheme.tertiaryContainer;
    }
  }

  /// 토글 위젯 — Material vs Cupertino 시각/촉감 차이(FR10).
  ///
  /// 비교 체험용 표시 토글이다(전역 상태 커밋 없음 — 발현은 Story 1.7). 활성
  /// 상태를 유지하기 위해 no-op `onChanged`를 제공한다.
  Widget _toggle() {
    final bool on = value > 0.5;
    switch (platform) {
      case ComparisonPlatform.cupertino:
        return CupertinoSwitch(value: on, onChanged: (_) {});
      case ComparisonPlatform.material:
      case ComparisonPlatform.custom:
        return Switch(value: on, onChanged: (_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // 본체 전체를 세로 스크롤로 감싸 작은 화면/큰 textScale에서도 오버플로 방지.
    // (내부 리스트의 물리 비교는 별도 고정 높이 영역에서 시연 — FR10.)
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x33000000)),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              platform.label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              key: boxKey,
              width: side,
              height: side,
              decoration: BoxDecoration(
                color: _boxColor(context),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              ComparisonPanel.scrollHint,
              style: TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 96,
              child: ListView.builder(
                key: listKey,
                physics: listPhysics,
                itemCount: 12,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '#${index + 1}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: _toggle(),
            ),
          ],
        ),
      ),
    );
  }
}
