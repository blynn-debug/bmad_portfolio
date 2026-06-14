import 'package:flutter/material.dart';

import 'manifest_button.dart';

/// 모든 실험실이 공유하는 공통 프레임 (FR5, FR8).
///
/// 레이아웃은 상단 결과 미리보기 + 하단 조작 패널 + 발현 버튼으로 고정되고,
/// 영역별 인터랙션 위젯(슬라이더/토글/드래그/시나리오/자유)은 [preview]/[controls]
/// 슬롯으로 주입한다. 스테이지·전역 상태에 의존하지 않는 재사용 프레임이며,
/// 발현은 [onManifest] 콜백으로 호출처(예: 스테이지 화면)에 위임한다.
///
/// 즉각 피드백(NFR4)은 슬롯 위젯이 로컬 setState로 책임진다 — 이 프레임은
/// 자체 상태를 보유하지 않는다.
class LabScaffold extends StatelessWidget {
  const LabScaffold({
    super.key,
    required this.title,
    required this.preview,
    required this.controls,
    required this.canManifest,
    required this.onManifest,
  });

  /// AppBar 타이틀(보통 스테이지 라벨).
  final String title;

  /// 상단 결과 미리보기 슬롯.
  final Widget preview;

  /// 하단 조작 패널 슬롯.
  final Widget controls;

  /// 발현 조건 충족 여부 — 충족 시에만 발현 버튼이 활성/노출된다 (FR6 게이팅).
  final bool canManifest;

  /// "발현하기" 실행 콜백.
  final VoidCallback onManifest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        // 큰 textScale/작은 화면에서도 RenderFlex overflow가 나지 않도록 본문
        // 전체를 스크롤 가능하게 감싼다(공간이 충분하면 Expanded로 채우고,
        // 부족하면 스크롤). [오버플로 회귀 가드]
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      // 상단: 결과 미리보기(남은 세로 공간을 차지).
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(child: preview),
                        ),
                      ),
                      // 하단: 조작 패널 + 발현 버튼.
                      Material(
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              controls,
                              const SizedBox(height: 12),
                              ManifestButton(
                                visible: canManifest,
                                onPressed: onManifest,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
