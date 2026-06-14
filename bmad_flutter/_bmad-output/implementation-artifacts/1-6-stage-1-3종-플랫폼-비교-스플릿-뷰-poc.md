---
baseline_commit: NO_VCS
---

# Story 1.6: Stage 1 3종 플랫폼 비교 (스플릿 뷰 PoC)

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a 학습자,
I want 같은 레이아웃을 Material/Cupertino/Custom으로 동시에 나란히 보고,
so that 플랫폼 디자인 철학의 차이를 한눈에 비교하며 이해한다.

## Acceptance Criteria

**AC1 (FR9)** — 3종 동시 렌더링 스플릿 뷰
- **Given** Stage 1 실험실에서
- **When** 3종 비교 뷰를 연다
- **Then** Material/Cupertino/Custom 패널이 한 화면에 **동시 렌더링**되어 나란히(가로 3분할) 비교된다
- **And** 각 패널에 어떤 플랫폼인지 라벨이 표시된다

**AC2 (FR11)** — 조작값 실시간 동시 반영
- **Given** 3종 비교 뷰가 열린 상태에서
- **When** 공통 슬라이더(튜닝값 소스)를 조작한다
- **Then** 3개 패널의 렌더링이 **동시에 실시간** 반영된다(지연 없는 setState, NFR4)
- **And** 튜닝값(소스 오브 트루스)은 부모(`ComparisonView`)가 단일 보유하고 3패널에 동일 값으로 주입된다(상태 중복 금지)

**AC3 (FR10)** — 동일 위젯의 플랫폼별 차이 체험
- **Given** 3종 비교 뷰에서
- **Then** 동일 역할 위젯의 플랫폼별 차이를 직접 체험할 수 있다:
  - 스크롤 물리: Material = clamping(끝에서 멈춤) vs Cupertino/Custom = bouncing(끝에서 튕김)
  - 토글/버튼 촉감: Material(`Switch`/ripple) vs Cupertino(`CupertinoSwitch`/opacity)
- **And** 세 패널은 동일한 튜닝값을 받아 동일 레이아웃을 그리되 플랫폼 스타일만 다르다

**AC4 (AR1) 🔴 — MaterialApp + Cupertino 위젯 한 화면 공존 검증 (프로젝트 생사 결정)**
- **Given** 단일 루트 `MaterialApp` 아래에서
- **When** Cupertino 패널이 `CupertinoTheme` + Cupertino 위젯(`CupertinoSwitch` 등)을 렌더한다
- **Then** 별도의 중첩 `CupertinoApp` 없이도 Material 위젯과 Cupertino 위젯이 **동일 위젯 트리에서 예외 없이 공존**한다(`takeException()` null)
- **And** 이 위젯 트리 구조(패널별 테마 격리 = 1단계 위임)가 검증되어 Epic 2/3가 재사용할 수 있다
- **And** 만약 `CupertinoTheme`-only 격리로 특정 Cupertino 위젯이 깨지면 **대안 구조(해당 패널 서브트리를 중첩 `CupertinoApp(home:)`로 감쌈)를 적용하고 그 결과를 Dev Agent Record에 기록**한다 (방향 재조정 — Gap R1)

## Tasks / Subtasks

- [x] **Task 1: `ComparisonPlatform` enum + 패널 추상화 — `comparison_panel.dart`** (AC: #1, #3, #4)
  - [x] `lib/shared/comparison_panel.dart` 생성 — `enum ComparisonPlatform { material, cupertino, custom }` + 한국어 라벨 extension(`'Material'`/`'Cupertino'`/`'Custom'`). **이름 주의:** `dart:io`의 `Platform`과 충돌하므로 아키텍처 문서의 `Platform`을 `ComparisonPlatform`으로 구체화(직렬화/외부 노출 없음, UI 식별용). [Source: architecture.md#Structure Patterns — ComparisonPanel({required Platform platform})]
  - [x] `class ComparisonPanel extends StatelessWidget` — 생성자: `required ComparisonPlatform platform`, `required double value`(공통 튜닝값 0.0~1.0, FR11). **이 PoC는 패널이 대표 레이아웃을 직접 그린다**(임의 child 주입 일반화는 Epic 2 component/animation 랩이 실제 소비할 때 도입 — 스코프 경계). [Source: architecture.md#3종 패널 추상화]
  - [x] **플랫폼 테마 격리(1단계 위임, AR1 PoC 핵심):** 패널은 자신의 조상 테마만 책임진다 — material → `Theme`(기본/약간 변형 `ThemeData`), cupertino → `CupertinoTheme`(`CupertinoThemeData`), custom → 식별 가능한 커스텀 `ThemeData`(예: 다른 seedColor). 루트 `MaterialApp`에서 상속되는 `Directionality`/`MediaQuery`/`Material` 위에 테마만 덧씌운다. **중첩 `CupertinoApp`/`MaterialApp` 금지(폴백 전용)**. [Source: architecture.md#Frontend Architecture — 단일 루트 MaterialApp 아래 패널별 Theme/CupertinoTheme + 필요한 조상 위젯 격리; 다중 App 중첩은 폴백]
  - [x] **패널 콘텐츠(동일 레이아웃, 플랫폼 스타일만 차이 — AC3):** 세로 Column으로 (1) 플랫폼 라벨 헤더(테마 텍스트 스타일), (2) `value`에 비례해 크기 변하는 박스(FR11 실시간 반영 — `Key('comparison_box_<platform.name>')`로 테스트 측정), (3) 스크롤 물리 차이 시연용 `ListView`(material=`ClampingScrollPhysics`, cupertino/custom=`BouncingScrollPhysics` — **명시적 physics 지정**으로 호스트 OS 무관 결정성 보장, FR10), (4) 토글 위젯(material=`Switch`, cupertino=`CupertinoSwitch`, custom=`Switch` 커스텀 테마 — ripple vs opacity 촉감 차이 + AR1 Cupertino 공존 증명). 토글은 로컬 데모(상태 없이 고정 `value: true` + `onChanged` no-op 또는 패널 로컬 표시용)로 두되, **전역 상태 커밋 금지**(발현은 Story 1.7 스코프).
  - [x] **오버플로 가드(1.1~1.3 학습):** 패널 내부 세로 오버플로 방지 — 박스/리스트는 `Expanded`/`Flexible` 또는 스크롤로 안전 처리. 가로 3분할에서 각 패널 폭이 좁아도 깨지지 않게 텍스트 `overflow: TextOverflow.ellipsis`. [Source: 1-1/1-2/1-3 Review — 오버플로 회귀 가드]

- [x] **Task 2: 3종 스플릿 뷰 컨테이너 — `comparison_view.dart`** (AC: #1, #2)
  - [x] `lib/shared/comparison_view.dart` 생성 — `class ComparisonView extends StatefulWidget`. 생성자: `required StageId stageId`(타이틀/맥락용), (선택) `double initialValue = 0.2`. **튜닝값 소스 오브 트루스를 단일 보유**(`double _value`)하고 3패널에 동일 값 주입(FR11, 상태 중복 금지). [Source: architecture.md#3종 패널 추상화 — 튜닝값은 부모가 보유, 3패널에 동일 값 주입]
  - [x] 레이아웃: `Scaffold(appBar: AppBar(title: Text('${stageId.label} · 3종 비교')))`, body = Column[ 상단 `Expanded(child: Row[ Expanded(ComparisonPanel.material), Expanded(ComparisonPanel.cupertino), Expanded(ComparisonPanel.custom) ])`, 하단 조작부 `Slider(value: _value, onChanged: setState로 _value 갱신)` + 안내 텍스트 ]. 슬라이더 조작 시 `setState` 1회로 3패널 동시 리빌드(NFR4 즉각 반영 — AC2).
  - [x] **가로 3분할 협소 화면 가드:** 매우 좁은 폭에서 3패널이 깨지지 않도록 `Row`를 가로 스크롤(`SingleChildScrollView(scrollDirection: Axis.horizontal)` + 각 패널 최소폭) 또는 `Expanded` 균등 분할 중 택1. 320×320·textScale 3.0 테스트로 검증.
  - [x] 표시 문자열(타이틀 접미사, 슬라이더 라벨, 안내)은 `static const`로 단일 출처화(테스트 공유). [Source: 1-1 Review — 문자열 상수화]

- [x] **Task 3: Stage 1(레이아웃) 실험실에서 3종 비교 뷰 진입점 추가** (AC: #1)
  - [x] `lib/shared/stage_lab_screen.dart` 수정 — `controls` 하단에 **레이아웃 스테이지 한정** "3종 비교 뷰 열기(PoC)" 버튼 추가. `widget.stageId == StageId.layout`일 때만 노출(다른 스테이지는 3종 비교 미적용 — Stage 4/5 등). 탭 시 `Navigator.of(context).push(MaterialPageRoute(builder: (_) => ComparisonView(stageId: widget.stageId)))`.
  - [x] **회귀 주의:** 기존 동작(슬라이더 조작→미리보기 갱신, 발현 게이팅/커밋, 오버플로 가드)은 변경하지 않는다. 버튼 추가만. 버튼 라벨은 `static const String openComparisonLabel`로.
  - [x] **스코프 경계:** Story 1.5(슬라이더 레이아웃 콘텐츠)·1.7(발현/프리셋)이 아직 없으므로, 이 PoC는 `StageLabScreen`(제네릭 데모 호스트)에서 진입한다. 1.5/1.7 구현 시 실제 `layout_lab.dart`로 진입점이 이동/통합될 수 있다(Dev Notes 기록).

- [x] **Task 4: 신규 테스트 — Red → Green** (AC: #1, #2, #3, #4)
  - [x] `test/shared/comparison_panel_test.dart`:
    - 각 `ComparisonPlatform`(material/cupertino/custom) 패널이 `MaterialApp(home: Scaffold(body: ...))` 하니스에서 예외 없이 렌더된다(AR1 공존 — `tester.takeException()` null).
    - 스크롤 물리 차이(AC3): material 패널의 스크롤뷰는 `ClampingScrollPhysics`, cupertino/custom 패널은 `BouncingScrollPhysics`(`ScrollView.physics.runtimeType` 또는 `getScrollPhysics` 검사).
    - 토글 위젯 차이(AC3/AR1): cupertino 패널에 `CupertinoSwitch`가, material 패널에 `Switch`가 존재(Cupertino 위젯이 `CupertinoApp` 없이 렌더됨 = AR1 공존 증명).
    - 값 반영(FR11): `value` 0.2 vs 0.8 패널의 박스(`Key('comparison_box_material')` 등) 크기가 다르다.
  - [x] `test/shared/comparison_view_test.dart`:
    - 3개 패널(`find.byType(ComparisonPanel)` == 3, 또는 3개 플랫폼 라벨 모두 표시) 동시 렌더(AC1).
    - 실시간 동시 반영(AC2/FR11): 슬라이더를 드래그(또는 `state`에서 `_value` 변경 유도)하면 3패널 박스 크기가 **모두** 갱신된다 — `pump` 후 3개 박스 크기 변화 단언.
    - 단일 소스(상태 중복 금지): `ComparisonView`만 `value` 상태를 가지며 패널은 `StatelessWidget`(패널 자체 튜닝 상태 없음) — 패널이 `StatelessWidget`임을 타입으로 보장.
  - [x] **오버플로 회귀 가드:** `comparison_panel_test`·`comparison_view_test`에 1.1~1.3 패턴 재사용 — `tester.view.physicalSize = Size(320, 320)`, `tester.view.devicePixelRatio = 1.0`, `textScaleFactor 3.0`(또는 `MediaQuery` textScaler), teardown에서 `resetPhysicalSize`/`resetDevicePixelRatio`, `tester.takeException()` null 단언.
  - [x] `test/shared/stage_lab_screen_test.dart` (UPDATE): layout 스테이지에서 "3종 비교 뷰 열기" 버튼이 보이고 탭 시 `ComparisonView`로 진입(`find.byType(ComparisonView)`); **비-layout 스테이지(예: component)에서는 버튼 미노출**. 기존 테스트(미리보기 갱신·발현 게이팅·발현 커밋)는 유지·통과.
  - [x] `flutter analyze` 0 issue + `flutter test` 전체 통과.

- [x] **Task 5: AR1 PoC 결과 기록** (AC: #4)
  - [x] 구현·테스트 후 Dev Agent Record의 Completion Notes에 **PoC 판정**을 명시 기록: 단일 루트 `MaterialApp` + 패널별 `CupertinoTheme` 격리로 Material/Cupertino 위젯 공존 및 스크롤 물리 차이가 **성공**했는지, 폴백(중첩 `CupertinoApp`)이 필요했는지. 성공이면 "PoC PASS — 패널별 테마 격리 구조 확정, Epic 2/3 재사용 가능". 실패면 적용한 대안 구조와 근거를 기록(방향 재조정). [Source: architecture.md#Gap Analysis — R1 스플릿 뷰 PoC 미실증; AR1]

## Dev Notes

### 핵심 컨텍스트
이 스토리는 **🔴 프로젝트 생사 결정 마일스톤(AR1)** — "MaterialApp + Cupertino 위젯을 한 화면에 공존시키는 스플릿 뷰"가 실제로 동작하는지 검증하는 PoC다. 아키텍처는 이미 **단일 루트 `MaterialApp` 아래 패널별 `Theme`/`CupertinoTheme` 격리(1단계 위임: `comparison_view` → `comparison_panel`)** 를 1차 설계로, **다중 App 중첩을 폴백**으로 정해 두었다. 이 스토리는 그 1차 설계를 코드로 실증하고, 3종 동시 렌더링(FR9) + 조작값 실시간 동시 반영(FR11) + 플랫폼별 차이 체험(FR10, 스크롤 물리·토글 촉감)을 충족한다.

산출물: (1) `comparison_panel.dart` — `ComparisonPlatform` enum + 단일 패널(플랫폼 테마 격리 + 값 반영 + 물리/토글 차이), (2) `comparison_view.dart` — 튜닝값 단일 보유 + 3패널 동시 주입 컨테이너, (3) `stage_lab_screen.dart`에 레이아웃 스테이지 한정 진입점. 이후 Epic 2(component/animation)·1.7(발현/프리셋)이 이 3종 비교 프레임을 재사용한다.

### 🚨 스코프 경계 (절대 넘지 말 것)
이 스토리는 **3종 비교 스플릿 뷰 + 실시간 반영 + 플랫폼 차이 체험 + AR1 PoC만** 한다. 다음은 후속 스토리 범위이므로 **여기서 구현 금지**:
- ❌ Custom 탭 튜닝값의 **로비 발현**(`manifest`) / 발현물 반영 → **Story 1.7**. 이 스토리의 토글/슬라이더는 비교 체험용 로컬 상태이며 `MuseumState`에 커밋하지 않는다.
- ❌ iOS/Material/Custom **프리셋·리셋**(`preset_controls.dart`) → **Story 1.7**.
- ❌ **shared_preferences 영속**(`MuseumRepository`/`prefs_keys.dart`) → **Story 1.4**. 튜닝값은 in-memory `ComparisonView` 로컬 상태(슬라이더)까지만. 재시작 시 초기화 — **의도된 것**.
- ❌ Stage 1 **슬라이더 레이아웃 학습 콘텐츠**(Container/Row/Column/Stack 실제 조작) → **Story 1.5** (`lib/stages/layout/`). 이 PoC의 패널 콘텐츠는 비교 구조를 증명하는 **대표 레이아웃**(헤더+값박스+스크롤리스트+토글)이지, 1.5의 전체 레이아웃 랩이 아니다.
- ❌ 임의 `child` 주입형 패널 일반화 → Epic 2 component/animation 랩이 실제 소비할 때. 지금은 `value` 기반 대표 콘텐츠.

### 🚨 회귀 주의 — 기존 코드와의 상호작용
[읽고 시작할 파일: `lib/shared/stage_lab_screen.dart`, `lib/shared/lab_scaffold.dart`, `lib/core/models/stage_id.dart`, `lib/core/state/museum_state.dart`, `test/shared/stage_lab_screen_test.dart`]

- **`stage_lab_screen.dart` 현재 상태:** `LabScaffold` 호스트 제네릭 데모. `controls`는 안내 텍스트 + 슬라이더(`_value`/`_touched`/`setState`), 발현은 `onManifest`에서 Navigator 사전 캡처 + `_manifesting` 가드 + `MuseumState.manifest` + pop. → **이 스토리는 `controls`에 layout 한정 "3종 비교 열기" 버튼만 추가**. 기존 슬라이더/발현 로직 변경 금지.
- **`StageId` 현재 상태:** `enum { layout..storage }` + `.label` extension. layout 라벨 = '레이아웃'. 변경 없음(읽기만).
- **`MuseumState` 현재 상태:** `manifest`/`isUnlocked`/`isCleared`/`toJson`/`loadFromJson`. **이 스토리에서 변경/호출 안 함**(비교는 발현과 무관, Story 1.7에서 연결).
- **`stage_lab_screen_test.dart` 현재 상태:** 미리보기 갱신·발현 게이팅·발현 커밋 검증. → 버튼 노출/진입 테스트만 **추가**, 기존 단언 유지.

> **원칙:** 이 스토리 완료 후 앱은 end-to-end로 동작해야 한다(로비→레이아웃 실험실 진입→슬라이더 미리보기 갱신→발현→로비 반영, 그리고 **레이아웃 실험실에서 3종 비교 뷰 진입→슬라이더로 3패널 동시 반영→플랫폼 차이 관찰→뒤로**). 기존 동작(순차 잠금, 발현, 오버플로 안전성)도 깨지지 않아야 한다.

### 🔴 AR1 PoC 구현 지침 (위젯 트리 구조 — 가장 중요)
[Source: architecture.md#Frontend Architecture, #3종 패널 추상화, #Architectural Boundaries, #Gap Analysis R1]
- **1차 구조(이걸 먼저 시도):** 루트는 앱의 단일 `MaterialApp`(이미 `app.dart`). `ComparisonView`는 그 아래 일반 `Scaffold`. 각 `ComparisonPanel`은 자신의 테마 조상만 덧씌운다:
  - material 패널: `Theme(data: ThemeData(...), child: ...)` — Material 위젯(`Switch`, `ListView` clamping).
  - cupertino 패널: `CupertinoTheme(data: CupertinoThemeData(...), child: ...)` — `CupertinoSwitch`, `ListView` bouncing. **`CupertinoApp` 중첩 금지(1차)** — 루트 MaterialApp에서 `Directionality`/`MediaQuery`/`Material`/`Localizations`가 상속되므로 Cupertino 위젯 다수가 `CupertinoTheme`만으로 렌더된다.
  - custom 패널: 식별 가능한 `ThemeData`(다른 seedColor 등) — Custom 디자인 철학 자리(1.7에서 튜닝 소스가 됨).
- **검증 포인트:** Cupertino 위젯이 `CupertinoApp` 없이 예외 없이 렌더되는지(`takeException` null), 스크롤 물리가 패널별로 다른지(clamping vs bouncing), 동일 `value`가 3패널에 동시 반영되는지.
- **폴백(1차 실패 시에만):** 깨지는 Cupertino 위젯이 있으면 해당 패널 서브트리를 `CupertinoApp(home: ...)`(또는 필요한 조상만 추가)로 감싸고, **그 사실과 어떤 위젯이 왜 필요로 했는지를 Completion Notes에 기록**(방향 재조정). 전 패널을 중첩 App으로 감싸는 것은 최후 수단.
- **스크롤 물리 결정성:** 호스트 OS에 따라 기본 physics가 달라 테스트가 흔들리지 않도록, 각 패널 스크롤뷰에 `physics`를 **명시 지정**한다(material=`ClampingScrollPhysics()`, cupertino/custom=`BouncingScrollPhysics()`).

### 아키텍처 준수 — 상태/경계 규칙 (반드시 따를 것)
[Source: architecture.md#Structure Patterns, #Communication Patterns, #Architectural Boundaries, #Enforcement Guidelines]
- **튜닝값 SSOT는 부모:** `ComparisonView`가 `_value`를 단일 보유, 3패널은 `StatelessWidget`으로 동일 값 주입받음(FR11, 상태 중복·우회 금지). 즉각 반영은 `ComparisonView`의 로컬 `setState`(지연 0, NFR4) — 전역 `MuseumState` 커밋 없음(발현은 1.7).
- **컴포넌트 경계:** `lib/shared/`(comparison_view/panel)는 스테이지·`MuseumState` 비의존 재사용 프레임 — 특정 stage/state를 import 하지 않는다. `comparison_view` → `comparison_panel` **1단 위임**(패널이 플랫폼 테마 조상 책임). `stage_lab_screen`은 `shared/`를 소비하는 쪽.
- **내비게이션 = Navigator 1.0**(`MaterialPageRoute`). 비교 뷰 진입은 push/pop.
- **shared가 stages를 import 금지** — `ComparisonView`는 `StageId`(core/models)만 참조(라벨/맥락용), `lib/stages/*` 의존 없음.

### 네이밍 / 직렬화 규칙 (반드시 준수)
[Source: architecture.md#Naming Patterns, #Format Patterns]
- 파일명 `snake_case.dart`(`comparison_view.dart`, `comparison_panel.dart`). 위젯/enum `PascalCase`(`ComparisonView`, `ComparisonPanel`, `ComparisonPlatform`). 메서드/변수 `lowerCamelCase`, 상수 `lowerCamelCase`, private `_prefix`, 불리언 `is/has/can` 접두.
- `ComparisonPlatform`은 UI 식별용(직렬화 없음). `dart:io` `Platform`과 혼동 금지 — 항상 `ComparisonPlatform` 사용.
- 표시 문자열은 `static const`로 단일 출처화. `flutter analyze` + `flutter_lints` 통과가 완료 기준.

### 파일 구조 — 이 스토리가 만지는 파일
[Source: architecture.md#Complete Project Directory Structure — shared/comparison_view(FR9) 🔴 PoC, shared/comparison_panel(FR10,11)]
- `lib/shared/comparison_panel.dart` (NEW) — `ComparisonPlatform` enum + 단일 패널(플랫폼 테마 격리 + 값 박스 + 스크롤 물리 + 토글). (FR10, FR11, AR1)
- `lib/shared/comparison_view.dart` (NEW) — 3종 스플릿 뷰 컨테이너(튜닝값 단일 보유 + 슬라이더 + 3패널 동시 주입). (FR9, FR11)
- `lib/shared/stage_lab_screen.dart` (UPDATE) — layout 한정 "3종 비교 열기" 진입 버튼 추가(기존 로직 불변).
- `test/shared/comparison_panel_test.dart` (NEW)
- `test/shared/comparison_view_test.dart` (NEW)
- `test/shared/stage_lab_screen_test.dart` (UPDATE — 버튼 노출/진입 테스트 추가, 기존 유지)

> **빈 디렉토리/후속 파일 미리 만들지 말 것:** `core/theme/*`(material/cupertino/custom_theme.dart), `shared/preset_controls.dart`, `stages/layout/*`는 후속 스토리(1.5/1.7). 이 스토리는 `comparison_view`/`comparison_panel` 내부에 최소 테마를 인라인으로 둔다(1.7에서 `core/theme/*`로 추출 가능). [Source: 1-3 Project Structure Notes — 후속 폴더 선생성 금지]

### 테스트 표준
[Source: architecture.md#File Organization Patterns, #Testing Framework; 1-1~1-3 Testing Standards]
- `flutter_test`(SDK 내장), `test/`가 `lib/` 미러링(`test/shared/`).
- **순수 위젯 테스트:** `ComparisonPanel`/`ComparisonView`는 `MuseumState` 비의존 → Provider 없이 `MaterialApp(home: ...)` 하니스로 테스트.
- 스크롤 물리 검사: `find.byType(ListView)` 등으로 `ScrollView` 위젯의 `physics.runtimeType`(`ClampingScrollPhysics`/`BouncingScrollPhysics`) 단언. 패널별로 키(`Key('comparison_box_<platform>')`, `Key('comparison_list_<platform>')`)로 식별.
- **AR1 공존 검사:** Cupertino 위젯(`CupertinoSwitch`)이 `CupertinoApp` 없이 `MaterialApp` 하니스에서 렌더 + `takeException()` null.
- **실시간 반영 검사:** `ComparisonView` 슬라이더 조작(또는 `tester.drag`) 후 `pump` → 3패널 박스 크기 동시 변화.
- **오버플로 회귀 가드:** 320×320·textScale 3.0, teardown reset, `takeException()` null.
- TDD: Red → Green → 정리.

### 1.1~1.3에서 이어받는 학습 (Previous Story Intelligence)
[Source: 1-1·1-2·1-3 Review Findings & Dev Notes]
- **환경:** 로컬 Flutter **3.41.9 stable**(설계 기준 3.44.0보다 낮음). `CupertinoSwitch`/`CupertinoButton`/`CupertinoTheme`/`BouncingScrollPhysics`/`ClampingScrollPhysics`/implicit 애니메이션은 3.41에서 안정 지원 → 본 스토리 영향 없음. **신규 의존성 추가 없음**(순수 Flutter material + cupertino). `provider`는 이미 추가됨(이 스토리는 Provider 미사용).
- **VCS 없음:** git 저장소 아님(`baseline_commit: NO_VCS`). 커밋 검증 불가 → 테스트/analyze로 검증.
- **오버플로 회귀 가드:** 1.1~1.3 리뷰에서 큰 textScale·작은 화면 오버플로 반복 지적. 가로 3분할(`ComparisonView`)·패널 내부 세로(`ComparisonPanel`) 모두 취약 지점 → 320×320·textScale 3.0 테스트 필수. `Expanded`/`Flexible`/스크롤/`ellipsis`로 안전 처리.
- **문자열 상수화:** 인라인 리터럴은 테스트와 중복돼 깨지기 쉽다는 지적 → `static const`(또는 `StageId.label`)로 단일 출처화.
- **테스트 하니스:** 합성 위젯은 실제 사용처와 동일 컨테이너로 감싸 테스트. `ComparisonView`/`ComparisonPanel`은 자체가 Scaffold/위젯이므로 `MaterialApp(home: ...)`로 감싼다.
- **이중 pop/동기 재빌드 방어(1.3 리뷰):** Navigator 호출 시 사전 캡처 패턴 학습 — 이 스토리는 단순 push/pop이라 해당 없음(발현 없음). 단, 진입 버튼 연타 방어는 push 1회면 충분(중복 push는 무해하나 필요 시 가드).

### Project Structure Notes
- 본 스토리는 architecture.md 디렉토리 구조와 정합한다(`shared/comparison_view`·`comparison_panel`을 새로 채움). `core/theme/*`·`shared/preset_controls`·`stages/layout/*`는 후속(1.5/1.7).
- `ComparisonView`/`ComparisonPanel`은 Epic 2(component/animation)·1.7(발현/프리셋)이 재사용하는 핵심 3종 비교 프레임 — API를 단순(`platform`+`value`)·stage/state 비의존으로 유지.
- **Story 1.5/1.7 미완 영향:** 정상 빌드 순서는 1.5(슬라이더 랩)→1.6(3종 비교)→1.7(발현/프리셋)이나, 본 작업은 1.6만 수행한다. 따라서 진입점을 제네릭 `StageLabScreen`(layout 한정 버튼)에 둔다. 1.5/1.7 구현 시 `layout_lab.dart`로 진입점이 통합되고 Custom 패널이 발현 소스로 연결될 수 있다 — 그 전까지 1.6은 자체 완결형 PoC로 동작.

### References
- [Source: epics.md#Story 1.6: Stage 1 3종 플랫폼 비교 (스플릿 뷰 PoC)]
- [Source: epics.md#FR9] — 레이아웃 스테이지에서 Material/Cupertino/Custom 3종 동시 렌더링(스플릿 뷰)
- [Source: epics.md#FR10] — 동일 위젯의 플랫폼별 차이 직접 체험(스크롤 물리 등)
- [Source: epics.md#FR11] — 조작값이 3종 렌더링에 실시간 동시 반영
- [Source: epics.md#AR1] 🔴 — MaterialApp + CupertinoApp 한 화면 공존 PoC 필수, Epic 1에서 최우선 검증, 실패 시 방향 재조정
- [Source: architecture.md#Frontend Architecture — 3종 렌더링] — 단일 루트 MaterialApp 아래 패널별 Theme/CupertinoTheme 격리, 다중 App 중첩은 폴백, Story 1.6 PoC로 스크롤 물리·기본 스타일 재현 검증
- [Source: architecture.md#Structure Patterns — 3종 패널 추상화] — ComparisonPanel({platform, child}), 튜닝값 부모 보유 3패널 동일 주입
- [Source: architecture.md#Architectural Boundaries — 컴포넌트 경계] — shared는 stage 비의존, comparison_view→comparison_panel 1단 위임, 패널이 플랫폼 테마 조상 책임(R1 PoC 지점)
- [Source: architecture.md#Gap Analysis — R1] — 스플릿 뷰 PoC 미실증, Story 1.6 최우선 검증, 실패 시 폴백(중첩 App) 적용 후 결과 기록
- [Source: architecture.md#Complete Project Directory Structure] — shared/comparison_view.dart(FR9 🔴 PoC), shared/comparison_panel.dart(FR10,11)
- [Source: 1-1·1-2·1-3 Review Findings] — 오버플로 가드·문자열 상수화·테스트 하니스·신규 의존성 없음
- NFR4(즉각 반영), NFR6(boring tech)

## Dev Agent Record

### Agent Model Used

claude-opus-4-8 (BMad dev-story workflow)

### Debug Log References

- `flutter --version` → Flutter 3.41.9 stable(설계 기준 3.44.0보다 낮음, 본 스토리 영향 없음). 신규 의존성 추가 없음(순수 Flutter material + cupertino).
- `flutter analyze` → No issues found.
- `flutter test` 1차 → 1건 실패: `comparison_view_test`가 320×320·textScale 3.0에서 하단 슬라이더 조작부가 세로로 커져 RenderFlex overflow(bottom 48px). 상단 3분할 패널과 하단 조작부가 한 Column에 Expanded+고정으로 배치돼, 큰 textScale에서 하단 intrinsic 높이가 가용 높이를 초과.
- 수정: `ComparisonView` body를 `LayoutBuilder`로 감싸 하단 조작부를 `ConstrainedBox(maxHeight: 가용높이/2) + SingleChildScrollView`로 제한 — 하단이 커져도 상단 패널 영역(Expanded)을 침범하지 않고 내부 스크롤로 처리(오버플로 가드). 재실행 → All tests passed (48/48).

### Completion Notes List

- **🔴 AR1 PoC 판정: PASS** — 단일 루트 `MaterialApp`(앱 `app.dart`) 아래에서, `ComparisonView`는 일반 `Scaffold`, 각 `ComparisonPanel`은 **자신의 테마 조상만** 책임지는 구조(material/custom=`Theme`, cupertino=`CupertinoTheme`)로 구현. **중첩 `CupertinoApp`/`MaterialApp` 없이** Material 위젯(`Switch`)과 Cupertino 위젯(`CupertinoSwitch`)이 동일 위젯 트리에서 예외 없이 공존함을 테스트로 검증(`find.byType(CupertinoApp) == 0`, `CupertinoSwitch` 렌더, `takeException()` null). 스크롤 물리도 패널별로 명시 지정해 Material=`ClampingScrollPhysics` vs Cupertino/Custom=`BouncingScrollPhysics` 차이 검증. **→ 폴백(중첩 App) 불필요. 패널별 테마 격리(comparison_view→comparison_panel 1단 위임) 구조 확정 — Epic 2/3가 재사용 가능.** (AC4)
- 3종 동시 렌더링(FR9/AC1): `ComparisonView`가 Material/Cupertino/Custom 3패널을 가로 3분할(`Row` + `Expanded`)로 동시 렌더. 각 패널에 플랫폼 라벨 헤더 표시.
- 실시간 동시 반영(FR11/AC2): 튜닝값(`_value`)을 `ComparisonView`가 **단일 보유**하고 3패널에 동일 주입. 하단 공통 슬라이더 조작 시 로컬 `setState` 1회로 3패널 박스가 **동시 동일하게** 갱신됨을 테스트로 검증(`m1==c1==u1` 그리고 모두 증가). 패널은 자체 튜닝 상태 없는 `StatelessWidget`(상태 중복/우회 금지).
- 플랫폼 차이 체험(FR10/AC3): 스크롤 물리(clamping vs bouncing) + 토글 위젯(`Switch` vs `CupertinoSwitch`) 차이를 동일 레이아웃 위에서 시각화.
- 진입점(Task 3): `StageLabScreen`에 **레이아웃 스테이지 한정** "3종 비교 뷰 열기(PoC)" 버튼 추가. 비-layout 스테이지에서는 미노출(테스트로 검증). 기존 동작(슬라이더 미리보기 갱신·발현 게이팅/커밋·오버플로 가드)은 변경 없이 유지.
- 스코프 경계 준수: Custom 탭 튜닝값의 **로비 발현/프리셋/영속은 미구현**(Story 1.7/1.4). 토글/슬라이더는 비교 체험용 로컬 상태이며 `MuseumState` 커밋 없음. Stage 1 실제 슬라이더 레이아웃 학습 콘텐츠(1.5)도 미구현 — 패널은 비교 구조 증명용 대표 레이아웃.
- 오버플로 회귀 가드(1.1~1.3 학습): `ComparisonPanel`(내부 세로 `SingleChildScrollView` + 텍스트 ellipsis), `ComparisonView`(하단 조작부 maxHeight 제한 + 스크롤) 모두 320×320·textScale 3.0 테스트 통과(`takeException()` null).
- 회귀: 기존 36개 테스트 유지 + 신규/갱신 후 전체 **48/48 통과**, `flutter analyze` 0 issue. 신규 의존성 없음.

### File List

- `lib/shared/comparison_panel.dart` (NEW) — `ComparisonPlatform` enum + 단일 패널(플랫폼 테마 격리 + 값 박스 + 스크롤 물리 차이 + 토글). (FR10, FR11, AR1)
- `lib/shared/comparison_view.dart` (NEW) — 3종 스플릿 뷰 컨테이너(튜닝값 단일 보유 + 공통 슬라이더 + 3패널 동시 주입, 하단 오버플로 가드). (FR9, FR11)
- `lib/shared/stage_lab_screen.dart` (UPDATE) — layout 한정 "3종 비교 열기" 진입 버튼 추가(import + `openComparisonLabel` 상수 + 조건부 버튼). 기존 로직 불변.
- `test/shared/comparison_panel_test.dart` (NEW) — 3종 렌더/AR1 공존/스크롤 물리/값 반영/오버플로 가드.
- `test/shared/comparison_view_test.dart` (NEW) — 3종 동시 렌더/단일 SSOT/실시간 동시 반영/오버플로 가드.
- `test/shared/stage_lab_screen_test.dart` (UPDATE) — layout 비교 버튼 노출·진입 + 비-layout 미노출 테스트 추가(기존 단언 유지).

### Change Log

- 2026-06-14: Story 1.6 구현 — 🔴 AR1 스플릿 뷰 PoC. `ComparisonView`(3종 동시 렌더 + 공통 슬라이더 단일 SSOT 실시간 반영) + `ComparisonPanel`(패널별 테마 격리 + 스크롤 물리/토글 차이). 단일 루트 MaterialApp 아래 중첩 App 없이 Material/Cupertino 위젯 공존 검증 → **PoC PASS**(폴백 불필요). `StageLabScreen`에 layout 한정 진입 버튼 추가. analyze 0 issue, test 48/48 통과. Status → review.

## Senior Developer Review (AI)

- 리뷰 일자: 2026-06-14
- 리뷰 방식: 3-레이어 적대적 리뷰(Blind Hunter / Edge Case Hunter / Acceptance Auditor) 병렬 + 트리아지
- 판정: **Approve** — AC1~AC4 전부 충족, 스코프 위반 0, 아키텍처 준수 100%, 48/48 테스트 통과

### 판정 요약

- **Acceptance Auditor**: AC1~AC4 모두 코드+테스트 증거로 PASS. 스코프 위반 0건. 🔴 AR1 PoC PASS가 Completion Notes에 정확히 기록됨.
- **Blind Hunter**: High 0건. 컴파일/널/범위 크래시 없음.
- **Edge Case Hunter**: 공개 파라미터 경계값(initialValue 범위) 1건만 실수정 가치 있음. 나머지는 도달 불가/by-design.

### Action Items

- [x] [Review][Patch] `ComparisonView.initialValue`를 0..1로 클램프 — 공개 생성자 파라미터(공유 위젯 경계)가 Slider 계약(0..1)을 위반하면 throw 가능. `_value` 초기화에 `.clamp(0.0, 1.0)` 적용 [lib/shared/comparison_view.dart:36] — **수정 완료**
- [x] [Review][Dismiss] `stageId != layout` 단언 부재 (Edge Case Hunter: High) — 유일한 진입 경로가 `StageLabScreen`의 layout 한정 게이트 버튼이며 stageId는 타이틀 라벨에만 사용(크래시 무관). 추측성 방어 코드 지양 원칙에 따라 by-design 처리.
- [x] [Review][Dismiss] `maxBottom = maxHeight/2` 극소 화면 근접-0 (Med) — `SingleChildScrollView`가 내부 스크롤로 흡수, 오버플로 가드 테스트(320×320·textScale 3.0) 통과로 무해 확인.
- [x] [Review][Dismiss] 3 `Expanded` 패널 협폭 클리핑 / Cupertino 박스 색 / 대비 / no-op 토글 (Blind Hunter Med·Low) — 텍스트 ellipsis로 완화된 시각적 사안이며 비교 체험 PoC 의도에 부합.

### Change Log (Review)

- 2026-06-14: 코드 리뷰 완료 — `initialValue` 클램프 패치 1건 적용, 도달 불가/by-design 4건 dismiss. analyze 0 issue, test 48/48 유지. Status → done.
