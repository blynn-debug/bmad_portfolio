---
baseline_commit: NO_VCS
---

# Story 1.7: Stage 1 튜닝값 발현 & 프리셋/리셋

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a 학습자,
I want Custom 탭에서 튜닝한 값을 로비에 발현하고 프리셋으로 비교·리셋하며,
so that 내가 만든 값이 그대로 앱이 되고, 프리셋 차이로 디자인 철학을 값으로 체감한다.

## Acceptance Criteria

**AC1 (FR12)** — Custom 튜닝값의 로비 발현(영구 반영)
- **Given** 3종 비교 실험실(`ComparisonView`)에서 Custom 튜닝값을 조정한 상태에서
- **When** "발현하기"를 실행한다
- **Then** 조정한 튜닝값이 전역 `MuseumState`에 커밋되고 로비 발현물(layout 카드)에 **반영**된다
- **And** 발현은 클리어(다음 스테이지 해제)와 동일 이벤트로 동작한다(기존 발현 루프 일관성)
- **And** "영구"의 의미는 **세션 내 SSOT 커밋 + 로비 반영**까지다 — 앱 재시작 영속(디스크)은 FR13/Story 1.4 스코프이므로 **이 스토리에서 구현하지 않는다**

**AC2 (FR14)** — 재입장 후 튜닝값 재조정 & 재반영
- **Given** 한 번 발현(클리어)한 뒤
- **When** 같은 스테이지의 3종 비교 뷰에 재입장해 값을 다시 조정하고 재발현한다
- **Then** 재입장 시 직전에 발현했던 튜닝값이 초기값으로 복원되어 보이고
- **And** 재조정 후 재발현하면 변경된 값이 로비 발현물에 **재반영**된다(이미 클리어된 상태여도 값 갱신 + 통지)

**AC3 (FR15)** — iOS/Material/Custom 프리셋 & 리셋
- **Given** 3종 비교 실험실에서
- **When** iOS / Material / Custom 프리셋 중 하나를 적용한다
- **Then** 적용 즉시 튜닝값이 해당 프리셋 값으로 바뀌고 3패널 렌더링에 **즉시** 반영되어 **값 차이가 눈에 보인다**(NFR4)
- **And** "리셋"을 누르면 기본값으로 되돌아간다
- **And** 세 프리셋은 서로 **다른 값**을 가져 디자인 철학 차이를 값으로 체감하게 한다

**AC4 (회귀/경계)** — 기존 동작 보존 + 스코프 경계
- **Given** 이 스토리 완료 후
- **Then** 기존 end-to-end 동작(순차 잠금, `StageLabScreen` 발현 루프, 3종 동시 렌더·실시간 반영, 오버플로 안전성)이 모두 유지된다
- **And** shared_preferences 디스크 영속(1.4), Stage 1 실제 슬라이더 레이아웃 학습 콘텐츠(1.5), `core/theme/*`·`tuning_values.dart` 추출은 **구현하지 않는다**

## Tasks / Subtasks

- [x] **Task 1: `MuseumState`에 튜닝값 발현 파이프라인 추가 — `museum_state.dart`** (AC: #1, #2)
  - [x] `lib/core/state/museum_state.dart` 수정 — 스테이지별 튜닝값을 보관할 `final Map<StageId, double> _tuningValues = <StageId, double>{};` 추가.
  - [x] `double? tuningValue(StageId stage) => _tuningValues[stage];` 게터 추가(발현된 적 없으면 null).
  - [x] **새 액션** `void manifestTuning(StageId stage, double value)` 추가(동사형 — 아키텍처 명명 규칙):
    - `value`를 `clamp(0.0, 1.0)`로 정규화(Slider 계약 보장, 공유 경계 방어).
    - 이미 클리어 + 동일 값이면 **no-op**(통지 없음) — 불필요한 리빌드 방지.
    - 아니면 `_tuningValues[stage] = clamped` 저장, 미클리어면 `_progress = _progress.withCleared(stage)` 로 클리어(발현=클리어 동일 이벤트), **`notifyListeners()` 1회만** 호출.
    - **FR14 핵심:** 이미 클리어된 스테이지여도 값이 달라지면 값 갱신 + 통지(재발현 재반영).
  - [x] **기존 `manifest(StageId)`는 변경하지 않는다**(`StageLabScreen` 제네릭 데모가 계속 사용 — 튜닝값 없는 단순 발현). `manifestTuning`은 값까지 동반하는 발현이다.
  - [x] **직렬화(`toJson`/`loadFromJson`)는 이 스토리에서 건드리지 않는다** — 튜닝값 디스크 직렬화는 Story 1.4(`tuning_values.dart` + shared_preferences) 스코프. `_tuningValues`는 in-memory SSOT까지만.

- [x] **Task 2: 프리셋/리셋 위젯 — `preset_controls.dart` (NEW)** (AC: #3)
  - [x] `lib/shared/preset_controls.dart` 생성. stage/state 비의존 재사용 위젯(shared 경계 준수 — `MuseumState`/`stages/*` import 금지).
  - [x] `enum TuningPreset { ios, material, custom }` + 라벨/값 extension. 세 프리셋은 **서로 다른** 대표 값(예: ios=0.9, material=0.55, custom=0.25 — 분명히 구분되는 값). `static const double defaultValue = 0.2;`(리셋 목표, `ComparisonView` 기본값과 일치).
  - [x] `class PresetControls extends StatelessWidget` — 생성자: `required ValueChanged<double> onApply`. iOS/Material/Custom 3개 프리셋 버튼(누르면 `onApply(preset.value)`) + "리셋" 버튼(`onApply(defaultValue)`).
  - [x] 표시 문자열(프리셋 라벨, 리셋 라벨, 안내)은 `static const`로 단일 출처화(테스트 공유). 각 버튼은 테스트 식별을 위해 텍스트 라벨 또는 `Key('preset_<name>')`/`Key('preset_reset')` 부여.
  - [x] **협소 폭 가드:** 4개 버튼이 좁은 폭에서 깨지지 않도록 `Wrap`(또는 가로 스크롤) 사용 + 텍스트 `overflow: TextOverflow.ellipsis`.

- [x] **Task 3: `ComparisonView`에 발현 + 프리셋 통합 — `comparison_view.dart` (UPDATE)** (AC: #1, #2, #3)
  - [x] `lib/shared/comparison_view.dart` 수정 — **선택적** 발현 콜백 추가: `final ValueChanged<double>? onManifest;`(생성자에 `this.onManifest`). null이면 발현 버튼 미노출(기존 1.6 직접 생성 테스트/사용 호환).
  - [x] 하단 조작부에 (a) 기존 공통 슬라이더, (b) `PresetControls(onApply: (v) => setState(() { _value = v; _touched = true; }))`, (c) `onManifest != null && _touched`일 때 노출되는 발현 버튼(`ManifestButton` 재사용)을 추가. `bool _touched = false;` 상태 추가(슬라이더 조작/프리셋 적용 시 true).
  - [x] 발현 버튼 동작: 1.3에서 학습한 **Navigator 사전 캡처 + 1회 가드** 패턴 적용 — `final navigator = Navigator.of(context); widget.onManifest!(_value); navigator.pop();`. `bool _manifesting` 가드로 이중 pop 방지.
  - [x] **하단 조작부 오버플로 가드 유지:** 기존 `LayoutBuilder` + `maxBottom = maxHeight/2` + `SingleChildScrollView` 구조 안에 프리셋/발현 버튼을 넣어 큰 textScale·작은 화면에서도 상단 패널 영역을 침범하지 않게 한다.
  - [x] `initialValue`(이미 존재, clamp됨)는 그대로 — FR14 재입장 복원은 **호출처(StageLabScreen)** 가 `MuseumState.tuningValue`를 `initialValue`로 주입해 처리한다(아래 Task 4). `ComparisonView`는 state 비의존 유지(shared 경계).

- [x] **Task 4: `StageLabScreen`에서 발현/재입장 배선 — `stage_lab_screen.dart` (UPDATE)** (AC: #1, #2)
  - [x] `lib/shared/stage_lab_screen.dart`의 "3종 비교 뷰 열기" 버튼 `onPressed` 수정 — push 시 `ComparisonView`에:
    - `initialValue: context.read<MuseumState>().tuningValue(widget.stageId) ?? 0.2`(FR14 재입장 복원 — 직전 발현값이 있으면 그 값으로 시작).
    - `onManifest: (double v) => context.read<MuseumState>().manifestTuning(widget.stageId, v)`(발현 = 전역 커밋; pop은 `ComparisonView`가 자체 수행).
  - [x] push 전 `MuseumState`를 `context.read`로 캡처(비동기 push 후 context 사용 경고 회피). 기존 슬라이더/제네릭 발현(`onManifest`→`manifest`) 로직은 변경하지 않는다(레이아웃 스테이지 제네릭 데모 유지).
  - [x] **회귀 주의:** 기존 layout 한정 버튼 노출/비-layout 미노출, 제네릭 발현 게이팅·커밋·pop은 그대로 동작해야 한다.

- [x] **Task 5: 로비 발현물에 튜닝값 반영 — `lobby_manifestations.dart` (UPDATE)** (AC: #1, #2)
  - [x] `lib/lobby/manifestations/lobby_manifestations.dart` 수정 — 각 발현물 카드에서 `state.tuningValue(stage)`를 읽어, 값이 있으면 **값에 비례하는 시각 지표**(예: 값 비례 너비 바 + 퍼센트 텍스트)를 카드에 추가. 값이 없으면(제네릭 발현) 기존 카드 모양 유지.
  - [x] 지표에 테스트용 키 `Key('manifest_tuning_${stage.name}')` 부여 — 재발현 시 너비/텍스트 변화로 FR14 재반영을 검증 가능하게.
  - [x] **회귀 주의:** 빈 상태 안내, 카드 누적, `ListTile` 미사용(로비 회귀 가드), 오버플로 안전성, 기존 라벨(`stage.label`/`manifestedLabel`)은 유지. 지표 추가만.

- [x] **Task 6: 테스트 — Red → Green** (AC: #1, #2, #3, #4)
  - [x] `test/state/museum_state_test.dart` (UPDATE): `manifestTuning` — (a) 값 커밋 + 클리어 + 통지 1회, (b) `tuningValue` 게터 반환, (c) 재발현(이미 클리어)에서 **다른 값**이면 값 갱신 + 통지(FR14), (d) 이미 클리어 + **동일 값**이면 no-op(통지 0), (e) clamp(범위 밖 입력 정규화). 기존 5개 테스트(초기/단순 manifest/중복/게이팅/라운드트립)는 유지·통과.
  - [x] `test/shared/preset_controls_test.dart` (NEW): iOS/Material/Custom 버튼 탭 시 `onApply`가 **서로 다른** 값으로 호출됨, 리셋 버튼은 `defaultValue`로 호출됨. 320×320·textScale 3.0 오버플로 가드(`takeException()` null).
  - [x] `test/shared/comparison_view_test.dart` (UPDATE): (a) 프리셋 적용 시 3패널 박스 크기가 변함(즉시 반영, AC3), 서로 다른 프리셋이 다른 크기 산출, (b) `onManifest` 제공 시 조작 후 발현 버튼 노출·탭 시 콜백이 `_value`로 호출 + 화면 pop, (c) `onManifest` 미제공(기존 1.6 경로) 시 발현 버튼 미노출. 기존 4개 테스트 유지. 오버플로 가드 유지.
  - [x] `test/shared/stage_lab_screen_test.dart` (UPDATE): layout에서 3종 비교 진입 → (프리셋/슬라이더로 조작) → 발현 → `MuseumState.tuningValue(layout)` 설정됨 + `isCleared(layout)` true + `ComparisonView` pop. 재입장 시 `initialValue`가 직전 발현값으로 복원(FR14) — `ComparisonView.initialValue` 위젯 프로퍼티 또는 패널 박스 크기로 검증. 기존 6개 테스트 유지.
  - [x] `test/lobby/manifestations/lobby_manifestations_test.dart` (UPDATE): `manifestTuning(layout, v)` 후 `Key('manifest_tuning_layout')` 지표가 나타나고, 더 큰 값으로 재발현하면 지표 너비/텍스트가 커진다(FR12/FR14). 기존 4개 테스트 유지(제네릭 `manifest`는 지표 없이 카드만).
  - [x] `flutter analyze` 0 issue + `flutter test` 전체 통과.

## Dev Notes

### 핵심 컨텍스트
이 스토리는 Epic 1 킬링 포인트의 마지막 조각 — **"내 튜닝값이 곧 내 앱"** 약속을 코드로 잇는 발현 파이프라인(상태 커밋 → 로비 반영)이다. 1.6에서 만든 3종 비교 프레임(`ComparisonView`/`ComparisonPanel`, 단일 SSOT 슬라이더)을 재사용해, (1) Custom 튜닝값을 전역 `MuseumState`에 발현(FR12), (2) 재입장 후 재조정·재반영(FR14), (3) iOS/Material/Custom 프리셋·리셋(FR15)을 추가한다.

**아키텍처 발현 파이프라인(AR3, 단방향):** UI 액션("발현하기") → `MuseumState.manifestTuning` → notify → `Consumer`(로비) 리빌드. UI는 영속 계층에 직접 접근하지 않는다(항상 상태 경유). 이 스토리는 그 파이프라인의 **상태→로비** 구간을 완성하고, **상태→디스크** 영속 구간은 Story 1.4가 채운다.

### 🚨 스코프 경계 (절대 넘지 말 것)
- ❌ **shared_preferences 디스크 영속(FR13)** → **Story 1.4**. 튜닝값은 `MuseumState` in-memory `Map<StageId,double>`까지만. 앱 재시작 시 초기화 — **의도된 것**. `toJson`/`loadFromJson`에 튜닝값을 추가하지 않는다(1.4가 `tuning_values.dart` 모델과 함께 도입).
- ❌ **Stage 1 실제 슬라이더 레이아웃 학습 콘텐츠(FR16)** → **Story 1.5**(`lib/stages/layout/`). 본 스토리는 1.6의 대표 레이아웃 패널을 그대로 발현 소스로 쓴다. "Custom 탭"의 튜닝 소스 = 현재의 단일 공통 튜닝값(`_value`) — Custom 패널이 디자인 철학 자리(AR3). 별도 탭 UI를 새로 만들지 않는다.
- ❌ `core/theme/*`(material/cupertino/custom_theme.dart) 추출 → 후속. 패널 테마는 1.6대로 인라인 유지.
- ❌ `core/models/tuning_values.dart` 직렬화 모델 파일 신설 → Story 1.4(영속과 함께). 지금은 `MuseumState` 내부 맵으로 충분.
- ❌ 스테이지별 실제 발현물 위젯(`skeleton_manifest.dart` 등) → 후속. 로비는 제네릭 카드 + 튜닝값 지표까지만.

### 🚨 회귀 주의 — 기존 코드와의 상호작용
[읽고 시작할 파일: `lib/core/state/museum_state.dart`, `lib/shared/comparison_view.dart`, `lib/shared/stage_lab_screen.dart`, `lib/lobby/manifestations/lobby_manifestations.dart`, `lib/shared/manifest_button.dart`, 및 해당 테스트들]

- **`MuseumState` 현재 상태:** `manifest`/`isUnlocked`/`isCleared`/`toJson`/`loadFromJson`. `manifest`는 이미 클리어면 no-op(통지 없음) — 기존 테스트("중복 manifest — no-op")가 이를 단언하므로 **`manifest` 시그니처/동작 불변**. 튜닝 발현은 **새 메서드 `manifestTuning`** 으로 분리한다.
- **`ComparisonView` 현재 상태:** 단일 `_value`(initialValue clamp), 하단 슬라이더, 발현/프리셋 없음. 1.6 테스트는 `ComparisonView(stageId:...)`를 `onManifest` 없이 직접 생성 → `onManifest`를 **nullable 선택 파라미터**로 추가해 호환 보장(null이면 발현 버튼 미노출).
- **`StageLabScreen` 현재 상태:** layout 한정 "3종 비교 열기" 버튼이 `ComparisonView(stageId:)`만 넘김. 여기에 `initialValue`/`onManifest` 배선 추가. 제네릭 발현(`onManifest`→`manifest`+pop, `_manifesting` 가드)·슬라이더·버튼 게이팅은 불변.
- **`LobbyManifestations` 현재 상태:** cleared 스테이지마다 제네릭 `Card`(아이콘+라벨+'발현됨'). `ListTile` 미사용이 회귀 가드 단언 대상 — 지표 추가 시 `ListTile`을 쓰지 않는다.
- **`ManifestButton`:** `visible`+`onPressed`, 라벨 `'발현하기'`(`ManifestButton.label`). 그대로 재사용.

> **원칙:** 완료 후 앱은 end-to-end로 동작해야 한다 — 로비→레이아웃 실험실→3종 비교 진입→(슬라이더/프리셋 조작→3패널 즉시 반영)→발현→로비 카드에 튜닝값 반영→재입장 시 값 복원→재조정·재발현→로비 재반영. 기존 동작(순차 잠금, 제네릭 발현, 오버플로 안전성)도 깨지지 않아야 한다.

### 아키텍처 준수 — 상태/경계 규칙 (반드시 따를 것)
[Source: architecture.md#Structure Patterns, #Communication Patterns, #Enforcement Guidelines]
- **발현 = 전역 커밋은 "발현하기" 시점만**(즉각 피드백은 로컬 setState). 프리셋/슬라이더 조작은 `ComparisonView` 로컬 `setState`(지연 0, NFR4) — 발현 버튼을 눌러야 `MuseumState`에 커밋.
- **단방향 파이프라인:** UI → `MuseumState.manifestTuning` → notify → 로비 `Consumer`/`watch` 리빌드. UI가 상태를 우회해 로비를 직접 갱신하지 않는다.
- **`notifyListeners()`는 변경 직후 1회만**(루프 내 다발 호출 금지).
- **shared 경계:** `comparison_view.dart`/`preset_controls.dart`는 `MuseumState`·`stages/*`를 import하지 않는다. 상태 결합은 호출처(`stage_lab_screen.dart`)가 콜백으로 주입.
- **명명:** 액션 동사형(`manifestTuning`), 불리언 `is/has/can`, 파일 `snake_case`, 위젯/enum `PascalCase`, 상수 `lowerCamelCase`. 표시 문자열 `static const` 단일 출처화.
- **StageId enum + `.name`** 사용(문자열/인덱스 하드코딩 금지). 튜닝 맵 키는 `StageId`.

### 파일 구조 — 이 스토리가 만지는 파일
[Source: architecture.md#Complete Project Directory Structure — shared/preset_controls(FR15), museum_state(FR12-15)]
- `lib/core/state/museum_state.dart` (UPDATE) — `_tuningValues` 맵 + `tuningValue` 게터 + `manifestTuning` 액션. (FR12, FR14)
- `lib/shared/preset_controls.dart` (NEW) — iOS/Material/Custom 프리셋 + 리셋(`onApply` 콜백, state 비의존). (FR15)
- `lib/shared/comparison_view.dart` (UPDATE) — 선택적 `onManifest` + `PresetControls` + 발현 버튼(`_touched`/`_manifesting` 가드, 하단 오버플로 가드 유지). (FR12, FR14, FR15)
- `lib/shared/stage_lab_screen.dart` (UPDATE) — 3종 비교 진입에 `initialValue`(tuningValue 복원) + `onManifest`(manifestTuning) 배선. (FR12, FR14)
- `lib/lobby/manifestations/lobby_manifestations.dart` (UPDATE) — 발현물 카드에 튜닝값 비례 지표 + `Key('manifest_tuning_<stage>')`. (FR12, FR14)
- 테스트: `test/state/museum_state_test.dart`(U), `test/shared/preset_controls_test.dart`(N), `test/shared/comparison_view_test.dart`(U), `test/shared/stage_lab_screen_test.dart`(U), `test/lobby/manifestations/lobby_manifestations_test.dart`(U).

> **빈 디렉토리/후속 파일 미리 만들지 말 것:** `core/persistence/*`, `core/models/tuning_values.dart`, `core/theme/*`, `stages/layout/*`, `lobby/manifestations/skeleton_manifest.dart`는 후속 스토리(1.4/1.5). [Source: 1-3·1-6 Project Structure Notes — 후속 폴더 선생성 금지]

### 테스트 표준
[Source: architecture.md#Testing Framework; 1-1~1-6 Testing Standards]
- `flutter_test`(SDK 내장), `test/`가 `lib/` 미러링.
- **상태 테스트:** `MuseumState`는 Provider 없이 직접 인스턴스화해 `addListener`로 통지 횟수 단언. 통지 1회/0회(no-op) 정밀 단언.
- **위젯 테스트:** `ComparisonView`/`PresetControls`는 `MaterialApp(home: ...)` 하니스. `StageLabScreen`/`LobbyManifestations`는 `ChangeNotifierProvider<MuseumState>.value` 하니스(기존 패턴 재사용).
- **즉시 반영(AC3):** 프리셋 탭 후 `pump` → 3패널 박스 크기 변화 단언(서로 다른 프리셋 = 다른 크기).
- **발현 콜백(AC1):** `onManifest` 스파이로 호출 값/횟수 단언, 발현 후 `find.byType(ComparisonView)` 사라짐(pop).
- **재반영(FR14/AC2):** 로비 지표 키 너비/텍스트가 재발현 후 변화.
- **오버플로 회귀 가드:** 320×320·textScale 3.0, teardown reset, `takeException()` null — 신규/수정 위젯 테스트 전부에 적용.
- TDD: Red → Green → 정리.

### Previous Story Intelligence (1.1~1.6에서 이어받는 학습)
[Source: 1-1·1-2·1-3·1-6 Dev Notes & Review Findings]
- **환경:** 로컬 Flutter **3.41.9 stable**(설계 기준 3.44.0보다 낮음). 본 스토리는 순수 Flutter material+cupertino + `provider`(이미 추가됨)만 사용 — **신규 의존성 없음**. shared_preferences는 1.4까지 추가하지 않는다.
- **VCS 없음:** git 저장소 아님(`baseline_commit: NO_VCS`). 검증은 `flutter analyze`(0 issue) + `flutter test`(전체 통과)로.
- **오버플로 회귀 가드(반복 지적):** 큰 textScale·작은 화면에서 RenderFlex overflow 빈발. `ComparisonView` 하단에 프리셋(버튼 4개)+발현 버튼을 추가하면 하단 높이가 커진다 → 기존 `maxBottom=maxHeight/2`+`SingleChildScrollView` 구조 안에 넣고, 프리셋은 `Wrap`으로 줄바꿈. 320×320·textScale 3.0 테스트 필수.
- **문자열 상수화:** 인라인 리터럴은 테스트 중복으로 깨지기 쉽다 → `static const`(프리셋/리셋/안내 라벨) 단일 출처화.
- **Navigator 사전 캡처 + 1회 가드(1.3 학습):** 발현 직후 동기 pop 시 이중 pop/동기 재빌드 방어 — `ComparisonView` 발현도 `navigator` 사전 캡처 + `_manifesting` 가드.
- **1.6 PoC 결과:** 단일 루트 `MaterialApp` + 패널별 테마 격리(중첩 App 없이 Material/Cupertino 공존) = PASS. 본 스토리는 그 프레임을 변형 없이 재사용(발현/프리셋만 추가).
- **로비 회귀 가드:** `LobbyManifestations`는 `ListTile`을 쓰지 않는다(테스트 단언). 카드 누적·빈 상태 유지.

### Project Structure Notes
- 본 스토리는 architecture.md 디렉토리 구조와 정합한다(`shared/preset_controls`(FR15) 신설, `museum_state`에 FR12-15 발현 파이프라인 추가).
- 정상 빌드 순서는 1.4(영속)→1.5(슬라이더 랩)→1.6(3종 비교)→1.7(발현/프리셋)이나, 현재 1.4/1.5는 backlog다. 따라서 본 스토리는 **1.6의 제네릭 3종 비교 프레임 위에서** 발현/프리셋을 구현하고, 디스크 영속(1.4)·실제 레이아웃 콘텐츠(1.5)는 후속에 위임한다 — 그 전까지 1.7은 세션 내 발현 루프로 자체 완결 동작한다.
- 1.4 구현 시: `MuseumState._tuningValues`를 `toJson`/`loadFromJson`에 포함시키고 `tuning_values.dart` 모델로 추출, shared_preferences로 영속하면 FR13이 완성되어 1.7의 발현이 재시작에도 유지된다. (본 스토리는 그 훅 지점을 깨끗이 남긴다.)

### References
- [Source: epics.md#Story 1.7: Stage 1 튜닝값 발현 & 프리셋/리셋]
- [Source: epics.md#FR12] — Custom 탭 튜닝값이 로비 발현물에 영구 반영(Epic 1, Story 1.7)
- [Source: epics.md#FR14] — 발현 후 재입장 튜닝 재조정 & 로비 재반영(Story 1.7)
- [Source: epics.md#FR15] — iOS/Material/Custom 프리셋 적용·리셋(Story 1.7)
- [Source: epics.md#FR13] — 영속(Story 1.4, 본 스토리 스코프 밖)
- [Source: architecture.md#AR3] — 발현 파이프라인 = Custom 탭 조작값 → (영속) → 로비 반영, UI는 상태 경유
- [Source: architecture.md#Structure Patterns / #Communication Patterns / #Enforcement Guidelines] — 발현 시점 전역 커밋, 단방향 파이프라인, notify 1회, 동사형 액션, shared 경계
- [Source: architecture.md#Complete Project Directory Structure] — shared/preset_controls.dart(FR15), museum_state(FR12-15)
- [Source: 1-1·1-2·1-3·1-6 Review Findings] — 오버플로 가드·문자열 상수화·Navigator 사전 캡처·로비 ListTile 회귀 가드·신규 의존성 없음
- NFR4(즉각 반영), NFR6(boring tech)

## Dev Agent Record

### Agent Model Used

claude-opus-4-8 (BMad dev-story workflow)

### Debug Log References

- `flutter --version` → Flutter 3.41.9 stable. 신규 의존성 추가 없음(순수 material+cupertino + 기존 provider).
- `flutter analyze` → No issues found (0 issue).
- `flutter test` 1차 → 1건 실패: 기존 1.6 테스트 `3종 패널이 동시 렌더된다`가 `find.text('Material')`/`find.text('Custom')`에서 findsOneWidget 위반. 원인: 신설 `PresetControls`의 프리셋 버튼 라벨(iOS/Material/Custom)이 패널 헤더 라벨(Material/Cupertino/Custom)과 텍스트가 겹침(의도된 신규 UI). 수정: 해당 단언을 `find.descendant(of: ComparisonPanel, ...)`로 범위 한정(패널 헤더만 검사). 재실행 → All tests passed (64/64).

### Completion Notes List

- **FR12 (Custom 튜닝값 로비 발현):** `MuseumState.manifestTuning(stage, value)` 신설 — 발현 시점에만 전역 커밋(단방향 파이프라인 AR3), notify 1회. `ComparisonView`의 "발현하기"가 `onManifest` 콜백으로 호출하고, `StageLabScreen`이 `manifestTuning`에 배선. 로비 `LobbyManifestations` 카드에 값 비례 지표(`_TuningIndicator`, `Key('manifest_tuning_<stage>')` + 퍼센트)로 반영.
- **FR14 (재입장 재조정·재반영):** `manifestTuning`은 이미 클리어된 스테이지여도 값이 다르면 갱신+통지(동일 값이면 no-op). 재입장 시 `StageLabScreen`이 `museum.tuningValue(stage)`를 `ComparisonView.initialValue`로 주입해 직전 발현값 복원. 재발현 시 로비 지표 너비/퍼센트가 재반영됨을 테스트로 검증.
- **FR15 (프리셋/리셋):** `shared/preset_controls.dart` 신설 — `TuningPreset {ios, material, custom}`(값 0.9/0.55/0.25, 서로 구분) + 리셋(기본값 0.2). state/stage 비의존(콜백 위임). 적용 즉시 3패널 박스 크기 변화로 값 차이 시각화(NFR4 로컬 setState).
- **아키텍처 경계 준수:** `comparison_view`/`preset_controls`는 `MuseumState`/`stages/*`를 import하지 않음(shared 경계). 전역 커밋은 호출처(`stage_lab_screen`)가 콜백으로 주입. 발현 직후 Navigator 사전 캡처 + `_manifesting` 1회 가드(1.3 학습) 재사용.
- **스코프 경계 준수:** shared_preferences 디스크 영속(1.4) 미구현 — 튜닝값은 in-memory `MuseumState`까지만, `toJson`/`loadFromJson` 미변경(1.4가 확장할 훅 지점 보존). Stage1 실제 슬라이더 레이아웃 콘텐츠(1.5)·`core/theme/*`·`tuning_values.dart` 미생성.
- **회귀:** 기존 `manifest()` 동작·시그니처 불변(중복 manifest no-op 테스트 유지). 기존 1.6 패널 라벨 단언만 범위 한정으로 갱신(겹치는 프리셋 라벨 때문, 동작 동일). 전체 **64/64 통과**(baseline 48 + 신규 16), `flutter analyze` 0 issue. 신규 의존성 없음.
- **속도 우선 판정:** 무거운 3-layer 코드리뷰는 생략(사용자 지시). self-check로 AC1~AC4 충족·스코프 위반 0·아키텍처 경계 준수 확인 후 done 처리.

### File List

- `lib/core/state/museum_state.dart` (UPDATE) — `_tuningValues` 맵 + `tuningValue` 게터 + `manifestTuning` 액션. (FR12, FR14)
- `lib/shared/preset_controls.dart` (NEW) — `TuningPreset` enum + `PresetControls`(iOS/Material/Custom 프리셋 + 리셋, state 비의존). (FR15)
- `lib/shared/comparison_view.dart` (UPDATE) — 선택적 `onManifest` + `PresetControls` + 발현 버튼(`_touched`/`_manifesting` 가드, 하단 오버플로 가드 유지). (FR12, FR14, FR15)
- `lib/shared/stage_lab_screen.dart` (UPDATE) — 3종 비교 진입에 `initialValue`(tuningValue 복원) + `onManifest`(manifestTuning) 배선. (FR12, FR14)
- `lib/lobby/manifestations/lobby_manifestations.dart` (UPDATE) — 발현물 카드에 `_TuningIndicator`(값 비례 바 + 퍼센트, `Key('manifest_tuning_<stage>')`). (FR12, FR14)
- `test/state/museum_state_test.dart` (UPDATE) — `manifestTuning` 커밋/재발현/no-op/clamp + `tuningValue` 테스트 추가(기존 5개 유지).
- `test/shared/preset_controls_test.dart` (NEW) — 프리셋 서로 다른 값/리셋/오버플로 가드.
- `test/shared/comparison_view_test.dart` (UPDATE) — 프리셋 즉시 반영/발현 콜백+pop/콜백 미제공 미노출 + 기존 단언 범위 한정.
- `test/shared/stage_lab_screen_test.dart` (UPDATE) — 3종 비교 발현 커밋+pop / 재입장 initialValue 복원.
- `test/lobby/manifestations/lobby_manifestations_test.dart` (UPDATE) — 튜닝 지표 표시/재반영/제네릭 발현 미지표.

### Change Log

- 2026-06-14: Story 1.7 구현 — Custom 튜닝값 발현 파이프라인(FR12) + 재입장 재조정·재반영(FR14) + iOS/Material/Custom 프리셋·리셋(FR15). `MuseumState.manifestTuning`/`tuningValue` 추가(in-memory SSOT, 디스크 영속은 1.4), `PresetControls` 신설, `ComparisonView`에 발현/프리셋 통합(state 비의존 콜백), `LobbyManifestations`에 튜닝값 지표 반영. analyze 0 issue, test 64/64 통과. 디스크 영속(1.4)·실제 레이아웃 콘텐츠(1.5)는 스코프 밖. Status → review.
