import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/models/stage_id.dart';
import '../core/state/museum_state.dart';
import 'comparison_view.dart';
import 'lab_scaffold.dart';

/// 공통 실험실 프레임([LabScaffold])을 호스트하는 제네릭 데모 화면.
///
/// Story 1.2의 임시 `StagePlaceholderScreen`을 대체한다. 스테이지별 **실제**
/// 학습 콘텐츠(레이아웃 슬라이더/컴포넌트 토글/애니메이션 드래그 등)는
/// Story 1.5+의 `lib/stages/*`에서 도입된다 — 이 화면은 공통 프레임이
/// end-to-end로 동작함(조작→미리보기 즉시 갱신, 발현→로비 반영)을 증명하는
/// 최소 데모다.
///
/// 로컬 미리보기 상태(_value)는 setState로 즉시 갱신(NFR4)하고, 조작을 1회
/// 이상 수행해야(_touched) 발현 조건이 충족된다(FR6 게이팅).
class StageLabScreen extends StatefulWidget {
  const StageLabScreen({super.key, required this.stageId});

  final StageId stageId;

  static const String controlLabel = '미리보기 크기 조절';
  static const String hintBeforeTouch = '아래 조작 패널을 움직이면 위 미리보기가 즉시 바뀝니다';
  static const String openComparisonLabel = '3종 비교 뷰 열기 (PoC)';

  @override
  State<StageLabScreen> createState() => _StageLabScreenState();
}

class _StageLabScreenState extends State<StageLabScreen> {
  double _value = 0.2;
  bool _touched = false;
  bool _manifesting = false;

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      title: widget.stageId.label,
      canManifest: _touched,
      onManifest: () {
        // 발현 직후 화면을 pop하므로, 전환 애니메이션 중 버튼이 한 번 더
        // 눌려도 이중 pop이 발생하지 않도록 1회만 실행되도록 가드한다.
        if (_manifesting) {
          return;
        }
        _manifesting = true;
        // notifyListeners()가 동기적으로 로비를 재빌드한 뒤에도 안전하도록
        // Navigator를 상태 변경 전에 캡처한다.
        final NavigatorState navigator = Navigator.of(context);
        context.read<MuseumState>().manifest(widget.stageId);
        navigator.pop();
      },
      preview: _PreviewBox(value: _value),
      controls: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(StageLabScreen.hintBeforeTouch),
          const SizedBox(height: 8),
          const Text(StageLabScreen.controlLabel),
          Slider(
            value: _value,
            onChanged: (double v) {
              setState(() {
                _value = v;
                _touched = true;
              });
            },
          ),
          // 3종 플랫폼 비교(스플릿 뷰 PoC) 진입점 — 레이아웃 스테이지 한정.
          // 다른 스테이지는 3종 비교를 적용하지 않는다(Stage 4/5 등은 체험형).
          if (widget.stageId == StageId.layout)
            OutlinedButton.icon(
              onPressed: () {
                // 비동기 push 후 context 사용 경고를 피하려 상태를 미리 캡처.
                final MuseumState museum = context.read<MuseumState>();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ComparisonView(
                      stageId: widget.stageId,
                      // 재입장 시 직전 발현 튜닝값으로 복원(FR14).
                      initialValue:
                          museum.tuningValue(widget.stageId) ?? 0.2,
                      // 발현 = 전역 커밋(FR12). pop은 ComparisonView가 수행.
                      onManifest: (double v) =>
                          museum.manifestTuning(widget.stageId, v),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.compare_arrows),
              label: const Text(StageLabScreen.openComparisonLabel),
            ),
        ],
      ),
    );
  }
}

/// 조작값([value])에 비례해 크기가 변하는 미리보기 박스 — 즉각 피드백 시각화.
class _PreviewBox extends StatelessWidget {
  const _PreviewBox({required this.value});

  /// 위젯 테스트가 미리보기 크기를 측정할 때 사용하는 키.
  static const Key boxKey = Key('stage_lab_preview_box');

  final double value;

  @override
  Widget build(BuildContext context) {
    final double side = 40 + value * 160;
    return Container(
      key: boxKey,
      width: side,
      height: side,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
