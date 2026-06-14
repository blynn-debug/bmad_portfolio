import 'package:flutter/foundation.dart';

import '../models/stage_id.dart';
import '../models/stage_progress.dart';

/// 박물관 진행 상태의 전역 단일 출처(SSOT) (FR4).
///
/// Provider로 주입되어 위젯이 `context.watch`로 구독하고 액션은 `context.read`로
/// 호출한다. 상태 변경 직후 [notifyListeners]를 1회만 호출한다.
///
/// 영속(Story 1.4)을 위한 [toJson]/[loadFromJson] 훅을 노출하지만, 이 스토리에서는
/// 실제 디스크 영속을 구현하지 않는다(in-memory 상태).
class MuseumState extends ChangeNotifier {
  StageProgress _progress = const StageProgress.initial();

  /// 스테이지별 발현된 튜닝값(0.0~1.0) (FR12, FR14).
  ///
  /// "발현하기" 시점에 [manifestTuning]으로만 커밋되는 발현 파이프라인의 상태다
  /// (AR3: Custom 탭 조작값 → 상태 → 로비 반영). 디스크 영속(FR13)은 Story 1.4
  /// 스코프이므로 이 맵은 in-memory SSOT까지만 — 재시작 시 초기화된다(의도).
  final Map<StageId, double> _tuningValues = <StageId, double>{};

  /// 해당 스테이지가 열려 있는지.
  bool isUnlocked(StageId stage) => _progress.isUnlocked(stage);

  /// 해당 스테이지가 클리어되었는지.
  bool isCleared(StageId stage) => _progress.isCleared(stage);

  /// 해당 스테이지에 발현된 튜닝값 — 발현된 적 없으면 null (FR12).
  double? tuningValue(StageId stage) => _tuningValues[stage];

  /// 발현(manifest) — 학습 조건 충족 후 실험실 산출물을 로비에 커밋하는 전역 액션.
  ///
  /// 발현 = 클리어(다음 스테이지 해제)와 동일 이벤트다(Epic 1 루프:
  /// 만지기→비교→발현→영속). 이미 발현/클리어된 스테이지면 no-op(통지 없음),
  /// 아니면 진행 상태를 불변 업데이트한 뒤 [notifyListeners]를 1회만 호출한다.
  void manifest(StageId stage) {
    if (_progress.isCleared(stage)) {
      return;
    }
    _progress = _progress.withCleared(stage);
    notifyListeners();
  }

  /// 튜닝값 발현 — Custom 튜닝값을 전역 상태에 커밋하고 로비에 반영하는 액션
  /// (FR12, FR14).
  ///
  /// 발현 = 클리어와 동일 이벤트이므로 미클리어 스테이지는 함께 해제한다. 단,
  /// **재입장 후 재발현**(FR14)을 위해 이미 클리어된 스테이지여도 튜닝값이 달라지면
  /// 값을 갱신하고 통지한다. 이미 클리어 + 동일 값이면 no-op(불필요한 리빌드 방지).
  /// 모든 경우 [value]는 Slider 계약(0..1)을 보장하도록 클램프하며, 상태 변경이
  /// 있을 때만 [notifyListeners]를 1회 호출한다.
  void manifestTuning(StageId stage, double value) {
    final double clamped = value.clamp(0.0, 1.0);
    final bool alreadyCleared = _progress.isCleared(stage);
    final bool sameValue = _tuningValues[stage] == clamped;
    if (alreadyCleared && sameValue) {
      return;
    }
    _tuningValues[stage] = clamped;
    if (!alreadyCleared) {
      _progress = _progress.withCleared(stage);
    }
    notifyListeners();
  }

  /// 진행 상태를 직렬화(Story 1.4 영속 훅).
  Map<String, dynamic> toJson() => _progress.toJson();

  /// JSON에서 진행 상태를 복원(Story 1.4 영속 훅).
  void loadFromJson(Map<String, dynamic> json) {
    _progress = StageProgress.fromJson(json);
    notifyListeners();
  }
}
