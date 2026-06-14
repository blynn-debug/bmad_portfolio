import 'stage_id.dart';

/// 스테이지 진행 상태를 보관하는 불변 모델 (FR3, FR4).
///
/// 클리어된 스테이지 집합을 갖고, 순차 잠금 규칙을 파생한다. 모든 갱신은
/// 새 인스턴스를 반환하는 불변 업데이트로 이뤄진다. Story 1.4의 영속 인프라가
/// 그대로 직렬화/복원할 수 있도록 `.name` 기반 `toJson`/`fromJson`을 갖춘다.
class StageProgress {
  const StageProgress(this.clearedStages);

  /// 빈 cleared 집합 — 첫 스테이지(layout)만 열린 초기 상태.
  const StageProgress.initial() : clearedStages = const <StageId>{};

  /// 클리어 완료된 스테이지 집합 (불변).
  final Set<StageId> clearedStages;

  /// 해당 스테이지가 클리어되었는지.
  bool isCleared(StageId stage) => clearedStages.contains(stage);

  /// 해당 스테이지가 열려 있는지 — 첫 스테이지이거나 직전 스테이지가 클리어된 경우.
  bool isUnlocked(StageId stage) {
    if (stage == StageId.values.first) {
      return true;
    }
    final StageId previous = StageId.values[stage.index - 1];
    return isCleared(previous);
  }

  /// [stage]를 cleared에 더한 새 인스턴스 반환 (불변 업데이트).
  StageProgress withCleared(StageId stage) {
    return StageProgress(<StageId>{...clearedStages, stage});
  }

  /// cleared를 `.name` 문자열 리스트로 직렬화.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cleared': clearedStages.map((StageId s) => s.name).toList(),
    };
  }

  /// JSON에서 복원. 알 수 없는 name은 무시(폴백).
  factory StageProgress.fromJson(Map<String, dynamic> json) {
    final Object? raw = json['cleared'];
    if (raw is! List) {
      return const StageProgress.initial();
    }
    final Set<StageId> cleared = <StageId>{};
    for (final Object? item in raw) {
      for (final StageId stage in StageId.values) {
        if (stage.name == item) {
          cleared.add(stage);
          break;
        }
      }
    }
    return StageProgress(cleared);
  }
}
