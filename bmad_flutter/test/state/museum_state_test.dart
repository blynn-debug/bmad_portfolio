import 'package:flutter_test/flutter_test.dart';

import 'package:bmad_flutter/core/models/stage_id.dart';
import 'package:bmad_flutter/core/state/museum_state.dart';

void main() {
  group('MuseumState', () {
    test('초기 상태 — layout만 열림, component 잠김', () {
      final MuseumState state = MuseumState();

      expect(state.isUnlocked(StageId.layout), isTrue);
      expect(state.isUnlocked(StageId.component), isFalse);
    });

    test('manifest(layout) — listener 1회 통지 + component 해제', () {
      final MuseumState state = MuseumState();
      int notifications = 0;
      state.addListener(() => notifications++);

      state.manifest(StageId.layout);

      expect(notifications, 1);
      expect(state.isCleared(StageId.layout), isTrue);
      expect(state.isUnlocked(StageId.component), isTrue);
    });

    test('중복 manifest — no-op(통지 없음)', () {
      final MuseumState state = MuseumState();
      state.manifest(StageId.layout);

      int notifications = 0;
      state.addListener(() => notifications++);
      state.manifest(StageId.layout);

      expect(notifications, 0);
    });

    test('순차 게이팅 — 직전 미클리어 스테이지는 잠김 유지', () {
      final MuseumState state = MuseumState();

      state.manifest(StageId.layout);

      expect(state.isUnlocked(StageId.component), isTrue);
      expect(state.isUnlocked(StageId.animation), isFalse);
    });

    test('manifestTuning — 값 커밋 + 클리어 + 통지 1회 (FR12)', () {
      final MuseumState state = MuseumState();
      int notifications = 0;
      state.addListener(() => notifications++);

      state.manifestTuning(StageId.layout, 0.7);

      expect(notifications, 1);
      expect(state.tuningValue(StageId.layout), 0.7);
      expect(state.isCleared(StageId.layout), isTrue);
      expect(state.isUnlocked(StageId.component), isTrue);
    });

    test('manifestTuning 재발현 — 이미 클리어여도 다른 값이면 갱신 + 통지 (FR14)', () {
      final MuseumState state = MuseumState();
      state.manifestTuning(StageId.layout, 0.3);

      int notifications = 0;
      state.addListener(() => notifications++);
      state.manifestTuning(StageId.layout, 0.8);

      expect(notifications, 1);
      expect(state.tuningValue(StageId.layout), 0.8);
    });

    test('manifestTuning — 이미 클리어 + 동일 값이면 no-op(통지 없음)', () {
      final MuseumState state = MuseumState();
      state.manifestTuning(StageId.layout, 0.5);

      int notifications = 0;
      state.addListener(() => notifications++);
      state.manifestTuning(StageId.layout, 0.5);

      expect(notifications, 0);
    });

    test('manifestTuning — 범위 밖 값은 0..1로 클램프', () {
      final MuseumState state = MuseumState();

      state.manifestTuning(StageId.layout, 1.5);
      expect(state.tuningValue(StageId.layout), 1.0);

      state.manifestTuning(StageId.layout, -0.5);
      expect(state.tuningValue(StageId.layout), 0.0);
    });

    test('tuningValue — 발현 전에는 null', () {
      final MuseumState state = MuseumState();
      expect(state.tuningValue(StageId.layout), isNull);
    });

    test('toJson/loadFromJson 영속 훅 라운드트립', () {
      final MuseumState source = MuseumState();
      source.manifest(StageId.layout);
      final Map<String, dynamic> json = source.toJson();

      final MuseumState restored = MuseumState();
      restored.loadFromJson(json);

      expect(restored.isCleared(StageId.layout), isTrue);
      expect(restored.isUnlocked(StageId.component), isTrue);
    });
  });
}
