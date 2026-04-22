---
stepsCompleted:
  - step-01-document-discovery
  - step-02-prd-analysis
  - step-03-epic-coverage-validation
  - step-04-ux-alignment
  - step-05-epic-quality-review
  - step-06-final-assessment
filesIncluded:
  - prd.md
  - architecture.md
  - epics.md
  - ux-design-specification.md
---

# Implementation Readiness Assessment Report

**Date:** 2026-04-22
**Project:** bmad_portfolio

## Document Inventory

| Document Type | File | Size | Last Modified |
|---------------|------|------|---------------|
| PRD | `prd.md` | 47KB | 2026-04-21 |
| Architecture | `architecture.md` | 66KB | 2026-04-22 |
| Epics & Stories | `epics.md` | 23KB | 2026-04-22 |
| UX Design | `ux-design-specification.md` | 64KB | 2026-04-21 |

**Supporting Research:**
- `research/market-portfolio-positioning-research-2026-04-20.md`
- `research/npl-calculator-logic-v3.1.gs`

**Issues:** None. No duplicate formats. All four required documents present.

## PRD Analysis

PRD는 전통적인 FR/NFR 번호 체계 대신 **MUST 12 통합 기능 단위**(Section: "MVP Feature Set - MUST 12개") + **Journey Requirements Summary 캐퍼빌리티 매트릭스** + **Success Criteria 기술 기준선**을 사용합니다. 아래는 추적성 검증용으로 재번호화하여 추출한 결과입니다.

### Functional Requirements

**FR1: 골격 & 배포 인프라**
Next.js 14+ App Router + Supabase + 카카오맵 + Vercel 프로덕션 배포 + 커스텀 도메인 연결 + HTTPS 활성화. (MUST 12 #1, 5h)

**FR2: 3-tier RBAC 시스템**
Guest / L1 일반 / L2 검증 / L3 전문가 / 대부업체 배지 / Admin 6단계 Role. Supabase RLS 읽기 강제, 쓰기는 admin 단일 하드코딩 계정. JWT claim에 `role`, `tier` 메타데이터 주입. (MUST 12 #2, 2h)

**FR3: 매물 탐색 3탭**
경매 / 공매 / 신탁공매 탭 UI. 경매 탭 1개만 실 데이터(2026-04-20 정적 스냅샷 JSON 박제), 공매·신탁공매는 Placeholder 라벨. 지도 뷰(카카오맵 JS SDK, `dynamic import` + `ssr: false`) + 리스트 뷰 병행. tier별 블러 게이팅. (MUST 12 #3, 4h)

**FR4: 배당 NPL 채권계산기 코어 로직**
Apps Script v3.1 포팅 — 양편넣기(+1일 토글), 배당순서(경매비용 → 당해세 → 최우선변제 → 저당권/전세권 → 일반채권), 지역별 소액임차 한도 자동 반영, 당해세 최우선 배당순서, 채권최고액 Cap (`Math.min(claim, maxBond)`), 질권대출금 100만원 단위 절사, 두 개의 시간축(실투자기간 vs 이자발생기간), 세 종류 수익률(기간·이자포함·연환산). 입력 15필드 / 출력 25필드+. Vitest 샘플 5건 골든 테스트 (Cap 경계 / 100만원 절사 경계 / 당해세 개입 / 윤년 / 단순 케이스). date-fns-tz + Asia/Seoul 타임존 보정. (MUST 12 #4, 5h)

**FR5: 계산기 UX 패턴**
원클릭 프리셋 1종 "1회 유찰+70%" 완성 (방어입찰·재매각은 Placeholder). Conversational Chunking 스텝 스크롤 동선(모바일 첫 스텝 보장). Live Calculation Shadow 실시간 그림자 출력. Rights Cascade 권리 재정렬 애니메이션. Calculator Dance 입력 시 필드 애니메이션. (MUST 12 #5, 4h)

**FR6: 랜딩 Hero 섹션**
Intent Framing 얇은 스트립(상단) — "NPL 실무자 × 핀테크 PM blynn의 작업물. 이 페이지 자체가 프로덕트 데모입니다. Meta 토글로 의사결정 주석을 보세요." Map Breath 맥박 CSS 애니메이션. Live Ticker 실 사건번호 CSS 루프 노출. Hero Reveal 권리분석 리포트 1건 Full Writeup (말소기준권리 · Cascade · 당해세 배당순서). (MUST 12 #6, 4h)

**FR7: 현직자 커뮤니티 UI 목업**
3 카테고리 (경매방 / 자유수다방 / Q&A) UI. 경매방 1 카테고리 실 콘텐츠 완성 — 샘플 글 5건 실무자 톤. L2+ 검증 블러 배너 (Guest/L1에게 노출). 자유수다방·Q&A는 Placeholder 라벨. 댓글·글쓰기 버튼은 "데모용 Placeholder" 명시. (MUST 12 #7, 2h)

**FR8: Meta 토글 시스템 + 주석 11개**
토글 UI (스페이스바 단축키). Meta 주석 11개 서빙 (채권최고액 Cap / 질권 100만원 절사 / 두 시간축 / 세 수익률 / 양편넣기 판례 / 대부업법 "거래→정보 매칭" / Supabase RLS 선택 / admin 단일 계정 / 멀티테넌트 미구현 / Placeholder 정직 / 교양 콘텐츠 축 제외 이유 #11). Ambient Annotation 인디케이터(`·` / "왜?" 은은한 시그널). First Annotation 자동 슬라이드인. aside 컴포넌트 focus trap. (MUST 12 #8, 5h)

**FR9: Placeholder 라벨 체계**
모든 미구현 접점 표준화 컴포넌트 (`<PlaceholderLabel reason="..." />`). 데모용임을 정직하게 노출하여 dead-end 0건 보장. (MUST 12 #9, 1h)

**FR10: About 섹션**
공고 매칭 표 (실제 외주 공고와 7모듈 line-by-line 매핑). 겸업/전업 가능 범위 명시 ("주 OO시간 전업 가능"). 법적 고지 인라인. Contact CTA (데스크톱 Slack DM + 모바일 mailto 자동 핸들러). (MUST 12 #10, 2h)

**FR11: 접근성 & 보안 방어선**
접근성 체크리스트(키보드 Tab 완결성, 시맨틱 HTML + ARIA, Focus visible, Color Contrast 4.5:1). 보안 체크리스트(service_role 키 클라이언트 번들 유입 grep 검증, RLS 정책 누락 테이블 검증, Storage 버킷 RLS 별도 검증). (MUST 12 #11, 3h)

**FR12: 문서 & 운영**
README + BMAD PRD 공개 링크 + 카카오맵 도메인 등록 검증 (Vercel 프로덕션 + `*.vercel.app` 와일드카드) + Lighthouse 측정 스크립트 + 최종 배포. (MUST 12 #12, 3h)

**FR13: 대부업체 매물 등록 폼 (⚠️ MUST 12에 누락 의심)**
10개 필드 매물 등록 폼. 실 제출은 admin 승인 없이 바로 상태 변경 — Meta 주석에 이유 명시. Product Scope MVP ⑦에는 명시되었으나 **MUST 12 최종 표에는 통합/누락 불분명 — Epic 단계 검증 필요**.

**FR14: admin 하드코딩 + tier 승격 시연**
admin 단일 하드코딩 계정 로그인 (JWT admin claim 주입). Supabase 직접 쿼리 접근 경로. 정적 스냅샷 JSON 수동 업데이트 스크립트. L1→L2 요청 시 admin 계정으로 셀프 tier 승격 시연. (Journey 4, 5 / MUST 12 #2에 부분 포함)

### Non-Functional Requirements

**NFR1: Performance (Lighthouse)**
Performance ≥ 80 (랜딩·계산기·리스트 페이지 한정, **지도 페이지 제외** — 카카오맵 SDK 300KB+ 동기 로드 이슈).

**NFR2: Performance (Core Web Vitals)**
LCP < 2.5s / FID < 100ms / CLS < 0.1.

**NFR3: Accessibility**
Lighthouse Accessibility ≥ 90 전 페이지. WCAG 2.1 Level AA 목표. shadcn/ui 또는 Radix 기반. 카카오맵 iframe은 `aria-label` + 리스트 뷰 대체.

**NFR4: Accessibility 필수 3요소**
① 키보드 Tab 완결성 (계산기 15필드 순서, Meta 토글 스페이스바, aside focus trap), ② 시맨틱 HTML + `<label for=>`, `aria-describedby`, `<main>/<aside>/<nav>` 분리, ③ Focus visible + Color contrast 4.5:1.

**NFR5: Security — 키 유출 방어**
`service_role` 키 클라이언트 번들 유입 0건 (포트폴리오 공개 저장소 기준).

**NFR6: Security — RLS 방어**
RLS 정책 누락 테이블 0건. Storage 버킷 RLS 별도 적용.

**NFR7: Reliability — 계산기 정확성**
샘플 5건에 대해 **원 단위 완전 일치**. 절사·Cap은 비트 단위, 수익률은 소수점 4자리 일치. (1e-4 기준 폐기)

**NFR8: Timezone 정합성**
`date-fns-tz` + `Asia/Seoul` 명시. Vercel serverless UTC 기본 ↔ Apps Script Asia/Seoul 고정 갭 방어. 윤년·말일 처리 검증.

**NFR9: Browser Compatibility**
데스크톱 (필수): Chrome / Safari / Firefox / Edge 최신. 모바일 (기본만): Safari iOS / Chrome Android 최신. IE11 이하·모바일 퍼스트·네이티브 앱 미지원.

**NFR10: Responsive Design**
Tailwind breakpoints (sm 640 / md 768 / lg 1024 / xl 1280). 데스크톱 1440px 설계 기준, 1024px 랩탑 기본 대응. 태블릿 768px 기본. 모바일 375px "깨지지 않을 정도" — Conversational Chunking 첫 스텝만 품질 보장(Journey 3).

**NFR11: SEO**
메타 태그 (`<title>`, description, OG tags, Twitter Card). JSON-LD 구조화 데이터 (Person blynn + CreativeWork NPL 마켓). robots.txt + sitemap.xml 최소. URL 전략: 루트 `/` + 섹션 `#fragment` 앵커.

**NFR12: Deployment Infrastructure**
Vercel (프로덕션 + preview) + Supabase 무료 티어. Git Integration 자동 파이프라인 (PR → preview, main → prod).

**NFR13: Data Sourcing**
공개 정보 한정: 법원경매 공고 + 온비드 공매 공고. 2026-04-20 기준 정적 스냅샷 JSON 박제. **실시간 크롤링 미배포** (courtauction.go.kr 이용약관 방어).

**NFR14: Meta 토글 KPI**
Meta 토글 최소 1회 ON 전환 + ON 상태 체류 60초+. Plausible 이벤트 계측 (SHOULD).

**NFR15: Timeline 제약**
4일 MVP · 제로 버퍼. MUST 12 총 38h + 버퍼 12h = 50h 경계. 1인 단독.

**NFR16: Rendering 전략**
SSG (랜딩·About·정적 콘텐츠), SSR (매물 리스트), CSR (계산기·Meta 토글·지도). ISR 미사용.

**NFR17: Tenant Model**
MVP = 단일 테넌트 (단일 DB · 단일 워크스페이스). Global Pool 사용자. 멀티테넌트 격리는 Vision.

### Additional Requirements

**AR1: Compliance — 대부업법**
UI 대응: "거래" → "정보 매칭" 전면 리프레이밍 / 가입 시 "대부업법 L2 적격성 자진 확인" 체크박스 / Footer 법적 고지 배너 / Meta 주석 #6.

**AR2: Compliance — 자본시장법**
L3 전문투자자는 "자격 증명 업로드 + admin 승인" **시연만**. Meta 주석에 금감원 등록 필요성 명시.

**AR3: Compliance — 변호사법**
권리분석 리포트 상단 "정보 제공·참고용 — 실제 판단은 변호사 자문 필요" 배너. "분석" → "요약" 용어. Meta 주석에 변호사 파트너십 변형 필요성 명시.

**AR4: Compliance — 개인정보보호법 & 정보통신망법**
**실명 수집 0건**. 이메일 + 닉네임만. L2 검증은 "가상 체크박스" 시연. 본인인증 미연동.

**AR5: Compliance — 신용정보법 & 금융실명법**
공개 사건번호 한정. 채무자 이름은 이니셜, 주소는 "동" 단위.

**AR6: 실무 용어 자연 노출**
양편넣기, 채권최고액, 질권대출, 지역별 소액임차, 당해세 최우선, 말소기준권리, 명도난이도, 특수물건, 배당종기일, 이자가산일, OPB, LTV, 전문투자자, 적격성 자진 확인.

**AR7: 사건번호 포맷**
법원 경매: `2024타경{5자리}` / 공매: `2024-{공고번호}-{물건번호}` / 신탁공매: Placeholder.

**AR8: 기존 자산 재활용**
NPL 계산기 Apps Script v3.1 (검증 완료, 김대리 승인 로직) — Next.js 포팅 원본. nodajimap (지도 표시 경험). 경매·온비드 크롤링 스크립트.

**AR9: 스택 제약**
Next.js 14+ (App Router) / React 18+ / TypeScript strict / Supabase / 카카오맵 JS SDK / shadcn/ui / Framer Motion / Tailwind CSS / date-fns-tz / Vercel / Plausible (SHOULD).

**AR10: 미구현 스코프 명시적 선언**
E2E/Visual Regression 테스트, 스토리북, Feature flags/A/B, i18n, 다크 모드 — Vision. MVP 범위 밖.

### PRD Completeness Assessment

**강점**
- 요구사항 추적성 지표가 매우 구체적 (계산기 샘플 5건 원 단위 일치, Meta 주석 11개 전부 서빙 등 명확한 합격 기준).
- Journey 5개가 MUST 기능과 line-by-line 매핑된 Capability Summary Table 제공.
- Compliance 요구사항이 UI 용어·구조 선택까지 구체화됨 (실용적 MVP 범위 내).
- Risk Mitigation 테이블(Technical/Market/Resource)이 대응 시점까지 명시됨.
- Gate 체계(4단계) 스코프 축소 에스컬레이션 경로 정의됨.

**갭/모호 영역 (Epic 단계에서 해소 필요)**
- **대부업체 매물 등록 폼 (MVP ⑦)이 MUST 12 최종 표에 독립 항목으로 등장하지 않음** — FR2 RBAC / FR7 커뮤니티 / 별도 중 어디 귀속? 공수 산정 누락 의심.
- **Contact CTA 인프라 세부(Slack DM 링크 실 주소, mailto subject 템플릿) 미정의** — FR10 About 섹션에 포함되었으나 구현 디테일 미정.
- **Plausible 이벤트 계측이 NFR14에서 SHOULD인지 MUST인지 혼재** — Meta 토글 KPI 측정 가능 여부 영향.
- **admin JWT claim 주입 방식** (Supabase custom claim vs 하드코딩 env) 미정.
- **정적 스냅샷 JSON 스키마 / 파일 위치** 미정의.
- **Meta 주석 11개 저장 방식** (Markdown 파일 / DB / 코드 주석 추출) 미정.
- **SHOULD → MUST 승급 기준** (Gate 통과 시 어떤 SHOULD를 먼저 승급할지) 우선순위 미정.

## Epic Coverage Validation

### 🚨 CRITICAL FINDING: Epic List 및 FR Coverage Map 미작성

`epics.md` 파일은 **Requirements Inventory (FR 20개 / NFR 20개 / UX-DR 28개 / Additional 기술·인프라 결정)까지만** 작성되어 있으며, 실제 **Epic 분해 (`## Epic List`)와 FR→Epic 매핑 (`## FR Coverage Map`)이 template placeholder 그대로 남아있습니다.**

```
## FR Coverage Map

{{requirements_coverage_map}}    ← 미작성

## Epic List

{{epics_list}}                    ← 미작성
```

이 상태에서는 **어떤 스토리가 어떤 FR을 구현하는지 추적 불가**하며, 4일 MVP 38h 공수 추정이 담기는 단위(Epic/Story)가 없어 스프린트 플래닝이 불가능합니다.

### Epic FR Coverage Extracted (epics.md Requirements Inventory 기준)

Epics 문서에는 Epic 분해는 없으나, 독립적으로 재번호화된 FR 목록(epics.md FR1~FR20)이 존재합니다. **PRD FR과 epics.md FR 번호는 서로 다른 체계**임에 유의.

### PRD ↔ Epics.md FR Cross-Map

| PRD FR | PRD 요구사항 (요약) | epics.md FR | 구현 세분화 수준 | 상태 |
|--------|--------------------|-----|------------|------|
| FR1 | 골격 & 배포 인프라 | epics.md FR19 (부분) + Additional Requirements (Starter Template, Next.js 16, pnpm, 환경 3단계) | Epic Story 단위 아직 없음 | ⚠️ 요구사항은 커버, Epic 없음 |
| FR2 | 3-tier RBAC | epics.md FR10 | Epic 없음 | ⚠️ 요구사항 커버, Epic 없음 |
| FR3 | 매물 탐색 3탭 | epics.md FR1 | Epic 없음 | ⚠️ |
| FR4 | 계산기 코어 로직 | epics.md FR3 | Epic 없음 | ⚠️ |
| FR5 | 계산기 UX 패턴 (프리셋/Chunking/Cascade/Dance) | epics.md FR4 + FR5 + FR6 + FR7 (4개로 세분화) | Epic 없음 | ⚠️ 세분화 승급, Epic 없음 |
| FR6 | 랜딩 Hero | epics.md FR8 | Epic 없음 | ⚠️ |
| FR7 | 커뮤니티 UI 목업 | epics.md FR9 | Epic 없음 | ⚠️ |
| FR8 | Meta 토글 + 주석 11개 | epics.md FR11 (토글) + FR12 (주석 서빙) | Epic 없음 | ⚠️ 세분화 승급, Epic 없음 |
| FR9 | Placeholder 라벨 체계 | epics.md FR13 | Epic 없음 | ⚠️ |
| FR10 | About | epics.md FR15 | Epic 없음 | ⚠️ |
| FR11 | 접근성 & 보안 방어선 | **독립 FR 없음** — epics.md NFR4~NFR9 · UX-DR21~26로 분산 | Epic 없음 | ❌ **누락 위험** (cross-cutting이어서 owner 불명) |
| FR12 | 문서 & 운영 | epics.md FR19 (부분) | Epic 없음 | ⚠️ |
| FR13 | 대부업체 매물 등록 폼 | epics.md FR14 | Epic 없음 | ⚠️ (PRD FR13 MUST 12 누락 의심을 epics가 해소함) |
| FR14 | admin 하드코딩 + tier 승격 | epics.md FR18 | Epic 없음 | ⚠️ |
| — | — | **epics.md FR2** (매물 카드 → 계산기 URL pre-fill) | — | ➕ **PRD Journey 1 동선을 FR로 명시적 승격** (정당한 추가) |
| — | — | **epics.md FR16** (규제 카피 상수 모듈) | — | ➕ **PRD AR1~AR3를 단일 소스로 승격** (정당한 아키텍처 결정) |
| — | — | **epics.md FR17** (채무자 정보 마스킹 빌드 스크립트) | — | ➕ **PRD AR5를 빌드 파이프라인으로 구체화** (정당) |
| — | — | **epics.md FR20** (SEO/OG 메타) | — | ➕ **PRD NFR11에서 FR로 승격** (구현 단위 명확화) |

### Missing Requirements

#### Critical Missing (CRITICAL)

**C1: Epic List 완전 미작성**
- 영향: 스토리 단위 공수 추정·병렬화·Gate 기반 스코프 축소 결정 불가
- 권고: **즉시 `bmad-create-epics-and-stories` 스킬을 실행**해 epics.md FR 20 + NFR 20 + UX-DR 28을 기반으로 Epic 6-8개 + Story 20-30개 분해 필요. 현 4일 MVP 38h 공수 분배가 Epic 단위 없이는 검증 불가.

**C2: FR Coverage Map 미작성**
- 영향: 추적성 증명 불가. 배포 후 "FR 누락 여부" 검증 수단 없음.
- 권고: Epic List 완성 후 FR→Epic→Story 3단 매트릭스 작성.

#### High Priority Missing (HIGH)

**H1: PRD FR11 (접근성 & 보안 방어선)가 독립 Epic 단위 없음**
- 현 상태: epics.md에서 NFR4~NFR9 · UX-DR21~26로 **횡단 관심사**로 분산. 책임 owner 불명.
- 영향: Epic 구현 시 각 feature팀(1인이지만 mental model 관점)이 "누가 체크리스트 실행하나" 모호. Lighthouse Accessibility ≥ 90 미달성 리스크.
- 권고: Epic "접근성 & 보안 방어선" 별도 세우고 Story "service_role 키 grep pre-commit 훅" / "RLS 정책 누락 테이블 검증 스크립트" / "키보드 Tab 완결성 E2E 체크리스트" / "Color Contrast 4.5:1 Figma 검증" 등으로 구체화. 구현 순서 상 **다른 Epic 완료 후 배포 Gate 직전** 배치.

**H2: PRD FR10 Contact CTA 세부 미정**
- 현 상태: epics.md FR15에 "mailto 자동 핸들러" 언급만. Subject 템플릿, 기본 본문, Slack DM 링크 실 주소 미정.
- 영향: Day 4 배포 당일 "어떤 이메일 주소·Slack 핸들 노출" 결정 필요. Journey 3 박변호사 "mailto 자동 수신자" 동작 검증 불가.
- 권고: Story "Contact CTA 구현" 스토리에 Acceptance Criteria로 ① 이메일 주소(blynn 실 주소) ② 제목 템플릿 "NPL 마켓 외주 문의 — {회사명}" ③ Slack 워크스페이스 초대 vs 개인 DM 링크 결정 포함.

**H3: PRD NFR14 Plausible 이벤트 계측 지위 불명**
- 현 상태: PRD에서 SHOULD · epics.md Additional Requirements에서도 SHOULD. 그러나 **Meta 토글 ON 전환율·60초+ 체류 측정은 Success Criteria의 핵심 KPI**.
- 영향: MVP 배포해도 KPI 측정 불가 → "포트폴리오 유효성 검증" 자체가 불가능.
- 권고: Plausible 단순 script 삽입은 **1h 이내 작업**이므로 MUST 승급 권고. Meta 토글 `data-plausible-event` 지정 Story 추가.

#### Medium Priority Missing (MEDIUM)

**M1: Starter Template 전제와 공수 추정 불일치**
- epics.md Additional Requirements에서 `create-next-app --example with-supabase` 사용 시 "Vercel + Supabase 셋업 2~3시간 절약" 언급. 그러나 PRD MUST 12 #1 "골격 & 배포" 5h는 이 절약 반영 여부 불명.
- 권고: Epic Story 수준에서 5h가 Starter 사용 기준인지 from-scratch 기준인지 명시.

**M2: Meta 주석 11개 내용(텍스트) 저장 위치 미확정**
- epics.md Additional Requirements에서 `lib/data/annotations.ts` TypeScript 모듈 결정. 그러나 **실제 11개 주석 본문·근거 링크·관련 주석 번호**가 어디 작성되는지 불명 (PRD 본문에는 일부만 스케치됨).
- 영향: Day 3 "Meta 토글 11개" 구현 시 콘텐츠 writing 공수 별도 필요.
- 권고: Story "Meta 주석 11개 작성" (콘텐츠 writing 전용) 분리. 기술 구현 5h 외 content 공수 2-3h 별도 산정.

**M3: 정적 스냅샷 JSON 스키마 미정**
- epics.md FR17 빌드 스크립트·NFR15·Additional Requirements에서 `app/data/listings.json` 결정됨. 그러나 **JSON 필드 스키마(사건번호·감정가·최저가·주소·특수물건 태그·tier 제한)는 미정의**.
- 권고: Epic "매물 탐색" Story 중 "정적 스냅샷 스키마 정의 + build-snapshot.ts 구현" Story 선행 배치.

**M4: epics.md FR2 (매물 카드 → 계산기 URL pre-fill)가 PRD MUST 12에 명시적 대응 없음**
- 정당한 Journey 1 동선 구현이지만, PRD MUST 12 공수표에는 이 기능 독립 공수 할당 안 됨 (FR3 매물 탐색 4h + FR5 계산기 UX 4h 중 어디에 포함?)
- 권고: Epic 분해 시 "매물 → 계산기 bridge" Story 0.5~1h 별도 할당.

### Coverage Statistics

- **PRD FRs (재번호화 기준)**: 14개 (FR1~FR14)
- **epics.md FRs (Requirements Inventory 기준)**: 20개 (FR1~FR20)
- **PRD → epics.md 요구사항 수준 커버리지**: **13/14 = 93%** (PRD FR11 접근성 & 보안 방어선만 독립 FR 없이 NFR/UX-DR 분산)
- **PRD → epics.md Epic 수준 커버리지**: **0/14 = 0%** (Epic List 미작성)
- **epics.md 신규 추가 (정당)**: 4개 (epics.md FR2, FR16, FR17, FR20)
- **전체 준비도**: Requirements Inventory 단계 완료 / **Epic Decomposition 단계 미착수**

## UX Alignment Assessment

### UX Document Status

**✅ Found** — `ux-design-specification.md` (64KB · 1,166 lines · 2026-04-21 작성 · 14 섹션 완주)

다음 섹션이 모두 완결되어 있음:
- Executive Summary · Core User Experience · Desired Emotional Response
- UX Pattern Analysis (8 레퍼런스: 빌사남·Linear·Stripe Docs·Apple/Arc·Notion·월부·Figma·GitHub README)
- Design System Foundation (shadcn/ui + Tailwind + Framer Motion) · Defining Interaction 메커닉
- Visual Design Foundation (Color/Typography/Spacing/Accessibility 토큰 전부 명시)
- Design Direction Decision ("Studio" 방향 선정, A/B/C/D 4안 비교)
- User Journey Flows (J1·J2·J4 Mermaid 다이어그램, J3·J5 패턴 상속)
- Component Strategy (9종 커스텀 컴포넌트 상세 스펙)
- UX Consistency Patterns · Responsive Design & Accessibility

### UX ↔ PRD Alignment

**강한 일치 (✅)**

| PRD 요소 | UX 대응 | 정합도 |
|---------|--------|-------|
| PRD Journey 1~5 | UX User Journey Flows — J1/J2/J4 Mermaid + J3/J5 패턴 상속 | ✅ 완전 일치 |
| PRD Success Criteria "Intent Framing 3초 통과" | UX Critical Success Moments "Intent Framing 3초" | ✅ |
| PRD "Meta 토글 ON 전환 + 60초+ 체류" | UX Emotional Journey Mapping "Meta ON 체류 60s+" | ✅ |
| PRD "dead-end 0건" | UX Flow Optimization Principles "Dead-end 0건 > 완결성" | ✅ |
| PRD Calculator Dance + Rights Cascade | UX Defining Experience 2분 구간 상세 mechanic (0-300ms Preset Fill / 300-700ms Dance / 700-1100ms Cascade) | ✅ 매우 구체적 |
| PRD "Placeholder 라벨 체계 MUST (신규 강조)" | UX Component Strategy `<PlaceholderLabel reason severity>` 3 variants (demo/pending/vision) | ✅ |
| PRD Accessibility ≥ 90 전 페이지 | UX Accessibility Strategy WCAG 2.1 AA + 체크리스트 10항목 | ✅ |
| PRD 3-tier RBAC + 대부업체 배지 | UX Tier Blur + `<TierGateBanner>` | ✅ |
| PRD "규제 인식을 UI 단어에 담기" | UX Emotional Design Principles 4 + Anti-Patterns + Design Inspiration Strategy | ✅ |
| PRD "빌사남 톤" | UX Visual Foundation Base Neutral + Color/Typography 10 token scale | ✅ |
| PRD MUST 12 전반 | UX Experience Mechanics + Component Roadmap Day 1~4 | ✅ |

**UX가 PRD보다 더 구체화한 영역 (➕ 정당한 확장)**

| 영역 | UX 추가 정보 | PRD 대비 |
|-----|------------|--------|
| 애니메이션 타이밍 | 0-300ms / 300-700ms / 700-1100ms 3단계 분할, stagger 0.4s, duration 400-600ms | PRD는 "Calculator Dance"만 언급, UX가 구체 숫자 명시 |
| Color tokens | Base 6 + Accent 3 + Semantic 6 + Meta aside 3 hex 값 확정 | PRD 미언급 |
| Typography 10 scale | display/h1/h2/h3/body-lg/body/body-sm/caption/number-hero/number | PRD 미언급 |
| 9개 커스텀 컴포넌트 상세 | anatomy · states · accessibility · interaction · content guideline | PRD는 기능만 열거 |
| Design Direction 4안 비교 | Ledger · Studio · Instrument · Newsroom 비교표, Studio 선정 근거 | PRD 미언급 |
| Mobile Meta 토글 bottom sheet 대체 | SHOULD 명시 + 실패 시 "데스크톱에서 확인" 캡션 | PRD 모호 |

**미약한 불일치 (⚠️)**

| 항목 | 이슈 | 완화 방안 |
|-----|------|---------|
| Lighthouse 점수 스크린샷 About 노출 | UX Testing Strategy "발주자 심사용 보너스" 제안. PRD MUST 12에 없음 | SHOULD 영역으로 분류 권고 |
| Hero "계산기 체험" 버튼 + "샘플 사건 자동 로드" pulse | UX Experience Mechanics 진입 경로 (B)에 명시. PRD Hero 스펙에 명시적 언급 없음 | Epic 분해 시 FR8 Hero Story에 포함 |
| Contact 확인 Dialog | UX Consistency Patterns Modal "선택, 대체로 mailto 직행" 언급. PRD FR10 미결정 | MVP에서 Dialog 생략 + mailto 직행만 채택 권고 |

### UX ↔ Architecture Alignment

**강한 일치 (✅)**

| UX 결정 | Architecture 대응 | 일치도 |
|--------|-----------------|-------|
| shadcn/ui + Tailwind + Radix + Framer Motion | D5.x Starter + shadcn/ui `components.json` + Framer 11+ | ✅ 완전 |
| Framer Motion `layout` prop for Rights Cascade | D4.6 "Framer Motion `layout` prop (Rights Cascade)" | ✅ 완전 |
| Framer Motion `AnimatePresence` for aside slide-in | D4.6 "AnimatePresence (aside slide-in)" | ✅ 완전 |
| `useReducedMotion()` 훅 존중 | Pattern #8 "애니메이션 — `prefers-reduced-motion` 옵트인" | ✅ 완전 |
| Meta 토글 Zustand + localStorage + URL | D4.1 "Zustand + URL 파라미터(`?meta=1`) + `localStorage`" | ✅ 완전 |
| 계산기 React Hook Form + Zod | D4.2 "RHF + Zod resolver" | ✅ 완전 |
| 9개 커스텀 컴포넌트 | `components/meta/*` · `components/placeholder/*` · `components/tier/*` · `features/calculator/*` 디렉토리 구조 매핑 | ✅ 완전 |
| Pretendard + JetBrains Mono | `next/font` 사용 (암묵적 지원) | ✅ |
| Color contrast 4.5:1 사전 검증 | Cross-Cutting Concern #7 "Color Contrast 4.5:1 Figma 사전 검증" | ✅ |
| 카카오맵 iframe 대체 리스트 뷰 | UX-DR23 + `features/listings/ListingsMap.tsx` + `ListingsMapSkeleton.tsx` + aria-label | ✅ |
| Skip link `#main` | `components/layout/SkipNav.tsx` 파일 포함 | ✅ |
| `<TierGateBanner>` 블러 패턴 | `components/tier/TierGate.tsx` + `require="L2+" fallback={<BlurBanner />}` | ✅ |
| `<PlaceholderLabel reason severity>` | `components/placeholder/PlaceholderLabel.tsx` + Pattern Enforcement "표준 컴포넌트 강제" | ✅ |

**불일치 (❌ 명시적 충돌)**

**A1: Meta 주석 저장 형식 불일치 (HIGH)**
- UX Spec UX-DR8 (`<MetaAnnotationPanel />`): **"Source: `/content/meta-annotations.mdx` 단일 파일"**
- Architecture D4.5: **"`data/annotations.ts` TypeScript 모듈 + id 기반"**
- **충돌 영향**: Day 3 "Meta 주석 11개 작성" 시 MDX 파일과 TypeScript 모듈 중 어디에 콘텐츠를 쓸지 혼란. 두 형식은 마크다운 렌더링 vs 플레인 스트링 처리가 다름.
- **권고**: **Architecture 결정(TypeScript 모듈) 우선 채택** — 타입 안전 + grep + 번들 내 즉시 접근 이점이 크고 11개 규모에 MDX 오버엔지니어링. UX Spec 해당 언급(UX-DR8 Source 라인)을 `lib/data/annotations.ts`로 정정 필요.

**경미한 불일치 / 구체화 필요 (⚠️)**

**A2: Meta 토글 "첫 주석 자동 슬라이드인" 구현 디테일 미완 (MEDIUM)**
- UX Spec: "Meta 토글 ON 최초 전환 시 첫 주석 자동 슬라이드인" (Effortless Interactions + UX-DR6 + UX-DR8)
- Architecture D4.1: Zustand store 언급만, "처음 ON 전환 감지" 로직 상세 없음
- **권고**: Zustand store에 `hasTriggeredFirstAnnotation: boolean` 플래그 추가 (persist 대상). 토글 ON 시 `!hasTriggeredFirstAnnotation`이면 자동 슬라이드인 + true 설정. 세션당 1회 보장.

**A3: 매물 → 계산기 URL pre-fill 라우팅 미완 (MEDIUM)**
- UX Spec: "URL 파라미터(`?case=2024타경110044&preset=1`) — 매물+프리셋 pre-load 공유"
- epics.md FR2에 이 동선 명시됨
- Architecture: `/auction/[caseNumber]` 서브 경로는 있으나, "루트 `/` + `?case=...&preset=...` pre-fill"과 "/auction/[caseNumber] 상세 페이지" 관계 불명
- **권고**: Epic 분해 시 "매물 카드 → 계산기" Story에서 URL 설계 확정. 가장 간단한 경로: 루트 `/#calculator?case=...&preset=...` 앵커 + 쿼리 스트링 → `useSearchParams()`로 초기값 주입. `/auction/[caseNumber]`는 상세 페이지 전용(심화 콘텐츠).

**A4: Mobile Meta 토글 bottom sheet 대체 구현 경로 미완 (LOW)**
- UX Spec: "Meta 토글: 모바일에선 bottom sheet 대체 (**SHOULD**), 실패 시 토글 비활성 + '데스크톱에서 확인' caption"
- Architecture: shadcn `Sheet` 컴포넌트 사용이지만 side=right 고정. `side="bottom"` breakpoint 기반 동적 전환 경로 미언급.
- **권고**: `useMediaQuery(min-width: 768px)` 훅으로 `Sheet side` 동적 결정. 실패 시 토글 자체 비활성 폴백은 Day 4 배포 직전 Gate에서 결정.

**A5: About "Lighthouse 점수 스크린샷" 노출 여부 (LOW)**
- UX Spec Testing Strategy에서 제안한 아이디어, PRD·Architecture 모두 미언급
- **권고**: SHOULD 영역 등록. 배포 후 실제 점수로 `public/og/lighthouse-score.png` 삽입. Story 별도 분리.

### Warnings

**W1: 9개 커스텀 컴포넌트 × epics.md 미분해 매핑 리스크**
- UX Component Strategy에서 Day 1-4 Implementation Roadmap까지 정의 (Phase 1-4 분배)
- 그러나 epics.md에 Epic/Story 분해가 아직 없어 **UX의 Day 배분이 epics의 실제 Epic 순서와 일치할지 검증 불가**
- PRD Day 1 "골격 & 배포" → UX Phase 1 Day 1 `<PropertyCard>`, `<PlaceholderLabel>`, `<TierGateBanner>`
- PRD Day 2 "계산기" → UX Phase 2 Day 2 `<CalculatorPresetBar>`, `<CalculatorStepChunk>`, `<RightsCascade>`
- PRD Day 3 "권리분석+커뮤니티+Meta" → UX Phase 3 Day 3 `<MetaToggle>`, `<AmbientAnnotationMark>`, `<MetaAnnotationPanel>`
- PRD Day 4 "디자인 패스+About+배포" → UX Phase 4 Day 4 대비 재검증·접근성 테스트
- 권고: Epic 분해 시 UX Phase 1~4와 PRD Day 1~4를 **Epic 순서의 1차 앵커**로 사용.

**W2: 접근성·보안 방어선 구현 owner 3문서 간 분산**
- PRD FR11 = 독립 Capability
- UX Accessibility Strategy = WCAG 체크리스트 형태
- Architecture Pattern Enforcement + ESLint + lint-staged = 자동화 규칙
- epics.md = NFR4~NFR9 + UX-DR21~26 횡단 관심사로 분산
- 권고: Epic "접근성 & 보안 방어선"을 독립 Epic으로 편성. 기술 체크리스트(ESLint rule·lint-staged grep·Lighthouse CI·수동 Tab 주행)를 Story로 구체화.

### Alignment Summary

- **UX 문서 존재 및 완결성**: ✅ 매우 높음 (1,166 lines, 14 섹션 완주)
- **UX ↔ PRD 정렬**: ✅ 강한 일치 + 정당한 UX 구체화 확장
- **UX ↔ Architecture 정렬**: ✅ 주요 결정 완전 일치 (9/10 영역)
- **명시적 충돌**: 1건 (A1: Meta 주석 저장 형식 MDX vs TypeScript)
- **구체화 필요 (Epic 분해 시 해소)**: 4건 (A2~A5)
- **Cross-cutting 경고**: 2건 (W1: 9개 컴포넌트 × Epic 미분해 · W2: 접근성·보안 owner 분산)

## Epic Quality Review

### 🔴 CRITICAL BLOCKER: Epics 자체가 존재하지 않음

`epics.md` 파일의 `## Epic List` 섹션이 `{{epics_list}}` placeholder 그대로 남아있으며, **Epic 0개 · Story 0개 상태**입니다. 따라서 본 단계의 정상 목적(Epic Quality 검증: User Value · Independence · Forward Dependency · Story Sizing · Acceptance Criteria)은 **리뷰할 대상이 없어 수행 불가**합니다.

이는 Step 3에서 이미 발견된 C1(Epic List 미작성) 이슈의 연장선이며, Step 5의 검증 자체가 불가능함을 의미합니다.

### 대신 제공: Epic 분해 시 준수해야 할 Best Practice 사전 점검 항목

Epic이 작성될 때 다음 기준을 충족해야 함을 기록합니다. PRD·UX·Architecture·epics.md Requirements Inventory를 종합할 때 예상되는 Epic 구조에 대한 **pre-flight 가이드**입니다.

#### 권장 Epic 분해 (6~7개 권고)

제안 순서는 Architecture의 "Implementation Sequence" (D1~D5 결정) + PRD Day 1~4 분배 + UX Component Roadmap Phase 1~4를 종합한 것입니다.

| 제안 Epic | 예상 User Value | 예상 포함 Story | 선행 Epic |
|----------|---------------|---------------|----------|
| **Epic 1: 골격 & 인프라 배포** | 발주자가 HTTPS URL로 접속해 빈 페이지라도 렌더됨을 확인할 수 있다 | Starter 초기화, Supabase 프로젝트 생성, 카카오맵 도메인 등록, 6개 테이블 + RLS 마이그레이션, Vercel 배포 게이트 통과 | 없음 |
| **Epic 2: 매물 탐색 & Tier 경험** | 발주자가 경매 매물 카드와 tier 블러 경험을 통해 3-tier RBAC 설계 사고를 확인할 수 있다 | 정적 스냅샷 빌드 스크립트 + 마스킹, ListingsTabs/Map/Card, TierGate, PlaceholderLabel 표준 | Epic 1 |
| **Epic 3: 계산기 Killer** | 발주자가 프리셋 원클릭으로 Calculator Dance + Rights Cascade를 체감할 수 있다 | 계산기 순수 함수 포팅, Vitest 샘플 5건 골든, RHF+Zod 폼, Conversational Chunking, Rights Cascade, Live Calculation Shadow | Epic 1 |
| **Epic 4: 랜딩 Hero + 매물→계산기 연결** | 발주자가 Intent Framing 3초 통과 후 매물 카드→계산기 pre-fill 동선을 완주할 수 있다 | Intent Framing Strip, Map Breath, Live Ticker, Hero Reveal 리포트, URL pre-fill 라우팅 | Epic 2, Epic 3 |
| **Epic 5: Meta 토글 시스템 + 주석 11개** | 발주자가 Meta 토글 ON으로 의사결정 주석을 발견할 수 있다 | MetaToggle, MetaProvider(Zustand+URL+persist), AmbientAnnotationMark, MetaAnnotationAside, annotations.ts 11개 | Epic 1 (병렬 가능) |
| **Epic 6: 커뮤니티 UI + 대부업체 폼 + About** | 발주자가 About 공고 매칭 표 + Contact CTA 종착점에 도달할 수 있다 | 커뮤니티 3탭 + 샘플 글 5건, L2 게이팅 블러, 대부업체 매물 등록 폼, 공고 매칭 표, ContactCTA mailto, 법적 고지 | Epic 2, Epic 5 |
| **Epic 7: 접근성·보안 방어선 + 배포 문서** | 발주자가 Lighthouse 점수와 공개 저장소 품질을 검증할 수 있다 | ESLint no-restricted-syntax, lint-staged grep, SkipNav, aria-label 전수, Lighthouse 측정, README, CLAUDE.md, AGENTS.md, SEO/OG 메타 | Epic 1~6 | 

#### Epic Quality 체크리스트 (분해 시 준수)

각 Epic이 다음을 만족해야 합니다. Epic 작성 후 이 체크리스트로 재검증하세요.

**✅ User Value Focus**
- [ ] Epic 제목이 **발주자 관점 성과**로 표현됨 ("Setup Database" ❌ → "매물 탐색 경험" ✅)
- [ ] Epic Goal이 **Primary User(발주자) 관찰 가능한 결과**를 기술함
- [ ] Epic 하나만 배포해도 **김OO Journey 중 1개 단계**가 dead-end 없이 작동함 (대안: Placeholder 라벨)

**✅ Epic Independence**
- [ ] Epic 2는 Epic 1 산출물로만 작동, Epic 3을 참조하지 않음
- [ ] Epic 순서가 선형 누적이며 역방향 의존성 없음
- [ ] 병렬 가능 Epic은 명시 (예: Epic 5 Meta 토글은 Epic 1 완료 후 Epic 2~4와 병렬)

**✅ Story Sizing**
- [ ] 각 Story는 **1인 blynn 기준 0.5h~4h 범위** (50h / 30 Story 목표 = 평균 1.7h)
- [ ] "모든 테이블 생성" 같은 meta-story 금지 — 테이블은 **그 기능이 처음 필요할 때** 마이그레이션
- [ ] Story 설명에 "Story X.Y에 의존" 금지 (forward dependency 금지)

**✅ Database Table Creation Timing (⚠️ 주의)**
- Architecture D1.5는 **"테이블+RLS 동일 마이그레이션 파일에 원자적 커밋"**을 요구
- epics.md Additional Requirements는 **단일 마이그레이션 파일 `0001_init_schema.sql`에 6개 테이블 전체 원자적 커밋** 명시
- **Best Practice("테이블은 필요할 때 생성")와 Architecture 결정("한 파일에 원자적")이 충돌**
- **해결**: 이 프로젝트는 Architecture 결정 존중 권고 (6 테이블 규모가 작고 RLS 누락 방어가 NFR). Epic 1 Story 1이 "6 테이블 + RLS 원자적 커밋"을 단일 Story로 포함. 이를 Best Practice 이탈로 간주하되 **의식적 선택**(Meta 주석 후보: "왜 테이블 한 번에 만들었나")으로 기록.

**✅ Acceptance Criteria 품질**
- [ ] Given/When/Then BDD 구조
- [ ] 각 AC가 독립적으로 검증 가능 (자동화 or 수동 스모크)
- [ ] Happy path + error path 모두 커버
- [ ] 측정 가능한 결과 (예: "Lighthouse Accessibility ≥ 90" ✅ / "접근성 좋음" ❌)

**✅ Starter Template 요구사항 (Architecture D 선결정)**
- [ ] Epic 1 Story 1 제목 = **"Starter Template 기반 프로젝트 초기화"**
- [ ] 이 Story의 Acceptance Criteria:
  - `pnpm create next-app --example with-supabase npl-market` 실행 완료
  - `.env.local`에 Supabase URL + publishable key 주입 완료
  - `pnpm dev` 시 localhost:3000 에러 없이 렌더
  - Supabase 더미 쿼리 연결 확인
  - 카카오 개발자 콘솔 3환경(localhost + `*.vercel.app` + 커스텀 도메인) 등록 완료

**✅ Greenfield Indicators (이 프로젝트 해당)**
- [ ] Epic 1에 "초기 프로젝트 설정" Story 포함
- [ ] 개발 환경 구성 Story (ESLint + lint-staged + Vitest + pnpm scripts)
- [ ] CI/CD 파이프라인 = **Vercel Git Integration 자동**으로 해소 (GitHub Actions는 Vision)

#### Anticipated Violation Risks

Epic 분해 시 빠지기 쉬운 함정을 미리 기록합니다.

**🔴 Critical Risk 1: "접근성 & 보안 방어선" Epic이 Epic 7(끝)에 배치되는 문제**
- 만약 Epic 7에 모든 접근성·보안 규칙을 몰아넣으면, Epic 1~6 작업 중 이미 규칙 위반이 누적되어 Day 4 배포 전 긴급 리팩터 발생.
- **해결**: 접근성·보안 규칙 중 **자동화 가능한 부분(ESLint rule, lint-staged grep, shadcn 기본 ARIA)은 Epic 1 Story 1에 포함**. Epic 7은 수동 Lighthouse 측정, Skip link 최종 검증, Color Contrast 재검증만.

**🟠 Major Risk 2: Epic 3 계산기가 Epic 5 Meta 토글 의존성 가짐**
- 계산기 출력 옆 Ambient Annotation 인디케이터(`·`)가 Meta 시스템에 의존.
- **해결**: Epic 3에서는 계산기 core + UX만 구현. Ambient Annotation은 Epic 5에서 "계산기·매물·커뮤니티 전역에 Mark 주입" Story로 별도 배치. Epic 3 단독 배포 시 인디케이터 없음은 OK (계산기 자체는 작동).

**🟠 Major Risk 3: Epic 4 Hero Reveal 권리분석 리포트가 Epic 3 계산기 로직 의존성 가짐**
- Hero Reveal Full Writeup은 실제 권리분석 결과 텍스트를 노출함. 계산기 로직과 데이터 일관성이 필요.
- **해결**: Hero Reveal은 **정적 Markdown/MDX 1건 콘텐츠**로 하드코딩 (작성 공수 1h). 계산기 로직이 동적 생성하지 않음. Meta 주석에 "실 배포 시 계산기 출력 자동 렌더 연동" 명시.

**🟡 Minor Risk 4: 대부업체 매물 등록 폼 Epic 귀속 모호**
- epics.md FR14로 독립 존재하나, Journey상 대부업체 Tier(배지) 경험의 일부. RBAC (Epic 1) 쓰기 = admin 단일로 한정되어 Server Action 경유.
- **해결**: Epic 6 "커뮤니티 + About"에 포함 또는 Epic 2 "매물 탐색 & Tier"에 포함 — 어느 쪽이든 Meta 주석 #7 "왜 admin 승인 생략했는가" 연결 필수.

**🟡 Minor Risk 5: Meta 주석 11개 콘텐츠 작성 공수 누락**
- `lib/data/annotations.ts` 구현(5h)과 **11개 주석 본문 집필(예상 2~3h)이 별개** 공수. PRD MUST 12 #8 5h에 포함되지 않을 수 있음.
- **해결**: Epic 5에 "Meta 주석 11개 콘텐츠 작성" Story 2h 분리. 각 주석 = 1~2문단 + 근거 링크.

### Epic Quality Review Summary

- **검토 가능 여부**: ❌ Epics 미작성으로 정상 리뷰 불가
- **제공 대체물**: Epic 분해 시 준수해야 할 pre-flight 가이드 (7 Epic 권고 + 체크리스트 + 5개 예상 위험)
- **즉시 필요 조치**: `bmad-create-epics-and-stories` 스킬 실행 → 본 가이드를 입력으로 Epic 6~7개 + Story 약 30개 분해 → 본 체크리스트로 재검증

## Summary and Recommendations

### Overall Readiness Status

**🟡 NEEDS WORK** — 구현 시작 전 단일 critical 블로커 해소 필요

**판단 근거**:
- PRD · UX · Architecture 3문서는 **매우 높은 품질과 정렬도**를 보임 (개별 품질 우수)
- 그러나 **Epic/Story 분해가 미완(`{{epics_list}}` placeholder)** 상태로, 4일 MVP 38h 공수 배분 단위와 구현 순서·병렬성·Gate 판단 기준이 없음
- Requirements Inventory 수준까지만 완결되어 "Day 1 오전에 어떤 Story부터 시작하는가"의 답이 없는 상태

이 상태에서 곧바로 `bmad-dev-story` 또는 `bmad-quick-dev`로 구현에 들어가면 다음 리스크가 발생합니다:
- 공수 과소추정 → Day 4 배포 Gate 실패
- Epic 간 순서 혼선 → 동일 파일 반복 수정
- Forward dependency 노출 → "Epic 3를 하려면 Epic 5가 있어야 함" 발견

### Critical Issues Requiring Immediate Action

#### 🔴 Critical 1건

**C1: Epic/Story 분해 완전 미작성** — `epics.md`의 `## Epic List` · `## FR Coverage Map` 두 섹션이 template placeholder 상태. Epic 0개 · Story 0개 · 공수 추정 0h 분배됨. **구현 블로커**.

#### 🟠 High 4건

**H1: PRD FR11(접근성 & 보안 방어선)이 독립 FR로 승격되지 않음** — epics.md에서 NFR4~9 · UX-DR21~26로 분산. Cross-cutting 특성상 "누가 체크리스트 실행하나" owner 불명. Lighthouse Accessibility ≥ 90 미달성 리스크.

**H2: Meta 주석 저장 형식 UX ↔ Architecture 충돌** — UX Spec UX-DR8이 `/content/meta-annotations.mdx` 단일 파일을 언급하는 반면, Architecture D4.5는 `lib/data/annotations.ts` TypeScript 모듈로 확정. Day 3 "Meta 주석 11개" Story 착수 시 혼란.

**H3: PRD NFR14 Plausible 이벤트 계측 지위 불명** — Success Criteria "Meta 토글 ON 전환율 + 60초+ 체류"의 측정 수단인데 SHOULD로 분류. MVP 배포해도 핵심 KPI 측정 불가 → 포트폴리오 유효성 검증 자체 불가.

**H4: Contact CTA 세부 사양 미정** — 실 이메일 주소, mailto subject 템플릿, Slack DM 링크 실 주소 결정 안 됨. Day 4 배포 직전 즉흥 결정 리스크.

#### 🟡 Medium 5건

**M1: PRD MUST 12 #1 "골격 & 배포" 5h 공수가 Starter 사용 기준인지 from-scratch 기준인지 불명** — Architecture는 Starter 기반으로 2-3h 절약 명시.

**M2: Meta 주석 11개 **콘텐츠 작성 공수** 미할당** — 기술 구현(5h) 외 본문·근거 링크 writing 2~3h 별도 필요.

**M3: 정적 스냅샷 JSON 스키마 미정의** — `app/data/listings.json` 필드 구조가 어디에도 정의되지 않음. `scripts/build-snapshot.ts` 구현 착수 블로커.

**M4: 매물 카드 → 계산기 URL pre-fill 라우팅 경로 미완** — epics.md FR2에 기능만 명시, Architecture에서 `/#calculator?case=...&preset=...` vs `/auction/[caseNumber]` 관계 불명.

**M5: Mobile Meta 토글 bottom sheet 대체 구현 경로 미완** — UX는 SHOULD로, Architecture는 shadcn `Sheet side=right` 고정으로 결정. breakpoint 동적 전환 로직 없음.

#### 🔵 Low 4건

- L1: About 섹션 Lighthouse 점수 스크린샷 노출 여부 미결정 (SHOULD)
- L2: Hero "계산기 체험" 빈 계산기 + 샘플 사건 자동 로드 버튼이 PRD에 없음 (UX만 명시)
- L3: SHOULD → MUST 승급 기준 우선순위 미정 (Gate 통과 시)
- L4: admin JWT claim 주입 방식 (Supabase custom claim vs env 하드코딩) 미확정 — Architecture는 `ADMIN_EMAILS` 환경변수 채택으로 해소

### Recommended Next Steps

1. **[즉시 · 2~3h] `bmad-create-epics-and-stories` 스킬 실행으로 Epic 분해 완료**
   - Step 5에서 제시한 7 Epic 권고 구조를 입력 가이드로 사용
   - 각 Epic의 Story를 0.5h~4h 단위로 분해 (총 ~30 Story, 평균 1.7h)
   - PRD MUST 12 + epics.md FR20 + UX-DR28 + Architecture D1~D5를 전부 Story AC에 추적성 유지
   - 공수 총합 38h 안착 검증 + 12h 버퍼 확인

2. **[Epic 분해 직후 · 0.5h] 4건의 High 이슈 중 결정 필요 항목 확정**
   - **H2 Meta 주석 저장 형식**: Architecture 결정(TypeScript 모듈) 채택하고 UX Spec 해당 언급 수정
   - **H3 Plausible 지위**: MUST 승급 (script 삽입 1h 이내) — Epic 7에 "Plausible 이벤트 계측" Story 추가
   - **H4 Contact CTA 실 주소**: 이메일 주소 결정 + 제목 템플릿 "NPL 마켓 외주 문의 — {회사명}" Story AC에 확정

3. **[Epic 분해 직후 · 0.5h] H1 접근성·보안 방어선 독립 Epic 편성**
   - Step 5에서 제시한 "자동화 가능한 부분은 Epic 1 Story 1에 포함 · 수동 측정은 Epic 7" 분리 전략 채택
   - ESLint `no-restricted-syntax` for `new Date()` 규칙 Story
   - lint-staged pre-commit grep (`SUPABASE_SERVICE_ROLE_KEY`) Story
   - Lighthouse 측정 + Skip link 검증 Story (Epic 7)

4. **[Epic 분해 직후 · 1h] Medium 이슈 Story 내부 결정 문서화**
   - M3 정적 스냅샷 JSON 스키마: Zod schema로 작성 (`app/data/listings.schema.ts`)
   - M4 URL pre-fill: 루트 `/#calculator?case=...&preset=...` 앵커 + `useSearchParams()` 채택 권고
   - M2 Meta 주석 콘텐츠 writing Story 별도 할당 (Epic 5 내부 2h)
   - M5 Mobile bottom sheet: SHOULD 유지, Day 4 Gate에서 결정

5. **[구현 전 · 0.5h] `bmad-check-implementation-readiness` 재실행**
   - 본 리포트의 재발행 — Epic 분해 완료 후 Step 3·5가 정상 동작함을 확인
   - C1 블로커 해소 + H1~H4 · M1~M5 체크리스트 검증
   - READY 상태 도달 시 `bmad-sprint-planning` 또는 `bmad-dev-story` 진입

6. **[구현 시작 직전 · Day 1 오전] Starter + 선행 작업 Gate**
   - `pnpm create next-app --example with-supabase npl-market` 실행
   - 카카오 개발자 콘솔 3환경 도메인 등록 (**Day 4 데모 1순위 리스크 방어**)
   - Supabase 프로젝트 + 6 테이블 + RLS 원자적 커밋
   - `pnpm dev` 렌더 확인 = Day 1 Gate 통과

### Final Note

본 평가는 **14건의 이슈를 4개 심각도 카테고리로 식별**했습니다 (Critical 1 · High 4 · Medium 5 · Low 4).

그러나 PRD · UX · Architecture · epics.md Requirements Inventory 자체의 개별 품질은 매우 우수하며, **Critical 1건(Epic 분해 미작성)만 해소되면 구현 준비 상태에 도달**할 것으로 평가됩니다. High 4건은 Epic 분해와 병행 해소 가능하며, Medium·Low 항목은 Story AC 내부 결정으로 흡수 가능합니다.

구현 시작 전 **최소 2~3시간의 Epic 분해 투자**가 4일 MVP 50h 제약 하에서 "계산기 코어 Gate → Meta 토글 Gate → 배포 전 점검 Gate → 최종 배포 Gate" 4단계 escalation 판단을 가능케 하며, 그 ROI가 매우 큽니다.

본 평가는 artifact 개선에 활용하시거나, 현 상태로 진행하시기로 결정하실 수도 있습니다.

---

**Assessor:** Winston (bmad-agent-architect) + bmad-check-implementation-readiness skill
**Date:** 2026-04-22
**Report Path:** `_bmad-output/planning-artifacts/implementation-readiness-report-2026-04-22.md`

