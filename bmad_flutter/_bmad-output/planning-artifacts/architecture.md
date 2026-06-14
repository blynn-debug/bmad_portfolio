---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
lastStep: 8
status: 'complete'
completedAt: '2026-06-13'
inputDocuments:
  - prds/prd-bmad_flutter-2026-06-13/prd.md
  - prds/prd-bmad_flutter-2026-06-13/addendum.md
  - epics.md
  - prfaq-bmad_flutter-distillate.md
  - brainstorming/brainstorming-session-2026-06-13-000000.md
workflowType: 'architecture'
project_name: 'bmad_flutter'
user_name: 'sy'
date: '2026-06-13'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**
23개 FR를 5개 기능 그룹으로 정리. (1) 박물관 셸 — 로비+순차잠금 진행
(FR1-4), (2) 실험실→발현 공통 루프 (FR5-8), (3) 3종 플랫폼 비교 — 킬링
포인트 (FR9-11), (4) 튜닝값 영속&발현 — 킬링 포인트 (FR12-15), (5) 8개
스테이지별 학습 콘텐츠 (FR16-23). 아키텍처적으로는 "조작값→상태→영속
저장→로비 발현" 단일 파이프라인이 FG2~FG4를 관통하는 중추.

**Non-Functional Requirements:**
- NFR1/NFR2: iOS 단일 surface, 실기기 직접 빌드, 모든 네이티브 기능 접근
  (App Store 미사용) → 플러그인 선정과 권한 플로우 설계 필요.
- NFR3: 로컬 영속(클라우드/계정 불필요) → 경량 로컬 저장 계층.
- NFR4: 즉각 피드백 → 리빌드 범위 최소화가 곧 학습 가치(상태관리 설계 직결).
- NFR5/NFR6: 셋업 최소화 + 3-4주 완주 복잡도 상한 → "boring technology",
  의존성 최소화가 아키텍처 제1원칙.

**Scale & Complexity:**
- Primary domain: iOS mobile (Flutter), 단일 surface
- Complexity level: 낮음~보통 (단일 사용자, 로컬 전용)
- Estimated architectural components: 로비 셸 / 실험실 공통 프레임 / 3종 테마
  렌더링 / 발현·영속 파이프라인 / 진행상태 관리 / 네이티브 어댑터(알림·보안)

### Technical Constraints & Dependencies

- 🔴 AR1: MaterialApp + CupertinoApp 한 화면 공존(스플릿 뷰) PoC 필수 —
  Stage 1이 프로젝트 생사 결정. 위젯 트리 구조가 최우선 아키텍처 결정.
- AR2: 영속성은 로컬 키-값 또는 경량 DB. 영속 인프라(Story 1.4)와 영속
  학습 콘텐츠(Stage 8)를 구분.
- AR3: 발현 파이프라인 = Custom 탭 조작값(상태) → 영속 저장 → 로비 반영.
- AR5: 무료 Apple 계정 7일 재설치 제약(배포 환경).
- 상태관리 자기참조: Stage 4가 setState/Provider/Riverpod를 학습 주제로
  다룸 → 앱 자체 상태관리 기술 선택과의 관계 정리 필요.

### Cross-Cutting Concerns Identified

1. 발현 파이프라인 (상태 → 영속 → 로비 위젯 반영) — 전 스테이지 관통
2. 3종 테마 격리 (Material / Cupertino / Custom 동시 렌더링)
3. 진행 상태 & 순차 잠금/해제 관리
4. 로컬 영속 계층 (튜닝값 + 진행 상태)
5. iOS 네이티브 어댑터 (권한·생체인증·키체인·로컬 알림)
6. 즉각 피드백을 위한 리빌드 범위 제어

## Starter Template Evaluation

### Primary Technology Domain

Flutter 모바일 (iOS 단일 surface). Flutter 안정 버전 3.44.0 (2026-05-18) 기준.

### Starter Options Considered

- **flutter create (공식 CLI):** SDK 내장, 추가 의존성 0, 표준 구조 + iOS
  빌드 설정 자동 생성. 핫 리로드/테스트 스캐폴드 포함.
- **Very Good CLI (very_good create flutter_app):** bloc 상태관리, dev/
  staging/prod 플레이버, 다중 플랫폼, i18n, 고커버리지 테스트 셋업. 확장형
  프로덕션 앱 지향 → 본 프로젝트 제약(NFR5/NFR6)과 상충하여 거부.

### Selected Starter: flutter create (공식 CLI)

**Rationale for Selection:**
- NFR5(셋업 최소화)·NFR6(초보+AI 3-4주 완주, boring technology)에 부합.
- Stage 4가 상태관리(setState/Provider/Riverpod)를 학습 주제로 다루므로,
  bloc을 강제하는 Very Good Core는 학습 서사와 충돌 → 거부.
- 단일 사용자 iOS 전용 학습 도구에 플레이버/다중 플랫폼/i18n은 군더더기.
- 표준 구조가 초보+AI 협업 디버깅(R3)에 가장 이해하기 쉬움.

**Initialization Command:**

```bash
flutter create --org com.sy --platforms=ios bmad_flutter
```
(iOS 단일 타깃. 필요 시 --platforms 조정. Flutter 3.44.0+)

**Architectural Decisions Provided by Starter:**

- **Language & Runtime:** Dart (Flutter 3.44.0 SDK 내장)
- **Styling Solution:** Flutter 위젯 + ThemeData/CupertinoTheme (별도 CSS 없음)
- **Build Tooling:** flutter build / Xcode 실기기 빌드 (NFR1)
- **Testing Framework:** flutter_test (SDK 내장, 스캐폴드 자동 생성)
- **Code Organization:** lib/ 기준 표준 구조 (세부 구조는 step-06에서 결정)
- **Development Experience:** 핫 리로드, flutter run, 단일 환경 셋업(NFR5)

**Note:** 이 명령으로 프로젝트를 초기화하는 것이 첫 구현 스토리(Story 1.1)가
된다.

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**
- 상태관리: Provider (앱 전역 인프라)
- 3종 스플릿 뷰 위젯 트리: 단일 루트 + 패널별 테마 격리 (Story 1.6 PoC)
- 로컬 영속: shared_preferences (JSON 키-값)

**Important Decisions (Shape Architecture):**
- 내비게이션: Navigator 1.0
- iOS 네이티브 플러그인 선정
- 발현 파이프라인 SSOT 패턴

**Deferred Decisions (Post-MVP):**
- 리빌드 히트맵 오버레이 (stretch, FR19)
- 발현 연출 고도화(파티클/사운드) — UX 단계
- DB(drift/sqflite) 전환 — 현 스코프 불요

### Data Architecture

- **영속 계층:** shared_preferences (최신). 진행상태 + 스테이지별 튜닝값을
  `stageId → {props}` 구조로 JSON 인코딩 저장. 클라우드/계정 없음(NFR3).
- **데이터 모델링:** 앱 전역 ChangeNotifier(MuseumState)가 in-memory SSOT,
  변경 시 shared_preferences로 직렬화. (AR2: 인프라 영속 ≠ Stage 8 학습 콘텐츠)
- **Stage 8 학습용 비교:** shared_preferences vs flutter_secure_storage 저장
  방식 차이를 토글로 시각화 (FR23) — 인프라와 분리된 학습 콘텐츠.

### Authentication & Security

- **생체인증:** local_auth ^2.x (Face ID/Touch ID) — Stage 7 (FR22, NFR2).
- **보안 저장:** flutter_secure_storage ^10.3.1 (키체인) — Stage 7 학습 +
  일반 저장 대비 시각화.
- 앱 로그인/계정 없음(단일 사용자, 로컬). 앱 잠금은 발현물(FR22).

### API & Communication Patterns

- N/A — 서버/네트워크 없음. 모든 동작 온디바이스(NFR1/NFR3).

### Frontend Architecture

- **상태관리:** Provider (ChangeNotifier + Consumer). 근거: NFR6 boring tech,
  초보 친화, 로비 반응형 반영에 적합, Stage 4 학습 도그푸딩.
  - 역할 분리: setState(실험실 로컬 즉각 피드백) / Provider(앱 전역) /
    Riverpod(Stage 4 비교 체험용). 자기참조를 교보재로 전환.
- **3종 렌더링:** 단일 루트 MaterialApp 아래 패널별 Theme/CupertinoTheme +
  필요한 조상 위젯(Material/MediaQuery/DefaultTextStyle) 격리. 다중 App 중첩은
  폴백. Story 1.6 PoC로 스크롤 물리·기본 스타일 재현 검증, 결과 기록 (AR1, R1).
- **내비게이션:** Navigator 1.0 (MaterialPageRoute). 순차 잠금은 Provider 상태
  진입 가드 (FR2, FR3).
- **실험실 공통 프레임:** 상단 미리보기 + 하단 조작 패널. 인터랙션 위젯(슬라이더/
  토글/드래그/시나리오/자유)을 슬롯으로 주입 (FR5, FR8).
- **즉각 피드백:** 실험실 조작은 로컬 setState로 지연 0, "발현하기"에서만 전역
  상태 커밋 (NFR4).

### Infrastructure & Deployment

- **배포:** Xcode 실기기 직접 빌드, App Store 미사용 (NFR1). 무료 Apple 계정
  7일 재설치 제약 감수 (AR5).
- **CI/CD:** 없음(개인 프로젝트). flutter_test 로컬 실행.
- **환경:** 단일 환경, 플레이버 없음 (NFR5).

### 핵심 플러그인 버전 (2026-06 검증)

- shared_preferences (최신), provider (최신)
- flutter_local_notifications ^21.0.0
- local_auth ^2.x
- flutter_secure_storage ^10.3.1
- (Stage 4 비교용) flutter_riverpod ^3.3.2

### Decision Impact Analysis

**Implementation Sequence:**
1. flutter create + 로비 셸 (Story 1.1)
2. Provider 전역 상태 + shared_preferences 영속 인프라 (Story 1.2, 1.4)
3. 실험실 공통 프레임 + 발현 파이프라인 (Story 1.3)
4. Stage 1 슬라이더 실험실 (Story 1.5)
5. 🔴 3종 스플릿 뷰 PoC (Story 1.6) — 생사 결정
6. 튜닝값 발현/프리셋 (Story 1.7) → 이후 Epic 2-4

**Cross-Component Dependencies:**
- 발현 파이프라인은 Provider(상태) + shared_preferences(영속)에 동시 의존.
- 3종 스플릿 뷰 PoC 결과가 Epic 2(컴포넌트/애니메이션 재사용)를 게이트.
- iOS 네이티브 플러그인은 실기기 빌드(NFR1/NFR2) 전제.

## Implementation Patterns & Consistency Rules

### Pattern Categories Defined

**Critical Conflict Points Identified:**
AI 에이전트가 다르게 선택할 수 있는 7개 영역(네이밍/상태/영속키/패널/직렬화/
에러·로딩/스테이지 식별)을 규칙화. 대부분 Effective Dart 표준 준수.

### Naming Patterns

**파일/디렉토리:**
- 파일명: `snake_case.dart` (예: `museum_state.dart`, `lab_scaffold.dart`).
- 디렉토리: `snake_case` (예: `lib/stages/layout/`).
- 위젯 파일은 주 위젯 1개 기준, 파일명 = 위젯의 snake_case.

**코드 (Effective Dart):**
- 클래스/enum/위젯: `PascalCase` (예: `MuseumState`, `StageId`, `LabScaffold`).
- 메서드/변수/필드: `lowerCamelCase` (예: `tuningValues`, `manifest()`).
- 상수: `lowerCamelCase` (Dart 표준, ALL_CAPS 금지).
- private: 선행 언더스코어 `_internalState`.
- 불리언: `is/has/can` 접두 (예: `isUnlocked`, `hasManifested`).

**영속 키 (shared_preferences):**
- 네임스페이스 접두 `museum.` + 도메인. 예: `museum.progress`,
  `museum.tuning.<stageId>` (예: `museum.tuning.layout`).
- 스테이지 식별은 `StageId` enum의 `.name`을 키에 사용해 오타 방지.

### Structure Patterns

**상태 클래스:**
- 전역 상태는 `ChangeNotifier` 1급 클래스. `notifyListeners()`는 상태 변경
  **직후 1회**만 호출(루프 내 다발 호출 금지).
- 위젯은 `context.watch<T>()`/`Consumer`로 구독, `context.read<T>()`로 액션
  호출. `Provider.of(listen:false)` 대신 `read` 일관 사용.
- 실험실 로컬 미리보기 상태는 `StatefulWidget` + setState(즉각 피드백, NFR4).
  "발현하기" 시점에만 전역 `MuseumState`에 커밋.

**3종 패널 추상화:**
- 공통 위젯 `ComparisonPanel({required Platform platform, required Widget
  child})` — Material/Cupertino/Custom 3개를 동일 인터페이스로 렌더.
- 각 패널은 자신의 Theme/CupertinoTheme + 필요한 조상 위젯을 책임지고 감쌈.
- 튜닝값(소스 오브 트루스)은 부모가 보유, 3패널에 동일 값 주입(FR11).

**디렉토리 골격 (세부는 다음 섹션):**
- `lib/` 하위 feature-first(스테이지별 폴더) + 공통 `shared/`. type-first
  (모든 widget을 한 폴더) 금지.

### Format Patterns

**직렬화:**
- 모델은 `toJson()/fromJson(Map<String,dynamic>)` 쌍 제공.
- JSON 필드: `lowerCamelCase` (Dart 객체와 일치, 변환 레이어 불요).
- 영속 저장은 `jsonEncode(model.toJson())` 문자열로 shared_preferences에.
- enum 직렬화는 `.name`(문자열), index 저장 금지(순서 변경 취약).

**스테이지 식별자:**
- `enum StageId { layout, component, animation, state, gesture,
  notification, security, storage }` — 문자열/int 직접 사용 금지.

### Communication Patterns

**상태 업데이트:**
- 불변 업데이트 지향: 컬렉션은 새 인스턴스로 교체 후 notifyListeners.
- 액션 메서드는 동사형(`unlockStage`, `saveTuning`, `manifest`).
- 발현 파이프라인 단방향: UI 액션 → MuseumState 메서드 → 영속 → notify →
  Consumer 리빌드. UI가 영속 계층 직접 접근 금지(항상 상태 경유, AR3).

### Process Patterns

**에러 처리:**
- 영속 읽기 실패는 기본값으로 폴백(앱 크래시 금지, 학습 흐름 보호).
- 네이티브 권한 거부(알림/생체)는 정상 분기로 처리해 시각화(FR21/FR22) —
  예외 아님.
- 사용자향 에러는 SnackBar/다이얼로그로 한국어 메시지, 로그는 개발용 분리.

**로딩 상태:**
- 앱 시작 시 shared_preferences 로드까지 스플래시/플레이스홀더. 로드 완료
  후 로비 렌더(영속 상태 복원 보장).

### Enforcement Guidelines

**All AI Agents MUST:**
- Effective Dart 네이밍 준수(파일 snake_case, 클래스 PascalCase).
- 영속 접근은 반드시 MuseumState 경유, 위젯에서 직접 shared_preferences 금지.
- StageId enum 사용, 스테이지를 문자열/숫자로 하드코딩 금지.
- enum 직렬화는 `.name`, index 금지.
- 실험실 즉각 피드백은 로컬 setState, 전역 커밋은 발현 시점만.

**Pattern Enforcement:**
- `flutter analyze` + `flutter_lints` 기본 룰셋 통과를 PR 기준으로.
- 패턴 위반 발견 시 이 문서에 추가/갱신 후 전파.

### Pattern Examples

**Good:**
- `museum.tuning.${StageId.layout.name}` → `museum.tuning.layout`
- `context.read<MuseumState>().manifest(StageId.layout)`

**Anti-Patterns:**
- `prefs.setString('stage1', ...)` (네임스페이스/enum 미사용)
- 위젯 build 내부에서 `SharedPreferences.getInstance()` 직접 호출
- `notifyListeners()`를 for 루프 안에서 반복 호출

## Project Structure & Boundaries

### Complete Project Directory Structure

```
bmad_flutter/
├── pubspec.yaml                      # 의존성: provider, shared_preferences,
│                                     #  flutter_local_notifications, local_auth,
│                                     #  flutter_secure_storage, flutter_riverpod(Stage4)
├── analysis_options.yaml             # flutter_lints 룰셋
├── README.md
├── ios/                              # Xcode 실기기 빌드 설정 (NFR1)
│   └── Runner/Info.plist             # 알림/Face ID 권한 선언 (NSFaceIDUsageDescription 등)
├── test/                             # flutter_test (소스 트리 미러링)
│   ├── state/
│   │   └── museum_state_test.dart
│   ├── persistence/
│   │   └── museum_repository_test.dart
│   └── stages/
│       └── layout/
│           └── layout_lab_test.dart
└── lib/
    ├── main.dart                     # 앱 진입점, Provider 루트 주입, 영속 로드
    ├── app.dart                      # 루트 MaterialApp, 라우팅, 테마
    │
    ├── core/                         # 횡단 인프라 (앱 전역)
    │   ├── state/
    │   │   └── museum_state.dart     # 🔵 전역 SSOT ChangeNotifier (진행+튜닝)
    │   ├── persistence/
    │   │   ├── museum_repository.dart # shared_preferences 영속 (AR2/AR3)
    │   │   └── prefs_keys.dart        # `museum.*` 키 상수
    │   ├── models/
    │   │   ├── stage_id.dart          # enum StageId {layout..storage}
    │   │   ├── stage_progress.dart    # 잠금/클리어 상태 모델 (+toJson/fromJson)
    │   │   └── tuning_values.dart     # 스테이지별 튜닝값 모델 (+직렬화)
    │   └── theme/
    │       ├── material_theme.dart
    │       ├── cupertino_theme.dart
    │       └── custom_theme.dart      # Custom 탭 발현 소스
    │
    ├── lobby/                        # FG1 박물관 셸 (Epic 1)
    │   ├── lobby_screen.dart          # 로비 메인 (FR1) — 발현물 합작품
    │   ├── exhibition_nav.dart        # 8개 전시실 내비 + 순차 잠금 (FR2,3,4)
    │   └── manifestations/            # 스테이지별 발현물 위젯 (로비에 누적)
    │       ├── skeleton_manifest.dart       # Stage1 골격
    │       ├── components_manifest.dart     # Stage2 버튼·카드
    │       ├── transition_manifest.dart     # Stage3 진입 애니메이션
    │       ├── progress_counter_manifest.dart # Stage4 진도 카운터
    │       ├── swipe_nav_manifest.dart      # Stage5 스와이프 내비
    │       ├── reminder_manifest.dart       # Stage6 리마인더
    │       ├── lock_manifest.dart           # Stage7 앱 잠금
    │       └── persistence_manifest.dart    # Stage8 영속성 증명
    │
    ├── shared/                       # FG2 실험실 공통 프레임 + 3종 비교 (재사용)
    │   ├── lab_scaffold.dart          # 상단 미리보기+하단 조작 슬롯 (FR5,8)
    │   ├── manifest_button.dart       # "발현하기" 액션 + 스케일/페이드 연출 (FR6,7)
    │   ├── comparison_view.dart       # 3종 스플릿 뷰 컨테이너 (FR9) 🔴 PoC
    │   ├── comparison_panel.dart      # 단일 패널(플랫폼 테마 격리) (FR10,11)
    │   └── preset_controls.dart       # iOS/Material/Custom 프리셋·리셋 (FR15)
    │
    └── stages/                       # FG5 스테이지별 학습 콘텐츠 (feature-first)
        ├── layout/                    # Stage1 (Epic1, FR16) — 슬라이더+3종+발현
        │   ├── layout_lab.dart
        │   └── layout_controls.dart
        ├── component/                 # Stage2 (Epic2, FR17) — 토글+3종+발현
        │   ├── component_lab.dart
        │   └── component_controls.dart
        ├── animation/                 # Stage3 (Epic2, FR18) — 드래그+3종+발현
        │   ├── animation_lab.dart
        │   └── curve_editor.dart
        ├── state_mgmt/                # Stage4 (Epic3, FR19) — 리빌드 카운터
        │   ├── state_lab.dart
        │   └── rebuild_counter.dart   # setState/Provider/Riverpod 비교
        ├── gesture/                   # Stage5 (Epic3, FR20) — 자유 구성
        │   └── gesture_lab.dart
        ├── notification/             # Stage6 (Epic4, FR21) — 권한 플로우
        │   ├── notification_lab.dart
        │   └── notification_service.dart  # flutter_local_notifications 어댑터
        ├── security/                  # Stage7 (Epic4, FR22) — 생체+키체인
        │   ├── security_lab.dart
        │   └── secure_storage_service.dart # local_auth + flutter_secure_storage
        └── storage/                   # Stage8 (Epic4, FR23) — 저장방식 비교
            └── storage_lab.dart       # shared_prefs vs secure_storage 토글
```

### Architectural Boundaries

**상태 경계 (State):**
- `MuseumState`(core/state)가 전역 SSOT. 모든 영속 변경은 여기를 경유.
- 실험실 로컬 미리보기 상태는 각 `*_lab.dart`의 StatefulWidget 내부에 격리
  (전역 오염 금지, 즉각 피드백 NFR4). 발현 시점에만 MuseumState로 커밋.

**영속 경계 (Data):**
- `MuseumRepository`(core/persistence)만 shared_preferences에 접근.
  위젯/실험실은 절대 직접 접근 금지. MuseumState ↔ Repository만 연결.
- `prefs_keys.dart`가 모든 `museum.*` 키의 단일 출처.

**컴포넌트 경계 (Component):**
- `lib/shared/`는 스테이지 비의존 재사용 프레임. `lib/stages/*`가 shared를
  소비하되 역방향 의존 금지(shared가 특정 stage를 import 금지).
- 3종 비교는 `comparison_view` → `comparison_panel` 1단 위임. 패널이 플랫폼
  테마 조상을 책임짐 (R1 PoC 지점).

**네이티브 경계 (Platform):**
- 네이티브 호출은 각 `*_service.dart` 어댑터에 격리(notification/security).
  실험실 UI는 서비스 인터페이스만 의존 → 권한 거부도 정상 분기로 시각화.

### Requirements to Structure Mapping

**Epic 1 (로비+첫 실험실):** `lib/main.dart`, `lib/app.dart`, `lib/lobby/`,
`lib/core/` 전체, `lib/shared/` 전체, `lib/stages/layout/`.
→ Story 1.6 PoC = `shared/comparison_view.dart` + `comparison_panel.dart`.

**Epic 2 (비교형 확장):** `lib/stages/component/`, `lib/stages/animation/`
(shared 3종 비교 재사용).

**Epic 3 (체험형):** `lib/stages/state_mgmt/`, `lib/stages/gesture/`
(3종 비교 미사용, 자체 인터랙션).

**Epic 4 (네이티브):** `lib/stages/notification/`, `lib/stages/security/`,
`lib/stages/storage/` + 각 `*_service.dart` 어댑터.

**횡단 관심사:**
- 발현 파이프라인: `stages/*` → `core/state` → `core/persistence` →
  `lobby/manifestations/*` 리빌드.
- 진행/잠금: `core/models/stage_progress` + `lobby/exhibition_nav`.

### Integration Points

**내부 통신:** 단방향 — UI 액션 → MuseumState 메서드 → Repository 영속 →
notifyListeners → lobby Consumer 리빌드.

**외부 통합:** 없음(서버/네트워크 N/A). 네이티브 플러그인만 `*_service.dart`
경유.

**데이터 흐름:** Custom 탭 튜닝값(소스) → MuseumState → jsonEncode →
shared_preferences → 재시작 시 fromJson 복원 → 로비 발현물 반영.

### File Organization Patterns

- **설정:** pubspec.yaml(의존성), analysis_options.yaml(린트), ios/(네이티브
  권한·서명).
- **소스:** feature-first — core(인프라) / lobby(셸) / shared(공통 프레임) /
  stages(스테이지별). type-first 금지.
- **테스트:** `test/`가 `lib/` 구조 미러링. 단위 테스트 우선(상태·영속).
- **에셋:** 현 MVP는 코드 생성 위주, 정적 에셋 최소. 필요 시 `assets/` +
  pubspec 선언.

### Development Workflow Integration

- **개발 서버:** `flutter run` 실기기, 핫 리로드로 실험실 즉각 반영.
- **빌드:** `flutter build ios` → Xcode 실기기 직접 빌드 (NFR1, AR5).
- **배포:** App Store 미사용, 7일 재설치 제약 감수.

## Architecture Validation Results

### Coherence Validation ✅

**Decision Compatibility:**
Provider · shared_preferences · Navigator 1.0 · flutter_create는 모두 Flutter
표준 조합으로 상호 충돌 없음. 모든 플러그인 버전(2026-06 검증)이 Flutter
3.44.0과 호환. Riverpod은 Stage 4 학습용으로만 격리되어 앱 인프라(Provider)와
공존 — 자기참조가 역할 분리로 해소됨.

**Pattern Consistency:**
Effective Dart 네이밍 + 단방향 발현 파이프라인 + StageId enum 규칙이 구조의
경계(core/lobby/shared/stages)와 정합. 영속 접근을 Repository로 단일화한
패턴이 "위젯 직접 접근 금지" 경계와 일치.

**Structure Alignment:**
feature-first 디렉토리가 8 스테이지 + 공통 프레임 재사용을 그대로 수용.
3종 비교 PoC가 shared/comparison_* 단일 지점에 집중되어 Epic 2-4 재사용 보장.

### Requirements Coverage Validation ✅

**Epic/Feature Coverage:**
- Epic 1 → lib/core + lobby + shared + stages/layout (수직 슬라이스 완비)
- Epic 2 → stages/component, animation (shared 3종 비교 재사용)
- Epic 3 → stages/state_mgmt, gesture (3종 비교 미적용)
- Epic 4 → stages/notification, security, storage + *_service 어댑터

**Functional Requirements Coverage:**
FR1-4(lobby/exhibition_nav/stage_progress), FR5-8(lab_scaffold/manifest_button),
FR9-11(comparison_view/panel), FR12-15(museum_state/repository/preset_controls),
FR16-23(stages/*) — 23개 전부 파일 수준 매핑 완료.

**Non-Functional Requirements Coverage:**
NFR1/2(ios/ + *_service), NFR3(shared_preferences), NFR4(로컬 setState 즉각
피드백), NFR5(flutter create 단일 환경), NFR6(Provider boring tech) — 충족.

### Implementation Readiness Validation ✅

**Decision Completeness:** 모든 결정이 버전과 함께 문서화. 발현 파이프라인
SSOT 패턴 명시.
**Structure Completeness:** 전체 디렉토리 트리 + 경계 + 통합 지점 구체화.
**Pattern Completeness:** 네이밍/직렬화/상태/에러/로딩 패턴 + 예시·안티패턴
명시.

### Gap Analysis Results

**Critical Gaps:** 없음 (모든 구현 차단 결정 해소).
**Important Gaps:**
- 🔴 R1 스플릿 뷰 PoC 미실증 — 설계·폴백은 완비. Story 1.6에서 최우선 검증
  필요. 실패 시 폴백(패널별 중첩 App) 적용 후 결과 기록.
**Nice-to-Have Gaps:**
- 발현 연출 세부(파티클/사운드)는 UX 단계 위임 (FR7 stretch).
- 리빌드 히트맵은 stretch (FR19), MVP는 카운터.

### Validation Issues Addressed

상태관리 자기참조(Stage 4 학습 대상 vs 앱 인프라)는 역할 3분할(setState/
Provider/Riverpod)로 해소. 영속성 이중성(인프라 vs Stage 8 학습)은 Repository
인프라와 storage_lab 학습 콘텐츠 분리로 해소.

### Architecture Completeness Checklist

**Requirements Analysis**
- [x] Project context thoroughly analyzed
- [x] Scale and complexity assessed
- [x] Technical constraints identified
- [x] Cross-cutting concerns mapped

**Architectural Decisions**
- [x] Critical decisions documented with versions
- [x] Technology stack fully specified
- [x] Integration patterns defined
- [x] Performance considerations addressed

**Implementation Patterns**
- [x] Naming conventions established
- [x] Structure patterns defined
- [x] Communication patterns specified
- [x] Process patterns documented

**Project Structure**
- [x] Complete directory structure defined
- [x] Component boundaries established
- [x] Integration points mapped
- [x] Requirements to structure mapping complete

### Architecture Readiness Assessment

**Overall Status:** READY FOR IMPLEMENTATION
**Confidence Level:** high — 단, R1 스플릿 뷰 PoC(Story 1.6) 결과가 최종
확신을 좌우. PoC 성공 시 high 유지, 실패 시 폴백 구조로 재조정.

**Key Strengths:**
- 킬링 포인트(3종 비교·발현 영속)가 단일 재사용 지점에 집중.
- boring technology로 NFR6(초보+3-4주) 제약 충족.
- 발현 파이프라인 단방향 SSOT로 일관성·디버깅 용이성 확보.
- 자기참조 난제(상태관리·영속)를 학습 교보재로 전환.

**Areas for Future Enhancement:**
- 발현 연출 고도화, 리빌드 히트맵, DB 전환(현 스코프 밖).

### Implementation Handoff

**AI Agent Guidelines:**
- 모든 아키텍처 결정을 문서 그대로 준수.
- 구현 패턴(네이밍/직렬화/상태/경계)을 전 컴포넌트에 일관 적용.
- 프로젝트 구조와 경계 존중(영속은 Repository 경유 등).
- 아키텍처 질문은 본 문서를 단일 출처로 참조.

**First Implementation Priority:**
1. `flutter create --org com.sy --platforms=ios bmad_flutter` (Story 1.1)
2. 이어서 Story 1.6 3종 스플릿 뷰 PoC를 조기 검증 — 프로젝트 생사 결정.
