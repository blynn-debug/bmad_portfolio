---
stepsCompleted: ['step-01-document-discovery', 'step-02-prd-analysis', 'step-03-epic-coverage-validation', 'step-04-ux-alignment', 'step-05-epic-quality-review', 'step-06-final-assessment']
documentsIncluded:
  - prds/prd-bmad_flutter-2026-06-13/prd.md
  - prds/prd-bmad_flutter-2026-06-13/addendum.md
  - architecture.md
  - epics.md
uxIncluded: false
---

# Implementation Readiness Assessment Report

**Date:** 2026-06-13
**Project:** bmad_flutter

## Document Inventory

| Type | File | Status |
|------|------|--------|
| PRD | `prds/prd-bmad_flutter-2026-06-13/prd.md` (10.5KB) | Included |
| PRD Addendum | `prds/prd-bmad_flutter-2026-06-13/addendum.md` (2.8KB) | Included (reference) |
| Architecture | `architecture.md` (27KB) | Included |
| Epics & Stories | `epics.md` (20.7KB) | Included |
| UX | — | Not present (user approved proceeding without UX) |

**Reference (non-assessed):** `prfaq-bmad_flutter.md`, `prfaq-bmad_flutter-distillate.md`

**Issues at discovery:**
- No duplicate document formats found.
- UX design document absent — assessment proceeds without UX alignment checks per user approval.

## PRD Analysis

### Functional Requirements (Total: 23, grouped FG1–FG5)

**FG1. 쇼케이스 박물관 셸 (로비 & 진행)**
- FR1: 앱 진입 시 쇼케이스 박물관 로비(메인 화면)를 표시. 로비는 모든 스테이지 발현물의 합작품이며 학습 진도가 시각적으로 드러남.
- FR2: 로비에서 8개 전시실(스테이지) 각각으로 진입하는 내비게이션 제공.
- FR3: 스테이지 진행은 순차 잠금/해제 — 직전 스테이지 클리어 시 다음 스테이지 해제. [ASSUMPTION]
- FR4: 각 스테이지의 클리어/잠금 상태를 추적하고 로비에 반영.

**FG2. 실험실 → 발현 공통 루프**
- FR5: 모든 스테이지는 공통 실험실 레이아웃(상단 결과 미리보기 + 하단 조작 패널). 조작 시 즉각 피드백.
- FR6: 학습 조건 충족 시 "발현하기" 액션 노출, 실행 시 산출물을 로비에 발현.
- FR7: 발현 시 클리어 연출. [ASSUMPTION] MVP는 단순 스케일/페이드.
- FR8: 영역별 서로 다른 인터랙션(슬라이더/토글/드래그/시나리오/자유)으로 반복 피로 방지.

**FG3. 3종 플랫폼 비교 (킬링 포인트)**
- FR9: 레이아웃·컴포넌트·애니메이션 스테이지에서 Material/Cupertino/Custom 3종 동시 렌더링(스플릿 뷰).
- FR10: 동일 위젯의 플랫폼별 차이 체험(ripple vs opacity, bouncing vs clamping).
- FR11: 조작 속성값이 3종 렌더링에 실시간 동시 반영.

**FG4. 튜닝값 영속 & 발현 (킬링 포인트)**
- FR12: Custom 탭 튜닝값이 로비 발현물에 영구 반영. [ASSUMPTION]
- FR13: 모든 튜닝값·진행 상태는 앱 재시작 후에도 유지(영속성).
- FR14: 발현 후 재입장해 튜닝값 재조정 가능, 변경은 로비에 재반영.
- FR15: 3종 비교 스테이지는 iOS/Material/Custom 프리셋 적용 및 리셋 제공.

**FG5. 스테이지별 학습 콘텐츠**
- FR16: (Stage 1 레이아웃) 슬라이더 실험실 — Container/Row/Column/Stack/Padding/Expanded/Wrap·Grid. 발현물: 로비 기본 골격.
- FR17: (Stage 2 컴포넌트) 토글 비교 — Button/Switch/Slider/TextField/NavBar/Dialog·Sheet. 발현물: 전시실 입구 버튼·카드.
- FR18: (Stage 3 애니메이션) 드래그로 Curve/Duration 조작. 발현물: 로비 진입 전환 애니메이션.
- FR19: (Stage 4 상태관리) setState/Provider/Riverpod 시나리오 + 리빌드 카운터. [ASSUMPTION] 히트맵은 stretch. 발현물: 실시간 학습 진도 카운터.
- FR20: (Stage 5 제스처) 제스처 타입 실시간 확인 + gesture arena 실험. 발현물: 스와이프로 전시실 이동.
- FR21: (Stage 6 알림) 로컬 알림 구성→발송→타임라인. iOS 권한 플로우. 발현물: 리마인더.
- FR22: (Stage 7 보안) 생체인증·키체인·앱 잠금 + 일반 vs 키체인 저장 시각화. 발현물: 앱 잠금 화면.
- FR23: (Stage 8 데이터 저장) 토글로 저장 방식 비교. 발현물: 재시작 후 튜닝값 유지(영속성 자기 증명).

### Non-Functional Requirements (Total: 6)

- NFR1: 폼팩터 — iOS 모바일 단일 surface, Xcode 실기기 직접 빌드(App Store 미사용).
- NFR2: 네이티브 접근 — 생체인증·키체인·로컬 알림 등 모든 네이티브 기능 사용 가능.
- NFR3: 영속성 — 진행 상태·튜닝값 로컬 영속 저장(클라우드/계정 불필요).
- NFR4: 즉각 피드백 — 모든 실험실 조작은 지연 없이 미리보기 반영.
- NFR5: 환경 셋업 최소화 — 한 번 셋업으로 끝까지 진행.
- NFR6: 단순성 우선 — 초보 단독(+AI) 3-4주 완주 가능 복잡도.

### Additional Requirements & Constraints

- Out of Scope: App Store 배포, 다중 사용자, 계정/로그인, 클라우드 동기화, Web/Android, 전 스테이지 3종 비교, 24스테이지, 리빌드 히트맵 풀 오버레이.
- 3종 비교는 Stage 1·2·3에만 적용(나머지 미적용).
- Risks: R1 스플릿 뷰 동시 렌더링(MaterialApp+CupertinoApp, PoC 필수, Stage 1이 생사 결정), R2 첫 쾌감까지 거리, R3 AI 협업 디버깅 한계, R4 무료 Apple 계정 7일 재설치 제약.
- 빌드 순서(addendum): 로비 인프라 → Stage 1 레이아웃 → 데이터 저장(영속성) → 나머지.

### PRD Completeness Assessment

- FR/NFR 번호 체계 일관, 스테이지별 발현물 명시. 추적성 양호.
- 열린 질문 4개는 아키텍처/UX로 이월(비차단)으로 명시됨.
- UX 문서 부재 — FR5/FR7/FR19 등 "시나리오 체험" UI 플로우, 발현 애니메이션 형태는 PRD에서 ASSUMPTION/이월 상태. Epics가 이를 어떻게 흡수했는지 검증 필요.

## Epic Coverage Validation

### Coverage Matrix

| FR | PRD 요구사항(요약) | Epic/Story 커버리지 | 상태 |
|----|------|------|------|
| FR1 | 로비 메인 화면 표시 | Epic1 / Story 1.1 | ✓ Covered |
| FR2 | 8개 전시실 내비게이션 | Epic1 / Story 1.2 | ✓ Covered |
| FR3 | 순차 잠금/해제 | Epic1 / Story 1.2 | ✓ Covered |
| FR4 | 클리어/잠금 상태 추적·반영 | Epic1 / Story 1.2 | ✓ Covered |
| FR5 | 공통 실험실 레이아웃·즉각 피드백 | Epic1 / Story 1.3, 1.5 | ✓ Covered |
| FR6 | "발현하기" 액션 | Epic1 / Story 1.3 (+전 스테이지) | ✓ Covered |
| FR7 | 발현 연출(스케일/페이드) | Epic1 / Story 1.3 | ✓ Covered |
| FR8 | 인터랙션 변주 | Epic1 / Story 1.3 (Epic2-4 실현) | ✓ Covered |
| FR9 | 3종 동시 렌더링(스플릿 뷰) | Epic1 / Story 1.6 (2.1, 2.2 재사용) | ✓ Covered |
| FR10 | 플랫폼별 차이 체험 | Epic1 / Story 1.6 (2.1, 2.2) | ✓ Covered |
| FR11 | 실시간 동시 반영 | Epic1 / Story 1.6 (2.1, 2.2) | ✓ Covered |
| FR12 | Custom 튜닝값 영구 발현 | Epic1 / Story 1.7 (2.1, 2.2) | ✓ Covered |
| FR13 | 재시작 후 유지(영속성) | Epic1 / Story 1.4 (+ 4.3) | ✓ Covered |
| FR14 | 재입장 튜닝 재조정 | Epic1 / Story 1.7 | ✓ Covered |
| FR15 | 프리셋 적용·리셋 | Epic1 / Story 1.7 (2.1, 2.2) | ✓ Covered |
| FR16 | Stage1 레이아웃 슬라이더 | Epic1 / Story 1.5 | ✓ Covered |
| FR17 | Stage2 컴포넌트 토글 비교 | Epic2 / Story 2.1 | ✓ Covered |
| FR18 | Stage3 애니메이션 드래그 | Epic2 / Story 2.2 | ✓ Covered |
| FR19 | Stage4 상태관리 리빌드 카운터 | Epic3 / Story 3.1 | ✓ Covered |
| FR20 | Stage5 제스처 자유 구성 | Epic3 / Story 3.2 | ✓ Covered |
| FR21 | Stage6 알림 권한 플로우 | Epic4 / Story 4.1 | ✓ Covered |
| FR22 | Stage7 보안 생체인증·키체인 | Epic4 / Story 4.2 | ✓ Covered |
| FR23 | Stage8 데이터 저장 비교 | Epic4 / Story 4.3 | ✓ Covered |

**NFR 추적:** NFR1·NFR5 → Story 1.1 AC; NFR2 → Story 4.1/4.2 AC; NFR3 → Story 1.4 AC; NFR4 → Story 1.3/1.5/2.2 AC. NFR6(3-4주 복잡도)는 에픽 수(4)·스토리 수(12)로 간접 반영.

**Additional Requirements 추적:** AR1(스플릿 뷰 PoC) → Story 1.6 AC 명시; AR2(영속 인프라) → Story 1.4; AR3(발현 파이프라인) → Story 1.4; AR4(빌드 순서) → Epic 1 구성 반영; AR5(7일 제약) → 문서화됨.

### Missing Requirements

- 누락된 FR 없음. PRD 23개 FR 전부 에픽/스토리에 추적 가능.
- 에픽에만 있고 PRD에 없는 FR 없음(역방향 정합성 OK).

### Coverage Statistics

- Total PRD FRs: **23**
- FRs covered in epics: **23**
- Coverage percentage: **100%**

### 관찰 사항 (다음 단계에서 심층 검증)

- UX 문서 부재 → FR7 발현 연출, FR19/FR21 "시나리오 체험" UI 세부는 스토리 AC에 원칙 수준으로만 반영됨. 구현 시 디테일 모호성 가능(차단은 아님, 추적성은 충족).
- FR8(인터랙션 변주)은 Story 1.3에서 "설계 원칙"으로 잡고 각 스테이지에서 실현 — 분산 충족 구조이므로 스토리 품질 단계에서 각 스테이지 AC 확인 필요.

## UX Alignment Assessment

### UX Document Status

**Not Found** — `*ux*.md` 패턴에 해당하는 문서 없음. 사용자가 UX 없이 진행에 동의함(Step 1).

### UX Implied?

**예 — UI 강하게 함의됨.** PRD 전체가 사용자 대면 인터랙티브 학습 앱:
- 실험실 인터랙션: 슬라이더/토글/드래그/시나리오/자유 구성 (FR5, FR8, FR16~FR23)
- 3종 스플릿 뷰 동시 렌더링 레이아웃 (FR9~FR11)
- 발현 연출(스케일/페이드)·전환 애니메이션 (FR7, FR18)
- 로비 성장 시각화·순차 잠금 UI (FR1~FR4)

### Alignment Issues

- **UX ↔ PRD:** PRD가 인터랙션 방식을 텍스트로 기술했으나, 구체적 화면 레이아웃·플로우·연출 디테일은 PRD가 명시적으로 "UX 단계로 이월"(prd.md 열린 질문). 현재 그 UX 산출물이 비어 있음.
- **UX ↔ Architecture:** architecture.md가 스플릿 뷰 위젯 트리 등 기술 구조를 다루지만, UX 산출물이 없어 "아키텍처가 UX를 충족하는가"의 직접 대조는 불가. PRD/에픽 AC를 대리 기준으로 사용함.

### Warnings

- ⚠️ **W1 (Medium):** UX 문서 부재. PRD가 명시적으로 UX로 이월한 항목 — "시나리오 체험"(FR19/FR21/FR22) UI 플로우, 발현 애니메이션 구체 형태(FR7) — 이 정의되지 않음. 에픽 AC는 원칙 수준으로만 흡수. **차단은 아님**(개인 학습 프로젝트, 사용자 동의), 단 구현 중 화면 디테일 결정이 즉흥적이 될 수 있음.
- ⚠️ **W2 (Low):** 스플릿 뷰(FR9)의 3종 동시 표시 화면 배치(세로 3분할? 탭? 스크롤?)가 UX/아키텍처 어디에도 확정되지 않음 → Story 1.6 PoC에서 함께 결정 권장.
- ✅ 완화 요인: epics.md가 UX 부재를 명시적으로 인지하고 "인터랙션 변주 원칙을 스토리 AC에 반영"한다고 선언. PRD도 해당 항목을 비차단 이월로 분류.

## Epic Quality Review

### Best Practices Compliance Checklist

| 기준 | 결과 |
|------|------|
| 에픽이 사용자 가치 전달 (기술 마일스톤 아님) | ✅ Pass |
| 에픽 독립성 (Epic N이 Epic N+1 불요) | ✅ Pass |
| 스토리 적정 크기 | ✅ Pass |
| 전방 의존성 없음 | 🟡 경미한 소프트 참조 1건 |
| DB/엔티티 적시 생성 | ✅ Pass (영속 인프라 Story 1.4에서 최초 필요 시점에 생성) |
| 명확한 AC (Given/When/Then) | ✅ Pass (일부 주관적 표현) |
| FR 추적성 유지 | ✅ Pass (모든 AC에 FR 태그) |
| 스타터 템플릿 정합 | ✅ Pass (arch=flutter create, Story 1.1 일치) |

### Epic 구조 검증 (사용자 가치 & 독립성)

- **Epic 1** "박물관 로비와 첫 실험실 — 핵심 루프 검증": 완결된 수직 슬라이스(앱 열기→만지기→비교→발현→영속). 단독으로 사용자 가치 전달. ✅
- **Epic 2** "비교형 실험실 확장": Epic 1의 shared 3종 비교 프레임 재사용. 전방 참조 없음. ✅
- **Epic 3** "체험형 실험실": Epic 1 인프라만 의존, 3종 비교 미사용 영역을 올바르게 분리. ✅
- **Epic 4** "iOS 네이티브 실험실": Epic 1 의존, 네이티브 어댑터 추가로 박물관 완성. ✅
- 기술 전용 에픽(예: "DB 셋업", "API 개발") **없음**. 모든 에픽이 사용자 체험 중심. ✅
- 순환/전방 에픽 의존성 **없음**. ✅

### 스토리 품질 & 의존성 분석

- Epic 1 스토리 체인(1.1→1.7) 모두 직전 산출물만 사용, 미래 스토리 역참조 없음(아래 경미 사항 제외).
- 모든 스토리가 BDD(Given/When/Then) 구조 + FR/NFR 태그로 추적 가능.
- 영속 계층(shared_preferences)은 Story 1.4에서 최초 필요 시점에 도입 — "upfront 전체 생성" 안티패턴 회피. ✅
- 그린필드 셋업 스토리(1.1) 존재, `flutter create` 명령까지 구체화. ✅

### 🔴 Critical Violations

- 없음.

### 🟠 Major Issues

- 없음.

### 🟡 Minor Concerns

- **M1 (소프트 전방 참조):** Story 1.2 AC에 "이후 Story 1.4의 영속 인프라로 저장될 수 있도록 단일 진도 상태로 관리"라는 미래 스토리 언급. 1.2는 1.4 없이도 완료 가능(세션 내 동작)하므로 **차단 아님**. 단 순수 독립성 관점에선 해당 문구를 "단일 진도 상태로 관리"로 일반화 권장.
- **M2 (스토리 순서 vs 아키텍처 시퀀스 불일치):** epics.md는 Story 1.3(발현 파이프라인) → 1.4(영속 인프라) 순. 반면 architecture.md "Implementation Sequence"는 1.4(영속) → 1.3(발현 프레임) 순 권장. 발현 파이프라인의 "재시작 후 유지"까지 완전 실현하려면 영속이 선행되는 편이 자연스러움. 구현 시 1.4를 1.3 직전/병행으로 당기는 것 고려. (세션 내 발현은 1.4 없이도 가능하므로 비차단)
- **M3 (주관적 AC 표현):** "지연 없이"(Story 1.3/1.5), "한눈에 비교"(1.6) 등 일부 AC가 비계량적. 학습 프로젝트 특성상 허용되나, 가능하면 "조작→미리보기 반영 16ms/1프레임 내" 같은 검증 가능 기준으로 구체화 가능.
- **M4 (분산 충족 FR8):** FR8(인터랙션 변주)이 Story 1.3에서 "설계 원칙"으로만 잡히고 실현은 각 스테이지(Epic 2-4)에 분산. 각 스테이지 AC가 고유 인터랙션을 명시하므로 추적성은 충족하나, 단일 스토리로의 완결 검증은 불가한 구조.

### 종합

에픽/스토리 구조는 **매우 견고**. Critical/Major 위반 0건. 4개 경미 사항은 모두 비차단이며 개인 학습 프로젝트 맥락에서 수용 가능. 특히 Epic 1을 "수직 슬라이스 + 스플릿 뷰 PoC 조기 검증"으로 설계한 점이 PRD의 R1/R2 리스크 완화 전략과 정확히 일치.

## Summary and Recommendations

### Overall Readiness Status

**READY** (조건부 — 비차단 권고 반영 권장)

근거: PRD↔Epics FR 추적성 100%(23/23), PRD/NFR/AR↔Architecture 파일 수준 매핑 완료, 에픽 품질 Critical/Major 위반 0건. 발견된 이슈는 모두 경미(Minor) 또는 비차단 경고(Warning)이며, 사용자가 UX 부재로 진행에 동의함.

### 발견 사항 집계

| 심각도 | 건수 | 항목 |
|--------|------|------|
| 🔴 Critical | 0 | — |
| 🟠 Major | 0 | — |
| 🟡 Minor | 4 | M1 소프트 전방참조, M2 스토리 순서 vs 아키텍처 시퀀스, M3 주관적 AC, M4 분산 충족 FR8 |
| ⚠️ Warning | 2 | W1 UX 문서 부재(Medium), W2 스플릿 뷰 화면 배치 미확정(Low) |

### Critical Issues Requiring Immediate Action

- **없음.** 구현 착수를 차단하는 이슈는 발견되지 않음.

### 구현 전 최우선 검증 (차단은 아니나 프로젝트 생사 직결)

- 🔴 **R1 / AR1 스플릿 뷰 PoC (Story 1.6):** MaterialApp+CupertinoApp 한 화면 공존은 PRD·아키텍처 공통으로 "프로젝트 생사 결정" 요소. 아직 실증되지 않음(설계·폴백만 완비). **Epic 1에서 최우선으로 조기 검증**하고 실패 시 폴백(패널별 App 중첩) 적용 후 결과 기록할 것.

### Recommended Next Steps

1. **(권장, 비차단) M2 반영:** 구현 순서를 아키텍처 시퀀스에 맞춰 Story 1.4(영속 인프라)를 1.3 직전/병행으로 당겨 발현 파이프라인의 "재시작 후 유지"까지 완전 실현. epics.md 스토리 순서 주석 정렬.
2. **(권장, 비차단) W1/W2 완화:** 본격 구현 전, 적어도 "시나리오 체험"(FR19/21/22) UI 플로우와 스플릿 뷰 3종 화면 배치(세로 3분할/탭/스크롤)를 Story 1.6 PoC 단계에서 함께 확정. 필요 시 경량 `bmad-ux` 산출물 작성.
3. **(선택) M1/M3 정리:** Story 1.2 AC의 1.4 직접 언급을 "단일 진도 상태로 관리"로 일반화, 주관적 AC("지연 없이")를 가능한 곳에서 1프레임/16ms 등 계량 기준으로 구체화.
4. **착수:** 위 반영 여부와 무관하게 Story 1.1(`flutter create --org com.sy --platforms=ios bmad_flutter`) → Story 1.6 PoC 순으로 구현 시작 가능.

### Final Note

본 평가는 **2개 카테고리(UX 정렬, 에픽 품질)에 걸쳐 6건의 이슈(Minor 4 + Warning 2)**를 식별했으며, **Critical/Major 이슈는 0건**입니다. 차단 요소가 없으므로 현 상태로 구현에 착수할 수 있습니다. 다만 R1 스플릿 뷰 PoC를 가장 먼저 검증하고, 위 권고를 반영하면 구현 중 즉흥적 결정 리스크를 더 줄일 수 있습니다.

---

**Assessment Date:** 2026-06-13
**Assessor:** Winston (System Architect) — bmad-check-implementation-readiness
**Documents Assessed:** PRD (+addendum), Architecture, Epics & Stories (UX 부재, 사용자 동의)
