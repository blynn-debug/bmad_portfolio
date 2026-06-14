import 'package:flutter/material.dart';

import '../core/models/stage_id.dart';
import 'comparison_panel.dart';
import 'manifest_button.dart';
import 'preset_controls.dart';

/// 3종 플랫폼 비교 스플릿 뷰 컨테이너 (FR9, FR11, AR1 🔴 PoC).
///
/// 단일 루트 `MaterialApp` 아래의 일반 [Scaffold]로, Material/Cupertino/Custom
/// 세 [ComparisonPanel]을 가로 3분할로 **동시 렌더링**한다(FR9). 공통 튜닝값
/// ([_value])을 **단일 보유**하고 세 패널에 동일하게 주입해, 하단 슬라이더를
/// 조작하면 로컬 [setState] 1회로 3패널이 **동시 실시간 반영**된다(FR11, NFR4).
///
/// 이 화면은 발현/영속과 무관하다 — Custom 탭 튜닝값의 로비 발현·프리셋은
/// Story 1.7, 영속은 Story 1.4 스코프다. 재시작 시 값은 초기화된다(의도).
class ComparisonView extends StatefulWidget {
  const ComparisonView({
    super.key,
    required this.stageId,
    this.initialValue = 0.2,
    this.onManifest,
  });

  /// 타이틀/맥락 표시용 스테이지 식별자(라벨만 사용 — stage 콘텐츠 비의존).
  final StageId stageId;

  /// 공통 튜닝값 초기치(0.0~1.0). 재입장 시 호출처가 직전 발현값을 주입한다(FR14).
  final double initialValue;

  /// "발현하기" 콜백 — 현재 튜닝값을 전달한다(FR12). null이면 발현 버튼 미노출
  /// (state 비의존 유지 — 전역 커밋은 호출처가 콜백으로 위임).
  final ValueChanged<double>? onManifest;

  static const String titleSuffix = ' · 3종 비교';
  static const String sliderLabel = '공통 튜닝값 — 3종 패널 동시 반영';

  @override
  State<ComparisonView> createState() => _ComparisonViewState();
}

class _ComparisonViewState extends State<ComparisonView> {
  // initialValue는 공개 생성자 파라미터(공유 위젯 경계)이므로 Slider 계약(0..1)을
  // 보장하기 위해 클램프한다 — 범위 밖 값이 들어와도 throw 없이 안전하게 동작.
  late double _value = widget.initialValue.clamp(0.0, 1.0);

  // 슬라이더/프리셋을 1회 이상 조작해야 발현 조건이 충족된다(FR6 게이팅).
  bool _touched = false;

  // 발현 직후 화면을 pop하므로, 전환 중 버튼이 한 번 더 눌려도 이중 pop이 나지
  // 않도록 1회만 실행되게 가드한다(1.3 학습).
  bool _manifesting = false;

  void _applyValue(double v) {
    setState(() {
      _value = v;
      _touched = true;
    });
  }

  void _onManifestPressed() {
    if (_manifesting) {
      return;
    }
    _manifesting = true;
    // notifyListeners()가 동기적으로 로비를 재빌드한 뒤에도 안전하도록
    // Navigator를 콜백 호출 전에 캡처한다.
    final NavigatorState navigator = Navigator.of(context);
    widget.onManifest!(_value);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.stageId.label}${ComparisonView.titleSuffix}'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // 큰 textScale/작은 화면에서 하단 조작부가 세로로 커져도 상단 3분할
            // 패널 영역을 침범해 오버플로하지 않도록, 하단 높이를 가용 높이의
            // 절반으로 제한하고 그 안에서 스크롤한다. [오버플로 회귀 가드]
            final double maxBottom = constraints.maxHeight / 2;
            return Column(
              children: <Widget>[
                // 상단: 3종 패널 동시 렌더링(가로 3분할). 각 패널에 동일 _value 주입.
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: ComparisonPanel(
                          platform: ComparisonPlatform.material,
                          value: _value,
                        ),
                      ),
                      Expanded(
                        child: ComparisonPanel(
                          platform: ComparisonPlatform.cupertino,
                          value: _value,
                        ),
                      ),
                      Expanded(
                        child: ComparisonPanel(
                          platform: ComparisonPlatform.custom,
                          value: _value,
                        ),
                      ),
                    ],
                  ),
                ),
                // 하단: 공통 튜닝값 슬라이더(소스 오브 트루스).
                Material(
                  elevation: 8,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxBottom),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text(ComparisonView.sliderLabel),
                            Slider(
                              value: _value,
                              onChanged: _applyValue,
                            ),
                            // 프리셋/리셋(FR15) — 적용 시 _value 갱신 + _touched.
                            PresetControls(onApply: _applyValue),
                            // 발현 버튼(FR12) — 콜백이 제공되고 1회 이상 조작 후 노출.
                            if (widget.onManifest != null) ...<Widget>[
                              const SizedBox(height: 12),
                              ManifestButton(
                                visible: _touched,
                                onPressed: _onManifestPressed,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
