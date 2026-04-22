---
stepsCompleted: ['step-01-validate-prerequisites', 'step-02-design-epics', 'step-03-create-stories']
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/architecture.md
  - _bmad-output/planning-artifacts/ux-design-specification.md
---

# NPL 마켓 - Epic Breakdown

## Overview

이 문서는 **NPL 마켓**의 Epic/Story 분해 결과를 담습니다. PRD의 요구사항, UX 디자인 스펙, 아키텍처 결정을 구현 가능한 스토리로 분해합니다.

**핵심 제약**: 4일 MVP · 1인(blynn) · 50h 상한 · 제로 버퍼. 모든 Epic/Story 분해는 **"단단한 12개 > 피상적 19개"** 원칙에 따릅니다.

## Requirements Inventory

### Functional Requirements

**FR1**: 매물 탐색 3탭 (경매·공매·신탁공매) 구현 — 경매 탭만 정적 스냅샷 실 데이터 렌더, 공매·신탁공매는 `<PlaceholderLabel severity="demo">`로 정직 노출. 지도·리스트 뷰 병행.

**FR2**: 매물 카드에서 "이 물건 시뮬레이션" 버튼 클릭 시 계산기 앵커 스크롤 + URL 파라미터(`?case=...&preset=...`)로 사건번호·감정가 pre-fill.

**FR3**: NPL 계산기 15필드 입력 수용 및 배당·수익률 계산 — Apps Script v3.1 로직 TypeScript 포팅 (양편넣기 +1일, 채권최고액 Cap, 질권대출 100만원 절사, 배당순서 당해세 최우선, 지역별 소액임차 한도 자동 반영).

**FR4**: 계산기 프리셋 3종 — "1회 유찰+70%" 1종 완성(15필드 원클릭 자동 입력), "방어입찰"·"재매각" 2종 `<PlaceholderLabel>` 오버레이.

**FR5**: 계산기 Conversational Chunking (15필드를 4-5 step 분할, 한 화면에 1 step 노출, Enter/Shift+Tab 이동) + Live Calculation Shadow (입력 200ms 디바운스 부분 재계산 + 영향 출력 필드 150ms highlight).

**FR6**: Rights Cascade — 말소기준권리 → 후순위 재정렬 애니메이션 (Framer Motion `motion.ul` + `layout` prop, stagger 0.4s). 법적 순서 시각화.

**FR7**: Calculator Dance — 출력 25+ 필드를 세 구획(기간·수익률·배당) 동시 fade-up + stagger로 펼침 (프리셋 클릭 ~ 완료까지 ≤ 1.2초).

**FR8**: 랜딩 Hero — Intent Framing 스트립 ("NPL 실무자 × 핀테크 PM blynn의 작업물…") + Map Breath 배경 애니메이션 + Live Ticker (CSS 루프, 실 사건번호 노출) + Hero Reveal 권리분석 리포트 1건 Full Writeup.

**FR9**: 현직자 커뮤니티 UI 목업 — 3 카테고리(경매방 샘플 글 5건 실동, 자유수다방·Q&A Placeholder) + L2+ 게이팅 블러 배너(상단 3건 후 `backdrop-blur-sm` + 중앙 "검증 요청" CTA + 설계 이유).

**FR10**: 3-tier RBAC — L1 일반·L2 검증·L3 전문가 + 🏢대부업체 배지 + admin. Supabase 이메일 매직링크 인증(본인인증 미연동). `profiles` 테이블 tier lookup 기반 권한 체크. L1→L2 승격 요청 플로우(Server Action).

**FR11**: Meta 토글 시스템 — 우상단 fixed 토글(shadcn Switch) + 스페이스바 단축키 + URL 파라미터(`?meta=on`) + localStorage persist(`npl-market:meta-store`) + 전역 상태(Zustand) + 첫 주석 자동 슬라이드인(Meta ON 최초 전환 시).

**FR12**: Meta 주석 11개 서빙 — 각 기능 옆 `<AmbientAnnotationMark id="..." />` 인디케이터(OFF `·` / ON "왜?") + `<MetaAnnotation id="...">` id 기반 참조 + `<MetaAnnotationPanel>` aside Sheet (420px, side=right, 300ms ease-out, focus trap, ESC 닫힘) + Accordion 형태로 번호·제목·본문·근거·관련 주석 노출.

**FR13**: Placeholder 라벨 체계 — `<PlaceholderLabel reason severity>` 표준 컴포넌트(3 variants: demo/pending/vision) + 모든 미구현 접점(저장·댓글·글쓰기·심의서 다운로드·공매/신탁공매 탭·admin UI 등)에 일관 적용. dead-end 0건.

**FR14**: 대부업체 매물 등록 폼 — 10개 필드 + Server Action 제출 + admin 승인 없이 바로 상태 변경 (Meta 주석 #7로 이유 명시).

**FR15**: About 섹션 — 공고 매칭 표 line-by-line(공고 단어 그대로 헤더 인용) + 겸업/전업 가능 범위 명시 + Contact SLA + 법적 고지 인라인 + Contact CTA (mailto 자동 핸들러, 모바일에서도 메일 앱 자동 실행).

**FR16**: 규제 카피 리프레이밍 상수 모듈 (`lib/copy/regulatory.ts`) — "거래" → "정보 매칭", "가입 승인" → "대부업법 L2 적격성 자진 확인", 권리분석 리포트 상단 "정보·참고용 — 실제 판단은 변호사 자문 필요" 배너 등 단일 소스 관리.

**FR17**: 채무자 정보 마스킹 — 빌드 스크립트 `scripts/build-snapshot.ts`가 원본 크롤링 JSON → 채무자 이니셜 + 주소 동 단위 변환 → `app/data/listings.json` 생성 (빌드 타임 1회 처리).

**FR18**: admin 최소 운영 경로 — `ADMIN_EMAILS` 환경변수 기반 Server Component guard (`/admin` 라우트) + tier 수동 승격 시연 UI. Admin UI 고도화(매물 관리·rich tier 변경)는 MVP 범위 밖 Meta 주석에 명시.

**FR19**: README (발주자 시선 3문단) + BMAD PRD 공개 링크 + 커스텀 도메인 배포 + 카카오맵 개발자 콘솔 도메인 등록 (로컬·preview·production 3환경 전부) + Lighthouse 로컬 측정 스크립트 + CLAUDE.md/AGENTS.md 에이전트 가이드.

**FR20**: SEO/OG 메타 — `app/layout.tsx` OG tags + Twitter Card + JSON-LD (Person blynn + CreativeWork NPL 마켓) + `robots.txt` + `sitemap.xml` (링크드인·슬랙 공유 시 프리뷰 품질 확보).

### NonFunctional Requirements

**NFR1 — 계산기 수치 정합성**: 샘플 5건(① 채권최고액 Cap ② 질권대출 100만원 절사 경계 ③ 당해세 개입 ④ 윤년 케이스 ⑤ 단순 케이스)에 대해 **원 단위 완전 일치**. 절사·Cap은 비트 단위, 수익률은 소수점 4자리 일치. Vitest 골든 테스트로 `pnpm test:run` 통과 시에만 배포.

**NFR2 — 타임존 보정**: `date-fns-tz` + `Asia/Seoul` 명시. Vercel serverless UTC ↔ Apps Script Asia/Seoul 갭 방어. 윤년·말일 처리 검증. `lib/format/date.ts` 외부에서 `new Date()` 직접 호출 ESLint 금지.

**NFR3 — Lighthouse Performance ≥ 80**: 랜딩·계산기·리스트 페이지 한정 (지도 페이지 제외, 카카오맵 SDK 300KB+ 이슈). Core Web Vitals: LCP < 2.5s / FID < 100ms / CLS < 0.1.

**NFR4 — Lighthouse Accessibility ≥ 90**: 전 페이지. WCAG 2.1 Level AA. shadcn/ui + Radix primitives 기반.

**NFR5 — 접근성 필수 3요소**: ① 키보드 Tab 완결성 (계산기 15필드 순서, Meta 토글 스페이스바, aside focus trap) ② 시맨틱 HTML (`<main>/<aside>/<nav>/<section>` + `<label for=>` + `aria-describedby`) ③ Focus visible (Tailwind `focus-visible:ring-2 ring-accent ring-offset-2`) + Color contrast 4.5:1 (본문), 3:1 (대형·비텍스트).

**NFR6 — 카카오맵 접근성**: iframe 컨테이너 `aria-label="경매 매물 지도"` + `title` 속성 + 지도 아래 리스트 뷰 병행 (fallback).

**NFR7 — `service_role` 키 클라이언트 유입 0건**: `.env.example`만 공개 + `.env.local` gitignored + `lint-staged` pre-commit grep (`SUPABASE_SERVICE_ROLE_KEY` 문자열 발견 시 커밋 차단).

**NFR8 — RLS 정책 누락 테이블 0건**: 전 테이블 RLS ON + 테이블 생성·RLS 정책을 동일 마이그레이션 파일에 원자적 커밋. 쓰기 매트릭스 전수 검증은 Post-MVP SHOULD.

**NFR9 — Storage 버킷 RLS 별도 적용**: `public-assets/` 단일 공개 버킷 + anon read 정책 명시.

**NFR10 — 실명 수집 0**: Supabase Auth 이메일 매직링크 단독. 본인인증(PASS, 카카오 소셜 로그인) 미연동. `profiles`에 `display_name`만 저장.

**NFR11 — 채무자 정보 공개 한정**: 공개 사건번호(법원경매·온비드)만 사용. 채무자 이름은 이니셜, 주소는 "동" 단위까지. 빌드 스크립트 1회 마스킹 처리.

**NFR12 — 브라우저 호환성**: 데스크톱 Chrome/Safari/Firefox/Edge 최신 (필수). 모바일 Safari iOS·Chrome Android 최신 ("깨지지 않을 정도"). IE11 이하 미지원.

**NFR13 — 반응형 설계 기준**: 1440px 데스크톱 설계 기준, 1024px 랩탑 기본 대응, 768px 태블릿 기본, 375px 모바일 첫 스텝만 품질 보장 (Journey 3 법무법인 A 모바일 진입 대응).

**NFR14 — 단일 테넌트**: Global Pool. 대부업체별 workspace 분리 미구현 (Meta 주석에 실 배포 시 multi-tenant 격리 필요성 명시).

**NFR15 — 정적 스냅샷 박제**: 2026-04-20 기준 JSON 덤프 사용. 실시간 크롤링 미배포 (courtauction.go.kr 이용약관 방어).

**NFR16 — 무료 티어 경계**: Vercel + Supabase 무료 플랜 내 안착. 트래픽 급증 시 정적 폴백 페이지 SHOULD.

**NFR17 — 4일 MVP 예산**: 1인 blynn 단독, 50h 상한, 제로 버퍼. milestone Gate 기반 스코프 축소 에스컬레이션 (계산기 Gate → Meta 토글 Gate → 배포 전 점검 Gate → 최종 배포 Gate).

**NFR18 — `prefers-reduced-motion` 존중**: Calculator Dance · Rights Cascade · aside slide-in 모든 Framer Motion 사용처에서 `useReducedMotion()` 훅 체크 → true면 `transition={{ duration: 0 }}` 폴백.

**NFR19 — 규제 카피 단일 소스**: "거래·가입 등 민감 단어"는 `lib/copy/regulatory.ts` 경유 필수. 컴포넌트 직접 하드코딩 금지.

**NFR20 — Meta 주석 11개 전부 서빙**: 주석 한 개도 누락 없이 MVP 배포. Meta 토글 Gate 실패 시에도 최소 8개로 축소하되 #11(교양 콘텐츠 제외 이유) 우선 보존.

### Additional Requirements

**아키텍처 결정에서 도출된 기술·인프라 요구사항:**

- **Starter Template**: `create-next-app --example with-supabase` (Vercel + Supabase 공식 유지 템플릿) — **Epic 1 Story 1의 기반**. Vercel + Supabase 셋업 2~3시간 절약, Server Components 호환 Supabase 클라이언트 분리 + middleware 세션 갱신 패턴 pre-wired.
- **런타임**: Next.js 최신 stable (16.x, Turbopack dev stable, AGENTS.md 포함) + React 18/19 + TypeScript strict + Node.js 18+.
- **패키지 매니저**: `pnpm` (disk-efficient, Vercel 기본 지원).
- **DB 스키마**: 6개 테이블 — `profiles` · `listings` · `community_posts` · `annotations` · `tier_requests` · `activity_log`. 단일 Supabase CLI SQL 마이그레이션 파일 (`supabase/migrations/0001_init_schema.sql`)에 테이블 + FK + index + RLS 원자적 커밋.
- **Validation**: Zod 단일 스키마 (타입 + 폼 + Server Action + 테스트 커버). `@hookform/resolvers/zod` 통합.
- **데이터 페칭**: Server Components 직접 Supabase 쿼리(기본) + Server Actions(변경). `app/api/*` 는 webhook 등 예외만. 반환 타입 `{ data: T } | { error: string }` discriminated union (Server Actions).
- **계산기 실행**: 클라이언트 사이드 순수 함수 (`lib/calculator/*.ts`) + Vitest `node` 환경 골든 테스트. 부작용(I/O·console·`Date.now`·`Math.random`) 절대 금지.
- **Meta 토글 상태**: Zustand + URL 파라미터(`?meta=1`) + `localStorage` persistence. SSR 안전 패턴 (`createStore` + Context Provider, `stores/provider.tsx`).
- **계산기 폼 상태**: React Hook Form + Zod resolver. `mode: 'onBlur'` + submit 재검증. 필드 이름 = schema key (snake_case).
- **라우팅 구조**: 루트 `/` 단일 페이지 + 섹션 앵커(`/#calculator`, `/#about`, `/#community`) + 서브 경로 `/auction/[caseNumber]`, `/profile/tier-request`, `/admin`.
- **컴포넌트 조직**: 기능별 `features/` (landing-hero, listings, calculator, community, about, lender-form) + 공용 `components/ui` (shadcn 자동 생성) + `components/meta` + `components/placeholder` + `components/tier` + `components/layout` + `components/seo`. `utils/supabase/*` · `components/ui/*` 직접 수정 금지.
- **Meta 주석 서빙**: `lib/data/annotations.ts` TypeScript 모듈 + id 기반 (`<MetaAnnotation id="rls-reason" />`). 인라인 텍스트 금지.
- **애니메이션**: Framer Motion `layout` prop (Rights Cascade) + `AnimatePresence` (aside slide-in) + `dynamic import`. `useReducedMotion` 훅 존중.
- **환경 분리**: 3단계 (`local` .env.local · `preview` Vercel env · `production` Vercel env). Supabase 프로젝트 단일(무료 티어 1개 한도).
- **도메인**: 커스텀 도메인 + `*.vercel.app` preview 와일드카드. 카카오 개발자 콘솔 3환경 전부 등록 (**Day 4 데모 지도 장애 1순위 리스크 방어**).
- **Analytics**: Plausible (SHOULD) — 개인정보 비수집, Meta 토글 전환율 측정. Sentry/Vercel Analytics 미도입.
- **CI/CD**: Vercel Git Integration (PR → preview, main → production 자동). GitHub Actions 미추가(4일 범위 외). `tsc --noEmit` + Vitest + ESLint는 로컬 `pnpm build` pre-check.
- **AI 에이전트 일관성**: `CLAUDE.md` 프로젝트 루트 배치 + `AGENTS.md` (Next.js 16 기본) 중복 반영. ESLint custom rule (`no-restricted-syntax` for `new Date()`). Zustand selector 함수형 강제.
- **테스트 co-location**: 계산기 테스트는 소스 옆 (`dividend.ts` + `dividend.test.ts`) + fixture 분리 (`__fixtures__/sample-01-cap.ts` 등 5개).
- **에러 핸들링**: App Router `error.tsx` boundary + shadcn `sonner` toast. Server Action에서 `throw` 금지 → discriminated union 반환.
- **규제 카피 상수 모듈**: `lib/copy/regulatory.ts` 단일 소스. `<Button>거래하기</Button>` 같은 하드코딩 금지.
- **날짜/금액 유틸 중앙화**: `lib/format/date.ts`(Asia/Seoul) + `lib/format/currency.ts` (`formatWon(amount, 'short' | 'full')`). `new Date()`, `.toLocaleString()` 직접 호출 금지.
- **정적 스냅샷 저장 위치**: `app/data/*.json` (코드 번들) — 빌드 타임 정적 import → SSG 최적화. `scripts/build-snapshot.ts` 가 원본 → 마스킹 → `app/data/listings.json` 생성.
- **Storage 단일 버킷**: `public-assets/` (RLS ON + anon read 정책). 권리분석 리포트 이미지·OG 이미지용.
- **.env 방어**: `.env.example` 공개 + `.env.local` gitignored + `lint-staged` pre-commit grep (`SUPABASE_SERVICE_ROLE_KEY` 문자열 차단).

### UX Design Requirements

**디자인 시스템 토큰 (Tailwind `theme.extend`):**

- **UX-DR1**: Color system 토큰 구현 — Base Neutral Scale 6개 (`bg-primary` #FAFAF9, `bg-secondary` #F5F5F4, `border` #E7E5E4, `muted` #78716C, `foreground` #1C1917, `foreground-hi` #0C0A09) + Accent 3개 (`accent` #475569, `accent-hover` #334155, `accent-subtle` #E2E8F0) + Semantic tier 3개 (`tier-l2` cyan-600, `tier-l3` violet-600, `tier-biz` yellow-700) + Meta aside 3개 (`meta-bg`, `meta-border-l`, `meta-accent`). **모든 본문 4.5:1 대비 검증 통과.**
- **UX-DR2**: Typography System — `Pretendard Variable` (primary sans, `next/font` 로드) + `JetBrains Mono` (사건번호·코드 인용) + 10개 type scale 토큰 (`display` 48/56, `h1` 36/44, `h2` 28/36, `h3` 22/30, `body-lg` 18/28, `body` 16/26, `body-sm` 14/22, `caption` 12/18, `number-hero` 40/48 tabular-nums, `number` 20/28 tabular-nums). Reading width `max-w-prose` (~65ch). Korean line-height 1.5-1.7.
- **UX-DR3**: Spacing & Layout — Base unit 4px (Tailwind 기본), 컴포넌트 내부 padding 12-16px, 카드 사이 16-24px, 섹션 간 64-96px, 페이지 좌우 마진 데스크톱 32-64px/모바일 16-24px. Grid: 1440px 설계 기준 max-width `1280px` 12-col fluid.
- **UX-DR4**: Motion tokens — 짧은 transition 150-200ms, Calculator Dance 400-600ms, aside Sheet 슬라이드인 300ms ease-out. `easeOut` 기본 curve. 모든 사용처에 `prefers-reduced-motion` 존중 (`useReducedMotion()` → `duration: 0`).

**커스텀 컴포넌트 9종 (shadcn/ui 확장):**

- **UX-DR5**: `<PlaceholderLabel reason severity>` — shadcn `Badge` variant + `Popover` 결합. 3 variants: `demo`(회색 "데모용 Placeholder") / `pending`(노란 "준비 중") / `vision`(보라 "실 배포 시 제공"). `reason` prop 필수, Popover로 1-2문장 이유 노출. `aria-label="이 기능은 데모용입니다: {reason}"`, 키보드 포커스로 Popover 열림.
- **UX-DR6**: `<MetaToggle />` 단일 인스턴스 — shadcn `Switch` 기반, 우상단 fixed, "Meta" 레이블 + `·` 장식. 상태 `off`/`on`/`focus-visible`. `role="switch"` `aria-pressed` `aria-label="의사결정 주석 토글"`. 스페이스바 전역 단축키. 클릭 → 전역 Zustand state 토글 → aside Sheet 자동 오픈 + `<AmbientAnnotationMark>` pronounced 모드 전환. localStorage + URL `?meta=on` 공유.
- **UX-DR7**: `<AmbientAnnotationMark id="..." />` — Meta OFF 시 작은 `·` muted 인디케이터 + hover Tooltip preview. Meta ON 시 "왜?" caption 배지. `aria-label="의사결정 주석 #{id} 표시"`, 키보드 포커스 가능. 클릭 시 Meta OFF면 자동 ON + aside 해당 주석 스크롤 + 150ms highlight.
- **UX-DR8**: `<MetaAnnotationPanel />` — shadcn `Sheet` (side=right, width 420px) + 내부 `Accordion` + 주석 11개 리스트. 콘텐츠 구조: `#{번호} {주제}` + 본문(body-sm, max-w-prose) + `근거:` 법령·판례·GitHub 커밋 링크 + `관련 주석:` 번호 링크. `role="complementary"` `aria-label="의사결정 주석"`, ESC 닫힘, focus trap. Meta ON 최초 시 첫 주석 자동 expanded.
- **UX-DR9**: `<CalculatorPresetBar presets={[...]} />` — 가로 Button 그룹 3개 ("1회 유찰+70%" / "방어입찰" / "재매각"). 상태 `default`/`pulse`(최초 500ms 1회)/`active`/`hover`/`focus-visible`. `role="group"` `aria-label="계산기 프리셋"`, 각 버튼 `aria-pressed`. 클릭 → 15 입력 필드 값 자동 채움 → Calculator Dance 트리거. MVP 1종 실동, 2종은 `<PlaceholderLabel severity="demo">` 오버레이.
- **UX-DR10**: `<CalculatorStepChunk stepIndex={n} />` — Conversational Chunking 단일 step 카드 + 제목(body-sm semibold) + 3-4 필드 + step 인디케이터 (1/4). 상태 `active`/`completed`/`pristine`. 각 필드 `<label for=>`, step 사이 Tab 자연 이동. Enter 다음 step, Shift+Tab 이전. 200ms 디바운스 Live Calculation Shadow 트리거.
- **UX-DR11**: `<RightsCascade items={...} />` — Framer Motion `motion.ul` + `layout` prop + 각 항목 `motion.li layoutId`. stagger 0.4s, 항목 fade+slide 300ms, `layout` 전환 `easeOut`. `role="list"`, 재정렬 직전 `aria-live="polite"` "권리 순서 재정렬 중" 선언.
- **UX-DR12**: `<PropertyCard property tier>` — 썸네일 없음(빌사남 패턴). 상단 사건번호 + tier 배지, 중앙 `number` 금액, 하단 진행률 + 특수물건 태그(유치권·법정지상권 등). 상태 `default`/`hover`(accent-subtle bg + border)/`focus-visible`/`tier-blurred`. `<article>` 태그, `aria-label="매물 {사건번호} 상세"`. CTA "이 물건 시뮬레이션" 버튼 → 계산기 앵커 + URL pre-fill. Tier 블러: 권한 부족 시 `blur-sm` + "L2 검증 후 해제" caption.
- **UX-DR13**: `<TierGateBanner targetTier reason />` — 상단 3건 노출 후 `backdrop-blur-sm` + 중앙 배너 ("L2 검증 회원 전용" + "검증 요청" 버튼 + 이유). 상태 `locked`/`unlocked` (tier 충족 시 자동 해제). `role="region"` `aria-label="L2 검증 필요 콘텐츠"`. 옆에 `<AmbientAnnotationMark id="5">` 연결.

**UX Consistency 패턴:**

- **UX-DR14**: Button Hierarchy 3단 — Primary (1화면 1개, `variant=default` accent 배경, "이 물건 시뮬레이션"·프리셋·Contact) / Secondary (`variant=outline` + accent 텍스트, "L2 검증 요청"·"샘플 사건 로드") / Tertiary (`variant=ghost`, 탭·Footer). "지금 시작" 강요형 카피 금지. Destructive 액션 MVP에 없음.
- **UX-DR15**: Feedback 패턴 — Success 인라인 badge 또는 `sonner` toast 우하단 3초 dismiss (🎉 금지) / Error 필드 `destructive` border + inline hint + `aria-describedby` (모달 금지) / Warning 영구 배너 (Footer · 섹션 상단) / Info 상태 유지 badge + Meta aside 상세. Toast 우하단 최대 3 스택.
- **UX-DR16**: Form 패턴 — Label 필드 위 left-aligned (`mb-1.5`) / Required 뒤 작은 `*` (destructive) / Help text 필드 아래 `caption` (`mt-1.5`) / onBlur 실시간 validation + 제출 시 전체 재검증 / 에러 첫 필드 auto-focus / Placeholder text는 예시만 / Submit 중 `disabled` + 내부 Spinner + "전송 중..." / 자동 채움 `accent-subtle` 배경 + "자동 적용됨" caption 3초 페이드.
- **UX-DR17**: Navigation 패턴 — 메인 네비게이션 없음(우상단 Meta 토글만 fixed). 세로 스크롤 + 앵커. Footer "맨 위로" 1개. URL 파라미터 `?meta=on`, `?case=2024타경110044&preset=1`. 키보드 Tab 섹션 순회. 모바일 햄버거 없음.
- **UX-DR18**: Modal & Overlay 패턴 — Dialog 2곳(admin 계정 안내·Contact 확인 선택) + Sheet 1곳(Meta aside 420px, side=right) + Popover(Ambient·Placeholder). 자동재생 모달 금지. 닫기 3경로 (ESC + 배경 클릭 + X). body scroll lock.
- **UX-DR19**: Empty & Loading 패턴 — Skeleton 우선(shadcn) / Spinner Submit 버튼 내부만, 전체 오버레이 금지 / 600ms 미만 지연은 스켈레톤 없이 / Empty illustration 없음(텍스트 + Placeholder로 충분).
- **UX-DR20**: Search & Filtering — MVP 범위 축소. Search 미구현, 매물·커뮤니티 모두 3-Tabs만. 필터 URL 동기화 미구현. Search 기능은 Vision (Meta 주석 언급).

**접근성 특수 (WCAG 2.1 AA):**

- **UX-DR21**: 숫자 금액 `aria-label` 한국어 보강 — `<span aria-label="이억사천오백만원">24.5억</span>` 스크린리더 한국어 음성.
- **UX-DR22**: Meta 토글 상태 `aria-pressed` + `aria-expanded` 병기.
- **UX-DR23**: 카카오맵 iframe `title` + `aria-label="경매 매물 지도"` + 지도 아래 리스트 뷰 병행 (fallback).
- **UX-DR24**: Tier 블러 영역 `aria-hidden="true"` (블러 내용 차단) + "L2 검증 후 해제" caption `aria-live`.
- **UX-DR25**: Rights Cascade `role="list"` + 재정렬 직전 `aria-live="polite"` 선언.
- **UX-DR26**: Skip link — `<a href="#main" class="sr-only focus:not-sr-only">` 키보드 진입자 용.

**Responsive Design:**

- **UX-DR27**: Desktop-First 접근(비상례적, 발주자 B 3-5 탭 심사 환경) — 1440px 설계, 1024px 랩탑 기본, 768px 태블릿 기본 대응(8-col → 주요 섹션 stacked), 375px 모바일 첫 스텝만 품질 보장.
- **UX-DR28**: Mobile 특수 대응 — 1-col stacked, 16px side padding, 터치 타겟 `min-h-11 min-w-11` (44×44px WCAG 2.5.5). Meta 토글: aside → bottom sheet 대체 (**SHOULD**), 실패 시 토글 비활성 + "데스크톱에서 확인" caption. Contact `mailto:` 자동 실행. 햄버거 메뉴 없음.

### FR Coverage Map

| FR | Epic | 비고 |
|----|------|------|
| FR1 (3-tab 매물) | Epic 2 | 경매 실데이터 + 2탭 Placeholder |
| FR2 (URL pre-fill) | Epic 3 | 매물 → 계산기 링크 |
| FR3 (계산기 15필드) | Epic 3 | Apps Script v3.1 포팅 |
| FR4 (프리셋) | Epic 3 | 1종 실동 + 2종 Placeholder |
| FR5 (Chunking + Live Shadow) | Epic 3 | 15필드 4-5 step 분할 |
| FR6 (Rights Cascade) | Epic 2 | 말소기준권리 재정렬 |
| FR7 (Calculator Dance) | Epic 3 | 출력 25+ 필드 펼침 |
| FR8 (Hero) | Epic 6 | Intent Framing + Live Ticker |
| FR9 (커뮤니티) | Epic 5 | 3 카테고리 + L2+ 블러 |
| FR10 (3-tier RBAC) | Epic 1 | Supabase 매직링크 |
| FR11 (Meta 토글) | Epic 4 | 전역 상태 + 단축키 |
| FR12 (주석 11개) | Epic 4 | aside Sheet + Accordion |
| FR13 (Placeholder 체계) | Epic 1 | 표준 컴포넌트 |
| FR14 (대부업체 등록) | Epic 5 | 10필드 Server Action |
| FR15 (About) | Epic 6 | 공고 매칭 표 + Contact |
| FR16 (규제 카피 모듈) | Epic 1 (구축) + Epic 6 (검수) | 단일 소스 |
| FR17 (마스킹 스크립트) | Epic 1 (스크립트) + Epic 2 (사용) | 빌드 타임 1회 |
| FR18 (admin 경로) | Epic 5 | ADMIN_EMAILS guard |
| FR19 (README·도메인·Lighthouse) | Epic 6 | 발주자 시선 3문단 |
| FR20 (SEO/OG) | Epic 6 | layout.tsx + JSON-LD |

## Epic List

### Epic 1: Foundation & Design System (기반 · 디자인 시스템)

**Epic Goal**: Vercel+Supabase 스타터 템플릿 기반 Next.js 16 App Router 뼈대 + Tailwind 디자인 토큰 + shadcn UI + Supabase RLS / 3-tier RBAC 인프라 + Placeholder 라벨 표준 컴포넌트 + 마스킹 빌드 스크립트 + 공용 유틸(date/currency/regulatory copy)을 구축하여 후속 Epic의 공통 기반을 제공합니다.

**User Outcome**: 방문자가 배포된 기반 페이지에 접속 → 인증 루트 작동 → Placeholder 라벨 일관성이 모든 미구현 접점에서 동작하는 "뼈대 상태" 확보.

**FRs covered**: FR10, FR13, FR16 (구축), FR17 (마스킹 스크립트)
**NFRs covered**: NFR7, NFR8, NFR9, NFR10, NFR11, NFR12, NFR13
**UX-DR covered**: UX-DR1~4 (토큰), UX-DR5 (Placeholder), UX-DR14~20 (Consistency), UX-DR26 (Skip link)

### Epic 2: 매물 탐색 & 권리 시각화 (Listings & Rights Cascade)

**Epic Goal**: 경매 탭 정적 스냅샷 실 데이터 렌더 + 공매/신탁공매 Placeholder 일관 노출 + PropertyCard (tier 블러 포함) + 지도·리스트 뷰 병행 + Rights Cascade 말소기준권리 시각화 애니메이션을 구현.

**User Outcome**: 방문자가 3-tab을 탐색하고 경매 매물 카드를 클릭해 상세를 확인, 권리 계층이 `layout` 애니메이션으로 재정렬되는 시각 체험을 얻습니다.

**FRs covered**: FR1, FR6, FR17 (스냅샷 사용)
**NFRs covered**: NFR6, NFR11, NFR15, NFR18
**UX-DR covered**: UX-DR11 (RightsCascade), UX-DR12 (PropertyCard), UX-DR21, UX-DR23, UX-DR24, UX-DR25

### Epic 3: NPL 계산기 코어 & UX (Calculator) ← Gate 1

**Epic Goal**: Apps Script v3.1 로직 TypeScript 포팅(양편넣기·배당순서·소액임차·당해세·질권대출 절사) + 샘플 5건 Vitest 골든 테스트 + 15필드 Conversational Chunking + Live Calculation Shadow + 프리셋 1종 완성(2종 Placeholder) + Calculator Dance + URL 파라미터 pre-fill.

**User Outcome**: 방문자가 매물 카드 "시뮬레이션" 버튼 클릭 → URL 파라미터로 사건번호·감정가 자동 입력 → 4~5 step으로 15필드 채움 → 실시간 부분 재계산 + Calculator Dance로 배당·수익률을 ≤1.2초에 확인.

**FRs covered**: FR2, FR3, FR4, FR5, FR7
**NFRs covered**: NFR1, NFR2, NFR18
**UX-DR covered**: UX-DR9, UX-DR10, UX-DR4

**Gate 1 체크포인트**: 샘플 5건 Vitest 통과 여부 → 실패 시 SHOULD 전부 즉시 포기.

### Epic 4: Meta 토글 주석 시스템 (Decision Layer) ← Gate 2

**Epic Goal**: 우상단 Meta 토글(shadcn Switch) + 스페이스바 + URL(`?meta=on`) + localStorage + Zustand 전역 상태 + Ambient Annotation Mark + aside Sheet (420px, side=right) + Accordion + 11개 의사결정 주석 서빙 (`lib/data/annotations.ts`).

**User Outcome**: 방문자가 Meta 토글을 켜면 aside Sheet가 슬라이드인, 11개 주석이 번호·제목·본문·근거·관련 주석 형태로 제공되고, 각 기능 옆 "왜?" 배지로 구체 근거에 바로 점프.

**FRs covered**: FR11, FR12
**NFRs covered**: NFR18, NFR19, NFR20
**UX-DR covered**: UX-DR6 (MetaToggle), UX-DR7 (AmbientMark), UX-DR8 (MetaAnnotationPanel), UX-DR22

**Gate 2 체크포인트**: 주석 11개 서빙 가능 여부 → 실패 시 8개로 축소 + #11 우선 보존.

### Epic 5: 커뮤니티 & 대부업체 등록 & admin 운영 (Community & Operations)

**Epic Goal**: 3 카테고리(경매방 실 샘플 5건 + 자유수다방/Q&A Placeholder) + L2+ 게이팅 블러 배너 + "검증 요청" CTA (Server Action) + 대부업체 매물 등록 10필드 폼 + admin 최소 운영 경로(`ADMIN_EMAILS` 기반 Server Component guard + tier 수동 승격 시연 UI).

**User Outcome**: 방문자가 커뮤니티 톤을 확인하고 L2 블러 배너를 체험 → "검증 요청" 제출. 대부업체는 10필드 등록 폼 데모. admin은 tier 승격 경로를 시연.

**FRs covered**: FR9, FR14, FR18
**NFRs covered**: NFR14, NFR16
**UX-DR covered**: UX-DR13 (TierGateBanner), UX-DR16 (Form 패턴)

### Epic 6: 랜딩 Hero · About · 배포 마무리 (Hero & Ship) ← Gate 3 + Gate 4

**Epic Goal**: Intent Framing 스트립 + Map Breath + Live Ticker + Hero Reveal 권리분석 Writeup 1건 + About(공고 매칭 표·겸업/전업 범위·법적 고지·Contact SLA·mailto CTA) + SEO/OG(layout.tsx OG + Twitter Card + JSON-LD + robots/sitemap) + 규제 카피 상수 모듈 최종 검수 + Lighthouse 측정 + 접근성 3요소 감사 + README 3문단 + BMAD PRD 링크 + 카카오맵 3환경 도메인 등록 + 커스텀 도메인 배포.

**User Outcome**: 발주자가 랜딩 첫 화면에서 blynn의 의도를 인지하고 Writeup을 훑은 뒤 About에서 겸업 범위·SLA를 확인, 공유된 링크가 프리뷰 품질을 갖춰 노출.

**FRs covered**: FR8, FR15, FR16 (검수), FR19, FR20
**NFRs covered**: NFR3, NFR4, NFR5, NFR12, NFR13, NFR17, NFR19
**UX-DR covered**: UX-DR27, UX-DR28

**Gate 3 체크**: Lighthouse + dead-end 점검, 실패 영역 Placeholder로 덮음.
**Gate 4 체크**: HTTPS + 도메인 + 카카오맵 작동, 실패 시 `*.vercel.app` 폴백.

---

## Epic 1: Foundation & Design System

Vercel+Supabase 스타터 기반 Next.js 16 App Router 뼈대 + Tailwind 디자인 토큰 + shadcn UI + Supabase RLS/3-tier RBAC + Placeholder 표준 컴포넌트 + 마스킹 스크립트 + 공용 유틸을 구축하여 후속 Epic의 공통 기반을 제공합니다.

### Story 1.1: Next.js + Supabase 스타터 템플릿 부트스트랩

As a 개발자 (blynn),
I want Vercel+Supabase 공식 스타터 템플릿으로 Next.js 16 프로젝트를 부트스트랩하고 로컬·Vercel·Supabase 3환경을 연결하여,
So that Server Components 호환 Supabase 클라이언트 + middleware 세션 갱신이 사전 구성된 기반에서 즉시 기능 개발에 들어갈 수 있다.

**Acceptance Criteria:**

**Given** `create-next-app --example with-supabase` 로 생성된 프로젝트
**When** `pnpm dev` 로 로컬을 구동
**Then** 기본 랜딩 페이지가 `localhost:3000` 에서 정상 렌더링되고, Supabase 연결이 성공한다
**And** Next.js 최신 stable (16.x) + Turbopack dev + TypeScript strict + pnpm 구성 확인

**Given** 환경변수 설정 파일
**When** 리포지토리 루트 확인
**Then** `.env.example` 이 공개되고 `.env.local` 은 `.gitignore` 에 등록되어 있다
**And** `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `ADMIN_EMAILS` 키가 `.env.example` 에 템플릿으로 포함

**Given** `lint-staged` + `husky` pre-commit 훅 설정
**When** `SUPABASE_SERVICE_ROLE_KEY` 문자열이 포함된 파일을 커밋 시도
**Then** pre-commit grep 이 탐지하여 커밋을 차단하고 에러 메시지를 출력한다

**Given** 프로젝트 루트
**When** 파일 존재 확인
**Then** `CLAUDE.md` + `AGENTS.md` (Next.js 16 기본) 에이전트 가이드가 존재하고 프로젝트 구조·컨벤션·금지 사항(service_role 키, `new Date()` 직접 호출 등)을 명시한다

### Story 1.2: Tailwind 디자인 토큰 + Typography 시스템

As a 개발자,
I want Tailwind `theme.extend` 에 UX-DR1~4 스펙대로 디자인 토큰(Color 12·Typography 10·Spacing·Motion)을 정의하고 Pretendard/JetBrains Mono 를 `next/font` 로 로드하여,
So that 모든 후속 컴포넌트가 단일 소스 토큰에 기대어 4.5:1 대비와 일관된 타이포그래피로 렌더링된다.

**Acceptance Criteria:**

**Given** `tailwind.config.ts` 에 디자인 토큰 정의
**When** `bg-primary`, `text-foreground`, `bg-accent`, `text-tier-l2`, `bg-meta-bg` 등 토큰 클래스를 사용
**Then** UX-DR1 스펙(Base Neutral 6: #FAFAF9/#F5F5F4/#E7E5E4/#78716C/#1C1917/#0C0A09, Accent 3, Semantic tier 3, Meta aside 3) 대로 CSS 변수·클래스가 생성된다

**Given** 본문 텍스트 색상 대비 검증
**When** Lighthouse Accessibility 감사를 실행
**Then** Color Contrast 항목에서 본문 4.5:1, 대형·비텍스트 3:1 기준을 전부 통과하고 경고 0건

**Given** 커스텀 폰트 로드 구성
**When** 페이지 최초 로드
**Then** `Pretendard Variable` 과 `JetBrains Mono` 가 `next/font` 로 로드되어 FOIT/FOUT 없이 표시된다

**Given** Typography scale 유틸 클래스
**When** 컴포넌트에서 `text-display`, `text-h1`~`text-h3`, `text-body-lg`, `text-body`, `text-body-sm`, `text-caption`, `text-number-hero`, `text-number` 클래스 사용
**Then** 10 scale 각각 정확한 font-size/line-height 로 렌더링되고, 숫자 클래스(`text-number-hero`, `text-number`)는 `font-feature-settings: 'tnum'` (tabular-nums) 적용

**Given** Motion 토큰
**When** Framer Motion 또는 Tailwind transition 클래스 사용
**Then** 짧은 150-200ms, Calculator Dance 400-600ms, aside 300ms ease-out 값이 토큰으로 참조 가능

### Story 1.3: Supabase 스키마·RLS·3-tier RBAC 원자적 마이그레이션

As a 개발자,
I want `supabase/migrations/0001_init_schema.sql` 단일 파일에 6개 테이블 + FK + index + RLS 정책 + 매직링크 자동 `profiles` 생성 트리거를 원자적으로 정의하고, `public-assets/` 스토리지 버킷을 별도 RLS 로 설정하여,
So that 모든 후속 Epic 이 안전하게 tier 기반 데이터 접근을 가정할 수 있다.

**Acceptance Criteria:**

**Given** `supabase/migrations/0001_init_schema.sql` 단일 마이그레이션
**When** `supabase db push` 실행
**Then** 6개 테이블(`profiles`, `listings`, `community_posts`, `annotations`, `tier_requests`, `activity_log`)이 전부 생성되고 각 테이블 RLS ON 상태
**And** 테이블 생성·FK·index·RLS 정책이 동일 마이그레이션 파일에 원자적으로 정의되어 부분 실패 시 전체 롤백

**Given** `profiles` 테이블 스키마
**When** 테이블 구조 확인
**Then** `tier` 컬럼이 enum(`L1`/`L2`/`L3`) 이고 기본값 `L1`, `lender_badge` boolean 기본값 `false`, `display_name` 컬럼 존재
**And** `profiles.id` 는 `auth.users.id` 외래키

**Given** Supabase 매직링크 이메일 인증
**When** 사용자가 최초 이메일 매직링크로 로그인
**Then** `auth.users` INSERT 트리거가 발동되어 `profiles` row 가 `tier='L1'`, `lender_badge=false` 기본값으로 자동 생성된다
**And** 실명·휴대폰 번호·본인인증 정보는 수집하지 않는다 (NFR10)

**Given** RLS 정책 정의
**When** 각 테이블별 정책 확인
**Then** 최소한 SELECT 정책이 모든 테이블에 명시되어 있고, `listings` 는 anon 읽기 허용, `profiles` 는 본인·admin 만 UPDATE
**And** 쓰기 매트릭스 전수 검증은 Post-MVP SHOULD 로 문서(Meta 주석 #8)에 고지

**Given** admin 식별
**When** `/admin` 라우트 접근 시 Server Component guard 체크
**Then** `ADMIN_EMAILS` 환경변수(쉼표 구분 리스트)와 현재 세션 이메일 일치 여부로 판단 (DB enum 사용 안 함)

**Given** `public-assets/` 스토리지 버킷
**When** 버킷 설정 확인
**Then** RLS ON + anon read 정책 명시 + 권리분석 리포트 이미지·OG 이미지용 업로드는 admin 만 가능

### Story 1.4: Placeholder 라벨 표준 컴포넌트 시스템

As a 방문자 (L1 무인증),
I want 미구현 접점(저장·댓글·공매 탭·admin UI 등)에서 일관된 `<PlaceholderLabel>` 이 표시되어,
So that dead-end 없이 "왜 이 기능이 비어 있는지" 즉시 이해할 수 있다.

**Acceptance Criteria:**

**Given** `components/placeholder/placeholder-label.tsx` 에 구현된 컴포넌트
**When** `<PlaceholderLabel severity="demo" reason="정적 스냅샷 박제">` 를 렌더
**Then** 회색 "데모용 Placeholder" 배지가 노출되고 `aria-label="이 기능은 데모용입니다: 정적 스냅샷 박제"` 속성을 갖는다

**Given** 3 variants 스펙
**When** `severity` prop 값에 따라
**Then** `demo` 는 회색 배경 + "데모용 Placeholder", `pending` 은 노란 배경 + "준비 중", `vision` 은 보라 배경 + "실 배포 시 제공" 텍스트를 렌더한다
**And** 각 variant 는 shadcn `Badge` variant 로 일관되게 파생

**Given** 키보드 접근성
**When** Tab 키로 `<PlaceholderLabel>` 에 포커스
**Then** `focus-visible:ring-2 ring-accent ring-offset-2` 적용 + shadcn `Popover` 가 자동 열려 `reason` prop 의 1-2문장을 노출한다

**Given** 개발 중 시각 확인
**When** dev-only 경로(예: `/dev/showcase`) 접근
**Then** 3 variants(demo/pending/vision)가 각각 최소 1건씩 렌더되어 디자인 QA 가능

**Given** `reason` prop 필수 검증
**When** `<PlaceholderLabel>` 사용 시 `reason` 누락
**Then** TypeScript 컴파일 에러로 차단된다 (타입 레벨 필수)

### Story 1.5: 공용 유틸 모듈 + 규제 카피 상수 + ESLint 가드

As a 개발자,
I want `lib/format/date.ts`(Asia/Seoul `date-fns-tz`) · `lib/format/currency.ts`(`formatWon` short/full) · `lib/copy/regulatory.ts`(규제 리프레이밍 상수) 모듈과 `no-restricted-syntax` ESLint 룰을 갖추어,
So that 모든 컴포넌트가 `new Date()` · `.toLocaleString()` · "거래/가입 승인" 같은 하드코딩 없이 단일 소스에 기대도록 한다.

**Acceptance Criteria:**

**Given** `lib/format/date.ts` 모듈
**When** `formatDate(date, 'yyyy-MM-dd HH:mm')` 호출
**Then** `date-fns-tz` 를 사용해 `Asia/Seoul` 타임존으로 강제 포맷 + 윤년·말일·자정 전환 edge case 처리

**Given** `lib/format/currency.ts` 모듈
**When** `formatWon(245_000_000, 'short')` 또는 `formatWon(245_000_000, 'full')` 호출
**Then** 각각 `"24.5억"` 또는 `"2억 4,500만원"` 형식으로 반환되고 절사 규칙(억/만 단위)이 일관 적용

**Given** `lib/copy/regulatory.ts` 상수 모듈
**When** 키 확인
**Then** `REGULATORY_COPY.INFORMATION_MATCHING`("정보 매칭"), `REGULATORY_COPY.L2_VERIFICATION`("대부업법 L2 적격성 자진 확인"), `REGULATORY_COPY.REPORT_DISCLAIMER`("정보·참고용 — 실제 판단은 변호사 자문 필요") 등 상수가 노출된다
**And** 컴포넌트는 이 키만 import 하여 사용한다

**Given** ESLint `no-restricted-syntax` 룰
**When** 컴포넌트에서 `new Date(...)` 직접 호출 또는 `.toLocaleString('ko-KR')` 사용 시도
**Then** lint 에러로 차단 (허용 예외: `lib/format/date.ts` 내부)
**And** "거래", "거래하기", "가입 승인" 등 금지 문자열 하드코딩도 커스텀 룰로 경고 (Warn 수준)

**Given** Vitest 단위 테스트
**When** `pnpm test:run` 실행
**Then** date/currency 포맷 edge case(윤년 2024-02-29, 말일 2025-12-31, 0원, 99,999,999원 억 전환 경계, 100만원 절사 경계) 가 전부 통과

### Story 1.6: 매스킹 빌드 스크립트 + 정적 스냅샷 JSON

As a 개발자,
I want `scripts/build-snapshot.ts` 로 원본 크롤링 JSON(채무자 실명·주소 전체)을 빌드 타임 1회 변환하여 `app/data/listings.json`(이니셜 + 동 단위)을 생성하고,
So that Epic 2 매물 탐색이 공개 채무자 정보 한정(NFR11) 규칙을 어기지 않고 정적 SSG 로 서빙된다.

**Acceptance Criteria:**

**Given** `data/raw/auction-2026-04-20.json`(원본, gitignored)
**When** `pnpm build:snapshot` 실행
**Then** `app/data/listings.json` 에 변환된 결과가 출력되고, 각 row 의 `debtor_name` 이 이니셜(예: "김○○")로, `address` 가 시군구+동 단위(예: "서울 강남구 역삼동")까지로 변환된다

**Given** 실명·번지 잔존 검증
**When** 변환 결과를 정규식으로 스캔(한글 2글자+성명 완전형 패턴, 번지 숫자 패턴)
**Then** 실명 또는 번지가 발견되면 스크립트가 `process.exit(1)` 로 종료하고 빌드 파이프라인을 실패시킨다

**Given** 빌드 파이프라인 통합
**When** `package.json` 스크립트 확인
**Then** `build: "pnpm build:snapshot && next build"` 형식으로 연결되어, 스냅샷 생성이 Next.js 빌드 직전 pre-step 으로 실행된다

**Given** 데이터 소스
**When** `app/data/listings.json` 구조 확인
**Then** 2026-04-20 기준 정적 스냅샷(NFR15)으로 최소 5건의 경매 매물이 포함되고, 각 row 는 `case_number`, `court`, `appraisal_price`, `minimum_bid`, `auction_date`, `property_type`, `special_tags`(유치권/법정지상권 등)를 갖는다

### Story 1.7: 라우팅 스캐폴드 + Skip Link + 기본 a11y 기반

As a 방문자 (키보드 사용자),
I want 사이트 루트 진입 시 Skip Link 로 메인 콘텐츠에 즉시 이동할 수 있고 섹션 앵커·서브 경로 라우팅 뼈대가 동작하여,
So that 후속 Epic 의 콘텐츠가 시맨틱 HTML 기반 레이아웃에 일관되게 배치될 수 있고 키보드만으로 사이트 전체를 탐색할 수 있다.

**Acceptance Criteria:**

**Given** App Router 디렉토리 구조
**When** `app/` 경로 확인
**Then** 루트 `app/page.tsx` + `app/auction/[caseNumber]/page.tsx` + `app/profile/tier-request/page.tsx` + `app/admin/page.tsx` 네 경로가 placeholder 콘텐츠로 동작한다
**And** 섹션 앵커 `/#calculator`, `/#about`, `/#community` 가 루트 페이지 내 `id` 속성으로 대응

**Given** 루트 레이아웃 시맨틱 HTML
**When** `app/layout.tsx` + `app/page.tsx` 렌더 결과 DOM 확인
**Then** `<main id="main">`, `<aside>`, `<nav>`, `<section>` 태그가 용도에 맞게 사용되고, 구조는 WCAG 2.1 landmark 규칙을 만족

**Given** Skip Link
**When** 페이지 로드 직후 Tab 키로 처음 포커스
**Then** `<a href="#main" class="sr-only focus:not-sr-only">메인 콘텐츠로 이동</a>` 이 화면 좌상단에 가시화되고 Enter 키로 `<main>` 으로 포커스 이동

**Given** 전역 포커스 스타일
**When** 임의 포커서블 요소에 키보드로 포커스
**Then** Tailwind `focus-visible:ring-2 ring-accent ring-offset-2` 가 기본 적용되어 시각적 포커스 인디케이터가 노출된다

**Given** 미구현 섹션 기본값
**When** 서브 경로 또는 섹션 앵커에 접근
**Then** 각 섹션/경로가 `<PlaceholderLabel severity="pending" reason="...">` 로 감싸진 기본 콘텐츠를 렌더하여 dead-end 0건 보장 (후속 Epic 이 대체 가능)

---

## Epic 2: 매물 탐색 & 권리 시각화

경매 탭 정적 스냅샷 실 데이터 렌더 + 공매/신탁공매 Placeholder + PropertyCard + 지도·리스트 뷰 병행 + Rights Cascade 말소기준권리 시각화 애니메이션.

### Story 2.1: 3-Tab 매물 탐색 구조 (경매·공매·신탁공매)

As a 방문자 (프롭테크 대표 B / 법무법인 파트너 A),
I want 3-Tab(경매·공매·신탁공매) 구조에서 경매 탭 실 데이터를 탐색하고 공매·신탁공매 탭에서는 Placeholder 로 정직한 미구현 상태를 확인하여,
So that 현재 제공 가능한 범위와 향후 확장 방향을 즉시 이해할 수 있다.

**Acceptance Criteria:**

**Given** `features/listings/` 아래 탭 UI 구현
**When** 루트 페이지 매물 섹션 렌더
**Then** shadcn `Tabs` 컴포넌트로 3-Tab("경매", "공매", "신탁공매")이 표시되고 기본 선택은 "경매" 탭

**Given** 경매 탭 선택 상태
**When** 탭 콘텐츠 렌더
**Then** `app/data/listings.json`(Story 1.6 산출물) 의 경매 스냅샷 5건 이상이 리스트 형태로 노출된다

**Given** 공매/신탁공매 탭 선택 상태
**When** 탭 전환
**Then** 탭 본문이 `<PlaceholderLabel severity="demo" reason="정적 스냅샷 박제 — 공매·신탁공매는 Post-MVP SHOULD">` 로 감싸진 미리보기 UI 로 표시되고, 실제 데이터 페칭 없이 즉시 렌더된다

**Given** 키보드 접근성
**When** Tab 키로 탭 헤더 포커스 + 좌우 화살표로 탭 전환
**Then** Radix Tabs 기본 키보드 네비게이션이 동작하고 `aria-selected` 속성이 전환된다

**Given** URL 상태 동기화
**When** 특정 탭 활성 상태
**Then** URL 파라미터(`?tab=auction|public|trust`)로 직접 링크 가능하고 페이지 새로고침 시 상태 유지

### Story 2.2: PropertyCard 컴포넌트 (빌사남 톤, 썸네일 없음)

As a 방문자,
I want 매물 리스트의 각 카드가 사건번호·금액·진행률·특수물건 태그를 한눈에 보여주고 tier 부족 시 블러 처리되어,
So that 이미지 로딩 지연 없이 텍스트 기반 빠른 스캔으로 관심 매물을 판단하고, 권한 제약을 즉시 인지할 수 있다.

**Acceptance Criteria:**

**Given** `components/listings/property-card.tsx` 구현
**When** `<PropertyCard property={listing} tier="L1">` 렌더
**Then** 상단에 사건번호(`font-mono`, JetBrains Mono) + tier 배지, 중앙 감정가·최저입찰가(`text-number` 20/28 tabular-nums), 하단에 진행률("3회 유찰") + 특수물건 태그(유치권·법정지상권 등) 노출
**And** 썸네일 이미지는 렌더하지 않는다 (빌사남 패턴)

**Given** 시맨틱 HTML 과 aria-label
**When** DOM 확인
**Then** 루트 태그가 `<article aria-label="매물 2024타경110044 상세">` 이고, 금액은 `<span aria-label="이억사천오백만원">24.5억</span>` 형식으로 한국어 음성 라벨 제공 (UX-DR21)

**Given** 상태별 스타일
**When** 카드 상태 전환
**Then** `default`(기본), `hover`(accent-subtle bg + border), `focus-visible`(ring), `tier-blurred`(권한 부족 시 `blur-sm` + "L2 검증 후 해제" caption) 4 상태 각각 정확히 표현되고, tier-blurred 영역은 `aria-hidden="true"` + caption `aria-live` (UX-DR24)

**Given** 시뮬레이션 CTA 버튼
**When** 카드 내 "이 물건 시뮬레이션" 버튼 렌더
**Then** shadcn `Button variant="default"` Primary 스타일로 노출 (UX-DR14, 1 카드당 Primary 1개 원칙)

**Given** 키보드 탐색
**When** Tab 키로 카드 포커스 → Enter
**Then** 카드 전체가 포커서블이고, Enter 시 매물 상세 페이지(`/auction/[caseNumber]`)로 이동한다

### Story 2.3: 리스트 뷰 + 카카오맵 뷰 병행

As a 방문자,
I want 매물 리스트와 카카오맵을 동시에 보며 공간적 분포와 텍스트 정보를 교차 확인하여,
So that 관심 지역·가격대 매물을 빠르게 탐색할 수 있고, 지도 로딩 실패 시에도 리스트만으로 탐색을 계속할 수 있다.

**Acceptance Criteria:**

**Given** 경매 탭 콘텐츠 레이아웃
**When** 데스크톱(1440px 설계 기준) 렌더
**Then** 좌측 리스트(5 이상 `<PropertyCard>`) + 우측 카카오맵 iframe 이 병렬 표시되고, 1024px 랩탑에서 동일 구조 유지, 768px 태블릿에서는 stacked (리스트 → 지도 순)

**Given** 카카오맵 iframe
**When** 지도 컨테이너 DOM 확인
**Then** `<iframe title="경매 매물 지도" aria-label="경매 매물 지도" src="..." loading="lazy">` 로 렌더되고, 지도 마커가 각 매물 좌표에 표시된다 (UX-DR23)

**Given** 카카오맵 SDK 로드 실패 또는 도메인 미등록
**When** iframe 로드 에러
**Then** iframe 영역이 `<PlaceholderLabel severity="pending" reason="카카오맵 도메인 등록 또는 네트워크 이슈">` 로 대체되고, 좌측 리스트는 독립적으로 동작한다 (fallback)

**Given** 카카오맵 도메인 등록 준비
**When** Story 2.3 완료 시점
**Then** 로컬(`localhost:3000`) 도메인이 카카오 개발자 콘솔에 이미 등록되어 로컬 개발 시 지도가 정상 동작 (preview/production 도메인 등록은 Epic 6 Story 에서 최종 검증)

**Given** Lighthouse Performance 지도 페이지 예외
**When** 지도 포함 페이지 Performance 측정
**Then** 카카오맵 SDK 300KB+ 로 인해 Performance ≥ 80 목표에서 해당 페이지는 제외됨을 README 에 명시 (NFR3)

### Story 2.4: 매물 상세 페이지 + 시뮬레이션 CTA

As a 방문자,
I want 매물 카드 클릭 시 상세 페이지로 이동해 권리 정보를 확인하고 "이 물건 시뮬레이션" CTA 로 계산기 섹션에 사전 입력된 상태로 이동하여,
So that 매물 → 시뮬레이션 플로우를 한 번의 클릭으로 체험할 수 있다.

**Acceptance Criteria:**

**Given** `/auction/[caseNumber]` 동적 라우트
**When** 사건번호 파라미터로 페이지 진입
**Then** `app/data/listings.json` 에서 해당 매물을 찾아 사건번호·법원·감정가·최저입찰가·경매일·특수물건·채무자(마스킹된 이니셜)·주소(동 단위)를 표시
**And** 매물이 없으면 Next.js `notFound()` 로 404 페이지 렌더

**Given** "이 물건 시뮬레이션" CTA 버튼
**When** 버튼 클릭
**Then** 루트 페이지 `/#calculator` 섹션 앵커로 스크롤 + URL 파라미터 `?case=2024타경110044&preset=1` 이 자동 부가된다

**Given** 계산기 섹션이 URL 파라미터 수신
**When** `?case=...` 파라미터로 루트 페이지 진입
**Then** 계산기 섹션은 사건번호·감정가를 pre-fill 할 수 있는 상태로 준비 (실제 pre-fill 동작은 Epic 3 Story 에서 구현, 본 스토리에서는 URL 파라미터가 정확히 전달되는 것까지 검증)

**Given** 매물 상세 페이지 미구현 영역
**When** "저장", "댓글", "심의서 다운로드" 등 접점
**Then** 전부 `<PlaceholderLabel severity="pending" ...>` 로 일관 노출되어 dead-end 0건

### Story 2.5: Rights Cascade 말소기준권리 애니메이션

As a 방문자 (법무법인 파트너 A),
I want 매물 상세에서 권리 목록이 말소기준권리를 기준으로 자동 재정렬되는 시각 애니메이션을 보며,
So that 복잡한 권리 순위를 텍스트가 아닌 레이아웃 변화로 직관적으로 이해할 수 있다.

**Acceptance Criteria:**

**Given** `components/listings/rights-cascade.tsx` 구현
**When** `<RightsCascade items={rights}>` 렌더 (rights: 권리 목록 배열)
**Then** Framer Motion `motion.ul layout` + 각 `motion.li layoutId={right.id}` 로 구성되고, 초기 렌더 시 원본 순서 노출 → 200ms 후 말소기준권리 기준 재정렬이 stagger 0.4s 로 실행된다 (UX-DR11)

**Given** 재정렬 애니메이션
**When** 각 항목 이동 관측
**Then** fade + slide 300ms + `layout` 전환이 `easeOut` curve 로 실행되고, 전체 애니메이션 완료까지 ≤ 1.5초

**Given** 접근성 선언
**When** DOM 확인
**Then** `<ul role="list">` + 재정렬 직전 `aria-live="polite"` 영역이 "권리 순서 재정렬 중"을 선언한다 (UX-DR25)

**Given** `prefers-reduced-motion: reduce` 사용자
**When** `useReducedMotion()` 훅이 true 반환
**Then** 모든 Framer Motion transition 이 `duration: 0` 으로 폴백되어 애니메이션 없이 최종 정렬 상태만 즉시 표시된다 (NFR18, UX-DR4)

**Given** 말소기준권리 판정 로직
**When** 권리 목록이 저당권·가압류·가등기·전세권·임차권을 포함
**Then** 가장 빠른 (등기 일자 기준) 저당권·가압류·담보가등기·전세권·임차권 중 하나를 말소기준권리로 식별하고, 기준 이후 권리는 모두 소멸, 기준 이전 권리는 인수로 시각 구분 (border 색상 · 배지로 표현)

---

## Epic 3: NPL 계산기 코어 & UX (Gate 1)

Apps Script v3.1 로직 TypeScript 포팅 + 샘플 5건 Vitest 골든 테스트 + 15필드 Conversational Chunking + Live Calculation Shadow + 프리셋 1종 완성(2종 Placeholder) + Calculator Dance + URL 파라미터 pre-fill.

**Gate 1 체크포인트**: Story 3.2 (샘플 5건 Vitest 골든 테스트) 통과 여부 → 실패 시 SHOULD 전부 즉시 포기, 나머지 MUST 사수.

### Story 3.1: 계산기 도메인 로직 TypeScript 포팅 (순수 함수)

As a 개발자 (blynn),
I want Apps Script v3.1 NPL 계산 로직을 `lib/calculator/*.ts` 순수 함수 모듈로 포팅하여 양편넣기·채권최고액 Cap·질권대출 100만원 절사·배당순서(당해세 최우선)·지역별 소액임차 한도를 구현하고,
So that 계산 로직이 부작용 없이 Vitest 로 결정적으로 검증 가능하고, 후속 UX 스토리는 이 모듈을 안심하고 호출할 수 있다.

**Acceptance Criteria:**

**Given** `lib/calculator/` 아래 모듈 분리
**When** 파일 구조 확인
**Then** `dividend.ts`(배당 계산), `interest.ts`(양편넣기 이자 계산), `pledge-loan.ts`(질권대출 절사), `small-tenant.ts`(소액임차 한도), `priority.ts`(배당순서) 모듈이 각각 독립된 순수 함수로 구현
**And** 각 파일에 대응되는 `*.test.ts` 가 co-location 으로 배치

**Given** 부작용 금지 원칙
**When** 모듈 코드 정적 분석
**Then** `Date.now()`, `Math.random()`, `console.*`, 파일·네트워크 I/O, 전역 변수 mutation 이 전부 없음
**And** 모든 시간 관련 입력은 함수 파라미터로 주입 (`calculate(input, { asOfDate: Date })`)

**Given** 양편넣기 규칙 (양쪽 끝 날짜 모두 포함)
**When** 2024-01-01 부터 2024-01-10 까지 이자 계산
**Then** 일수가 10일(양편넣기 +1일 적용)로 산출되고, `date-fns-tz` Asia/Seoul 타임존으로 처리 (NFR2)

**Given** 채권최고액 Cap 규칙
**When** 실제 배당 대상 금액이 채권최고액을 초과
**Then** 채권최고액으로 Cap 처리되어 초과분은 배당에서 제외된다

**Given** 질권대출 100만원 절사 규칙
**When** 질권대출 잔액 계산 결과가 1,000,000원 단위 미만을 포함 (예: 12,345,678원)
**Then** 100만원 단위로 내림 절사하여 12,000,000원으로 처리

**Given** 배당순서 규칙
**When** 배당 대상 권리 목록 배열 입력
**Then** ① 집행비용 → ② 당해세(최우선) → ③ 임금채권(최종 3개월) → ④ 소액임차보증금 → ⑤ 일반 조세 → ⑥ 담보권(설정 순위) → ⑦ 일반채권 순서로 정렬된다

**Given** 지역별 소액임차 한도
**When** 매물 주소의 시군구 코드 입력
**Then** 서울·수도권 과밀억제권역·광역시·기타 4구간 분류에 따라 2024년 고시 기준(예: 서울 최우선변제액 5,500만원·보증금 한도 1.65억) 한도가 자동 반영

**Given** 윤년·말일·자정 경계 케이스
**When** 2024-02-29, 2025-12-31 23:59 등 edge case 입력
**Then** 전부 Asia/Seoul 기준으로 정상 처리되어 하루 밀림 없음 (NFR2)

### Story 3.2: 샘플 5건 Vitest 골든 테스트 (Gate 1 체크포인트)

As a 개발자,
I want 대표 케이스 5건을 `__fixtures__/` 에 배치하고 Vitest 골든 테스트로 원 단위 완전 일치·수익률 소수점 4자리 일치를 검증하여,
So that 계산 로직이 MVP 배포 가능한 정합성 수준에 도달했는지 Gate 1 에서 객관적으로 판정할 수 있다.

**Acceptance Criteria:**

**Given** 5개 fixture 파일
**When** `lib/calculator/__fixtures__/` 확인
**Then** `sample-01-cap.ts`(채권최고액 Cap), `sample-02-pledge.ts`(질권대출 100만원 절사 경계), `sample-03-local-tax.ts`(당해세 개입), `sample-04-leap.ts`(윤년 2024-02-29 케이스), `sample-05-simple.ts`(단순 케이스) 가 각각 `input` + `expected` 구조로 정의된다

**Given** 각 fixture 의 `expected`
**When** 값 타입 확인
**Then** 배당 금액(원 단위 정수), 수익률(소수점 4자리 고정), 집행 일수(양편넣기 포함), 각 권리별 배당액이 명시된다

**Given** `lib/calculator/*.test.ts` 골든 테스트
**When** `pnpm test:run` 실행
**Then** 5건 전부에서 계산 결과가 `expected` 와 원 단위 완전 일치 + 수익률 `toBeCloseTo(expected, 4)` 통과

**Given** CI 게이트
**When** `pnpm build` 실행
**Then** `test:run` 을 pre-step 으로 호출하여 테스트 실패 시 빌드 전체가 실패한다

**Given** Gate 1 판정 기준
**When** Story 3.2 완료 시점
**Then** 샘플 5건 전부 통과를 배포 필수 조건으로 문서(Meta 주석 #1 또는 README)에 명시
**And** 통과 실패 시 Phase 2 SHOULD(프리셋 2·3종, 공매·신탁공매 실 데이터 등) 전부 즉시 포기 결정 규칙을 README 에 기록

### Story 3.3: 15필드 Zod 스키마 + React Hook Form 연결

As a 개발자,
I want 계산기 입력 15필드를 Zod 단일 스키마로 정의하고 React Hook Form + `@hookform/resolvers/zod` 로 연결하여,
So that 타입·폼·Server Action·테스트가 동일 스키마를 공유하고 `mode: 'onBlur'` 실시간 검증으로 오입력을 즉시 차단할 수 있다.

**Acceptance Criteria:**

**Given** `lib/calculator/schema.ts` 단일 스키마
**When** Zod 스키마 확인
**Then** 15필드(사건번호, 감정가, 최저입찰가, 낙찰예정가, 채권최고액, 질권대출 원금, 질권대출 이율, 질권대출 기간, 배당 요구일, 경매일, 당해세, 임금채권, 소액임차 여부, 지역 코드, 기타 선순위) 가 각각 정확한 타입·검증 규칙과 함께 정의된다
**And** 각 필드 이름은 schema key = snake_case 로 통일

**Given** React Hook Form 통합
**When** `useForm({ resolver: zodResolver(schema), mode: 'onBlur' })` 사용
**Then** 필드 blur 시 실시간 검증 + 제출 시 전체 재검증 + 에러 첫 필드 auto-focus 동작 (UX-DR16)

**Given** 필드별 검증 규칙
**When** 사용자 입력
**Then** 금액 필드는 양수 정수 + 최대 100조 이하, 날짜 필드는 2020-01-01 이후 + 2030-12-31 이전, 사건번호는 `\d{4}타경\d{5,6}` 패턴, 이율은 0~50% 범위를 만족해야 한다

**Given** 타입 재사용
**When** Server Action 또는 테스트에서 타입 임포트
**Then** `z.infer<typeof calculatorInputSchema>` 로 타입 추출 가능 + Vitest 테스트에서도 동일 스키마로 fixture 검증

**Given** 검증 에러 UI
**When** 필드 에러 발생
**Then** 필드 `destructive` border + 아래 `caption` 힌트 + `aria-describedby` 로 스크린리더 연동 (UX-DR16, 모달 금지)

### Story 3.4: Conversational Chunking + Live Calculation Shadow

As a 방문자,
I want 15필드가 한 화면에 쏟아지는 대신 4~5 step 으로 분할되어 한 번에 한 step 씩 입력하고, 입력할 때마다 영향받는 출력 필드가 즉시 연쇄 재계산으로 업데이트되어,
So that 계산기의 복잡도를 부담 없이 체험하면서 "입력 → 영향" 관계를 실시간으로 이해할 수 있다.

**Acceptance Criteria:**

**Given** `<CalculatorStepChunk stepIndex>` 컴포넌트
**When** 계산기 섹션 렌더
**Then** 15필드가 4~5 step(예: ① 매물 기본 3필드 · ② 질권대출 3필드 · ③ 선순위·당해세 4필드 · ④ 임차·지역 3필드 · ⑤ 예정가 2필드)으로 분할되어 한 화면에 1 step 만 노출되고, 각 step 카드 상단에 제목(body-sm semibold) + 인디케이터 "1/4" 형식 표시 (UX-DR10)

**Given** step 사이 전환
**When** Enter 키 또는 "다음" 버튼 클릭
**Then** 현재 step 의 `onBlur` 검증 통과 시 다음 step 으로 이동 + 이전 step 은 접혀서 입력값 요약만 표시 + 첫 필드 auto-focus

**Given** 역방향 전환
**When** Shift+Tab 또는 "이전" 버튼 클릭
**Then** 이전 step 으로 돌아가고 마지막 필드 auto-focus

**Given** Live Calculation Shadow
**When** 필드 값 변경 (blur 또는 200ms 디바운스 후)
**Then** 영향받는 출력 필드만 부분 재계산되어 해당 값이 업데이트되고, 업데이트된 출력 필드는 150ms 동안 `bg-accent-subtle` highlight 로 시각 표시 (UX-DR10)

**Given** 키보드 네비게이션
**When** 하나의 step 내에서 Tab 이동
**Then** 필드 순서대로 자연스럽게 순회하고 마지막 필드에서 Tab → "다음" 버튼 포커스 → 추가 Tab → 다음 step 첫 필드로 이동

**Given** step 상태 시각
**When** 상단 step 인디케이터 확인
**Then** `active`(현재), `completed`(체크 아이콘), `pristine`(숫자만) 3 상태가 명시적으로 구분된다

**Given** `prefers-reduced-motion`
**When** 사용자가 reduced motion 선호
**Then** step 전환 애니메이션과 Live Shadow highlight 모두 `duration: 0` 으로 폴백되어 즉시 전환 + highlight 없음 (NFR18)

### Story 3.5: 프리셋 1종 완성 + 2종 Placeholder

As a 방문자 (김OO · Secondary),
I want "1회 유찰+70%" 프리셋 버튼 한 번의 클릭으로 15필드가 전형적 가정 값으로 자동 채워져 즉시 결과를 확인하고 나머지 2종 프리셋은 Placeholder 로 확장 방향을 예고 받아,
So that NPL 계산기의 사용성을 15필드 수동 입력 없이 체험할 수 있다.

**Acceptance Criteria:**

**Given** `<CalculatorPresetBar presets={[...]}>` 컴포넌트
**When** 계산기 섹션 상단 렌더
**Then** 3 버튼("1회 유찰+70%", "방어입찰", "재매각")이 가로 Button 그룹으로 표시되고, `role="group" aria-label="계산기 프리셋"` + 각 버튼 `aria-pressed` 상태 노출 (UX-DR9)

**Given** "1회 유찰+70%" 프리셋 클릭
**When** 버튼 활성화
**Then** `lib/calculator/presets.ts` 에 정의된 15필드 기본값(1회 유찰 가정 + 감정가 70% 낙찰 가정 + 표준 질권대출 비율 등)이 RHF 폼에 `setValue` 로 일괄 입력 + Story 3.6 Calculator Dance 트리거
**And** 입력된 필드는 `bg-accent-subtle` + "자동 적용됨" caption 3초 페이드 (UX-DR16)

**Given** "방어입찰"·"재매각" 프리셋
**When** 버튼 렌더
**Then** 두 버튼 위에 `<PlaceholderLabel severity="demo" reason="프리셋 2·3종은 Phase 2 SHOULD">` 가 오버레이되어 클릭 시 Popover 로 이유 노출 + 실제 필드 채움은 동작하지 않는다

**Given** 프리셋 버튼 상태
**When** 상태 전환 관측
**Then** `default`(기본), `pulse`(최초 500ms 1회 애니메이션으로 주목 유도), `active`(클릭 후 강조), `hover`, `focus-visible` 5 상태가 정의된 스타일로 동작 (UX-DR9)

**Given** 초기 페이지 진입 시 Pulse 유도
**When** 페이지 최초 로드 후 500ms
**Then** "1회 유찰+70%" 버튼이 1회 pulse 애니메이션 (`prefers-reduced-motion` 사용자는 제외)

**Given** 샘플 사건 로드 서브 옵션
**When** 프리셋 버튼 옆 "샘플 사건 로드" Secondary 버튼 (`variant=outline`) 제공
**Then** 5개 샘플 fixture (`sample-01` ~ `sample-05`) 중 하나를 드롭다운으로 선택해 해당 input 을 폼에 주입할 수 있다 (데모 편의)

### Story 3.6: Calculator Dance + URL pre-fill

As a 방문자,
I want 프리셋 클릭 또는 15필드 입력 완료 시 출력 25+ 필드가 세 구획(기간·수익률·배당)으로 동시 fade-up + stagger 로 펼쳐지고, 매물 카드에서 시뮬레이션 CTA 클릭 시 URL 파라미터로 사건번호·감정가가 자동 입력되어,
So that 매물 → 계산기 → 결과 플로우가 한 번에 1.2초 내에 드라마틱하게 완성된다.

**Acceptance Criteria:**

**Given** Calculator Dance 출력 영역
**When** 프리셋 클릭 또는 전체 입력 완료 시 트리거
**Then** 출력 25+ 필드가 세 구획(기간·수익률·배당)에 Framer Motion `AnimatePresence` + stagger 로 fade-up 펼쳐지고, 시작부터 완료까지 총 소요 시간 ≤ 1.2초 (NFR17 데모 임팩트)

**Given** 애니메이션 상세
**When** 각 구획 관측
**Then** 구획 간 stagger 150ms · 구획 내 필드 stagger 40ms · 각 필드 fade 200ms + slide 12px ease-out + `text-number` tabular-nums 로 숫자 정렬

**Given** 결과 카드 하이라이트
**When** 최종 수익률 필드 렌더 완료
**Then** `number-hero` (40/48 tabular-nums) 크기 + `bg-accent-subtle` → 투명 fade 150ms 로 시선 유도

**Given** URL 파라미터 수신
**When** 페이지가 `/?case=2024타경110044&preset=1` 로 진입
**Then** 자동으로 해당 매물의 사건번호·감정가·최저입찰가를 `app/data/listings.json` 에서 읽어 RHF 폼의 대응 필드에 setValue + 프리셋 1번 자동 적용 + 계산기 섹션 앵커로 부드럽게 스크롤

**Given** 잘못된 URL 파라미터
**When** 존재하지 않는 `case` 또는 유효하지 않은 `preset` 수신
**Then** 경고 toast(`sonner` 우하단) "요청한 매물을 찾지 못했습니다" 3초 + 빈 폼 상태로 진입하고 에러로 끝나지 않는다 (dead-end 0건)

**Given** `prefers-reduced-motion`
**When** reduced motion 선호 사용자
**Then** Calculator Dance 전체가 `duration: 0` 폴백으로 최종 상태 즉시 표시 (NFR18, UX-DR4)

**Given** Calculator Dance 반복 트리거
**When** 다른 프리셋 클릭 또는 재입력으로 재계산
**Then** 이전 애니메이션이 정리된 후 새로운 Dance 가 재실행된다 (`AnimatePresence` key 기반)

---

## Epic 4: Meta 토글 주석 시스템 (Gate 2)

우상단 Meta 토글(shadcn Switch) + 스페이스바 + URL(`?meta=on`) + localStorage + Zustand 전역 상태 + Ambient Annotation Mark + aside Sheet + 11개 의사결정 주석 서빙.

**Gate 2 체크포인트**: Story 4.4 (aside Panel + 주석 11개 서빙) 완료 여부 → 실패 시 8개로 축소 + #11(교양 콘텐츠 제외 이유) 우선 보존.

### Story 4.1: 11개 주석 데이터 모듈 (`lib/data/annotations.ts`)

As a 개발자 (blynn),
I want 11개 의사결정 주석을 `lib/data/annotations.ts` TypeScript 모듈로 정의하고 각 주석에 id·번호·주제·본문·근거 링크·관련 주석을 구조화하여,
So that 컴포넌트는 id 로 주석을 grep 가능하게 참조할 수 있고 Meta 토글 Gate 실패 시 8개로 축소 운용이 가능하다.

**Acceptance Criteria:**

**Given** `lib/data/annotations.ts` 모듈
**When** 타입 정의 확인
**Then** `type Annotation = { id: string; number: number; title: string; body: string; rationale: Array<{ label: string; href?: string }>; related: string[]; priority: 'must' | 'fallback-omit' }` 형태로 정의된다
**And** `export const ANNOTATIONS: Annotation[]` 배열이 11개 요소를 포함하고 각 요소 id 가 고유

**Given** 11개 주석 주제 (MVP 필수 11개)
**When** 배열 확인
**Then** 다음 11개 주제가 전부 포함된다:
- #1 `calc-starter-template` — "왜 Vercel+Supabase 공식 스타터인가"
- #2 `calc-pure-function` — "왜 계산기 로직을 순수 함수 + Vitest 골든 테스트로 격리했는가"
- #3 `rls-scope` — "왜 쓰기 RLS 매트릭스 전수 검증이 아니라 읽기만 강제했는가"
- #4 `masking-script` — "왜 빌드 타임 1회 마스킹 스크립트인가 (런타임 마스킹 아님)"
- #5 `l2-gating` — "L2 게이팅 설계 이유 (대부업법·자본시장법 경계)"
- #6 `copy-reframing` — "거래 → 정보 매칭, 가입 승인 → L2 적격성 자진 확인 리프레이밍 이유"
- #7 `lender-form-no-approval` — "대부업체 매물 등록 admin 승인 없이 바로 상태 변경한 이유"
- #8 `rls-write-matrix-postmvp` — "쓰기 RLS 9가지 매트릭스 전수 검증을 Post-MVP SHOULD 로 미룬 이유"
- #9 `timezone-asia-seoul` — "왜 `date-fns-tz` Asia/Seoul 강제 + 양편넣기 판례 기준인가"
- #10 `single-tenant-rationale` — "왜 단일 테넌트 Global Pool 인가 (multi-tenant 격리 미구현)"
- #11 `no-edu-content` — "왜 교양 콘텐츠 축이 없는가 (선별이 곧 설계 역량)"
**And** 각 주석의 `priority` 필드로 Gate 2 실패 시 제거 가능한 3개를 `fallback-omit` 으로 표시 (예: #3, #8, #10), #11 은 반드시 `must`

**Given** 각 주석의 `rationale` 링크
**When** 근거 배열 확인
**Then** 법령(예: "대부업법 제3조"), 판례(대법원 판결 URL), GitHub 커밋 SHA 링크, 또는 외부 레퍼런스(예: Supabase RLS 문서)가 최소 1개 이상 제공된다

**Given** 관련 주석 링크
**When** `related` 필드 확인
**Then** 각 주석이 최소 1개 관련 주석 id 를 참조하여 `<MetaAnnotationPanel>` 에서 점프 가능하게 한다 (예: #5 → #6, #7; #3 → #8)

**Given** 주석 추가·수정 워크플로
**When** 새 주석을 추가하거나 기존 주석 본문 수정 시
**Then** `lib/data/annotations.ts` 만 편집하면 되고, 컴포넌트 측 코드 변경 없이 번들에 반영된다

### Story 4.2: Meta 토글 전역 상태 (Zustand + URL + localStorage + 스페이스바)

As a 방문자,
I want 우상단 Meta 토글을 클릭하거나 스페이스바를 누르거나 `?meta=on` URL 로 진입했을 때 전역 Meta 상태가 일관되게 ON/OFF 전환되고 페이지 새로고침·재방문 시에도 localStorage 로 복원되어,
So that 세 가지 경로(UI · 키보드 · URL) 모두가 동일한 단일 상태원에 기댄다.

**Acceptance Criteria:**

**Given** Zustand 스토어 구성
**When** `stores/meta-store.ts` 와 `stores/provider.tsx` 확인
**Then** SSR 안전 패턴(`createStore` 팩토리 + Context Provider)으로 구현되어 Next.js App Router 에서 hydration mismatch 없이 동작
**And** 상태 shape: `{ isOn: boolean; activeAnnotationId: string | null }` + actions `toggle() / setOn(boolean) / setActiveAnnotation(id)`

**Given** `<MetaToggle>` 우상단 fixed 컴포넌트
**When** 모든 페이지 레이아웃 렌더
**Then** shadcn `Switch` 기반으로 우상단에 fixed 표시 + "Meta" 레이블 + `·` 장식 + `role="switch" aria-pressed={isOn} aria-expanded={isOn} aria-label="의사결정 주석 토글"` (UX-DR22)

**Given** 전역 스페이스바 단축키
**When** 문서 어디에서나 스페이스바 keydown
**Then** input·textarea·contenteditable 요소에 포커스가 있지 않은 경우에만 Meta 토글이 전환된다 (입력 방해 방지)

**Given** URL 파라미터 동기화
**When** `/?meta=on` 으로 진입
**Then** 초기 렌더 시 Meta 상태가 ON 으로 세팅되고, 사용자가 토글 변경 시 URL 쿼리가 `router.replace` 로 업데이트된다
**And** `?meta=off` 또는 파라미터 없음 시 OFF 기본값

**Given** localStorage 영속화
**When** 사용자가 Meta 상태 변경
**Then** `localStorage["npl-market:meta-store"]` 에 JSON 직렬화 저장 + 다음 방문 시 복원된다
**And** URL 파라미터가 있으면 URL 값이 localStorage 보다 우선

**Given** 토글 전환 시 부가 효과
**When** Meta OFF → ON 전환
**Then** aside Sheet(Story 4.4) 가 자동 오픈 + `<AmbientAnnotationMark>`(Story 4.3) 가 "왜?" 배지 모드로 전환
**And** 최초 ON 전환 시 첫 주석(#1)이 auto-expanded + 슬라이드인 (전체 방문 세션 중 1회만)

### Story 4.3: `<AmbientAnnotationMark>` 인라인 인디케이터

As a 방문자,
I want 각 기능 옆에 Meta 주석의 존재를 암시하는 인디케이터가 표시되어 Meta OFF 상태에서는 방해되지 않고 ON 상태에서는 "왜?" 배지로 명확히 드러나,
So that 포트폴리오 심사층이 숨어 있지만 발견 가능한 형태로 제공된다.

**Acceptance Criteria:**

**Given** `components/meta/ambient-annotation-mark.tsx`
**When** `<AmbientAnnotationMark id="calc-pure-function" />` 렌더
**Then** `lib/data/annotations.ts` 에서 해당 id 의 주석을 lookup 하고 존재하지 않으면 개발 환경에서 console.error + null 렌더

**Given** Meta OFF 상태
**When** 인디케이터 렌더
**Then** 작은 `·` (text-muted, 2px 크기) 으로 은은하게 표시되고, hover 시 shadcn `Tooltip` 으로 주석 제목(첫 줄)을 preview (UX-DR7)

**Given** Meta ON 상태
**When** 인디케이터 렌더
**Then** "왜?" caption 배지(accent 색상 + body-sm)로 전환되어 뚜렷하게 노출된다

**Given** 키보드 포커스
**When** Tab 키로 인디케이터 포커스
**Then** `focus-visible:ring-2 ring-accent` 적용 + `aria-label="의사결정 주석 #{number} {title} 표시"` 제공

**Given** 클릭 또는 Enter
**When** Meta OFF 상태에서 인디케이터 활성화
**Then** Meta 토글이 자동 ON + aside Sheet 오픈 + 해당 주석 auto-expanded + `bg-accent-subtle` 150ms highlight

**Given** Meta ON 상태에서 클릭
**When** 인디케이터 활성화
**Then** aside Sheet 이 열려 있으면 해당 주석 위치로 스크롤 + 150ms highlight, 닫혀 있으면 열고 동일 동작

**Given** 11개 주석 배치 지점
**When** 전체 사이트 렌더
**Then** 각 주석 id 에 대응하는 기능 근처에 `<AmbientAnnotationMark id="..." />` 가 최소 1곳 배치되어 있다 (예: #5 는 `<TierGateBanner>` 옆, #2 는 계산기 결과 영역 옆, #11 은 Hero 인텐트 스트립 옆 등)

### Story 4.4: `<MetaAnnotationPanel>` aside Sheet + Accordion (Gate 2 체크포인트)

As a 방문자,
I want Meta 토글 ON 시 우측에서 420px 너비 aside Sheet 이 슬라이드인하며 11개 주석을 Accordion 리스트로 노출하여,
So that 한 화면에서 SaaS 콘텐츠를 가리지 않고 의사결정 주석을 읽으며 둘을 교차 참조할 수 있다.

**Acceptance Criteria:**

**Given** `components/meta/meta-annotation-panel.tsx`
**When** aside Sheet 마크업 확인
**Then** shadcn `Sheet` (side=right, width 420px) 내부에 Accordion 으로 11개 주석 리스트 + 각 아이템 헤더는 `#{번호} {주제}`, 콘텐츠는 `body-sm max-w-prose` 본문 + "근거:" 섹션 + "관련 주석:" 번호 링크 (UX-DR8)

**Given** 접근성 속성
**When** DOM 확인
**Then** `<aside role="complementary" aria-label="의사결정 주석">` + Sheet 열린 상태 `aria-modal="false"` (SaaS 콘텐츠 차단하지 않음) + ESC 키로 닫힘 + focus trap 은 shadcn Sheet 기본 활성화
**And** aside 슬라이드인 300ms ease-out (UX-DR4), `useReducedMotion()` 사용자는 `duration: 0` 폴백 (NFR18)

**Given** 첫 주석 자동 expanded
**When** 사용자가 해당 세션에서 Meta 토글을 처음 ON 전환
**Then** 주석 #1(`calc-starter-template`) 가 자동 expanded 상태로 첫 화면에 노출 + 한 번 expanded 된 이후에는 재전환 시 마지막 상태 유지 (localStorage 또는 Zustand 세션)

**Given** 주석 간 점프
**When** 주석 본문 내 "관련 주석:" 링크 클릭 (예: #5 → #6)
**Then** 현재 주석 collapsed + 타겟 주석 expanded + 부드럽게 스크롤 + 150ms highlight

**Given** 11개 주석 전부 서빙 (Gate 2 통과 조건)
**When** aside 오픈 상태
**Then** 11개 주석이 전부 Accordion 리스트에 렌더되고 각 항목이 expand 가능 + 본문·근거·관련 주석을 전부 표시
**And** 실패 시 fallback: `priority === 'fallback-omit'` 주석 3개를 제거한 8개로 축소하되 #11 은 반드시 포함

**Given** 외부 근거 링크
**When** 사용자가 근거 링크(대법원 판례 URL 등) 클릭
**Then** `target="_blank" rel="noopener noreferrer"` 로 새 탭에서 열리고, 내부 GitHub 커밋 링크는 동일 창에서 이동

**Given** Sheet 닫기 3경로 (UX-DR18)
**When** 닫기 트리거
**Then** ESC 키 + Sheet 외부 클릭 + 우상단 X 버튼 세 가지 경로 모두 닫기 동작 + body scroll lock 해제

**Given** 모바일 환경 (375px)
**When** 모바일에서 Meta 토글 ON
**Then** aside 가 bottom sheet 으로 대체 시도 (SHOULD), 실패 시 Meta 토글 자체가 비활성 + "데스크톱에서 확인" caption 노출 (UX-DR28)

---

## Epic 5: 커뮤니티 & 대부업체 등록 & admin 운영

3 카테고리(경매방 실 샘플 5건 + 자유수다방/Q&A Placeholder) + L2+ 블러 배너 + "검증 요청" CTA + 대부업체 10필드 매물 등록 폼 + admin 최소 운영 경로.

### Story 5.1: 커뮤니티 3 카테고리 UI + 경매방 샘플 글 5건

As a 방문자 (프롭테크 대표 B),
I want 커뮤니티 섹션에서 "경매방" 카테고리의 실무자 톤 샘플 글 5건을 읽고 나머지 2개 카테고리("자유수다방"·"Q&A")는 Placeholder 로 확장 방향을 확인하여,
So that 실 배포 시 기대할 수 있는 커뮤니티 톤·수준을 데모로 검증할 수 있다.

**Acceptance Criteria:**

**Given** `features/community/` 디렉토리
**When** 커뮤니티 섹션 렌더 (`/#community`)
**Then** shadcn `Tabs` 기반 3-Tab ("경매방" · "자유수다방" · "Q&A") + 기본 선택 "경매방"

**Given** 경매방 샘플 글 데이터
**When** `app/data/community-posts.json` 확인
**Then** 실무자 톤(사건번호 언급·법령 인용·숫자 중심) 샘플 글 최소 5건이 각각 제목·본문·작성자(익명 이니셜)·tier 배지·작성일시(Asia/Seoul)를 포함한다
**And** 본문에는 실제 사건번호 포맷(`2024타경XXXXX`)·판례 언급·금액(`formatWon` 포맷)이 섞여 톤 검증 가능

**Given** 경매방 탭 렌더 (상단 3건 영역)
**When** 사용자가 L1 인증되지 않은 상태 또는 L1 상태
**Then** 상위 3건은 일반 노출되고 4~5번째 글은 Story 5.2 `<TierGateBanner>` 로 블러 처리된다

**Given** 자유수다방·Q&A 탭
**When** 탭 전환
**Then** `<PlaceholderLabel severity="demo" reason="자유수다방·Q&A는 Phase 2 SHOULD — 경매방 톤 검증 이후 확장">` 로 감싸진 샘플 3건 목업이 블러/그레이 처리로 노출된다

**Given** 키보드 접근성
**When** Tab + 좌우 화살표
**Then** Radix Tabs 키보드 네비게이션 동작 + `aria-selected` 전환 + 각 게시글은 `<article aria-label="게시글: {제목}">` 구조

**Given** URL 상태
**When** 사용자가 특정 탭 활성 상태
**Then** URL `?community=auction|chat|qa` 로 공유 가능

### Story 5.2: `<TierGateBanner>` L2+ 블러 + "검증 요청" CTA

As a 방문자 (L1 또는 무인증),
I want 경매방 상단 3건 이후 L2+ 검증 회원 전용 콘텐츠가 블러 처리되고 중앙 배너로 "검증 요청" CTA 와 이유가 표시되어,
So that 게이팅이 존재한다는 사실과 해제 경로를 즉시 인지할 수 있다.

**Acceptance Criteria:**

**Given** `components/tier/tier-gate-banner.tsx` 구현
**When** `<TierGateBanner targetTier="L2" reason="대부업법·자본시장법 경계 반영">` 렌더
**Then** 아래 콘텐츠 영역에 `backdrop-blur-sm` 오버레이 + 중앙에 "L2 검증 회원 전용" 타이틀 + 이유 body-sm + Secondary 버튼 "검증 요청" (UX-DR13)

**Given** 게이팅 상태
**When** 현재 사용자 tier 가 targetTier 이상
**Then** 배너는 `unlocked` 상태로 자동 해제되고 콘텐츠가 정상 노출된다
**And** 아직 인증되지 않은 사용자는 "로그인 후 검증 요청" 으로 CTA 변경

**Given** 접근성 선언
**When** DOM 확인
**Then** 배너 루트가 `<div role="region" aria-label="L2 검증 필요 콘텐츠">` + 검증 요청 버튼 `aria-describedby="tier-gate-reason"` + 블러된 콘텐츠 영역 `aria-hidden="true"` (스크린리더 차단)

**Given** Meta 주석 연결
**When** 배너 옆 DOM 관찰
**Then** `<AmbientAnnotationMark id="l2-gating" />` 가 배너 우측 또는 "검증 요청" 버튼 옆에 배치되어 Meta 주석 #5 로 점프 가능

**Given** "검증 요청" 버튼 클릭
**When** 사용자 인증 상태
**Then** 인증된 사용자: `/profile/tier-request` 페이지로 이동 (Story 5.3)
**And** 비인증 사용자: Supabase 매직링크 로그인 모달 또는 로그인 페이지로 리다이렉트 + 로그인 후 원래 페이지 복귀

**Given** `prefers-reduced-motion`
**When** reduced motion 사용자
**Then** 블러 적용은 유지하되 배너 슬라이드인/페이드인 애니메이션은 `duration: 0` 폴백

### Story 5.3: L1 → L2 tier 승격 요청 Server Action

As a L1 인증 사용자,
I want `/profile/tier-request` 페이지에서 간단한 자진 확인 양식을 제출하여 L2 승격 요청을 생성하고,
So that "대부업법 L2 적격성 자진 확인" 과정을 거쳐 admin 승인 후 커뮤니티 전체에 접근할 수 있다.

**Acceptance Criteria:**

**Given** `/profile/tier-request` 페이지
**When** L1 사용자 접근
**Then** "대부업법 L2 적격성 자진 확인" 타이틀 + 자진 확인 체크리스트 3개(대부업 등록 여부·관련 실무 경력·자본시장법 경계 숙지) + 자유 기재 "요청 사유" textarea(최대 500자) + 제출 버튼 노출
**And** 규제 카피는 `lib/copy/regulatory.ts` 의 `REGULATORY_COPY.L2_VERIFICATION` 상수 사용

**Given** 제출 Server Action
**When** 폼 제출
**Then** Zod 스키마로 검증 → `tier_requests` 테이블에 INSERT (`user_id`, `target_tier='L2'`, `reason`, `checklist_json`, `status='pending'`, `created_at`)
**And** Server Action 반환 타입은 `{ data: { requestId: string } } | { error: string }` discriminated union

**Given** 성공 응답
**When** INSERT 성공
**Then** `sonner` toast 우하단 "검증 요청을 접수했습니다 — admin 검토 후 안내" 3초 노출 + 폼이 "접수 완료" 상태로 교체 + 재제출 버튼 비활성화

**Given** 중복 제출 방지
**When** 같은 사용자가 24시간 내 재제출 시도
**Then** Server Action 이 DB 에서 `status='pending'` 이거나 최근 24h 내 제출 기록을 확인해 에러 반환 `{ error: "이미 접수된 요청이 처리 중입니다" }` + 폼 에러 인라인 노출

**Given** 제출 중 상태
**When** 버튼 클릭 후 응답 대기
**Then** 버튼 `disabled` + 내부 Spinner + "전송 중..." 텍스트 (UX-DR16)

**Given** RLS 정책
**When** `tier_requests` 테이블 INSERT
**Then** RLS 정책으로 본인 `user_id` 만 INSERT 가능 + 본인과 admin 만 SELECT 가능

**Given** 이미 L2+ 사용자 또는 admin
**When** `/profile/tier-request` 접근
**Then** "이미 L2 검증 완료 상태입니다" 안내 + 폼 숨김

### Story 5.4: 대부업체 매물 등록 10필드 폼

As a L3+🏢대부업체 배지 사용자,
I want 10필드 폼으로 매물을 직접 등록하면 admin 승인 없이 바로 `listings` 에 추가되어,
So that MVP 데모 환경에서 대부업체 온보딩 플로우를 실감 나게 체험할 수 있다.

**Acceptance Criteria:**

**Given** `features/lender-form/` 디렉토리
**When** `/profile/lender/new-listing` 페이지 접근
**Then** 현재 사용자가 L3 이상 + `lender_badge=true` 인 경우에만 폼 노출, 그 외에는 `<TierGateBanner targetTier="L3">` + 대부업체 배지 안내

**Given** 10필드 Zod 스키마
**When** `features/lender-form/schema.ts` 확인
**Then** 10필드가 정의된다: `case_number`(사건번호 패턴), `court`(법원명 select), `property_type`(아파트/오피스텔/상가 select), `address`(시군구+동), `appraisal_price`(감정가), `minimum_bid`(최저입찰가), `auction_date`(경매일), `special_tags`(특수물건 multi-select), `claim_amount`(채권 원금), `contact_note`(자유 메모 200자)

**Given** RHF + Zod 폼 UX
**When** 사용자가 필드 입력
**Then** `mode: 'onBlur'` 실시간 검증 + 에러 필드 `destructive` border + inline caption (UX-DR16)

**Given** 제출 Server Action
**When** 폼 제출
**Then** Zod 검증 통과 후 `listings` 테이블에 INSERT (`status='approved'` 기본값 - admin 승인 단계 없음, `created_by_user_id`=current user, `source='lender'`)
**And** 반환 타입 discriminated union `{ data: { listingId } } | { error }`

**Given** 성공 응답
**When** INSERT 성공
**Then** toast "매물이 등록되었습니다" + `/auction/[caseNumber]` 페이지로 리다이렉트

**Given** 승인 없이 바로 상태 변경 이유 명시
**When** 폼 하단 또는 제출 버튼 옆 관찰
**Then** `<AmbientAnnotationMark id="lender-form-no-approval" />` 인라인 배치되어 Meta 주석 #7("admin 승인 없이 바로 상태 변경 — MVP 범위 밖 승인 워크플로")로 즉시 점프 가능

**Given** RLS 정책
**When** `listings` 테이블 INSERT
**Then** RLS 가 `auth.uid() = created_by_user_id AND profiles.tier = 'L3' AND profiles.lender_badge = true` 조건을 강제
**And** 스키마상 `created_by_user_id` 컬럼이 추가되어야 하면 Story 1.3 마이그레이션에 사전 반영 필요 (의존성 확인 후 필요 시 추가 마이그레이션)

**Given** 제출 중 상태
**When** 버튼 클릭 후 응답 대기
**Then** 버튼 `disabled` + Spinner + "등록 중..." (UX-DR16)

### Story 5.5: admin 최소 운영 경로 + tier 수동 승격 UI

As a admin (blynn),
I want `/admin` 경로에서 대기 중인 tier 승격 요청 목록을 확인하고 한 번의 클릭으로 승인·거부할 수 있어,
So that 데모 시연 중 실시간으로 L1 → L2 승격 시나리오를 재현할 수 있다.

**Acceptance Criteria:**

**Given** `/admin` Server Component 가드
**When** admin 이 아닌 사용자가 접근
**Then** 현재 세션 이메일을 `ADMIN_EMAILS` 환경변수(쉼표 구분)와 비교하고 일치하지 않으면 Next.js `notFound()` 렌더 (admin 존재 은닉)
**And** 일치하면 admin 대시보드 UI 노출

**Given** admin 대시보드 UI
**When** admin 이 `/admin` 접근
**Then** 상단에 현재 admin 계정 이메일 + tier 통계 요약(L1/L2/L3 카운트) + 대기 중 `tier_requests` 리스트 (status='pending', 최신 순)

**Given** 각 승격 요청 카드
**When** admin 관찰
**Then** 요청자 이메일(익명화된 이니셜) + 제출 일시(Asia/Seoul) + 자진 확인 체크리스트 요약 + 요청 사유(textarea 원문) + "승인" / "거부" 버튼 두 개

**Given** "승인" 버튼 클릭
**When** admin 이 클릭
**Then** Server Action 호출 → `tier_requests.status='approved'` + `profiles.tier=target_tier` 동시 업데이트 (트랜잭션) + toast "승격 처리 완료" + 리스트에서 해당 카드 제거

**Given** "거부" 버튼 클릭
**When** admin 이 클릭
**Then** Server Action 호출 → `tier_requests.status='rejected'` + 거부 사유 입력 모달 (간단 textarea) + 확인 시 업데이트 + toast "거부 처리 완료"

**Given** admin UI 범위 외 기능
**When** 매물 CRUD · 커뮤니티 관리 · 분석 대시보드 등을 찾으려 할 때
**Then** `<PlaceholderLabel severity="vision" reason="admin UI 고도화는 MVP 범위 밖 — Meta 주석 참조">` 로 명시 + `<AmbientAnnotationMark id="lender-form-no-approval" />` 근처 배치해 의사결정 근거 노출

**Given** RLS 정책
**When** admin Server Action 이 `tier_requests` / `profiles` UPDATE
**Then** Server Action 내부에서 `auth.uid()` 확인 + `ADMIN_EMAILS` 재검증 + `service_role` 키를 사용해 RLS 우회 업데이트 (Server Action 내부 한정, 클라이언트 노출 0건 — NFR7 검증)

**Given** admin 세션 만료
**When** 오래된 세션으로 Server Action 호출
**Then** 에러 반환 `{ error: "admin 재인증 필요" }` + 로그인 페이지로 리다이렉트

---

## Epic 6: 랜딩 Hero · About · 배포 마무리 (Gate 3 + Gate 4)

Intent Framing 스트립 + Map Breath + Live Ticker + Hero Reveal 권리분석 Writeup 1건 + About 섹션 + SEO/OG + 규제 카피 최종 검수 + Lighthouse + 접근성 감사 + README + 커스텀 도메인 배포.

**Gate 3 체크포인트**: Story 6.5 (Lighthouse + dead-end 점검) — 실패 영역은 Placeholder 라벨로 덮음.
**Gate 4 체크포인트**: Story 6.6 (HTTPS + 도메인 + 카카오맵 3환경 작동) — 실패 시 `*.vercel.app` 폴백.

### Story 6.1: 랜딩 Hero — Intent Framing + Map Breath + Live Ticker

As a 방문자 (첫 3초에 의도 파악이 필요한 발주자 B),
I want 랜딩 첫 화면에서 Intent Framing 스트립으로 "NPL 실무자 × 핀테크 PM blynn의 작업물 — 이 페이지 자체가 프로덕트 데모, Meta 토글로 의사결정 주석을 보세요" 메시지를 명확히 읽고 Map Breath 배경 애니메이션 + Live Ticker 로 실 사건번호가 흐르는 것을 보아,
So that "서비스인가 포트폴리오인가" 인지 혼란 없이 3초 내에 의도를 파악한다.

**Acceptance Criteria:**

**Given** `features/landing-hero/` 디렉토리
**When** 루트 페이지 진입 (`/`)
**Then** 첫 화면(viewport 영역)에 Intent Framing 스트립이 최상단 얇은 배너로 노출되고, 본문은 `text-display` (48/56) 타이틀 + `text-body-lg` 서브카피 구성

**Given** Intent Framing 스트립 본문
**When** DOM 확인
**Then** 정확한 카피: "NPL 실무자 × 핀테크 PM blynn의 작업물. 이 페이지 자체가 프로덕트 데모입니다. Meta 토글로 의사결정 주석을 보세요."
**And** `<MetaToggle>` 우상단 fixed 위치 근처에 있어 스트립 ↔ 토글 시선 연결이 자연스러움

**Given** Map Breath 배경 애니메이션
**When** Hero 섹션 배경 확인
**Then** CSS 기반 subtle 애니메이션(지도 영역 outlined paths 가 천천히 호흡하듯 opacity/scale 변화, 10~15초 루프)이 `prefers-reduced-motion` 사용자에게는 정지 상태로 폴백
**And** Framer Motion 사용하지 않고 순수 CSS animation 으로 구현 (경량)

**Given** Live Ticker
**When** Hero 섹션 하단 또는 중간 영역 관찰
**Then** 실 사건번호 5건 이상이 가로로 CSS `@keyframes` 루프로 흐르고 (`2024타경110044 · 2025타경203318 · ...`), JetBrains Mono 모노스페이스로 노출
**And** 데이터 소스는 `app/data/listings.json` (Story 1.6 스냅샷)의 `case_number` 필드

**Given** Hero CTA
**When** 메인 영역 확인
**Then** Primary 버튼 1개만 존재 ("시뮬레이션 체험" — 계산기 앵커 `/#calculator` 로 스크롤) + Secondary 링크 "About" `/#about` (UX-DR14)

**Given** 반응형
**When** 뷰포트 변경
**Then** 1440px/1024px 에서는 Hero 높이 `min-h-[80vh]`, 768px 태블릿 stacked, 375px 모바일에서는 Map Breath 제거 + Live Ticker 속도 둔화 (UX-DR27/28)

**Given** Meta 주석 연결
**When** Intent Framing 스트립 옆 관찰
**Then** `<AmbientAnnotationMark id="no-edu-content" />` 또는 다른 핵심 주석 1개가 배치되어 Meta 토글 유도 시그널 제공

### Story 6.2: Hero Reveal — 권리분석 리포트 1건 Full Writeup

As a 방문자 (법무법인 파트너 A),
I want Hero 하단 Reveal 섹션에서 실제 사건 1건에 대한 권리분석·배당 시나리오·수익률 결론을 Full Writeup 으로 읽어,
So that 계산기의 "숫자가 아닌 맥락" 을 먼저 이해하고 실무 깊이를 판단할 수 있다.

**Acceptance Criteria:**

**Given** `app/data/hero-writeup.mdx` (또는 `.md`) 파일
**When** 콘텐츠 소스 확인
**Then** 실제 경매 1건(예: `2024타경110044`) 에 대한 권리분석 Writeup 이 MDX/Markdown 으로 작성되어 있고, 다음 섹션을 포함: ① 매물 개요 ② 권리 계층 분석 ③ 배당 시나리오(여러 가정) ④ 수익률 결론 ⑤ 실무 리스크 노트
**And** 모든 금액은 `formatWon` 포맷, 날짜는 `formatDate` (Asia/Seoul), 사건번호는 JetBrains Mono 로 렌더

**Given** Writeup 렌더링 인프라
**When** `/` 페이지 Hero 하단 스크롤
**Then** Reveal 섹션이 자연 노출되며 `<article class="prose max-w-prose">` (UX-DR2 reading width ~65ch) 구조로 본문 타이포그래피 적용

**Given** `<RightsCascade>` 재사용
**When** Writeup "권리 계층 분석" 섹션
**Then** Story 2.5 에서 구현한 `<RightsCascade>` 컴포넌트가 이 Writeup 에도 재사용되어 시각 일관성 유지 + `prefers-reduced-motion` 폴백 동일 적용

**Given** Writeup 접근성
**When** 스크린리더 탐색
**Then** 섹션 제목은 `<h2>/<h3>` 계층, 금액 인라인은 `<span aria-label="이억사천오백만원">24.5억</span>` 한국어 음성 라벨 (UX-DR21), 표는 `<table>` + `<caption>` 구조

**Given** Writeup 하단 액션
**When** 사용자가 Writeup 을 다 읽음
**Then** 하단에 "이 사건을 계산기로 시뮬레이션" Primary 버튼 → `/#calculator?case={사건번호}&preset=1` URL 로 스크롤 (Story 3.6 pre-fill 동작 연결)

**Given** Writeup 의 법적 고지
**When** 상단 또는 하단 관찰
**Then** 규제 카피 모듈에서 `REGULATORY_COPY.REPORT_DISCLAIMER` ("정보·참고용 — 실제 판단은 변호사 자문 필요") 배너가 명시적으로 렌더된다

### Story 6.3: About 섹션 — 공고 매칭 표 + 겸업/전업 + Contact

As a 방문자 (발주자 B, Meta 토글 미열람 Journey 2 Edge Case),
I want About 섹션에서 발주 공고 단어와 blynn 의 역량·경력이 line-by-line 매칭된 표를 보고 겸업/전업 가능 범위·법적 고지·Contact SLA 를 확인한 뒤 mailto CTA 로 즉시 연락할 수 있어,
So that Meta 토글을 열지 않아도 Primary Success Path 가 성립한다.

**Acceptance Criteria:**

**Given** `features/about/` 디렉토리
**When** About 섹션 렌더 (`/#about`)
**Then** 4 subsection 이 명확히 구분된다: ① 공고 매칭 표 ② 겸업/전업 가능 범위 ③ 법적 고지 인라인 ④ Contact (mailto CTA + SLA)

**Given** 공고 매칭 표
**When** 표 구조 확인
**Then** `<table>` 이 2열(공고 단어 원문 | blynn 대응 내용)로 렌더되고, 공고 헤더 문구를 단어 그대로 인용(예: "NPL 실무 5년+" 을 공고 표현 그대로), 대응 내용은 구체 숫자·경험·산출물 링크로 답변
**And** 표에 `<caption>발주자 공고 요구사항과 blynn 역량 매칭</caption>` 명시 + Lighthouse 접근성 통과

**Given** 겸업/전업 가능 범위
**When** 해당 subsection 관찰
**Then** "현재 겸업 가능 범위" 와 "전업 조건" 이 별도 단락으로 명시(예: "주 20h 이하 겸업 · 월 최대 80h 작업 · 3개월 이내 전업 전환 가능")

**Given** 법적 고지 인라인
**When** 관련 문단 확인
**Then** `REGULATORY_COPY` 모듈의 상수를 사용한 "정보·참고용 — 실제 판단은 변호사 자문 필요" 같은 라인이 규제 관련 문구 옆에 인라인 배치된다

**Given** Contact 영역
**When** CTA 확인
**Then** Primary 버튼 "greatse1020@gmail.com 으로 문의" 가 `<a href="mailto:greatse1020@gmail.com?subject=...">` 로 렌더되고, 모바일에서는 클릭 시 메일 앱 자동 실행
**And** Contact 옆에 Contact SLA 명시 (예: "평일 12시간 이내 응답 · 주말 24시간 이내")

**Given** About 섹션 반응형
**When** 375px 모바일 진입
**Then** 표가 stacked(2열 → 2행 반복) + mailto CTA 가 눈에 띄게 하단 고정되지 않되 탭 가능한 `min-h-11 min-w-11` 터치 타겟 확보 (UX-DR28)

### Story 6.4: SEO/OG + JSON-LD + robots/sitemap

As a 방문자 (링크드인·슬랙에서 공유받은 링크로 진입),
I want 링크 프리뷰에 제목·설명·이미지가 제대로 노출되고 검색 엔진이 사이트 구조를 이해할 수 있어,
So that Push 채널(링크드인 공유·콜드 DM)의 첫인상 품질이 확보된다.

**Acceptance Criteria:**

**Given** `app/layout.tsx` metadata
**When** Next.js `metadata` export 확인
**Then** `title`, `description`, OpenGraph(`og:title`, `og:description`, `og:image`, `og:url`, `og:type='website'`, `og:locale='ko_KR'`), Twitter Card(`twitter:card='summary_large_image'`, `twitter:title`, `twitter:description`, `twitter:image`) 가 전부 정의된다

**Given** OG 이미지
**When** `public/og.png` 또는 동적 OG 이미지 확인
**Then** 1200×630 해상도 + "NPL 마켓 — NPL 실무자 × 핀테크 PM blynn" 브랜딩 이미지가 존재하고, `og:image` 메타로 연결
**And** 이미지는 `public-assets/` 스토리지 버킷 또는 `public/` 정적 자원에서 서빙 (Story 1.3 에서 생성한 버킷 활용)

**Given** JSON-LD 구조화 데이터
**When** `<script type="application/ld+json">` 확인
**Then** Person 스키마(blynn: name, jobTitle, url, sameAs[LinkedIn, GitHub]) + CreativeWork 스키마(NPL 마켓: name, creator=Person, description, url) 두 블록이 layout.tsx 에 삽입된다

**Given** `app/robots.ts`
**When** 파일 존재·동작 확인
**Then** production 에서는 `{ rules: [{ userAgent: '*', allow: '/', disallow: ['/admin', '/profile/'] }], sitemap: 'https://{domain}/sitemap.xml' }` 반환, preview 에서는 `{ rules: [{ userAgent: '*', disallow: '/' }] }` (크롤러 차단)

**Given** `app/sitemap.ts`
**When** `/sitemap.xml` 접근
**Then** 루트 `/`, 매물 상세 경로(`/auction/[caseNumber]` 각 매물), `/profile/tier-request` 가 lastmod·changefreq·priority 포함되어 XML 로 생성

**Given** 링크 프리뷰 확인
**When** 배포된 URL 을 링크드인·슬랙에 공유 시뮬레이션
**Then** 프리뷰 카드에 제목·설명·OG 이미지가 전부 정확히 렌더되고 한글 인코딩 깨짐 없음

### Story 6.5: 규제 카피 최종 검수 + Lighthouse + 접근성 감사 (Gate 3)

As a 개발자 (blynn, 배포 직전 검수자),
I want 규제 카피 상수 모듈이 전수 사용되었는지 검증하고 Lighthouse Performance/Accessibility 와 접근성 필수 3요소를 감사하여,
So that MVP 배포 전 "작동하는 척" 위험을 제거하고 dead-end 영역은 Placeholder 로 덮어 정직한 상태로 배포한다.

**Acceptance Criteria:**

**Given** 규제 카피 전수 검증
**When** `rg "거래하기|가입 승인|계약" --type tsx --type ts` 실행 (개발 스크립트 `pnpm check:copy`)
**Then** `lib/copy/regulatory.ts` 외부에서 금지 문자열 하드코딩이 0건이거나, 모든 사용처가 규제 카피 상수 import 를 경유한다

**Given** Lighthouse Performance 측정 스크립트
**When** `pnpm lh:measure` 실행 (Lighthouse CLI 또는 `lighthouse-ci`)
**Then** 랜딩·계산기·리스트(지도 제외) 페이지에서 Performance ≥ 80 + LCP < 2.5s + FID < 100ms + CLS < 0.1 (NFR3)
**And** 실패 페이지는 로그에 식별 + 긴급 튜닝 혹은 `pnpm lh:report` 로 이유 문서화 (지도 페이지는 사전 제외 명시)

**Given** Lighthouse Accessibility 측정
**When** 전 페이지 측정
**Then** Accessibility ≥ 90 (NFR4) + WCAG 2.1 Level AA 경고 0건

**Given** 접근성 필수 3요소 감사 (NFR5)
**When** 수동 + 자동 체크
**Then** ① 키보드 Tab 완결성(계산기 15필드 순서·Meta 토글 스페이스바·aside focus trap·Skip Link)이 모든 Journey 에서 동작 ② 시맨틱 HTML(`<main>/<aside>/<nav>/<section>` + `<label for=>` + `aria-describedby`) 감사 ③ Focus visible + Color contrast 4.5:1 본문·3:1 대형 비텍스트 감사

**Given** dead-end 점검
**When** Journey 1~5 수동 클릭 주행
**Then** 모든 미구현 접점에 `<PlaceholderLabel>` 이 배치되어 있고, 클릭 시 Popover 로 이유 노출 + 네비게이션 복귀 가능 (dead-end 0건)

**Given** `prefers-reduced-motion` 검증
**When** DevTools Emulation 으로 `prefers-reduced-motion: reduce` 활성
**Then** Calculator Dance · Rights Cascade · aside Sheet · Map Breath · Live Ticker 전부 `duration: 0` 또는 정지 상태로 폴백 (NFR18)

**Given** 체크리스트 산출물
**When** Gate 3 완료 시점
**Then** `_bmad-output/gates/gate-3-checklist.md` 또는 README 에 Lighthouse 점수표·접근성 감사 결과·Placeholder 로 덮인 영역 목록이 기록된다

**Given** Gate 3 실패 대응
**When** Performance 또는 Accessibility 목표 미달
**Then** 해당 페이지만 제외(예외 목록 README 명시) 또는 긴급 튜닝 1시간 시도, 최종 실패 시 Placeholder 로 덮고 Meta 주석에 사유 추가

### Story 6.6: README + 커스텀 도메인 배포 + 카카오맵 3환경 등록 (Gate 4)

As a 발주자 B (링크드인 공유받은 URL 로 3-5분 심사),
I want 커스텀 도메인으로 연결된 HTTPS 사이트에서 카카오맵이 정상 작동하고 README 첫 3문단으로 blynn 의 의도·작업 범위·연락처를 즉시 파악하여,
So that 데모 검증 경로(지도·계산기·Meta·About)가 전부 동작하는 상태로 의사결정에 활용할 수 있다.

**Acceptance Criteria:**

**Given** README.md 발주자 시선 3문단
**When** 리포지토리 루트 README 확인
**Then** 첫 3문단이 다음을 담는다: ① 프로젝트 한 줄 요약 + 배포 URL + 의도(포트폴리오 + SaaS 이중 데모) ② MVP 범위(4일·1인·50h 제약·MUST 12) + 범위 외 명시 ③ Contact(blynn 이메일·BMAD PRD 공개 링크·GitHub) + "Meta 토글 ON으로 의사결정 주석 탐색 유도" 문구
**And** README 상단 배지: 배포 URL + Lighthouse 점수 + License

**Given** BMAD PRD 공개 링크
**When** README 에서 참조
**Then** `_bmad-output/planning-artifacts/prd.md` 가 GitHub 기본 경로로 브라우저 렌더 가능하거나 gist/공개 링크로 제공된다
**And** 아키텍처·UX·epics 문서도 동일하게 링크 제공

**Given** 커스텀 도메인 연결
**When** 배포 환경 확인
**Then** Vercel production 에 커스텀 도메인(예: `npl-market.blynn.dev`)이 연결되어 HTTPS 자동 적용 + `*.vercel.app` 와일드카드도 preview 환경에서 동작
**And** 도메인 실패 시 `*.vercel.app` 기본 URL 로 폴백 공개 (SHOULD 강등)

**Given** 카카오맵 3환경 도메인 등록
**When** 카카오 개발자 콘솔 확인
**Then** `localhost:3000`(local) · `{preview}.vercel.app`(preview 와일드카드) · `{production-domain}`(production) 세 도메인 전부 등록 완료 + 각 환경에서 지도 iframe 이 실제로 렌더된다 (Gate 4 최우선 체크)

**Given** 환경변수 3환경 분리 확인
**When** Vercel 대시보드 환경변수 설정
**Then** `SUPABASE_URL` · `SUPABASE_ANON_KEY` · `ADMIN_EMAILS` · `KAKAO_MAP_APP_KEY` 가 production/preview/local 3환경에 각각 올바른 값으로 설정되어 있고, `SUPABASE_SERVICE_ROLE_KEY` 는 server-side only 로 표시된다

**Given** 최종 배포 스모크 테스트
**When** Production URL 로 Journey 1~5 수동 스모크
**Then** 모든 Journey 가 dead-end 없이 완주되고, 계산기 프리셋 1종·Meta 토글·About mailto·지도·Placeholder 가 전부 정상 동작

**Given** Gate 4 실패 대응
**When** 커스텀 도메인 또는 카카오맵이 production 에서 실패
**Then** 즉시 `*.vercel.app` 폴백 URL 로 공개 + README 에 "도메인 연결은 SHOULD 강등, 카카오맵 실 배포 시 재등록 예정" 명시 + 포트폴리오 공유 URL 을 폴백으로 업데이트

**Given** Meta 주석 #11 최종 보존 확인
**When** 배포 직후 확인
**Then** Meta 토글 ON 시 11개(또는 축소 시 8개) 주석이 전부 렌더되고 #11("왜 교양 콘텐츠 축이 없는가")은 반드시 포함된다 (NFR20)
