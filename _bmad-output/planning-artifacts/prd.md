---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-02b-vision', 'step-02c-executive-summary', 'step-03-success', 'step-04-journeys', 'step-05-domain', 'step-06-innovation-skipped', 'step-07-project-type', 'step-08-scoping']
visionInsights:
  metaVision: 'blynn을 "부동산 핀테크 도메인 전문 프로덕트 개발자"로 포지셔닝 → 1개월 내 단가 1,000만원+, 프롭테크 공고 2건 계약, 미팅 2건 대기, 꾸준한 고객 확보'
  toolVision: 'NPL 마켓은 메타 Vision의 증거물(Proof of Work). Meta 토글로 SaaS층 / 포트폴리오 심사층 이중성 구현'
  delightMoment: 'Calculator Dance + Rights Cascade — "계산기가 아니라 의사결정 지원 시스템" 체감'
  coreInsight: '친밀성(B2C UX) × ERP 역량(B2B 복잡도) 동시 구현. 현직자 디테일을 프로덕트 레벨로 코드화하는 것만이 정보 비대칭을 해소'
  realProblem: '(A) 발주자의 "도메인×프로덕트 겸비자" 탐색 실패 + (C) 바이브 코딩 홍수 속 일반 풀스택 차별화 실패'
  whyNow: '외주 공고 9건 동시 존재 + 바이브 코딩 도구 성숙 + 기존 자산(계산기 v3.1·지도·크롤러) 검증 완료'
scopeChanges:
  - 'Web3/블록체인 NPL 마켓에서 제외. C 페르소나(Web3 커뮤니티) 제외 → 타겟 독자 2명(B: 프롭테크, A: 법무법인)'
  - 'blynn 포지션 = "부동산 핀테크 도메인 전문 프로덕트 개발자" (블록체인 "전문" 문구 삭제)'
  - '"90% 커버 기술스택"은 Operating Principle(NFR·내부 효율)이지 About 세일즈 메시지 아님'
classification:
  projectType: 'web_app'
  projectTypeSecondary: 'saas_b2b'
  domain: 'fintech'
  domainAdjacent: 'legaltech'
  complexity: 'high (domain) / medium (implementation)'
  projectContext: 'greenfield'
  reusedAssets:
    - 'NPL 계산기 Apps Script v3.1 (검증 로직)'
    - 'nodajimap (지도 표시 경험)'
    - '경매·온비드 크롤링 스크립트'
  metaLayer: '포트폴리오 ↔ SaaS 이중성 (Meta 토글로 물리적 분리)'
inputDocuments:
  - _bmad-output/brainstorming/brainstorming-session-2026-04-20-1410.md
  - _bmad-output/planning-artifacts/research/market-portfolio-positioning-research-2026-04-20.md
  - _bmad-output/planning-artifacts/research/npl-calculator-logic-v3.1.gs
referenceLinks:
  - label: 'NPL 김대리 블로그 (기존 교양 콘텐츠 채널)'
    url: 'https://blog.naver.com/npl_kim'
    role: '교양 콘텐츠 축 제외 근거 — 기존 채널에서 커버되므로 포트폴리오에서 중복 제거'
existingAssets:
  - name: 'NPL 채권 시뮬레이션 v3.1 (Google Apps Script)'
    path: '_bmad-output/planning-artifacts/research/npl-calculator-logic-v3.1.gs'
    status: '검증 완료 (김대리 승인 로직)'
    role: '계산기 핵심 로직의 Next.js 포팅 원본 — 개발 리스크 대폭 감소'
documentCounts:
  briefs: 0
  research: 2
  brainstorming: 1
  projectDocs: 0
  referenceLinks: 1
  existingAssets: 1
workflowType: 'prd'
projectType: 'greenfield'
designPrinciples:
  ui: '사용자 친밀성 최우선 + 프로덕트에 대한 고민이 느껴지는 디테일'
  calculator: '직관적·친화적 UI + ERP 수준의 복합 업무 처리 역량이 드러나는 설계 (킬러 축)'
---

# Product Requirements Document - NPL 마켓

**Author:** blynn
**Date:** 2026-04-20

## Executive Summary

**NPL 마켓**은 NPL(부실채권) 정보 매칭 허브를 표방하는 웹 플랫폼이자, **blynn을 "부동산 핀테크 도메인 전문 프로덕트 개발자"로 포지셔닝하는 외주 수주용 영업 무기(Proof of Work)**다.

한 URL에 두 모드가 공존한다. **Meta 토글 OFF**는 경매·공매·신탁공매 매물 탐색, 배당 NPL 채권계산기, L2+ 검증 회원 전용 현직자 커뮤니티로 구성된 SaaS 사용자 체험층이다. **Meta 토글 ON**은 각 기능에 "왜 이 선택?" 주석 11개가 aside로 펼쳐지는 포트폴리오 심사층이다. 이 이중 구조가 "프로덕트 완성도"와 "설계 의도"를 동시에 증명한다.

**타겟 독자는 외주 발주자 2명**: ① 프롭테크 대표(1순위), ② 법무법인 파트너(2순위). 1개월 성공 지표는 **프롭테크 공고 2건 계약 체결, 단가 1,000만원+ 확보, 미팅 2건 대기, 꾸준한 고객 확보**다.

**해결하는 진짜 문제**: 바이브 코딩 개발자가 포화된 시장에서 발주자는 "도메인 × 프로덕트 역량 겸비자"를 이력서·깃허브로 판별할 수 없다. 이 정보 비대칭은 **현직자만 아는 실무 디테일을 프로덕트 레벨로 코드화**할 때만 해소된다.

**4일 MVP + 제로 버퍼** 제약에서 실행 가능한 것은, 검증된 기존 자산 3종(NPL 계산기 Apps Script v3.1, nodajimap 지도 경험, 경매·온비드 크롤링)을 Next.js + Supabase + 카카오맵 스택으로 재조립하기 때문이다.

### What Makes This Special

**배당 NPL 채권계산기가 Delight Moment다.** 입력 15필드 · 출력 25필드+ 규모의 복잡도를 원클릭 프리셋(1회 유찰·방어입찰·재매각) · 실시간 Rights Cascade · Calculator Dance 애니메이션으로 감싼다. 발주자가 "이건 계산기가 아니라 **ERP 수준 의사결정 지원 시스템**"이라고 인식하는 순간이 설계 목표다. **B2C 친밀성 × B2B 복잡도를 한 화면에 성립시키는 것**이 핵심.

코드에 박힌 현직자 시그널이 Meta 토글 주석을 자동 공급한다. 채권최고액 Cap(`Math.min(claim, maxBond)`), 질권대출금 100만원 단위 절사, 두 개의 시간축(실투자기간 vs 이자발생기간), 세 종류 수익률(기간·이자포함·연환산), 지역별 소액임차 한도 자동 반영, 당해세 최우선 배당순서 — 각 한 줄이 주석 하나의 근거가 된다.

법·규제 대응은 **UI 체크박스와 배너의 단어 선택**에 담긴다. "거래"를 "정보 매칭"으로, "가입 승인"을 "대부업법 L2 적격성 자진 확인"으로 리프레이밍하는 카피 차이가 회색지대를 우회한다. **선별이 곧 설계 역량**임을 Meta 주석 11번("왜 교양 콘텐츠 축이 없는가")이 명시적으로 증명한다.

## Project Classification

- **Project Type**: `web_app` (주) + `saas_b2b` 특성 (3-tier RBAC + Admin 승인 + 대부업체 매물 등록 폼)
- **Domain**: `fintech` (주) + `legaltech` 인접 (권리분석·말소기준권리·판례 기반 양편넣기 로직·사건번호 체계). **Web3/블록체인은 제외** (C 페르소나 탈락, blynn 포지션도 "부동산 핀테크"로 집중).
- **Complexity**: `high` (도메인: 대부업법·자본시장법 경계) / `medium` (구현: 포트폴리오 전용, 실 결제·실 거래 없음)
- **Project Context**: `greenfield` — 단, 검증된 기존 자산 3종 재활용 (계산기 Apps Script v3.1 · nodajimap · 크롤링 스크립트)
- **Meta-Layer**: 포트폴리오 ↔ SaaS 이중성을 Meta 토글로 물리적 분리

## Success Criteria

### User Success

**주연은 하나다. Primary = 외주 발주자. Secondary는 Primary를 설득하는 증거물이지, 독립된 실사용 대상이 아니다.**

**Primary User: 외주 발주자 (B 프롭테크 대표 / A 법무법인 파트너)**

- **3초 Intent Framing 통과** — Hero 상단 얇은 스트립에 "NPL 실무자 × 핀테크 PM blynn의 작업물. 이 페이지 자체가 프로덕트 데모입니다. Meta 토글로 의사결정 주석을 보세요." 노출. "서비스야, 포트폴리오야?" 인지 혼란 차단.
- **Meta 토글 참여 KPI (재정의)**: "주석 3개 열람"이 아니라 **"Meta 토글 최소 1회 ON 전환 + ON 상태 체류 60초+"**. 숨겨진 콘텐츠 discovery rate 15~25% 현실 반영. Ambient annotation (은은한 · / "왜?" 인디케이터) + 토글 ON 시 첫 주석 자동 슬라이드인으로 discovery 보조.
- **About → 공고 매칭 표 도달 → Contact CTA 전환 가능 상태**: 심사층의 종착 지점. 이 경로가 끊기면 수주 전환 불가.

**Secondary User: NPL 마켓 시나리오 유저 (김OO 목업)**

- **성공 기준은 "실사용 완결"이 아닌 "데모 동선 dead-end 0건"**. 시나리오 3개(Hero Reveal → 계산기 프리셋 1종 → 커뮤니티 블러 배너)만 실제 작동, 나머지는 **명시적 "데모용 Placeholder" 라벨로 정직하게 노출**.
- 죽은 링크·미구현 버튼이 드러나는 순간 Primary 심사 실패로 직결. 정직한 스코프 노출이 신뢰 방어선.

### Business Success

**blynn 개인 수주 지표. 기준점 = 포트폴리오 공개가 아니라 "첫 문의 유입일"부터 측정** (한국 프리랜서 플랫폼 전환 사이클 30~41일 반영).

**1개월 (첫 문의 D+30)**
- **계약 1건 체결 + 미팅 확정 2~3건**
- **프로젝트형 공고 평균 1,500만원 / 상주형 월 1,000만원 이원화**
- **Push 채널 병행** 전제 — 콜드 DM, NPL 업계 밋업, 링크드인 등. 포트폴리오는 Pull 채널 하나일 뿐.

**2~3개월 (D+60~90)**
- **계약 2건 누적 체결** (1개월 1건 + 추가 1건)
- **재문의 의사 표명 1건+** (구두 확약 기준). "꾸준한 고객"은 정의상 이 시점부터 측정 가능.
- **신규 응대 공고 10건 기준 요구사항 매핑율 80%+**
- **수주 프로젝트 3건에서 7모듈 재사용율 70%+** (기존 "90% 커버"를 허영 지표에서 운영 가능 지표로 재정의)

**숨은 가정 대응**
- About 섹션에 **겸업/전업 가능 범위 명시** ("주 OO시간 전업 가능" 등). "NPL 현직자 = 겸업 리스크" 30% 확률 질문 대응.
- 바이브 코딩은 세일즈 메시지에서 제외 — 속도를 단독으로 팔면 할인 압력 반사. **"도메인 이해 × 구현 속도의 곱"**으로만 포지셔닝.
- NPL 공급 사이클성 시장 리스크 인지 — 공고 풀 2개월 후 1/3 감소 가능성 30%. 수주 포트폴리오 다각화 필요 시 부동산 일반(경매·프롭테크) 축으로 확장.

### Technical Success

**4일 MVP · 제로 버퍼 제약의 작동 가능 기준 (재정의).**

- **계산기 수치 정합성 — 1e-4 기준 폐기**: 샘플 5건(Cap 걸리는 케이스 / 질권 100만원 절사 경계 / 당해세 개입 / 윤년 케이스 / 단순 케이스)에 대해 **원 단위 완전 일치**. 절사·Cap은 비트 단위, 수익률은 소수점 4자리 일치.
- **날짜 연산 타임존 보정**: `date-fns-tz` + `Asia/Seoul` 명시. Vercel serverless UTC 기본 ↔ Apps Script Asia/Seoul 고정 갭 방어. 윤년·말일 처리 검증.
- **Supabase RLS 3-tier — 범위 축소**: **읽기 권한만 RLS 강제**, 쓰기는 MVP에서 admin 단일 계정(하드코딩 OK). Meta 주석에 "왜 이렇게 했는지" 명시해 스코프 선택임을 드러냄. 9가지 정책 매트릭스 전수 검증은 SHOULD.
- **Lighthouse 범위 한정**:
  - **Performance ≥ 80** — 랜딩·계산기·리스트 페이지 한정 (**지도 페이지 제외**, 카카오맵 SDK 300KB+ 동기 로드 이슈)
  - **Accessibility ≥ 90** — 전 페이지. shadcn/ui 또는 Radix 기반. 카카오맵 iframe은 `aria-label` + 대체 텍스트 리스트 뷰 병행.
- **접근성 필수 3요소 (점수 역산 아님)**:
  1. 키보드 Tab 완결성 — 계산기 15필드 순서, Meta 토글 스페이스바, aside 슬라이드인 focus trap
  2. 시맨틱 HTML + `<label for=>`, `aria-describedby`, `<main>/<aside>/<nav>` 분리. 코드 품질 시그널 자체가 심사 포인트.
  3. Focus visible + Color contrast 4.5:1. Meta aside 회색 텍스트 Figma 사전 검증 필수.
- **보안 기본선**:
  - `service_role` 키 클라이언트 번들 유입 0건 (포트폴리오 공개 저장소 기준 — 유출 시 즉시 사망)
  - RLS 정책 누락 테이블 0건 (RLS ON + 정책 없음 = 전면 차단 사고 방지)
  - Storage 버킷 RLS 별도 적용 (테이블만 잠그고 이미지 공개 고전 실수 차단)
- **데이터 출처 — 정적 스냅샷**: 법원 경매 크롤링은 **2026-04-20 기준 정적 덤프 JSON** 박제. 실시간 크롤링 미배포 (courtauction.go.kr 이용약관 방어).
- **배포 인프라**: Vercel + Supabase 무료 티어 기반. 트래픽 급증 시 정적 폴백 페이지 준비 (SHOULD).
- **카카오맵 도메인 등록**: 배포 전 Vercel 프로덕션 도메인 + preview 와일드카드(`*.vercel.app`) 허용 여부 확인. Day 4 데모 지도 안 뜨는 사고 1순위.

### Measurable Outcomes

| 영역 | 지표 | 목표 | 기한 |
|------|------|------|------|
| 비즈니스 | 계약 체결 | 1건 | 첫 문의 D+30 |
| 비즈니스 | 미팅 확정 | 2~3건 | 첫 문의 D+30 |
| 비즈니스 | 계약 누적 | 2건 | D+60~90 |
| 비즈니스 | 단가 프로젝트형 | 평균 1,500만원 | D+60~90 |
| 비즈니스 | 단가 상주형 | 월 1,000만원 | D+60~90 |
| 비즈니스 | 재문의 의사 표명 | 1건+ | D+60~90 |
| 비즈니스 | 요구사항 매핑율 (공고 10건) | 80%+ | D+90 |
| 비즈니스 | 7모듈 재사용율 (수주 3건) | 70%+ | D+90 |
| 유저-발주자 | Intent Framing 3초 통과 | 정성 관찰 | 배포 후 |
| 유저-발주자 | Meta 토글 ON 전환 | Plausible 이벤트 (SHOULD) | 배포 후 |
| 유저-발주자 | Meta ON 체류 | 60초+ | 배포 후 |
| 유저-NPL | 데모 동선 dead-end | 0건 | D+4 |
| 기술 | Lighthouse Performance | ≥ 80 (지도 제외) | D+4 |
| 기술 | Lighthouse Accessibility | ≥ 90 | D+4 |
| 기술 | 계산기 샘플 5건 정합성 | 원 단위 일치 | D+4 |
| 기술 | service_role 키 클라이언트 유입 | 0건 | D+4 |
| 기술 | RLS 정책 누락 테이블 | 0건 | D+4 |
| 기술 | Meta 토글 주석 서빙 | 11개 전부 | D+4 |

## Product Scope

### MVP - Minimum Viable Product (4일, 스코프 재조정 필요)

**⚠️ MUST 19개 → 12개 축소 권고**: 현 초안의 MUST 19개는 4일(50h)에서 항목당 2.6h로 "작동하는 척" 리스크 높음. **단단한 12개 > 피상적 19개** 원칙으로 Epic/Story 단계에서 축소 결정.

**우선 MVP 구성 (축소 후 기준)**:

- ① **매물 탐색 3탭** (경매·공매·신탁공매) + tier별 블러 (1개 탭만 실 데이터, 나머지 2개 탭은 Placeholder로 정직하게 노출)
- ② **배당 NPL 채권계산기** (Apps Script v3.1 포팅 + 프리셋 3종 + Rights Cascade + Calculator Dance + 샘플 5건 골든 테스트)
- ③ **현직자 커뮤니티 UI 목업** (3 카테고리 + 샘플 글 5건 + L2+ 게이팅 블러 배너)
- ④ **3-tier RBAC** (읽기 RLS 강제 + admin 단일 계정)
- ⑤ **Meta 토글 시스템 + 주석 11개** (First Annotation 자동 오픈 + Ambient Annotation 인디케이터 포함)
- ⑥ **랜딩 Hero + Intent Framing 스트립** (Map Breath + Live Ticker + Hero Reveal 권리분석 리포트 1건)
- ⑦ **대부업체 매물 등록 폼** (10개 필드, 실 제출은 admin 승인 없이 바로 상태 변경 — Meta 주석에 이유 명시)
- ⑧ **About + 공고 매칭 표 + 겸업/전업 범위 명시**
- ⑨ **README · BMAD PRD 공개 · 도메인 배포 · 법적 고지**
- ⑩ **계산기 Conversational Chunking + Live Calculation Shadow** (UX 패턴 2종)
- ⑪ **접근성 기본 3요소** (키보드 Tab · 시맨틱 HTML · Focus/Contrast)
- ⑫ **보안 기본선 검증** (키·RLS·Storage 체크리스트)

### Growth Features (Post-MVP — SHOULD)

- Plausible 이벤트 계측 (Meta 토글 전환율·체류 시간 실측)
- 심의서 템플릿 (.xlsx) 다운로드
- 경매방 "2024타경XXXXX" 자동 링크 파싱
- 용어사전 페이지
- 커뮤니티 L2 게이팅 배너 UX 폴리싱
- 정적 폴백 페이지 (트래픽 급증 대비)
- RBAC 쓰기 권한 정책 매트릭스 전수 검증 (9가지)
- BMAD PRD 내부 섹션 링크화
- (COULD) VBA Ghost before/after 애니메이션
- (COULD) 의사결정 로그 커밋 해시 실제 링크화
- (COULD) Admin UI로 tier 변경 시연

### Vision (Future — Post-Portfolio)

- "거래" → "의향 등록 + 외부 체결" 구조 전환 (대부업법 안전)
- 글쓰기·댓글 + 실명제 + 스팸·어뷰징 방지
- 결제·구독 / 1:1 메시지 / 알림 / 모바일 최적화
- 자동 크롤링 스케줄러
- PDF 심의서 출력
- **blynn의 7모듈 정형 스택 내부 도구화** — 외주 프로젝트 OS로 진화 (About 노출 안 함 — Operating Principle)

## User Journeys

### Journey 1 — 프롭테크 대표 B (Primary, Success Path)

**Persona**: 김대표, 42세, 대구 프롭테크 스타트업(시리즈 A) 대표. 상가 매물 관리 플랫폼 외주 공고(위시켓)에 4명 지원, blynn의 NPL 마켓 링크 포함. 오후 3시 20분, 카페에서 노트북 세 탭 열어 비교 심사 중.

**Opening (0~3초)**
Hero Map Breath 맥박 애니메이션 + Intent Framing 스트립 읽음. 감정: "깃허브 링크만 주는 다른 지원자랑 다르네." 호기심 발동, 탭 유지.

**Rising Action (3초~8분)**
- 30초~2분: Live Ticker·실 사건번호 "2024타경110044" 확인 → "진짜 데이터네." 계산기 프리셋 "1회 유찰+70%" 원클릭 → Rights Cascade 재정렬 + Calculator Dance. "업무 이해도 있다."
- 2~5분: Meta 토글 "·" 인디케이터 발견, 클릭. 첫 주석 자동 슬라이드인 — "L2는 대부업법·자본시장법 경계 반영". "법 이슈도 생각했구나."
- 5~8분: 양편넣기 주석·Supabase RLS 주석·"거래→정보 매칭" 리프레이밍 주석 3개 추가 열람. ON 체류 60초+ 달성.

**Climax**
About 섹션의 공고 매칭 표가 **자기 공고와 line-by-line 대응**: "상가 매물 관리 ↔ 매물 탐색 3탭", "사용자 등급 ↔ 3-tier RBAC". 겸업 범위 문구 확인. "내 공고를 구조적으로 읽은 사람. 다른 3명은 일반 풀스택 포폴인데 이건 맞춤."

**Resolution**
Contact CTA 클릭 → Slack DM "미팅 가능하신가요?" → 다음 날 zoom 예약.

**Revealed Capabilities**: Intent Framing 스트립 · Map Breath · Live Ticker · 실 사건번호 데이터(정적 스냅샷) · 프리셋 3종 · Rights Cascade · Calculator Dance · Meta 토글 + Ambient Annotation + First Annotation 자동 오픈 · Meta 주석 11개 · 공고 매칭 표 · 겸업 범위 명시 · Contact CTA

### Journey 2 — 프롭테크 대표 B (Primary, Edge Case: Meta 토글 미열람)

**Situation**: 같은 발주자 B, 이번엔 Meta 토글 한 번도 안 켜고 SaaS 모드로만 탐색. **OFF 경로에서도 Primary Success가 성립해야 한다는 구조적 테스트.**

**Scene**
- "공매 탭" 클릭 → **"데모용 — 현재 경매 탭만 실 데이터" Placeholder 라벨** 확인. 혼란 대신 안심. "스코프를 정확히 아는 사람."
- 커뮤니티 클릭 → L2 검증 블러 배너 "실 배포 시 스팸·어뷰징 방지 포함." 설계 고민 인지.
- 매물 등록 폼 시도 → **정직하게 "admin 계정 필요 — Meta 주석 참조"** 모달. Dead-end 아닌 경로 안내.
- About 공고 매칭 표 직진 → Contact CTA.

**Resolution**
Meta 토글은 끝까지 안 켰지만 Intent Framing + Placeholder 정직 노출로 시그널 전달 완료. → 미팅 요청.

**Lesson**: Meta 토글 ON은 Plus 옵션. **OFF 경로에서도 Primary Success가 성립**해야 한다 — 정직한 Placeholder 라벨 체계 + 구조적 매칭 표가 OFF 경로의 주역.

**Revealed Capabilities**: Placeholder 라벨 체계(모든 미구현 영역) · L2 블러 배너 UX 완성도 · admin 계정 안내 모달 · OFF 경로 단독 설득력

### Journey 3 — 법무법인 파트너 A (Primary 2순위, Mobile-First 진입)

**Persona**: 박변호사, 48세, 서울 강남 중견 로펌 파트너. 부실채권 권리분석 자동화 도구 외주 공고를 **링크드인 피드에서 blynn 태그 글로** 접함. 점심시간 스마트폰 첫 접속.

**Opening (모바일)**
URL 진입 → 반응형 기본(데스크톱 뷰 세로 늘어짐) → Hero 스트립 읽음.

**Rising Action**
- 계산기 섹션에서 **Conversational Chunking이 모바일에서도 스텝 스크롤 동선 유지**(다행히). 첫 스텝 3필드는 제대로 보임.
- 양편넣기 +1일 토글 → Meta 주석 "대법원 판례 기준" 확인. **법률가 즉각 인증**.
- Hero Reveal 권리분석 리포트 Full Writeup — 말소기준권리 · Cascade · 당해세 배당순서 실무 정확도 만족.

**Climax**
About 공고 매칭 표 "권리분석 자동화 ↔ Rights Cascade" 매핑 확인. "실무에서 원하는 자동화 요소가 POC 수준으로 돌아감."

**Resolution**
모바일 Contact 클릭 → 이메일 앱 자동 수신자 입력 → "저녁에 다시 연락드릴게요" → 저녁에 데스크톱 재방문 → Meta 토글 탐색 → 다음 날 미팅.

**Edge Risk**: 모바일 반응형은 **기본만**. Conversational Chunking이 모바일에서 "깨지지 않을 정도"만 구현하면 됨. 첫 스텝 품질 > 중간 이후 품질.

**Revealed Capabilities**: 모바일 반응형 기본(CSS breakpoint 최소) · Conversational Chunking 모바일 내성 · 판례 Meta 주석 · Hero Reveal 권리분석 리포트 Full Writeup · 모바일 Contact mailto 자동 핸들러

### Journey 4 — 김OO (Secondary, NPL 시나리오 목업 체험, dead-end 0건)

**Persona**: 김OO, 35세, 부동산 투자 경력 3년, NPL 초보. 유튜브 NPL 김대리 영상 보다 링크 타고 방문. 실사용 의사 있음. **(그러나 Success 기준은 "납득"이 아닌 "dead-end 0건".)**

**D+0 (비회원)**
- Hero Reveal 권리분석 리포트 전문 30초+ 체류. "무료로 공개하는 데가?"
- 커뮤니티 진입 시 L2 검증 블러 배너 확인. 가입 동기 발생.

**D+1~7 (L1 → 계산기 완결)**
- L1 가입 → 관심 물건 저장 시도 → **"저장 UI만 동작 — 데모" Placeholder 라벨** 정직 노출.
- 계산기 프리셋 "1회 유찰+70%" 원클릭 → **Rights Cascade 완결**. **시나리오 3개 중 1번 작동 구간 실현**. 여기가 "살아 있어야 하는 동선"의 핵심.
- L1→L2 요청 플로우 → admin 단일 계정으로 셀프 tier 승격 시연 (Meta 주석에 "admin UI 2주 공수라 범위 밖" 명시).

**D+14 (커뮤니티)**
- 경매방 샘플 글 5건 읽기 가능. 댓글·글쓰기 버튼은 **"데모용 Placeholder"** 명시 라벨. Dead-end 아님.
- 샘플 글 중 "2024타경110044 동작구 신대방동" 발견 → 계산기로 연동 → 권리분석 리포트 연결 (SHOULD 구현되면 자동 링크 파싱).

**D+30 (L3 시연)**
- 심의서 템플릿 다운로드 시도 → SHOULD 영역, MVP에선 "다운로드 준비 중" Placeholder.
- **Journey 종료. dead-end 0건 달성 = Primary 심사 신뢰 방어선 유지.**

**Revealed Capabilities**: 3 카테고리 커뮤니티 UI 목업 + 샘플 글 5건 실무자 톤 · L2+ 게이팅 블러 배너 · 계산기 프리셋 최소 1종 완결 · Placeholder 라벨 체계(저장·댓글·글쓰기·템플릿) · admin tier 승격 시연 · (SHOULD) 경매방 "2024타경XXXXX" 자동 링크 파싱

### Journey 5 — blynn (admin/operator, Operations)

**Situation**: 포트폴리오 배포 후 발주자 미팅 예약될 때마다 접속. **4일 MVP 이후 지속 운영 Journey지만, capability 측면에선 4일 내 admin 최소 동작만 필요.**

**Pre-Meeting Prep (반복 Journey)**
- admin 단일 하드코딩 계정 로그인 (JWT admin claim 주입).
- 정적 스냅샷 JSON 수정 or Supabase 직접 쿼리로 매물 1~2건 갱신.
- Meta 토글 주석 11개 중 1~2개 미팅 피드백 반영 → Markdown 편집 → 재배포.
- 미팅 직전 5분: Lighthouse 재측정 / 콘솔 에러 체크 / 데모 동선 dead-end 최종 확인.

**Post-Meeting**
- 미팅 피드백으로 About 공고 매칭 표 행 추가/교체 (공고 유형별 대응 강화).
- 견적·계약 단계는 포트폴리오 외부 (이메일·Slack·계약서).

**Meta Admin UI 관련 결정**
- **Admin UI는 MVP 범위 밖**. Meta 주석에 "admin UI 2주 공수, 실 운영 우선 구현 항목" 명시. **"스코프 선별 역량" 자체가 세일즈 시그널**.

**Revealed Capabilities**: admin 하드코딩 계정 + JWT admin claim · Supabase 직접 쿼리 접근 경로 · 정적 스냅샷 JSON 수동 업데이트 스크립트 · Lighthouse 측정 스크립트

### Journey Requirements Summary

| Capability | Journey | 우선순위 |
|---|---|---|
| Intent Framing Hero 스트립 | 1, 2 | MUST |
| Map Breath + Live Ticker | 1 | MUST |
| 실 사건번호 데이터 (정적 스냅샷) | 1, 2, 3, 4 | MUST |
| 계산기 프리셋 + Rights Cascade + Calculator Dance | 1, 2, 3, 4 | MUST |
| Conversational Chunking (모바일 내성 포함) | 1, 3 | MUST |
| Meta 토글 + Ambient Annotation + First Annotation 자동 오픈 | 1 | MUST |
| Meta 주석 11개 서빙 | 1, 2 | MUST |
| 권리분석 리포트 Full Writeup (Hero Reveal) | 1, 3, 4 | MUST |
| About 공고 매칭 표 + 겸업 범위 | 1, 2, 3 | MUST |
| Contact CTA (모바일 mailto 포함) | 1, 2, 3 | MUST |
| Placeholder 라벨 체계 | 2, 4 | **MUST (신규 강조)** |
| 3 카테고리 커뮤니티 UI 목업 + 샘플 5건 + L2 블러 | 4 | MUST |
| admin 하드코딩 + tier 승격 시연 경로 | 4, 5 | MUST |
| Supabase 직접 쿼리 + 정적 스냅샷 수동 업데이트 | 5 | MUST |
| 경매방 "2024타경XXXXX" 자동 링크 파싱 | 4 | SHOULD |
| 심의서 템플릿 (.xlsx) 다운로드 | 4 | SHOULD |
| admin UI (tier 변경·매물 관리) | 5 | Vision |

**핵심 교훈**: 각 Journey는 Secondary User(김OO)의 실사용이 아니라 **Primary User(발주자)가 김OO Journey를 "관찰"할 때 신뢰가 유지되는 수준**을 기준으로 설계. Placeholder 라벨 체계는 새 capability로 승격.

## Domain-Specific Requirements

### 도메인 컨텍스트 (재확인)

- **Primary 도메인**: `fintech` (high) — NPL 채권·배당·질권대출·대부업
- **Adjacent 도메인**: `legaltech` (high) — 권리분석·판례 기반 양편넣기·사건번호 체계
- **포트폴리오 전용 메타 조건**: 실 거래·결제·실명 수집 없음. 도메인 요구사항은 **"UI 용어·구조에 규제 인식을 담기"**가 본질. 이 선택 자체가 세일즈 시그널.

### Compliance & Regulatory (한국)

**① 대부업법**
- NPL 담보채권 양수·매매가 대부업 영위로 포섭될 수 있음
- **UI 대응**: "거래" → "정보 매칭" 전면 리프레이밍 / 가입 시 "대부업법 L2 적격성 자진 확인" 체크박스 / Footer 법적 고지 배너
- **Meta 주석 #6**: 실 배포 시 "거래" → "의향 등록 + 외부 체결" 변형 필요 명시

**② 자본시장법**
- L3 전문투자자는 금융감독원 승인 사안
- **UI 대응**: L3는 "자격 증명 업로드 + admin 승인" 시연만. Meta 주석에 "실 배포 시 금감원 등록 절차 연동" 명시

**③ 변호사법 (법무법인 독자 A 관련)**
- 권리분석이 "법률 의견·자문"으로 해석될 경우 비변호사 법률사무 대행 리스크
- **UI 대응**: 권리분석 리포트 상단 "정보 제공·참고용 — 실제 판단은 변호사 자문 필요" 배너 / "분석" 대신 "요약" 용어 / Meta 주석에 "법무법인 공고 대응 시 변호사 파트너십 구조 변형 필요" 명시

**④ 개인정보보호법 & 정보통신망법**
- 실명·주민번호·연락처 수집 시 고지·동의·저장 요건
- **MVP 대응**: **실명 수집 0건**. 이메일 + 닉네임만. L2 검증은 **"가상 체크박스"** 시연. Meta 주석에 "실 배포 시 본인인증 연동 필요성" 명시

**⑤ 신용정보법 & 금융실명법**
- 채무자 이름·주소 노출 시 위반 가능
- **MVP 대응**: **공개 사건번호 한정** (법원경매·온비드). 채무자 이름은 이니셜, 주소는 "동" 단위까지. Meta 주석에 "실 배포 시 개인정보 마스킹 정책 필요" 명시

### Technical Constraints (도메인 기반)

**보안**
- Supabase RLS 읽기 강제 (Technical Success 기준 재참조)
- `service_role` 키 클라이언트 유입 0건 / Storage 버킷 RLS 별도
- 포트폴리오 공개 저장소 기준 — `.env.example`만 공개, 실 키 유출 방지

**데이터 출처 — 공개 정보 한정**
- 법원경매 공고 · 온비드 공매 공고: 공개 정보, 사용 가능
- 신탁공매: 공개 범위 제한 → MVP는 Placeholder 라벨
- **정적 스냅샷 박제**: 2026-04-20 기준 JSON 덤프. 실시간 크롤링 미배포 (courtauction.go.kr 이용약관 방어)

**계산기 정확성**
- 채권최고액 Cap, 당해세 최우선, 지역별 소액임차 한도, 양편넣기 +1일: **법령·판례 인용 Meta 주석 필수**
- 샘플 5건 골든 테스트 (Technical Success 참조)

**권리분석 로직**
- 말소기준권리·Rights Cascade는 **2020년 개정 법 기준**
- Meta 주석에 "법 개정 시 로직 업데이트 필요 — 실 배포 시 법무 자문 계약" 명시

### Integration Requirements

**MVP에서 미구현 (Placeholder + Meta 주석)**
- 법원경매정보시스템 공식 API (유료·제휴 필요)
- 온비드 Open API (공개, Vision 단계 연동 가능)
- KIS·NICE 신용평가 (전문투자자 등록 시 필요)
- 본인인증 서비스 (PASS, 카카오 본인확인)
- 카카오 소셜 로그인

**MVP에서 사용**
- **카카오맵 API** (클라이언트 사이드, 배포 도메인 등록 필수 — Day 4 데모 사고 1순위)
- **Supabase Auth** (이메일 기반, 본인인증 미연동)
- **Plausible Analytics** (SHOULD, 개인정보 비수집)

### Risk Mitigations

| Risk | 영향 | 대응 |
|---|---|---|
| 대부업법 회색지대 | 실 서비스 시 행정처분 | "정보 매칭" 리프레이밍 + 자진 확인 + Meta #6 |
| 변호사법 회색지대 | 권리분석이 법률사무 해석 | "요약·참고용" 배너 + 변호사 자문 권고 |
| 자본시장법 L3 | 전문투자자 자격 금감원 소관 | L3 시연만, Meta 주석으로 실 등록 필요성 명시 |
| 개인정보 수집 | 고지·동의 절차 필요 | MVP는 이메일+닉네임만 |
| 채무자 정보 노출 | 신용정보법·실명법 위반 | 공개 사건번호 한정, 이니셜·부분 주소 |
| 법 개정 로직 오류 | 당해세·소액임차 변동 | Meta 주석에 법 개정 의존성 명시 |
| 크롤링 약관 위반 | robots.txt/약관 위반 | 정적 스냅샷, 실시간 크롤링 미배포 |
| 카카오맵 도메인 미등록 | Day 4 데모 지도 장애 | 배포 전 Vercel 프로덕션 + preview 와일드카드 등록 |

### Domain Pattern — 한국 NPL 특화 시그널

**실무 용어 (계산기·UI 전반 자연 노출)**
- 양편넣기, 채권최고액, 질권대출, 지역별 소액임차, 당해세 최우선, 말소기준권리, 명도난이도, 특수물건(유치권·법정지상권), 배당종기일, 배당예정일, 이자가산일, OPB, LTV, 전문투자자, 적격성 자진 확인

**사건번호 포맷 (실무 정확도 시그널)**
- 법원 경매: `2024타경{5자리}`
- 공매: `2024-{공고번호}-{물건번호}`
- 신탁공매: 신탁회사별 상이 (MVP Placeholder)

**배당순서 (2020년 개정)**
- 경매·집행비용 → **당해세** → 최우선변제(소액임차보증금·임금채권) → 저당권·전세권 → 일반채권

### 포트폴리오 특수 조건 — "규제 인식을 UI로 증명"

이 섹션의 본질은 **"실제 준수"가 아닌 "UI 용어·구조 선택에 규제 인식을 담기"**. 단어 하나("거래" → "정보 매칭")와 체크박스 하나("대부업법 적격성 자진 확인")의 차이가 발주자에게 **"규제 공부한 사람"** 신호.

**Meta 토글 주석이 도메인 요구사항 문서 역할**: 각 기능 옆 주석에 "실 배포 시 어떤 변형이 필요한지" 명시 → 이 자체가 legaltech·fintech 발주자 대상 세일즈 시그널.

**교양 콘텐츠 제외 재확인**:
- 변호사법·대부업법 회색지대 (교양 콘텐츠가 "법률·금융 자문"으로 해석될 위험)
- 4일 MVP 품질 확보 난이도
- 기존 NPL 김대리 블로그·유튜브 채널이 이미 커버 ([blog.naver.com/npl_kim](https://blog.naver.com/npl_kim))
- → Meta 주석 #11 "왜 교양 콘텐츠 축이 없는가"로 선별 역량 증명

## Web App + SaaS B2B Specific Requirements

### Project-Type Overview

NPL 마켓은 **web_app (주) + saas_b2b 특성 (부)** 하이브리드.
- web_app 측면: 단일 URL, 브라우저 기반, 반응형, Next.js SSR/SSG 혼합
- saas_b2b 측면: 3-tier RBAC + 대부업체 배지 + admin 승인 흐름
- **스킵 영역**: 멀티 테넌트 격리 · 구독·과금 · 모바일 퍼스트 · CLI

### Technical Architecture

**프레임워크 & 런타임**
- **Next.js 14+ (App Router)**, React 18+ (Server + Client Components)
- **TypeScript** strict mode
- **Supabase** (PostgreSQL + Auth + Storage + RLS, 무료 티어)
- **카카오맵 JavaScript SDK** (dynamic import + `ssr: false` 필수)
- **shadcn/ui** (접근성 기본 확보 + 커스터마이즈 용이, 4일 MVP 권장)
- **Framer Motion** (Calculator Dance · Rights Cascade · aside 슬라이드인)
- **Tailwind CSS** (디자인 시스템)
- **date-fns-tz** (Asia/Seoul 타임존 보정)
- 배포: **Vercel** (프로덕션 + preview)
- 분석: **Plausible** (SHOULD, 개인정보 비수집)

**Rendering 전략**
- **SSG**: 랜딩 · About · 정적 콘텐츠 (대부분의 페이지)
- **SSR**: 매물 리스트 (초기 데이터 렌더링)
- **CSR**: 계산기 · Meta 토글 aside · 지도 상호작용
- **ISR 미사용** (정적 스냅샷 기반이라 불필요)

### Browser Matrix

**데스크톱 (필수)**: Chrome 최신 · Safari 최신 · Firefox 최신 · Edge 최신 (Chromium)
**모바일 (기본만)**: Safari iOS 최신 · Chrome Android 최신 — "깨지지 않을 정도"
**미지원**: IE11 이하 · 모바일 퍼스트 UX · 네이티브 앱

### Responsive Design

- **Breakpoints**: Tailwind 기본 `sm (640) / md (768) / lg (1024) / xl (1280)`
- **데스크톱 `1440px`** 설계 기준, `1024px` 랩탑 기본 대응
- **태블릿 `768px`**: 기본 대응
- **모바일 `375px`**: 첫 스텝만 제대로, Conversational Chunking 모바일 내성 유지 (Journey 3 기준)
- **데스크톱 전용 장치**: Meta 토글 aside 슬라이드인 (모바일에선 bottom sheet 대체 or 비활성 — SHOULD)

### Performance Targets

Success Criteria 재참조 + 구체화:
- **Lighthouse Performance ≥ 80** (랜딩·계산기·리스트 한정, 지도 제외)
- **Core Web Vitals**: LCP < 2.5s / FID < 100ms / CLS < 0.1
- **Code splitting**: 카카오맵 SDK · Framer Motion dynamic import
- **Image optimization**: Next.js `<Image>` 컴포넌트
- **Font optimization**: `next/font` + 시스템 폰트 fallback

### SEO Strategy

**목적**: 발주자 콜드 검색보다 **링크드인·슬랙 공유 시 프리뷰 품질**이 우선. 검색 유입은 보너스.

- **메타 태그**: `<title>`, `<meta description>`, OG tags (링크드인 카드 프리뷰), Twitter Card
- **구조화 데이터 (JSON-LD)**: Person (blynn) + CreativeWork (NPL 마켓)
- **robots.txt + sitemap.xml** — 최소 버전
- **URL 전략**: 루트 `/` 단일 페이지 중심, 섹션 `#fragment` 앵커 (`/#calculator`, `/#about`)
- **키워드**: "NPL 프로덕트 개발자", "부동산 핀테크 개발자", "blynn 포트폴리오"

### Accessibility (WCAG 2.1 Level AA 목표)

Success Criteria 재참조:
- Lighthouse Accessibility ≥ 90 전 페이지
- 키보드 Tab 완결성 (계산기·Meta 토글·aside focus trap)
- 시맨틱 HTML (`<main>/<aside>/<nav>`, `<label for=>`)
- ARIA (`aria-label`, `aria-describedby`, `aria-expanded` on Meta 토글)
- Color Contrast 4.5:1 (Meta aside 회색 텍스트 사전 검증)
- Focus Visible (Tailwind `focus-visible:`)
- **카카오맵 iframe 대체**: 컨테이너 `aria-label` + 지도 아래 리스트 뷰 병행

### Tenant Model

**MVP = 단일 테넌트** (단일 DB · 단일 워크스페이스). 사용자는 Global Pool (L1·L2·L3·대부업체·admin).

**Meta 주석 후보 (신규)**: "실 배포 시 대부업체별 워크스페이스 분리 필요 (multi-tenant row scoping or schema isolation). 현재 대부업체 배지는 role marker이지 tenant isolator 아님 — 포트폴리오 범위 선택."

### RBAC Matrix

| Role | 매물 탐색 | 권리분석 리포트 | 계산기 | 커뮤니티 | 매물 등록 | Admin UI |
|------|----------|--------------|--------|--------|----------|---------|
| Guest | 블러 제한 | Hero Reveal 1건 | 제한 프리셋 | 블러 배너 | ❌ | ❌ |
| L1 일반 | 블러 일부 해제 | 1건 전체 | 전체 프리셋 | 블러 배너 | ❌ | ❌ |
| L2 검증 | 권리분석 50% 해제 | 전체 | 전체 | **읽기 진입** | ❌ | ❌ |
| L3 전문가 | 전체 | 전체 + 심의서 | 전체 | 전체 | ❌ | ❌ |
| 🏢 대부업체 | 전체 | 전체 | 전체 | 전체 | ✅ | ❌ |
| Admin (blynn) | 전체 | 전체 | 전체 | 전체 | ✅ | ✅ |

- **RLS**: 읽기만 강제 (Success Criteria 기준). 쓰기는 admin 단일 계정.
- **JWT Claims**: `role`, `tier` 메타데이터 주입.
- **Supabase Auth**: 이메일 매직링크 기본 + 비밀번호 백업. 본인인증 미연동.

### Integration List

| Integration | MVP 상태 | 비고 |
|-------------|---------|------|
| 카카오맵 JS SDK | ✅ 사용 | 배포 도메인 등록 필수 (Day 4 리스크) |
| Supabase Auth (이메일) | ✅ 사용 | 매직링크 + 비번 백업 |
| Supabase Storage | ✅ 사용 | 권리분석 리포트 이미지 |
| Plausible Analytics | ✅ SHOULD | Meta 토글 이벤트 계측 |
| 법원경매정보시스템 API | ❌ Placeholder | 정적 스냅샷 JSON 박제 |
| 온비드 Open API | ❌ Placeholder | Vision 단계 |
| KIS/NICE 신용평가 | ❌ Placeholder | 전문투자자 등록 시 |
| 본인인증 (PASS) | ❌ Placeholder | 실 배포 시 |
| 카카오 소셜 로그인 | ❌ Placeholder | Vision |

### Compliance Requirements

Step 5 (Domain Requirements) 재참조 — 대부업법·자본시장법·변호사법·개인정보보호법·신용정보법·금융실명법. **UI 용어·구조 선택으로 규제 인식 반영**. 실제 준수 X.

### Implementation Considerations

**4일 MVP 일자별 구성 (축소 전 초안)**
- **Day 1**: Next.js + Supabase + 카카오맵 골격 / 매물 3탭 / 3-tier RBAC 읽기 RLS / 랜딩 Hero
- **Day 2**: 계산기 Apps Script 포팅 / 프리셋 3종 / Rights Cascade / Calculator Dance / tier 블러
- **Day 3**: 권리분석 리포트 1건 / 커뮤니티 UI 목업 / L2+ 게이팅 / Meta 토글 11개
- **Day 4**: 디자인 패스 / About + 공고 매칭 표 / README / 배포

(⚠️ MUST 19→12 축소는 **Step 8 Scoping**에서 최종 결정)

**테스트 전략**
- E2E·Visual Regression: **미구현** (4일 범위 외)
- 계산기 골든 테스트: **Vitest + 샘플 5건 필수** (Technical Success 기준)
- 타입 체크: `tsc --noEmit` CI 통과 필수
- 린트: ESLint + Prettier 기본

**CI/CD**
- Vercel Git Integration (PR → preview, main → prod 자동)
- 파이프라인 복잡화는 Vision

**미구현 스코프 경계 (명시적 선언)**
- 테스트 자동화 (E2E, Visual Regression) — Vision
- 스토리북 컴포넌트 카탈로그 — Vision
- Feature flags / A/B 테스트 — Vision
- 다국어 (i18n) — Vision
- 다크 모드 — Vision (COULD 정도)

## Project Scoping & Phased Development

### MVP Strategy & Philosophy

**MVP Approach: Experience MVP**

목표는 기능 체크리스트 완주가 아닌 **"Primary User(발주자)가 30초 안에 '이건 다르다' 체감하는 경험 파이프라인 구축"**. 4일의 중심 질문은 세 가지로 수렴:

- **발주자가 Hero부터 Contact까지 끊기지 않고 스크롤 완주할 수 있는가?**
- **계산기에서 "ERP 수준 시스템"을 체감할 수 있는가?**
- **Meta 토글이 열리거나 / Placeholder 라벨로 정직 노출되는가?**

나머지는 모두 부차적. "단단한 12개 > 피상적 19개" 원칙.

**Resource Requirements**
- **팀 크기**: 1인 (blynn 단독)
- **가용 시간**: 4일 × 8h = 32h 실제 + 야간 버퍼 (총 최대 50h 경계)
- **필수 스킬**: Next.js · TypeScript · Supabase · CSS 애니메이션 · 타임존 안전한 날짜 연산 · 한국 NPL 도메인 지식
- **외부 의존**: 카카오 개발자 콘솔(도메인 등록) · Vercel · 도메인 등록

### MVP Feature Set (Phase 1) — MUST 12개

**Core User Journeys Supported**
- Journey 1 (프롭테크 대표 B, Success Path) — 완전 지원
- Journey 2 (프롭테크 대표 B, Meta OFF Edge Case) — 완전 지원
- Journey 3 (법무법인 파트너 A, Mobile 진입) — 부분 지원 (Conversational Chunking 모바일 첫 스텝만 보장)
- Journey 4 (김OO, Secondary 목업) — dead-end 0건 기준 지원
- Journey 5 (blynn admin) — 최소 운영 경로만

**MUST 12 (통합 기능 단위, 총 예상 38h)**

| # | 기능 | 포함 | 예상 |
|---|------|------|------|
| 1 | **골격 & 배포** | Next.js App Router + Supabase + 카카오맵 + Vercel 배포 + 도메인 연결 + HTTPS | 5h |
| 2 | **RBAC** | 3-tier (L1/L2/L3) + 대부업체 배지 + 읽기 RLS + admin 단일 계정 + JWT claim | 2h |
| 3 | **매물 탐색** | 경매 탭 1개 실 데이터(정적 스냅샷) + 공매/신탁공매 Placeholder 라벨 + 지도·리스트 뷰 + tier별 블러 | 4h |
| 4 | **계산기 코어** | Apps Script v3.1 포팅(양편넣기·배당순서·소액임차·당해세) + 샘플 5건 Vitest 골든 테스트 + date-fns-tz 타임존 보정 | 5h |
| 5 | **계산기 UX** | 프리셋 1종 "1회 유찰+70%" 완성 (나머지 2종 Placeholder) + Conversational Chunking + Live Calculation Shadow + Rights Cascade + Calculator Dance | 4h |
| 6 | **랜딩 Hero** | Intent Framing 스트립 + Map Breath (CSS 애니) + Live Ticker (CSS 루프) + Hero Reveal 권리분석 리포트 1건 Full Writeup | 4h |
| 7 | **커뮤니티** | 경매방 1 카테고리 완성 (샘플 글 5건 실무자 톤) + L2+ 블러 배너 + 자유수다방/Q&A Placeholder | 2h |
| 8 | **Meta 토글 시스템** | 토글 UI + 주석 11개 + Ambient Annotation 인디케이터 (`·`/"왜?") + First Annotation 자동 오픈 | 5h |
| 9 | **Placeholder 라벨 체계** | 모든 미구현 접점 표준화 컴포넌트 (`<PlaceholderLabel reason=... />`) | 1h |
| 10 | **About** | 공고 매칭 표 + 겸업/전업 범위 명시 + 법적 고지 인라인 | 2h |
| 11 | **접근성 & 보안 방어선** | 키보드 Tab · ARIA · Color Contrast 4.5:1 · Focus visible / service_role 키 유출 체크 · RLS 누락 테이블 체크 · Storage 버킷 RLS | 3h |
| 12 | **문서 & 운영** | README + BMAD PRD 공개 링크 + 카카오맵 도메인 등록 검증 + Lighthouse 측정 스크립트 + 최종 배포 | 3h |
| | **합계** | — | **38h** |
| | **버퍼** | milestone Gate 판단 이후 탄력 운용 | **12h** |

### Post-MVP Features

**Phase 2 (Growth — SHOULD, 시간 남으면)**
- 프리셋 2·3종 추가 ("방어입찰", "재매각")
- 공매·신탁공매 탭 실 데이터 (샘플 최소)
- 커뮤니티 자유수다방·Q&A 카테고리 실 콘텐츠
- Plausible Analytics 이벤트 계측 (Meta 토글 전환율)
- 디자인 패스 (빌사남 톤) — shadcn/ui 기본 대신 커스텀
- 용어·숫자 감수 집중 블록
- 경매방 "2024타경XXXXX" 자동 링크 파싱
- 심의서 템플릿 (.xlsx) 다운로드
- 용어사전 페이지 (Footer 링크)
- L2 게이팅 배너 UX 폴리싱
- 정적 폴백 페이지 (트래픽 급증 대비)

**Phase 3 (Vision — Post-Portfolio)**
- 전체 RBAC 쓰기 정책 매트릭스 전수 검증 (9가지)
- 실시간 크롤링 스케줄러
- 글쓰기·댓글·실명제·스팸 방지 파이프라인
- 결제·구독·1:1 메시지·푸시 알림
- 본인인증 서비스 연동 (PASS)
- PDF 심의서 출력
- 법원경매/온비드 공식 API 연동
- 멀티 테넌트 격리 (대부업체별 워크스페이스)
- admin UI (tier 변경·매물 관리)
- 다크 모드·다국어(i18n)

### Risk Mitigation Strategy

**Technical Risks**

| Risk | 대응 | 시점 |
|---|---|---|
| 카카오맵 도메인 미등록 → 배포 데모 지도 장애 | Vercel 프로덕션 + `*.vercel.app` 와일드카드 등록 완료. 도메인 미지원이면 nip.io 등 대안 확보 | **선행 작업** (MVP 타이머 시작 전) |
| Apps Script 포팅 타임존 갭 → 수익률 하루 밀림 | `date-fns-tz` + Asia/Seoul 명시, 샘플 5건 골든 테스트 Vitest 실행 | 계산기 코어 완성 직후 |
| Supabase RLS 함정 (service_role 키 유출 · 정책 누락) | RLS 검증 체크리스트 실행 (키 클라이언트 번들 grep, 테이블별 정책 존재 확인) | RBAC 구현 직후 |
| Lighthouse Performance 지도 페이지 외 저점 | `dynamic import` + SSG 우선. 배포 전 측정 → Score 80 미만 페이지 식별 → 긴급 튜닝 | 배포 전 최종 점검 |
| Vercel·Supabase 무료 티어 트래픽 한계 | 정적 폴백 페이지 준비 (SHOULD). 심각 시 Supabase Pro 업그레이드 | 배포 후 관찰 |

**Market Risks**

| Risk | 대응 | 시점 |
|---|---|---|
| Pull 채널 편향 (발주자가 포트폴리오 직접 검색 안 함) | Push 채널 동시 가동 — 링크드인 공유 + NPL 밋업 참석 예약 + 프롭테크 대표 콜드 DM | 배포 직후 즉시 |
| 프롭테크 대표는 Meta 토글 안 열 가능성 | OFF 경로 Success Path(Journey 2) 강화 — Intent Framing 스트립 + Placeholder 라벨 체계 + 공고 매칭 표 정직 | MVP 포함 |
| "AI 보조 개발 = 할인 요인" 역풍 | 바이브 코딩을 세일즈 메시지에서 전면 제거. About에서 "도메인 이해 × 구현 속도의 곱"으로만 포지셔닝 | MVP 포함 |
| NPL 공급 사이클성 리스크 (공고 2개월 후 1/3 감소 가능성 30%) | 부동산 일반(경매·프롭테크) 축으로 확장 가능하게 7모듈 레고 설계. 타겟 공고 다각화 | D+30 이후 |

**Resource Risks**

| Risk | 대응 |
|---|---|
| blynn 단독 4일 50h — 중간 블로커 발생 시 | **Gate 체계로 대응**: 각 milestone 완료 후 다음 단계로 확장하거나 SHOULD 포기 결정 |
| 개인 에너지 소진 | 야간 작업 한계선 사전 설정 (예: 22시 cutoff). 최종일 오전 전 반드시 수면 확보 |
| 외부 의존 지연 (도메인 승인, 카카오 도메인 등록) | 선행 작업으로 완전 해소. 최종일 당일 의존 0 |

**Scope Reduction Escalation Path (milestone Gate 기반)**

우선순위 Gate 순서는 milestone 완료 시점마다 판단:

1. **계산기 코어 Gate**: 샘플 5건 골든 테스트 통과? → NO면 SHOULD 전부 즉시 포기, 나머지 MUST만 사수
2. **Meta 토글 Gate**: 토글 UI + 주석 11개 서빙 가능? → NO면 주석 8개로 축소 + 주석 #11(교양 콘텐츠 제외 이유) 우선 보존
3. **배포 전 점검 Gate**: Lighthouse 측정 + 데모 동선 dead-end 점검 → 실패 영역은 Placeholder 라벨 추가로 덮음
4. **최종 배포 Gate**: HTTPS + 도메인 + 카카오맵 작동? → 실패 시 Vercel 기본 `*.vercel.app` URL로 공개, 도메인 연결은 SHOULD 강등
