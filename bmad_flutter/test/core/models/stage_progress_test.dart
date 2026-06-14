import 'package:flutter_test/flutter_test.dart';

import 'package:bmad_flutter/core/models/stage_id.dart';
import 'package:bmad_flutter/core/models/stage_progress.dart';

void main() {
  group('StageProgress', () {
    test('초기 상태에서 layout만 열려 있고 나머지는 잠겨 있다', () {
      const StageProgress progress = StageProgress.initial();

      expect(progress.isUnlocked(StageId.layout), isTrue);
      for (final StageId stage in StageId.values.skip(1)) {
        expect(progress.isUnlocked(stage), isFalse, reason: stage.name);
      }
    });

    test('withCleared(layout) 후 component가 열린다', () {
      const StageProgress progress = StageProgress.initial();

      final StageProgress next = progress.withCleared(StageId.layout);

      expect(next.isCleared(StageId.layout), isTrue);
      expect(next.isUnlocked(StageId.component), isTrue);
      // 원본은 불변 — 변경되지 않는다.
      expect(progress.isCleared(StageId.layout), isFalse);
    });

    test('순차 잠금 — 직전 미클리어 스테이지는 잠긴 상태 유지', () {
      final StageProgress progress =
          const StageProgress.initial().withCleared(StageId.layout);

      // component는 열렸지만 animation은 component 미클리어로 잠김.
      expect(progress.isUnlocked(StageId.component), isTrue);
      expect(progress.isUnlocked(StageId.animation), isFalse);
    });

    test('toJson/fromJson 라운드트립 — .name 직렬화', () {
      final StageProgress progress = const StageProgress.initial()
          .withCleared(StageId.layout)
          .withCleared(StageId.component);

      final Map<String, dynamic> json = progress.toJson();
      expect(json['cleared'], containsAll(<String>['layout', 'component']));

      final StageProgress restored = StageProgress.fromJson(json);
      expect(restored.isCleared(StageId.layout), isTrue);
      expect(restored.isCleared(StageId.component), isTrue);
      expect(restored.isCleared(StageId.animation), isFalse);
    });

    test('fromJson — 알 수 없는 name은 무시(폴백)', () {
      final StageProgress restored = StageProgress.fromJson(<String, dynamic>{
        'cleared': <String>['layout', 'unknown_stage'],
      });

      expect(restored.isCleared(StageId.layout), isTrue);
      expect(restored.clearedStages.length, 1);
    });

    test('fromJson — cleared 누락/형식 오류 시 초기 상태', () {
      final StageProgress restored =
          StageProgress.fromJson(<String, dynamic>{});

      expect(restored.clearedStages, isEmpty);
    });
  });
}
