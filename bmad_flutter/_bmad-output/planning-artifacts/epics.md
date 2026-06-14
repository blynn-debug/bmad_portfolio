---
stepsCompleted: [1, 2, 3, 4]
inputDocuments:
  - prds/prd-bmad_flutter-2026-06-13/prd.md
  - prds/prd-bmad_flutter-2026-06-13/addendum.md
  - prfaq-bmad_flutter-distillate.md
---

# Flutter Showcase Museum - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for Flutter Showcase Museum, decomposing the requirements from the PRD and PRD Addendum into implementable stories. (Architecture/UX 문서 미작성 — 개인 학습 프로젝트로 PRD + addendum의 기술 메모를 근거로 진행. 스플릿 뷰 PoC는 Epic 1에 명시 검증 스토리로 포함.)

## Requirements Inventory

### Functional Requirements

**FG1. 쇼케이스 박물관 셸 (로비 & 진행)**
- FR1: 앱 진입 시 쇼케이스 박물관 로비(메인 화면)를 표시한다. 로비는 모든 스테이지 발현물의 합작품이며 학습 진도가 시각적으로 드러난다.
- FR2: 로비에서 8개 전시실(스테이지) 각각으로 진입할 수 있는 내비게이션을 제공한다.
- FR3: 스테이지 진행은 순차 잠금/해제 방식이다 — 직전 스테이지를 클리어해야 다음이 열린다.
- FR4: 각 스테이지의 클리어/잠금 상태를 추적하고 로비에 반영한다.

**FG2. 실험실 → 발현 공통 루프**
- FR5: 모든 스테이지는 공통 실험실 레이아웃(상단 결과 미리보기 + 하단 조작 패널)을 따르고, 조작 시 즉각 피드백을 보여준다.
- FR6: 학습 조건 충족 시 "발현하기" 액션을 노출하고, 실행 시 산출물을 로비에 발현시킨다.
- FR7: 발현 시 클리어를 알리는 연출을 보여준다(MVP 단순 스케일/페이드).
- FR8: 영역별로 서로 다른 인터랙션 방식(슬라이더/토글/드래그/시나리오/자유)을 제공해 반복 피로를 방지한다.

**FG3. 3종 플랫폼 비교 (킬링 포인트)**
- FR9: 레이아웃·컴포넌트·애니메이션 스테이지에서 Material/Cupertino/Custom 3종을 동시 렌더링해 나란히 비교한다(스플릿 뷰).
- FR10: 동일 위젯의 플랫폼별 차이를 직접 체험하게 한다(Material ripple vs iOS opacity, 스크롤 물리 등).
- FR11: 사용자가 조작한 속성값이 3종 렌더링에 실시간 동시 반영된다.

**FG4. 튜닝값 영속 & 발현 (킬링 포인트)**
- FR12: 3종 비교 스테이지에서 Custom 탭의 튜닝값이 로비 발현물에 영구 반영된다.
- FR13: 모든 튜닝값과 진행 상태는 앱을 재시작해도 유지된다(영속성).
- FR14: 발현 후에도 재입장해 튜닝값을 다시 조정할 수 있고 변경은 로비에 재반영된다.
- FR15: 3종 비교 스테이지는 iOS/Material/Custom 프리셋 적용 및 리셋을 제공해 값 차이로 디자인 철학을 체감하게 한다.

**FG5. 스테이지별 학습 콘텐츠**
- FR16: (Stage 1 — 레이아웃) 슬라이더 실험실에서 Container/Row/Column/Stack/Padding/Expanded/Wrap·Grid 속성을 조작하며 배치 원리를 체득. 발현물: 로비 기본 골격.
- FR17: (Stage 2 — 컴포넌트) 토글 비교로 Button/Switch/Slider/TextField/NavBar/Dialog·Sheet 플랫폼별 차이 체험. 발현물: 전시실 입구 버튼·카드.
- FR18: (Stage 3 — 애니메이션) 드래그로 Curve/Duration 조작, 커브 그래프와 실제 움직임 비교. 발현물: 로비 진입 전환 애니메이션.
- FR19: (Stage 4 — 상태관리) setState/Provider/Riverpod 시나리오 체험, 리빌드 카운터로 체감(히트맵은 stretch). 발현물: 실시간 학습 진도 카운터.
- FR20: (Stage 5 — 제스처) 터치하며 제스처 타입 실시간 확인, gesture arena 실험. 발현물: 스와이프 전시실 이동.
- FR21: (Stage 6 — 알림) 로컬 알림 구성→발송→타임라인 시각화, iOS 권한 플로우 체험. 발현물: 리마인더.
- FR22: (Stage 7 — 보안) 생체인증·키체인·앱 잠금 체험, 일반 저장 vs 키체인 차이 시각화. 발현물: 앱 잠금 화면.
- FR23: (Stage 8 — 데이터 저장) 토글로 저장방식 차이 비교. 발현물: 재시작해도 모든 튜닝값 유지(영속성 자기증명).

### NonFunctional Requirements

- NFR1: iOS 모바일 단일 surface. Xcode 실기기 직접 빌드로 배포(App Store 미사용).
- NFR2: 실기기 빌드 전제로 생체인증·키체인·로컬 알림 등 모든 네이티브 기능 사용 가능.
- NFR3: 진행 상태와 튜닝값을 로컬에 영속 저장(클라우드/계정 불필요).
- NFR4: 모든 실험실 조작은 체감상 지연 없이 미리보기에 반영(학습 도구 핵심 가치).
- NFR5: 초보자가 한 번 셋업한 환경으로 끝까지 진행 가능(셋업 복잡성이 포기로 이어지지 않게).
- NFR6: 초보 단독(+AI) 프로젝트로 3-4주 내 완주 가능한 구현 복잡도 유지.

### Additional Requirements

(PRD Addendum / 리스크 기반)
- AR1: 스플릿 뷰 동시 렌더링(MaterialApp + CupertinoApp 한 화면 공존) PoC 필수 — Epic 1에서 가장 먼저 검증. 실패 시 프로젝트 방향 재조정.
- AR2: 영속성은 로컬 키-값 또는 경량 DB로 구현. Stage 8이 영속성 자체를 학습 주제로 삼으므로, 영속 인프라(Epic 1)와 영속 학습 콘텐츠(Stage 8)를 구분.
- AR3: 발현 파이프라인 = 조작값(상태) → 영속 저장 → 로비 위젯 반영. Custom 탭 값이 발현 소스.
- AR4: 빌드 순서 = 로비 인프라 → Stage 1(킬링포인트 검증) → 영속 인프라 → 나머지 스테이지.
- AR5: 무료 Apple 계정 7일 재설치 제약 감수(배포 환경 제약).

### UX Design Requirements

(UX 문서 미작성 — N/A. 인터랙션/연출 세부는 향후 `bmad-ux`에서 정의. 현재는 PRD의 인터랙션 변주 원칙을 스토리 AC에 반영.)

### FR Coverage Map

- FR1: Epic 1 - 로비 메인 화면 (Story 1.1)
- FR2: Epic 1 - 8개 전시실 내비게이션 (Story 1.2)
- FR3: Epic 1 - 순차 잠금/해제 (Story 1.2)
- FR4: Epic 1 - 진행 상태 추적 (Story 1.2)
- FR5: Epic 1 - 공통 실험실 프레임 (Story 1.3)
- FR6: Epic 1 - 발현 액션 (Story 1.3)
- FR7: Epic 1 - 발현 연출 (Story 1.3)
- FR8: Epic 1 - 인터랙션 변주 원칙 (Story 1.3); 각 스테이지에서 실현 (Epic 2-4)
- FR9: Epic 1 - 3종 비교 스플릿 뷰 PoC (Story 1.6); 재사용 (Story 2.1, 2.2)
- FR10: Epic 1 - 플랫폼별 차이 체험 (Story 1.6); 재사용 (Story 2.1, 2.2)
- FR11: Epic 1 - 실시간 동시 반영 (Story 1.6); 재사용 (Story 2.1, 2.2)
- FR12: Epic 1 - Custom 튜닝값 발현 (Story 1.7); 재사용 (Story 2.1, 2.2)
- FR13: Epic 1 - 영속 인프라 (Story 1.4)
- FR14: Epic 1 - 재입장 튜닝 재조정 (Story 1.7)
- FR15: Epic 1 - 프리셋/리셋 (Story 1.7); 재사용 (Story 2.1, 2.2)
- FR16: Epic 1 - Stage 1 레이아웃 (Story 1.5)
- FR17: Epic 2 - Stage 2 컴포넌트 (Story 2.1)
- FR18: Epic 2 - Stage 3 애니메이션 (Story 2.2)
- FR19: Epic 3 - Stage 4 상태관리 (Story 3.1)
- FR20: Epic 3 - Stage 5 제스처 (Story 3.2)
- FR21: Epic 4 - Stage 6 알림 (Story 4.1)
- FR22: Epic 4 - Stage 7 보안 (Story 4.2)
- FR23: Epic 4 - Stage 8 데이터 저장 (Story 4.3)

## Epic List

### Epic 1: 박물관 로비와 첫 실험실 — 핵심 루프 검증
앱을 열면 쇼케이스 로비가 보이고, 레이아웃 실험실에서 속성을 만지고 3종 플랫폼을 비교한 뒤 Custom 튜닝값을 "발현"하면 로비가 성장하며, 재시작해도 그 결과가 유지된다. 만지기→비교→발현→영속의 핵심 루프와 스플릿 뷰 PoC를 한 번에 검증하는 수직 슬라이스(프로젝트 생사 결정 마일스톤).
**FRs covered:** FR1, FR2, FR3, FR4, FR5, FR6, FR7, FR8, FR9, FR10, FR11, FR12, FR13, FR14, FR15, FR16

### Epic 2: 비교형 실험실 확장 — 컴포넌트 & 애니메이션
Epic 1에서 검증된 3종 비교 + 튜닝 발현 루프를 컴포넌트와 애니메이션 영역으로 확장한다. 사용자는 버튼/스위치 등의 플랫폼별 촉감 차이와 모션 커브를 직접 비교·튜닝하고, 그 결과가 로비에 발현된다.
**FRs covered:** FR17, FR18 (FR9-FR12, FR15 재사용)

### Epic 3: 체험형 실험실 — 상태관리 & 제스처
3종 비교가 아닌 "체험·관찰" 중심 학습. 상태관리 방식별 리빌드를 카운터로 관찰하고, 제스처를 자유롭게 만지며 발견한다. 발현물은 로비의 실시간 진도 카운터와 스와이프 내비게이션.
**FRs covered:** FR19, FR20

### Epic 4: iOS 네이티브 실험실 — 알림 · 보안 · 데이터 저장
iOS 네이티브 특화 시나리오를 안전하게 체험한다. 알림 권한 플로우, 생체인증·키체인 보안, 저장 방식 비교를 거치며 로비에 리마인더·앱 잠금·완전한 영속성이 발현되어 박물관이 완전체가 된다.
**FRs covered:** FR21, FR22, FR23

## Epic 1: 박물관 로비와 첫 실험실 — 핵심 루프 검증

앱을 열면 쇼케이스 로비가 보이고, 레이아웃 실험실에서 속성을 만지고 3종 플랫폼을 비교한 뒤 Custom 튜닝값을 "발현"하면 로비가 성장하며, 재시작해도 그 결과가 유지된다. 핵심 루프와 스플릿 뷰 PoC를 검증하는 수직 슬라이스.

### Story 1.1: 프로젝트 셋업 & 로비 스캐폴딩

As a 학습자(sy),
I want Flutter 프로젝트를 만들고 iOS 실기기에서 로비 화면이 뜨는 것을 확인하고,
So that 한 번 셋업한 환경으로 끝까지 학습을 진행할 토대를 갖춘다.

**Acceptance Criteria:**

**Given** 빈 작업 환경에서
**When** Flutter 프로젝트를 생성하고 iOS 실기기로 빌드한다
**Then** 쇼케이스 박물관 로비(메인 화면)의 기본 골격이 실기기에서 표시된다
**And** 로비는 학습 진도를 담을 자리(전시실 영역)를 가진 빈 상태로 시작한다 (FR1)
**And** Xcode 실기기 직접 빌드 절차가 한 번 정립되어 재현 가능하다 (NFR1, NFR5)

### Story 1.2: 8개 전시실 내비게이션 & 순차 잠금/진행 상태

As a 학습자,
I want 로비에서 8개 전시실로 이동하되 순서대로 잠금이 풀리는 것을 보고,
So that "성장하는 박물관" 흐름을 따라 한 스테이지씩 진행할 수 있다.

**Acceptance Criteria:**

**Given** 로비가 표시된 상태에서
**When** 전시실 목록을 본다
**Then** 8개 전시실(스테이지) 진입점이 표시된다 (FR2)
**And** 첫 스테이지만 열려 있고 나머지는 잠겨 있다 (FR3)
**When** 한 스테이지를 클리어한다
**Then** 다음 스테이지가 해제되고 로비에 클리어/잠금 상태가 반영된다 (FR3, FR4)
**And** 진행 상태는 이후 Story 1.4의 영속 인프라로 저장될 수 있도록 단일 진도 상태로 관리된다

### Story 1.3: 공통 실험실 프레임 & 발현 액션

As a 학습자,
I want 모든 실험실이 공유하는 "상단 미리보기 + 하단 조작" 틀과 "발현하기" 동작을,
So that 어느 스테이지에 들어가도 일관된 방식으로 만지고 결과를 로비에 반영할 수 있다.

**Acceptance Criteria:**

**Given** 한 스테이지(실험실)에 입장한 상태에서
**When** 하단 조작 패널을 조작한다
**Then** 상단 미리보기가 지연 없이 즉시 갱신된다 (FR5, NFR4)
**Given** 스테이지 학습 조건을 충족한 상태에서
**When** "발현하기"를 실행한다
**Then** 해당 산출물이 로비에 발현되고 단순 스케일/페이드 연출로 클리어가 표시된다 (FR6, FR7)
**And** 공통 프레임은 영역별로 다른 인터랙션 위젯(슬라이더/토글/드래그/시나리오/자유)을 끼울 수 있도록 설계된다 (FR8)

### Story 1.4: 튜닝값 & 진행 상태 영속 인프라

As a 학습자,
I want 내 진행 상태와 튜닝값이 앱을 껐다 켜도 그대로 남는 것을,
So that "내 튜닝값이 곧 내 앱"이라는 약속이 실제로 지켜진다.

**Acceptance Criteria:**

**Given** 진행 상태와 튜닝값이 존재하는 상태에서
**When** 앱을 완전히 종료하고 다시 실행한다
**Then** 클리어/잠금 상태와 저장된 튜닝값이 그대로 복원된다 (FR13, NFR3)
**And** 영속 계층은 로컬 저장(키-값 또는 경량 DB)으로 구현되며 클라우드/계정을 요구하지 않는다 (NFR3, AR2)
**And** 발현 파이프라인(조작값 → 저장 → 로비 반영)이 이 저장 계층을 통해 동작한다 (AR3)

### Story 1.5: Stage 1 레이아웃 실험실 (슬라이더 학습)

As a 학습자,
I want 슬라이더로 레이아웃 속성을 만지며 배치가 어떻게 바뀌는지 보고,
So that Row/Column/Stack/Padding 등 레이아웃 원리를 설명 없이 체득한다.

**Acceptance Criteria:**

**Given** Stage 1 실험실에 입장한 상태에서
**When** Container/Row/Column/Stack/Padding/Expanded/Wrap·Grid 관련 속성 슬라이더를 조작한다
**Then** 상단 미리보기의 레이아웃이 실시간으로 변한다 (FR16, FR5, NFR4)
**And** 각 속성 변화가 배치에 미치는 영향을 직접 관찰할 수 있다
**And** 발현 시 로비의 기본 골격(헤더·콘텐츠·푸터 구조)이 나타난다 (FR16, FR6)

### Story 1.6: Stage 1 3종 플랫폼 비교 (스플릿 뷰 PoC)

As a 학습자,
I want 같은 레이아웃을 Material/Cupertino/Custom으로 동시에 나란히 보고,
So that 플랫폼 디자인 철학의 차이를 한눈에 비교하며 이해한다.

**Acceptance Criteria:**

**Given** Stage 1 실험실에서
**When** 3종 비교 뷰를 연다
**Then** Material/Cupertino/Custom이 한 화면에 동시 렌더링되어 나란히 비교된다 (FR9)
**And** 슬라이더 조작값이 3종 렌더링에 실시간 동시 반영된다 (FR11)
**And** 동일 위젯의 플랫폼별 차이(예: 스크롤 물리 bouncing vs clamping)를 직접 체험할 수 있다 (FR10)
**And** MaterialApp + CupertinoApp을 한 화면에 공존시키는 위젯 트리 구조가 검증된다 — 실패 시 대안 구조를 기록하고 방향을 재조정한다 (AR1)

### Story 1.7: Stage 1 튜닝값 발현 & 프리셋/리셋

As a 학습자,
I want Custom 탭에서 튜닝한 값을 로비에 발현하고 프리셋으로 비교·리셋하며,
So that 내가 만든 값이 그대로 앱이 되고, 프리셋 차이로 디자인 철학을 값으로 체감한다.

**Acceptance Criteria:**

**Given** 3종 비교 실험실에서 Custom 탭 값을 조정한 상태에서
**When** "발현하기"를 실행한다
**Then** Custom 탭의 튜닝값이 로비 발현물에 영구 반영된다 (FR12)
**Given** 발현 후
**When** 해당 스테이지에 재입장해 값을 다시 조정하고 재발현한다
**Then** 변경된 값이 로비에 재반영된다 (FR14)
**Given** 실험실에서
**When** iOS/Material/Custom 프리셋을 적용하거나 리셋한다
**Then** 프리셋 간 값 차이가 즉시 보이고 기본값으로 되돌릴 수 있다 (FR15)

## Epic 2: 비교형 실험실 확장 — 컴포넌트 & 애니메이션

Epic 1에서 검증된 3종 비교 + 튜닝 발현 루프를 컴포넌트와 애니메이션 영역으로 확장한다.

### Story 2.1: Stage 2 컴포넌트 토글 비교 & 발현

As a 학습자,
I want 같은 컴포넌트를 토글로 플랫폼별로 나란히 눌러보고 튜닝해 발현하며,
So that 버튼·스위치 등의 플랫폼별 촉감 차이를 손가락으로 기억한다.

**Acceptance Criteria:**

**Given** Stage 2 실험실에 입장한 상태에서
**When** Button/Switch/Slider/TextField/NavBar/Dialog·Sheet를 토글로 플랫폼 전환하며 조작한다
**Then** 같은 컴포넌트의 Material vs Cupertino 차이(예: ripple vs opacity)를 직접 체험한다 (FR17, FR10)
**And** Material/Cupertino/Custom 3종 비교와 실시간 동시 반영이 동작한다 (FR9, FR11)
**And** Custom 튜닝값 발현 + 프리셋/리셋이 동작한다 (FR12, FR15)
**And** 발현 시 각 전시실 입구의 버튼·카드가 로비에 나타난다 (FR17, FR6)

### Story 2.2: Stage 3 애니메이션 드래그 실험 & 발현

As a 학습자,
I want 커브를 드래그로 조작하며 그래프와 실제 움직임을 나란히 보고,
So that 애니메이션 수학(Curve/Duration)을 직관적으로 이해한다.

**Acceptance Criteria:**

**Given** Stage 3 실험실에 입장한 상태에서
**When** Curve를 드래그로 조작하고 Duration을 조정한다
**Then** 커브 그래프와 실제 움직임이 나란히 실시간 표시된다 (FR18, FR5, NFR4)
**And** 플랫폼별 모션 차이를 3종 비교로 확인한다 (FR9, FR10, FR11)
**And** Custom 튜닝값 발현 + 프리셋/리셋이 동작한다 (FR12, FR15)
**And** 발현 시 로비 진입 전환 애니메이션이 적용된다 (FR18, FR6)

## Epic 3: 체험형 실험실 — 상태관리 & 제스처

3종 비교가 아닌 체험·관찰 중심 학습. 상태관리 리빌드 관찰과 제스처 자유 발견.

### Story 3.1: Stage 4 상태관리 시나리오 & 리빌드 카운터

As a 학습자,
I want setState/Provider/Riverpod 시나리오에서 리빌드가 어디서 일어나는지 카운터로 보고,
So that "왜 setState만으론 안 되는가"를 숫자 변화로 체감한다.

**Acceptance Criteria:**

**Given** Stage 4 실험실에 입장한 상태에서
**When** setState/Provider/Riverpod 시나리오를 전환하며 동작시킨다
**Then** 각 위젯의 리빌드 횟수가 카운터로 표시되어 방식별 차이를 비교할 수 있다 (FR19)
**And** 리빌드 히트맵 오버레이는 stretch goal로 분류되어 MVP 범위에서 제외된다 (FR19)
**And** 발현 시 로비에 실시간 학습 진도 카운터가 나타난다 (FR19, FR6)
**And** 이 스테이지는 3종 비교/튜닝 발현을 적용하지 않는다 (PRD 스코프)

### Story 3.2: Stage 5 제스처 자유 구성 & 스와이프 내비

As a 학습자,
I want 화면을 터치하며 어떤 제스처가 인식되는지 실시간으로 보고 겹침을 실험하며,
So that 제스처 충돌(gesture arena)을 손가락으로 이해한다.

**Acceptance Criteria:**

**Given** Stage 5 실험실에 입장한 상태에서
**When** 화면을 탭/드래그/스와이프 등으로 터치한다
**Then** 인식된 제스처 타입이 실시간으로 표시된다 (FR20)
**And** 제스처 영역을 겹쳐 충돌(arena) 동작을 관찰할 수 있다 (FR20)
**And** 발현 시 로비에서 스와이프로 전시실을 이동할 수 있게 된다 (FR20, FR6)

## Epic 4: iOS 네이티브 실험실 — 알림 · 보안 · 데이터 저장

iOS 네이티브 특화 시나리오 체험. 박물관을 완전체로 마무리.

### Story 4.1: Stage 6 알림 권한 플로우 & 리마인더 발현

As a 학습자,
I want 로컬 알림을 구성·발송하고 권한 요청/거부 플로우를 안전하게 체험하며,
So that iOS 권한 시나리오를 실제 앱을 망가뜨릴 걱정 없이 익힌다.

**Acceptance Criteria:**

**Given** Stage 6 실험실(실기기)에 입장한 상태에서
**When** 로컬 알림을 구성하고 발송한다
**Then** 발송 결과가 타임라인으로 시각화된다 (FR21)
**And** iOS 권한 요청 및 거부 시나리오를 체험할 수 있다 (FR21, NFR2)
**And** 발현 시 로비에 "오늘 실험실 들러보세요" 리마인더가 나타난다 (FR21, FR6)

### Story 4.2: Stage 7 보안 (생체인증·키체인) & 앱 잠금 발현

As a 학습자,
I want 생체인증과 키체인 저장을 체험하고 일반 저장과의 차이를 시각적으로 보고,
So that iOS 보안 감각을 손으로 체득한다.

**Acceptance Criteria:**

**Given** Stage 7 실험실(실기기)에 입장한 상태에서
**When** 생체인증을 수행하고 데이터를 키체인에 저장한다
**Then** 일반 저장 vs 키체인 저장의 차이가 시각화된다 (FR22, NFR2)
**And** 발현 시 로비에 앱 잠금 화면이 적용된다 (FR22, FR6)

### Story 4.3: Stage 8 데이터 저장 비교 & 영속성 자기증명

As a 학습자,
I want 저장 방식 차이를 토글로 비교하고 재시작 후에도 모든 튜닝값이 남는 것을 확인하며,
So that 영속성의 의미를 박물관 전체가 유지되는 것으로 직접 증명받는다.

**Acceptance Criteria:**

**Given** Stage 8 실험실에 입장한 상태에서
**When** 저장 방식을 토글로 전환하며 비교한다
**Then** 저장 방식별 동작 차이를 관찰할 수 있다 (FR23)
**Given** 모든 스테이지의 튜닝값이 발현된 상태에서
**When** 앱을 재시작한다
**Then** 모든 튜닝값과 발현물이 그대로 유지되어 박물관이 완전체로 보존된다 (FR23, FR13)
**And** 발현 시 "재시작해도 유지됨"이 로비에 영속성의 자기증명으로 표시된다 (FR23, FR6)
