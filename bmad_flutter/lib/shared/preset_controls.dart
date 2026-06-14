import 'package:flutter/material.dart';

/// 3종 비교 스테이지의 디자인 철학 프리셋 (FR15).
///
/// 각 프리셋은 **서로 다른** 대표 튜닝값을 가져, 적용 즉시 3패널 렌더링에
/// 값 차이가 눈에 보이게 한다(디자인 철학을 값으로 체감). 직렬화/외부 노출
/// 없는 UI 식별 전용이다.
enum TuningPreset { ios, material, custom }

/// 프리셋 라벨/대표 값.
extension TuningPresetSpec on TuningPreset {
  String get label {
    switch (this) {
      case TuningPreset.ios:
        return 'iOS';
      case TuningPreset.material:
        return 'Material';
      case TuningPreset.custom:
        return 'Custom';
    }
  }

  /// 적용 시 설정되는 대표 튜닝값(0.0~1.0). 세 값은 분명히 구분된다.
  double get value {
    switch (this) {
      case TuningPreset.ios:
        return 0.9;
      case TuningPreset.material:
        return 0.55;
      case TuningPreset.custom:
        return 0.25;
    }
  }
}

/// iOS/Material/Custom 프리셋 적용 + 리셋 컨트롤 (FR15).
///
/// stage/state 비의존 재사용 위젯(shared 경계) — 선택된 값은 [onApply] 콜백으로만
/// 위임하고 자체 상태를 갖지 않는다. 협소 폭에서도 깨지지 않도록 [Wrap]으로
/// 줄바꿈 처리한다.
class PresetControls extends StatelessWidget {
  const PresetControls({super.key, required this.onApply});

  /// 프리셋/리셋 선택 시 적용할 튜닝값을 전달하는 콜백.
  final ValueChanged<double> onApply;

  /// 리셋 시 되돌릴 기본값 — [ComparisonView] 기본값과 일치.
  static const double defaultValue = 0.2;

  static const String hint = '프리셋으로 값 차이를 비교하거나 기본값으로 리셋';
  static const String resetLabel = '리셋';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          hint,
          style: TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: <Widget>[
            for (final TuningPreset preset in TuningPreset.values)
              OutlinedButton(
                key: Key('preset_${preset.name}'),
                onPressed: () => onApply(preset.value),
                child: Text(
                  preset.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            TextButton(
              key: const Key('preset_reset'),
              onPressed: () => onApply(defaultValue),
              child: const Text(
                resetLabel,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
