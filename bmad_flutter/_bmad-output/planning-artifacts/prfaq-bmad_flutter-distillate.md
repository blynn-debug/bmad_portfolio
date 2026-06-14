---
title: "PRFAQ Distillate: bmad_flutter"
type: llm-distillate
source: "prfaq-bmad_flutter.md"
created: "2026-06-13"
purpose: "Token-efficient context for downstream PRD creation"
---

## Product Identity

- **Name:** Flutter Showcase Museum
- **One-liner:** Material과 iOS를 나란히 비교하고, 내 손으로 튜닝한 값이 그대로 앱이 되는 학습 도구
- **Concept type:** 개인 학습 도구 (비상업, 1인 사용)
- **Target user:** Flutter/iOS 초보 개발자 (개발자 sy 본인)
- **Core pain:** 기존 Flutter 학습이 "읽고 따라치기"뿐이라 플랫폼 차이를 체감 못하고, 귀찮아서 학습 자체를 포기함
- **Positioning:** "0에서 1로" — Flutter 마스터가 아니라 감 잡기. 다음 앱을 만들고 싶게 만드는 출발점

## Killing Points (Differentiators)

- **3종 플랫폼 비교:** Material / Cupertino / Custom을 스플릿 뷰로 동시 렌더링 — DartPad, Widgetbook, Flutter Gallery(아카이브됨) 어디에도 없음
- **내 튜닝값이 앱이 됨:** 실험실에서 조작한 속성값이 쇼케이스 로비에 영속적으로 반영 — 어떤 모바일 생태계에도 없는 "탐색이 곧 건설" 모델
- **3종 비교 적용 범위:** 레이아웃, 컴포넌트, 애니메이션에만. 상태관리/제스처/알림/보안/데이터 저장에는 미적용 (카오스 엔지니어링으로 검증)

## Scope & Architecture

- **8개 영역 × 1스테이지 = 총 8개** (24개에서 극압축)
- **스테이지 매트릭스:**
  - Stage 1: 레이아웃 — 슬라이더 실험실, 3종 비교 ✅, 튜닝 저장 ✅, 쉬움
  - Stage 2: 컴포넌트 — 토글 비교, 3종 비교 ✅, 튜닝 저장 ✅, 쉬움
  - Stage 3: 애니메이션 — 드래그 조작, 3종 비교 ✅, 튜닝 저장 ✅, 보통
  - Stage 4: 상태관리 — 시나리오 체험 (히트맵), 보통
  - Stage 5: 제스처 — 자유 구성, 쉬움
  - Stage 6: 알림 — 시나리오 체험 (권한 플로우), 보통
  - Stage 7: 보안 — 시나리오 체험 (인증 플로우), 도전
  - Stage 8: 데이터 저장 — 토글 비교, 튜닝 저장 ✅ (자기 자신), 보통
- **발현 맵:** 각 스테이지 클리어 시 로비에 발현 — 골격 → 버튼 → 애니메이션 → 진도 카운터 → 스와이프 내비 → 알림 → 잠금 → 영속성
- **인터랙션 변주:** 영역별로 다른 인터랙션 방식 (슬라이더/토글/드래그/시나리오/자유)
- **앱 구조:** 쇼케이스 박물관 메타포 — 로비(메인 화면) + 8개 전시실(실험실)

## Competitive Intelligence

- Flutter Gallery 2024년 아카이브 — 위젯 쇼케이스 공백
- Flutter 2026년 Material/Cupertino 코어 분리 진행 중 — 이 분리를 가르치는 도구 부재
- DartPad: 코드 에디터, 인터랙티브 속성 조작 불가
- Widgetbook: 개발자 도구, 학습 목적 아님, knobs 있지만 교육 내러티브 없음
- Swift Playgrounds: 가장 가까운 유사 사례지만, "탐색이 곧 앱" 모델 아님
- 어떤 모바일 생태계에도 side-by-side 디자인 시스템 비교 + 인터랙티브 속성 조작 + 탐색-건설 융합을 결합한 도구 없음

## Technical Risks & Constraints

- **스플릿 뷰 동시 렌더링:** MaterialApp + CupertinoApp 한 화면에 공존시키는 위젯 트리 분리 필요 — PoC 필수
- **리빌드 히트맵:** Flutter 렌더링 파이프라인 훅 필요, 초보 프로젝트 범위 초과 가능 — 단순 리빌드 카운터로 대체 고려
- **배포:** Xcode 실기기 직접 빌드, 무료 계정 7일 재설치 제약
- **AI 의존:** Claude Code가 구현 돕지만, 디버깅 시 코드 이해 한계 존재

## Build Strategy

- **빌드 순서:** 로비 인프라 → 레이아웃 실험실 (킬링 포인트 검증) → 데이터 저장 → 나머지 스테이지
- **타임라인:** 3-4주 (AI 협업 전제)
- **핵심 마일스톤:** 스테이지 1 완성 = 프로젝트 생사 결정. 핵심 루프(만지기→비교→발현) 동작 확인
- **역할 분담:** AI=구현/구조, sy=체험/미감 판단/환경 셋업

## Rejected Alternatives & Decisions

- Web-only 배포 → 거부: 네이티브 기능(생체인증, 키체인, 알림) 체험 불가
- 24개 스테이지 → 거부: 스코프 폭발, "한번에 만든다" 제약 위반
- 모든 스테이지에 3종 비교 → 거부: 의미 없는 영역(상태관리, 제스처)에 과적용
- 동일 인터랙션 패턴 → 거부: 반복 피로 유발
- 감성적/짧은 헤드라인(A안) → 거부: 킬링 포인트 둘 다 담는 구체적 차별화 선호
- 추상적 비전 인용구 → 거부: 구체적 체감("3시간 읽기 vs 3분 만지기") 선호

## Success Criteria

- 8개 스테이지 완주, 로비 완전체
- Row/Column 차이를 설명 없이 이해
- Material/Cupertino 느낌 차이를 기억
- setState vs Provider 차이를 히트맵으로 기억
- "다음 앱을 만들고 싶다"는 동기 생성 (궁극적 성공 기준)

## Verdict Summary

- **Forged:** 킬링 포인트 명확성, 스코프 절제, 정직한 포지셔닝, 스테이지 1 전략, 타이밍
- **Needs heat:** 스플릿 뷰 PoC, 인터랙션 변주 구체화, 발현 애니메이션 쾌감 설계
- **Cracks:** 첫 쾌감까지의 거리 (인프라 선행 필요), 리빌드 히트맵 난이도

## Open Questions

- MaterialApp + CupertinoApp 동시 렌더링의 구체적 위젯 트리 구조는?
- "시나리오 체험" 인터랙션의 구체적 UI/플로우는?
- 발현 애니메이션의 구체적 형태 (파티클? 스케일? 사운드?)
- 리빌드 히트맵을 MVP에서 유지할 것인가, 카운터로 대체할 것인가?
- 레이아웃 실험실을 로비 인프라 없이 독립 실행 가능하게 만들 것인가?
