---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
lastStep: 8
status: 'complete'
completedAt: '2026-04-22'
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/ux-design-specification.md
  - _bmad-output/planning-artifacts/research/market-portfolio-positioning-research-2026-04-20.md
  - _bmad-output/planning-artifacts/research/npl-calculator-logic-v3.1.gs
  - _bmad-output/brainstorming/brainstorming-session-2026-04-20-1410.md
workflowType: 'architecture'
project_name: 'NPL 마켓'
user_name: 'blynn'
date: '2026-04-21'
projectContext:
  projectType: 'web_app + saas_b2b'
  domain: 'fintech + legaltech'
  context: 'greenfield (기존 자산 3종 재활용)'
  constraint: '4일 MVP / 1인 / 50h 버퍼 0'
  deployment: 'Vercel + Supabase 무료 티어'
  reusedAssets:
    - 'NPL 계산기 Apps Script v3.1 (검증 완료 로직)'
    - 'nodajimap (지도 표시 경험)'
    - '경매·온비드 크롤링 스크립트 (정적 스냅샷 용)'
---

# Architecture Decision Document — NPL 마켓

**Author:** blynn
**Date:** 2026-04-21

_이 문서는 단계별 협업 탐색을 통해 append-only로 구축됩니다. 각 아키텍처 결정이 함께 확정되며 추가됩니다._

## Project Context Analysis

### Requirements Overview

**Functional Requirements (PRD MUST 12 — 통합 기능 단위)**

- **인프라·인증**: Next.js 14 App Router + Supabase + Vercel 배포, 3-tier RBAC(L1/L2/L3) + 대부업체 배지, 읽기 RLS 강제, admin 하드코딩 단일 계정
- **콘텐츠·데이터**: 매물 탐색 3탭(경매 실 데이터 / 공매·신탁공매 Placeholder), 지도·리스트 뷰, Hero 랜딩(Intent Framing·Map Breath·Live Ticker·Hero Reveal), About(공고 매칭 표·겸업 범위·법적 고지)
- **Killer 기능 (계산기)**: Apps Script v3.1 로직 Next.js 포팅(양편넣기·채권최고액 Cap·질권대출 100만원 절사·배당순서·지역별 소액임차·타임존 보정), Vitest 골든 테스트 샘플 5건, 프리셋 1종 완결 + Conversational Chunking + Live Calculation Shadow + Rights Cascade + Calculator Dance
- **메타 장치**: Meta 토글 시스템(전역 상태·단축키·aside slide-in·주석 11개·Ambient Annotation·First Annotation 자동 오픈), Placeholder 라벨 표준 컴포넌트(`<PlaceholderLabel reason={...} />`), 커뮤니티 L2+ 게이팅 블러 배너
- **품질 방어선**: 접근성 필수 3요소(키보드 Tab·시맨틱 HTML·Focus/Contrast) + 보안 체크리스트(service_role 유출 0·RLS 누락 0·Storage 버킷 RLS)

**Non-Functional Requirements (아키텍처 드라이버)**

| 카테고리 | 요구사항 | 아키텍처 영향 |
|---|---|---|
| 정확성 | 샘플 5건 원 단위 일치 (절사·Cap 비트 단위, 수익률 소수점 4자리) | Vitest 골든 테스트, `date-fns-tz` Asia/Seoul 명시, 정수 연산 보장 |
| 성능 | Lighthouse Performance ≥ 80 (랜딩·계산기·리스트; 지도 제외), LCP < 2.5s / CLS < 0.1 | SSG 우선, 카카오맵·Framer Motion dynamic import, 코드 스플리팅 |
| 접근성 | Lighthouse Accessibility ≥ 90 전 페이지, WCAG 2.1 AA, 키보드 Tab 완결성 | shadcn/ui + Radix 기반, aside focus trap, 카카오맵 iframe 대체 리스트 뷰 |
| 보안 | service_role 키 클라이언트 유입 0, RLS 누락 테이블 0, Storage 버킷 RLS | `.env.example`만 공개, RLS 검증 체크리스트 CI |
| 규제 | 실명 수집 0, 채무자 이니셜·주소 동 단위, "거래"→"정보 매칭" 리프레이밍 | 카피 상수 모듈화, 데이터 마스킹 레이어, Supabase Auth 이메일만 |
| 타임존 | Vercel serverless UTC ↔ Apps Script Asia/Seoul 갭 방어 | `date-fns-tz` 핵심 의존성, 윤년·말일 검증 |
| 호환성 | Chrome/Safari/Firefox/Edge 최신, 모바일 반응형 "기본만" | Tailwind breakpoint sm/md/lg/xl, 모바일 Meta aside는 bottom sheet or 비활성(SHOULD) |

**Scale & Complexity**

- **Domain complexity**: High — fintech(NPL·배당·질권대출·대부업) × legaltech(판례·말소기준권리·당해세 배당순서). 규제 경계(대부업법·자본시장법·변호사법·개인정보보호법·신용정보법) 인식을 UI 용어·구조로 표현하는 것이 본질 요구사항.
- **Implementation complexity**: Medium — 포트폴리오 전용(실거래·결제·실명 수집 없음), 읽기 중심, 단일 테넌트. 단 계산기 정합성과 Meta 토글 시스템은 정밀 구현 요구.
- **UX complexity**: High — Meta 토글 이중 레이어(OFF SaaS ↔ ON 포트폴리오 심사), 애니메이션 오케스트레이션(Framer Motion layout/AnimatePresence), Conversational Chunking + Live Shadow, Rights Cascade 재정렬.
- **Data & traffic scale**: Low — 정적 스냅샷 JSON, 발주자 심사 수십 명 규모, Vercel + Supabase 무료 티어 충분. 트래픽 급증 대비 정적 폴백 페이지 SHOULD.

- Primary domain: `web_app + saas_b2b` (fintech × legaltech)
- Complexity level: **High (domain) / Medium (implementation) / High (UX)**
- 주요 아키텍처 컴포넌트(예상): 라우팅 레이어 · 인증·RBAC 컨텍스트 · 데이터 페칭(Server Components + Supabase) · 계산 엔진(계산기 코어) · Meta 토글 전역 상태 · 컴포넌트 라이브러리(shadcn 커스텀) · 애니메이션 오케스트레이션 · Placeholder 라벨 체계 · 정적 스냅샷 데이터 레이어 · 접근성·보안 CI 체크

### Technical Constraints & Dependencies

**Hard Constraints (협상 불가)**

- **4일 MVP · 1인 blynn · 50h 상한 · 제로 버퍼** — 모든 아키텍처 결정은 이 제약의 함수
- **공개 저장소 + 포트폴리오 전용** — 실 키 유출 금지, BMAD PRD 문서 공개
- **무료 티어 경계** — Vercel + Supabase 무료 플랜 내 안착, 트래픽 급증 시 정적 폴백 SHOULD

**Reused Assets (Greenfield + 자산 재활용)**

- NPL 계산기 Apps Script v3.1 — `_bmad-output/planning-artifacts/research/npl-calculator-logic-v3.1.gs` (검증 완료 · 김대리 승인 로직 · Next.js 포팅 원본)
- nodajimap — 지도 표시 경험 (카카오맵 SDK 경험 자산)
- 경매·온비드 크롤링 스크립트 — 2026-04-20 기준 정적 JSON 덤프 생성용 (실시간 크롤링은 미배포)

**확정된 기술 스택 (PRD·UX 선결정)**

- **Framework**: Next.js 14+ (App Router) + React 18+ + TypeScript strict
- **Backend**: Supabase (PostgreSQL + Auth + Storage + RLS, 무료 티어)
- **Map**: 카카오맵 JavaScript SDK (클라이언트 only, `dynamic import` + `ssr: false`)
- **UI**: shadcn/ui + Tailwind CSS + Radix UI primitives
- **Animation**: Framer Motion (Calculator Dance · Rights Cascade · aside slide-in)
- **Date/Time**: `date-fns-tz` (Asia/Seoul 고정)
- **Testing**: Vitest (계산기 골든 테스트 샘플 5건)
- **Analytics**: Plausible (SHOULD, 개인정보 비수집)
- **Deployment**: Vercel (PR preview + main prod) + Git integration

**External Dependencies (선행 작업 리스크)**

- 카카오 개발자 콘솔: 배포 도메인 + `*.vercel.app` 와일드카드 등록 **(Day 4 데모 지도 장애 1순위 리스크)**
- 도메인 등록 (커스텀 도메인 사용 시)
- Vercel·Supabase 프로젝트 초기 세팅

**Placeholder/Vision (MVP 미구현, Meta 주석으로 명시)**

- 본인인증(PASS), 카카오 소셜 로그인, KIS·NICE 신용평가
- 법원경매/온비드 공식 API, 실시간 크롤링 스케줄러
- Admin UI, 쓰기 RLS 정책 매트릭스 전수, multi-tenant 격리

### Cross-Cutting Concerns Identified

1. **Meta 토글 전역 상태** — 모든 페이지가 ON/OFF 구독. 전역 스토어(Context/Zustand) · 단축키(스페이스바) · 첫 주석 자동 슬라이드인 오케스트레이션 · Ambient Annotation 인디케이터 서빙. URL 파라미터 sync 여부는 결정 필요.
2. **Placeholder 라벨 체계** — 표준 컴포넌트 `<PlaceholderLabel reason={...} />`가 모든 미구현 접점에 일관 적용. dead-end 0건 신뢰 방어선.
3. **Tier/RBAC 컨텍스트** — JWT claim(`role`, `tier`) 기반 서버 컴포넌트 접근 제어 + 클라이언트 블러 처리. 읽기 RLS DB 레이어 강제. admin 단일 하드코딩.
4. **숫자·날짜 포맷팅** — Asia/Seoul 타임존 고정, 정수 연산(`Math.floor`, `Math.min` 기반 Cap), 소수점 정책. 공통 유틸 모듈화.
5. **규제 카피 상수** — "거래"→"정보 매칭", "가입 승인"→"대부업법 L2 적격성 자진 확인" 등 단어 리프레이밍을 상수 모듈로.
6. **SEO·OG 메타** — 루트 레이아웃에 Person/CreativeWork JSON-LD, OG/Twitter Card, 섹션 앵커(`/#calculator`, `/#about`).
7. **접근성·Focus 관리** — 키보드 Tab 완결성, aside focus trap, Placeholder 모달 focus 복귀, 카카오맵 iframe 대체 리스트 뷰, Color Contrast 4.5:1 Figma 사전 검증.
8. **데이터 마스킹** — 채무자 이니셜, 주소 동 단위, 사건번호 공개 한정 — 정적 스냅샷 생성 시점 1회 처리 (권장) vs 렌더 시점 반복 처리 (결정 필요).
9. **배포 도메인 의존성** — 카카오맵 도메인 등록이 Day 4 리스크 1순위. 선행 작업 + `*.vercel.app` 와일드카드 백업 + nip.io 대체 경로 확보.
10. **CI 품질 방어선** — `tsc --noEmit`, ESLint + Prettier, `.env` 스캐닝(service_role 누출 방지), RLS 누락 테이블 inventory 체크.

## Starter Template Evaluation

### Primary Technology Domain

**`web_app + saas_b2b` / fintech × legaltech** — Next.js App Router 기반 단일 URL 웹 앱. 모바일 퍼스트·네이티브·CLI 비대상.

### Starter Options Considered

| 옵션 | 결론 |
|------|------|
| `create-next-app --example with-supabase` (**공식 Vercel + Supabase**) | **✅ 선택** |
| `create-next-app@latest` bare + 수동 Supabase/shadcn init | 불필요한 수작업, 4일 제약에서 낭비 |
| `create-t3-app` (T3 Stack — Prisma + NextAuth + tRPC) | Supabase 방향과 충돌 (부적합) |
| `supa-next-starter` / Razikus `supabase-nextjs-template` 등 커뮤니티 | 결제·i18n·mobile 과잉 기능 — 스코프 오버, 제거 비용 발생 |

### Selected Starter: `create-next-app --example with-supabase`

**Rationale for Selection:**

- Vercel + Supabase 양측 공식 유지 템플릿 (`vercel/next.js/tree/canary/examples/with-supabase`)
- PRD·UX 선결정 스택(Next.js App Router + TypeScript + Tailwind + shadcn/ui + Supabase 쿠키 auth)과 1:1 일치
- Server Components 호환 Supabase 클라이언트 분리 + middleware 세션 갱신 패턴이 pre-wired — 직접 맞추면 통상 2-3시간 손실 구간을 제로로
- Next.js 16의 `AGENTS.md` 파일이 포함되어 AI 코딩 에이전트(BMAD + bmad-quick-dev)가 최신 Next.js 패턴을 따르도록 유도 — 바이브 코딩 흐름과 정렬

**Initialization Command:**

```bash
pnpm create next-app@latest --example with-supabase npl-market
cd npl-market
cp .env.example .env.local   # Supabase URL + publishable key 주입
pnpm install
pnpm dev
```

**추가 셋업 (MVP 1일차 오전):**

```bash
# shadcn/ui 신규 컴포넌트 추가 (필요 시점에)
pnpm dlx shadcn@latest add button card dialog sheet toggle tooltip

# 애니메이션 / 날짜 / 테스트
pnpm add framer-motion date-fns date-fns-tz
pnpm add -D vitest @vitest/ui @testing-library/react @testing-library/jest-dom jsdom
```

**기본 선택 (별도 지정 없을 시):**

- **Next.js 버전**: 최신 stable (16.x) — PRD "14+" 요구 충족, Turbopack dev stable, AGENTS.md 포함
- **패키지 매니저**: `pnpm` — disk-efficient, monorepo 확장성, Vercel 기본 지원

### Architectural Decisions Provided by Starter

**Language & Runtime**
- TypeScript strict 모드 · React 18/19 호환 · Node.js 18+ 런타임
- Next.js 최신 stable (Turbopack dev 서버 stable, App Router 전용 async request APIs + 신 캐싱 기본값)

**Styling Solution**
- Tailwind CSS + PostCSS · `theme.extend`가 디자인 토큰 지점
- shadcn/ui `components.json` 초기화 완료 — 컴포넌트별 copy-paste 추가 방식
- Radix UI primitives 기반 접근성 (Lighthouse Accessibility ≥ 90 역산 없이 달성 가능 조건)

**Build Tooling**
- Turbopack dev server (cold start 10x, HMR ms 수준 — 4일 피드백 루프에 중요)
- Webpack production build (기본)
- Code splitting · tree shaking · Next.js `<Image>` · `next/font` 폰트 최적화

**Testing Framework**
- **Vitest 직접 추가** (Starter 미포함) — 계산기 골든 테스트 샘플 5건 전용. `vitest.config.ts` 루트 생성
- E2E 미구현 (Vision)

**Code Organization**
- App Router 구조: `app/`(라우트 + layout) · `components/`(UI 재사용) · `utils/supabase/`(클라이언트 분리) · `lib/`(공통 로직) · `public/`(정적 자산)
- Supabase 3-way 클라이언트: `server.ts` (Server Components / Route Handlers) · `client.ts` (Client Components) · `middleware.ts` (세션 갱신)
- 환경 변수: `.env.example` 공개용 + `.env.local` 개발용 (공개 저장소 기준 `.gitignore` 방어)

**Development Experience**
- `pnpm dev` (Turbopack) · `pnpm build` · `pnpm start` · `pnpm lint`
- Vercel Git Integration — PR → Preview URL, main → Production 자동 배포
- shadcn CLI `--dry-run` · `--diff` 로 컴포넌트 추가 전 변경 미리보기

**Note:** 프로젝트 초기화(이 명령 실행 + `.env` 주입 + 카카오 개발자 콘솔 도메인 등록)는 구현 첫 Story이자 **Day 1 오전 Gate**로 운영. 카카오맵 도메인 등록 실패는 Day 4 데모 장애 1순위 리스크이므로 로컬·Preview·Production 도메인을 이 시점에 전부 등록.

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**

- Data 스키마 · Validation 전략 (D1.2, D1.3)
- Auth 방식 · Tier 저장 · admin 하드코딩 · RLS 정책 (D2.1-D2.4)
- 데이터 페칭 패턴 · 계산기 실행 위치 (D3.1, D3.2)
- Meta 토글 전역 상태 · 폼 상태 (D4.1, D4.2)

**Important Decisions (Shape Architecture):**

- 정적 스냅샷 저장·마스킹 전략 (D1.1, D1.4)
- 마이그레이션 · Storage · `.env` 누출 방어 (D1.5, D2.5, D2.6)
- 라우팅·컴포넌트 조직·애니메이션 표준 (D4.3-D4.6)
- 환경 분리·도메인·모니터링·CI (D5.1-D5.4)
- Error Handling (D3.3)

**Deferred Decisions (Post-MVP):**

- RLS 쓰기 정책 매트릭스 전수 검증 (Vision)
- Sentry 에러 트래킹 (Vision)
- GitHub Actions CI workflow (4일 MVP 오버)
- 정적 HTML 트래픽 폴백 (무료 티어 한도 미도달 가정)
- 환경별 Supabase 프로젝트 분리 (Vision)

### Data Architecture

| # | 결정 | 선택 | Rationale |
|---|------|------|-----------|
| D1.1 | 정적 스냅샷 JSON 저장 위치 | **`app/data/*.json`** (코드 번들) | 빌드 타임 정적 import → SSG 최적화, CDN 캐시 무료, Supabase 조회 비용·레이턴시 제거. D-day 박제 변동 없음 |
| D1.2 | DB 스키마 테이블 | **6개 테이블**: `profiles` · `listings` · `community_posts` · `annotations` · `tier_requests` · `activity_log` | 최소 스키마. 정적 스냅샷은 파일 번들이니 DB 대상 아님 |
| D1.3 | 데이터 Validation | **Zod** (+ `@hookform/resolvers/zod`) | 단일 스키마가 타입·폼·Server Action·테스트 모두 커버. 4일 MVP 표준 |
| D1.4 | 데이터 마스킹 시점 | **빌드 스크립트 1회 처리** (`scripts/build-snapshot.ts`) | 런타임 반복 오류 취약, 원본 실수 노출 리스크 제거. 채무자 이니셜·주소 동 단위 변환을 생성 시점에 고정 |
| D1.5 | 마이그레이션 도구 | **Supabase CLI SQL 마이그레이션** (`supabase/migrations/*.sql`) | 네이티브 + 버전 관리. Prisma/Drizzle은 Supabase와 중복 |

### Authentication & Security

| # | 결정 | 선택 | Rationale |
|---|------|------|-----------|
| D2.1 | Auth 방식 | **Supabase Auth 이메일 매직링크 (단독)** | 본인인증 미연동 포트폴리오 기준 가장 간결. PRD "매직링크 기본" 일치 |
| D2.2 | Tier/Role 저장 | **`profiles` 테이블 lookup + RLS** (JWT는 `role` 단일 flag만) | admin tier 변경 즉각 반영(재로그인 불요), 시연 동선 유지 |
| D2.3 | admin 하드코딩 | **환경변수 `ADMIN_EMAILS`** + Server Component 검증 | 공개 저장소 안전, 환경별 분리 가능, RLS 무한 재귀 회피 |
| D2.4 | RLS 정책 패턴 | **전 테이블 RLS ON** · 읽기 = 공개 or tier 체크 · 쓰기 = admin only(service_role Server Action 경유) | PRD "읽기 RLS 강제" 준수, 쓰기 매트릭스 전수 검증은 Post-MVP SHOULD |
| D2.5 | Storage 버킷 | **단일 공개 버킷 `public-assets/`** (RLS ON + anon read 정책) | 권리분석 리포트·OG 이미지만. 비공개 업로드 없음 |
| D2.6 | `.env` 누출 방어 | **`.env.example` + `.gitignore` + `lint-staged` pre-commit grep** | 실제 `service_role` 키 변수명 grep으로 커밋 시점 차단 |

### API & Communication Patterns

| # | 결정 | 선택 | Rationale |
|---|------|------|-----------|
| D3.1 | 데이터 페칭 | **Server Components 직접 Supabase 쿼리** (기본) + **Server Actions** (변경) | App Router 네이티브, Starter 방향 일치, 불필요한 API 간접층 제거 |
| D3.2 | 계산기 실행 위치 | **클라이언트 사이드 순수 함수** (`lib/calculator/*.ts`) + Vitest 노드 환경 골든 테스트 | Live Calculation Shadow 즉각 반응, 서버 왕복 불필요, 포팅 원본(Apps Script)도 클라이언트 성격 |
| D3.3 | Error Handling | **App Router `error.tsx` boundary + shadcn `sonner` toast** | 구역별 boundary → 전역 크래시 방지, toast 비파괴 UX |

### Frontend Architecture

| # | 결정 | 선택 | Rationale |
|---|------|------|-----------|
| D4.1 | Meta 토글 전역 상태 | **Zustand + URL 파라미터(`?meta=1`) + `localStorage` persistence** | Context 재렌더 회피 + 딥링크 공유 + 재방문 유지. Zustand SSR hydration 패턴 검증됨 |
| D4.2 | 계산기 폼 상태 | **React Hook Form + Zod resolver** | 15필드 Conversational Chunking의 dirty/error 추적 표준. Zod 스키마 타입 단일 출처 |
| D4.3 | 라우팅 전략 | **루트 `/` 단일 페이지 + 섹션 앵커** (`/#calculator`, `/#about`, `/#community`) + 서브 경로: `/auction/[caseNumber]`, `/profile/tier-request`, `/admin` | UX Spec 확정, 세로 스크롤 내러티브, 링크드인 DM 앵커 공유 |
| D4.4 | 컴포넌트 조직 | **기능별(`features/`) + 공용(`components/ui`, `components/meta`, `components/placeholder`)** | Cross-cutting(Meta·Placeholder)은 공용, 도메인 기능은 feature 폴더. 4일 MVP 규모에 적정 |
| D4.5 | Meta 주석 서빙 | **`data/annotations.ts` TypeScript 모듈 + id 기반** (`<MetaAnnotation id="rls-reason" />`) | 타입 안전 + grep 가능 + 번들 내 즉시 접근 |
| D4.6 | 애니메이션 표준 | **Framer Motion `layout` prop (Rights Cascade) + `AnimatePresence` (aside slide-in) + dynamic import** | UX Spec 확정 패턴. `prefers-reduced-motion` 존중 |

### Infrastructure & Deployment

| # | 결정 | 선택 | Rationale |
|---|------|------|-----------|
| D5.1 | 환경 분리 | **3단계**: `local`(.env.local) · `preview`(Vercel env) · `production`(Vercel env). Supabase 프로젝트는 단일 | 무료 티어 1개 한도 + 관리 비용 최소화. admin_emails는 환경별 다름 |
| D5.2 | 도메인 | **커스텀 도메인** + `*.vercel.app` preview 와일드카드 (카카오 개발자 콘솔 전부 등록) | 발주자 링크 신뢰도 + SEO OG 프리뷰 품질 |
| D5.3 | 모니터링·분석 | **Plausible (SHOULD)** — 개인정보 비수집. Vercel Analytics·Sentry 미도입 | Meta 토글 전환율 측정 목적. Sentry는 MVP 오버 |
| D5.4 | CI/CD | **Vercel Git Integration (자동) + GitHub Actions 미추가** | `tsc --noEmit` · Vitest · ESLint는 로컬 `pnpm build` 사전 검증. 4일 오버 회피 |
| D5.5 | 트래픽 폴백 | **정적 HTML 폴백 미구현 (MVP)** — Post-MVP SHOULD | 발주자 수십 명 트래픽 규모에 과함 |

### Decision Impact Analysis

**Implementation Sequence (구현 순서)**

1. **Day 1 오전**: D5.1 환경 분리 + Starter init + D2.1 Auth + D1.2 스키마 + D2.4 RLS 기본 정책
2. **Day 1 오후**: D1.1 정적 스냅샷 → D1.4 마스킹 스크립트 → 매물 3탭 (D3.1 Server Components 직접 쿼리)
3. **Day 2**: D3.2 계산기 순수 함수 포팅 → Vitest 골든 테스트 → D4.2 React Hook Form + Zod → 프리셋·애니메이션
4. **Day 3**: D4.1 Meta 토글 Zustand + URL param → D4.5 annotations.ts → Placeholder 체계 → 커뮤니티
5. **Day 4**: About + 접근성 + 배포 + D5.2 도메인 + D5.3 Plausible

**Cross-Component Dependencies (결정 상호 의존)**

- **D1.2(스키마) ↔ D2.4(RLS)**: 테이블 생성과 RLS 정책은 동일 마이그레이션 파일로 원자적 커밋 (RLS 누락 0건 보장)
- **D4.1(Meta 토글) ↔ D4.5(annotations.ts)**: Zustand `activeAnnotationId`가 `annotations.ts` id와 일치 — 타입 공유 필수
- **D3.2(계산기) ↔ D1.3(Zod)**: 계산기 입력 스키마를 Zod로 단일 정의 → 폼·테스트·타입 일원화
- **D2.3(admin env) ↔ D5.1(환경 분리)**: admin_emails는 환경별 다름 (preview 테스트 계정 등)
- **D3.2(계산기 클라이언트) ↔ D4.6(애니메이션)**: 계산 결과 변경 → Framer Motion `layout` prop으로 자동 재정렬 애니메이션
- **D1.1(`app/data/*.json`) ↔ D1.4(마스킹)**: 빌드 스크립트가 원본 크롤링 JSON → 마스킹 적용 → `app/data/listings.json` 생성

## Implementation Patterns & Consistency Rules

### Pattern Categories Defined

**9개 영역의 Critical Conflict Points 식별 및 규칙 확정**: Naming · Project Structure · Data Format · State Updates · Error Handling · Loading · **Domain-Specific (8종)** · Testing · AI Agent Enforcement.

### Naming Patterns

**Database (Postgres · Supabase) — `snake_case`**

- 테이블: 복수형 `profiles`, `listings`, `community_posts`, `tier_requests`, `annotations`, `activity_log`
- 컬럼: `user_id`, `created_at`, `tier_level`, `case_number`
- FK: `<table>_id` — 예: `author_id references profiles(id)`
- Index: `idx_<table>_<columns>` — 예: `idx_listings_case_number`
- RLS 정책: `<table>_<operation>_<role>` — 예: `listings_select_anon`, `tier_requests_update_admin`

**TypeScript / React — Next.js 관례**

- 커스텀 컴포넌트: `PascalCase` 파일 + 컴포넌트명 → `components/meta/MetaToggle.tsx`, `components/placeholder/PlaceholderLabel.tsx`
- shadcn 자동 생성본(`components/ui/button.tsx`)은 lowercase 유지 (CLI 관례 — 수정 금지)
- 훅: `use<Name>` camelCase → `useMetaStore`, `useTierGate`
- 유틸 함수: camelCase → `formatWon`, `toSeoulDate`, `calculateDividend`
- 상수: `SCREAMING_SNAKE_CASE` → `MAX_BOND_CAP`, `REGIONAL_DEPOSIT_LIMITS`
- 타입: `PascalCase` → `Listing`, `TierLevel`, `CalculatorInput`

**Routes (Next.js App Router)**

- 폴더: `kebab-case` → `app/tier-request/`
- 동적 세그먼트: `camelCase` → `app/auction/[caseNumber]/page.tsx`
- 앵커 fragment: `kebab-case` → `#calculator`, `#about`, `#community`

**Env Vars — `SCREAMING_SNAKE_CASE`**

- Public: `NEXT_PUBLIC_*` 접두사 필수 (Next.js 규칙)
- Server-only: `SUPABASE_SERVICE_ROLE_KEY`, `ADMIN_EMAILS`
- **NEVER** expose `SUPABASE_SERVICE_ROLE_KEY` to any client code path

### Project Structure Patterns

```
npl-market/
├── app/                         # Next.js App Router (routes + layouts)
│   ├── (root)/                  # 루트 페이지 그룹 (단일 URL)
│   │   └── page.tsx             # 랜딩 + 섹션 앵커
│   ├── auction/[caseNumber]/    # 매물 상세
│   ├── profile/tier-request/    # L1→L2 승격 요청
│   ├── admin/                   # admin 하드코딩 가드
│   ├── data/                    # ★ 정적 스냅샷 JSON (D1.1)
│   │   ├── listings.json
│   │   └── community-posts.json
│   ├── layout.tsx               # 루트 레이아웃 + OG/JSON-LD
│   ├── error.tsx                # 전역 에러 boundary
│   └── loading.tsx              # 전역 Suspense fallback
├── features/                    # ★ 기능별 컴포넌트 (D4.4)
│   ├── calculator/
│   ├── landing-hero/
│   ├── community/
│   ├── listings/
│   └── about/
├── components/                  # ★ 공용 컴포넌트
│   ├── ui/                      # shadcn 자동 생성 (수동 수정 금지)
│   ├── meta/                    # MetaToggle / MetaAnnotation / AmbientAnnotationMark
│   └── placeholder/             # PlaceholderLabel
├── lib/                         # ★ 순수 로직 (부작용 없음)
│   ├── calculator/              # Apps Script 포팅 + 순수 함수 + co-located Vitest
│   ├── format/                  # currency.ts / date.ts
│   ├── copy/regulatory.ts       # ★ 모든 규제 리프레이밍 상수
│   ├── tier/                    # gate.ts / types.ts
│   └── data/annotations.ts      # Meta 주석 11개 id 기반
├── stores/
│   └── meta-store.ts            # Zustand + persist
├── utils/supabase/              # Starter 기본 (수정 금지)
├── supabase/migrations/         # ★ SQL 마이그레이션 (D1.5)
├── scripts/
│   └── build-snapshot.ts        # 크롤링 JSON → 마스킹 → app/data/
├── public/og/                   # OG 이미지
├── AGENTS.md                    # Next.js 16 코딩 에이전트 가이드
├── CLAUDE.md                    # ★ 이 프로젝트의 Claude Code 규칙
└── middleware.ts                # Supabase 세션 갱신
```

**원칙:**
- 테스트는 **co-located** (`dividend.ts` 옆 `dividend.test.ts`) — 4일 MVP 내 계산기만 해당
- `components/ui/*` (shadcn 생성본) 직접 수정 금지 — 커스텀은 `components/meta/` 또는 `features/` 하위 래핑
- `utils/supabase/*` (Starter 생성본) 수정 금지 — 확장은 별도 폴더
- `app/api/`는 webhook 등 특수 용도만. 기본 데이터 페칭은 Server Components 직접 쿼리(D3.1)

### Data Format Patterns

**DB ↔ App 경계 — 원칙: 변환 최소화 = snake_case 유지**

- Supabase 쿼리 반환값 그대로 사용. 변환 레이어 없음 (4일 MVP 시간 절약 + 타입 일치)
- **예외**: React props는 camelCase — DB row를 props로 넘길 때 at-the-boundary에서 한 번만 변환 (`const { created_at: createdAt } = row`)
- `generated.types.ts` (Supabase CLI 생성): snake_case 그대로 유지

**날짜 / 시간**

- **저장**: ISO 8601 UTC (Postgres `timestamptz`) → `'2026-04-21T05:00:00.000Z'`
- **연산**: `date-fns-tz` + `Asia/Seoul` 명시 — `zonedTimeToUtc`, `utcToZonedTime`
- **표시**: `ko-KR` locale + "YYYY.MM.DD" 또는 "2026년 4월 21일"
- ⛔ **금지**: `new Date()` 직접 사용 (`lib/format/date.ts` 외부에서는 금지) — Vercel UTC 사고 방어
- ⛔ **금지**: `toLocaleDateString()` 직접 사용 → `formatSeoulDate(date, variant)` 유틸 경유

**금액**

- **저장**: integer (원 단위). 소수점 금지
- **표시**: `formatWon(amount, variant: 'short' | 'full')` 단일 유틸 경유
  - short: `"24.5억"` — 10억 이상 `X.X억`, 1억 이상 `X.X천`, 기타 `X만`
  - full: `"1,720,857,880원"` — `toLocaleString('ko-KR')`
- 수익률: 소수점 4자리 일치, `%` 접미사는 표시 시점에만

**Boolean · Null**

- DB: `NOT NULL` 기본값 권장, nullable은 명시적 의도만
- TS 경계: `null` → `undefined` 변환 금지. `null` 그대로 허용하고 `x ?? default` 패턴
- JSON serialization: API 응답은 `null` 명시 (`undefined`는 필드 누락)

**JSON 파일 (`app/data/*.json`)**

- 구조: snake_case (DB 일치)
- 한국어 key 금지: `"사건번호"` ❌ → `"case_number"` ✅
- 마스킹 필드는 suffix: `debtor_initial`, `address_district`

### State Management Patterns

**Zustand (D4.1 Meta Store)**

- Store 파일당 1개 도메인 — `stores/meta-store.ts`, `stores/calculator-ui-store.ts` (필요 시)
- Immutable 업데이트: `set((state) => ({ ...state, key: value }))` — Immer 미사용 (4일 제약)
- Action 이름: 동사 + 대상 (`toggleMeta`, `setActiveAnnotation`, `resetCalculator`)
- Selector 사용: `useMetaStore((s) => s.isOn)` — 객체 구조분해 금지 (불필요 재렌더)
- Persist: `zustand/middleware`의 `persist` + `localStorage` 키 prefix `npl-market:*`
- SSR 안전 패턴: `createStore` + Context Provider (`stores/provider.tsx`) — App Router 공식 권장

**React Hook Form + Zod (D4.2 계산기 폼)**

- Schema 위치: `lib/calculator/schema.ts` — Zod가 타입 단일 출처
- Resolver: `zodResolver(CalculatorInputSchema)`
- Validation timing: `mode: 'onBlur'` + submit 시 재검증
- 필드 이름: schema key와 일치 (snake_case) — 타입 안전

**Server Components 데이터 페칭 (D3.1)**

- 페이지 단위 `async` 함수 내 Supabase 쿼리 직접 실행
- 결과를 Client 컴포넌트 prop으로 내려보냄 (serialize 가능한 형태 유지)
- Suspense boundary는 `loading.tsx`로 자동 처리

### Error Handling Patterns

**Server Components / Server Actions**

- Server Component 내 에러 → `throw` → 가장 가까운 `error.tsx` boundary가 수신
- Server Action 반환 타입: `{ data: T } | { error: string }` discriminated union
- ⛔ **금지**: Server Action에서 `throw` (직렬화 실패 + 사용자 원인 미전달)

**Client Components**

- 사용자 에러: `sonner` toast — `toast.error("요청을 처리하지 못했습니다. 다시 시도해주세요.")`
- 개발자 에러: `console.error` (production 유지 — 포트폴리오 공개 저장소 맥락)
- 네트워크 타임아웃·재시도: MVP 미구현 (Post-MVP)

**사용자 문구 규칙**

- 친절함 > 기술 상세. "500 Internal Error" ❌ → "잠시 후 다시 시도해주세요" ✅
- 규제 카피 상수 경유 — `regulatory.errors.*` 참조

### Loading State Patterns

- Server Components → `loading.tsx` + Suspense
- Client Components → `<Skeleton>` (shadcn). inline loading state 금지
- 계산기 Live Calculation Shadow → `isCalculating` 로컬 상태 + `<span className="opacity-50">`
- 지도 페이지: 카카오맵 SDK `dynamic(() => ..., { loading: () => <MapSkeleton /> })`

### Domain-Specific Patterns (NPL 마켓 고유) ★

**1. Meta 주석 참조 — id 기반만 허용**

- ✅ `<MetaAnnotation id="rls-reason" />` — `lib/data/annotations.ts`에서 id로 조회
- ❌ `<MetaAnnotation>인라인 텍스트</MetaAnnotation>` — 주석 11개 중앙 관리 위반
- 신규 주석: `annotations.ts`에 id 추가 → 컴포넌트에서 참조

**2. Placeholder 라벨 — 표준 컴포넌트만 허용**

- ✅ `<PlaceholderLabel reason="admin UI는 2주 공수, 범위 밖" />`
- ❌ `<span>(데모용)</span>` · `<Badge>준비 중</Badge>` — 표준화 위반
- 카피·스타일 일관성이 신뢰 방어선 → 절대 우회 금지

**3. 규제 리프레이밍 카피 — 상수 경유**

- ✅ `t.listingAction` → `"정보 매칭 요청"`
- ❌ 컴포넌트에 `"거래하기"` 직접 하드코딩
- 상수 위치: `lib/copy/regulatory.ts`
- Meta 주석 #6, #11은 상수 변경 이유 설명

**4. 날짜 계산 — `date-fns-tz` 경유 필수**

- ✅ `formatSeoulDate(row.created_at, 'YYYY.MM.DD')`
- ❌ `new Date(row.created_at).toLocaleDateString()` — 타임존 사고
- 공통 유틸: `lib/format/date.ts`에서만 `new Date()` 허용

**5. 금액 포맷팅 — `formatWon` 경유 필수**

- ✅ `formatWon(1720857880, 'short')` → `"17.2억"`
- ❌ `amount.toLocaleString()` 직접 사용 — 포맷 분산
- 계산기 숫자도 동일: 원 단위 integer 저장 → 표시 시점 변환만

**6. Tier 가드 — 표준 패턴**

- Server Component: `const tier = await getTier()` + 조건 분기
- Client Component: `<TierGate require="L2+" fallback={<BlurBanner />}>` 표준 컴포넌트
- ⛔ **금지**: RLS만 의존하고 클라이언트 블러 생략 — UX Spec의 블러 배너가 L2 동기화 장치

**7. 계산기 순수 함수 — 부작용 절대 금지**

- `lib/calculator/*.ts` 모든 함수는 순수 (I/O·console·`Date.now`·`Math.random` 금지)
- Vitest 테스트 가능성 보장 = 골든 테스트 5건 원 단위 일치 방어선
- 입력 Date는 파라미터 주입 (`calculate(input: CalculatorInput, evaluationDate: Date)`)

**8. 애니메이션 — `prefers-reduced-motion` 옵트인**

- 모든 Framer Motion 사용처: `useReducedMotion()` 훅으로 체크 → true면 `transition={{ duration: 0 }}`
- Calculator Dance · Rights Cascade · aside slide-in 모두 적용
- Lighthouse ≥ 90 접근성 요구의 일부

### Testing Patterns

- **MVP 범위 = 계산기 골든 테스트만** (Vitest)
- 테스트 파일: co-located `*.test.ts`
- 샘플 5건: `lib/calculator/__fixtures__/sample-01-cap.ts` 등 fixture 파일 분리
- 정합성 기준: **원 단위 완전 일치** (절사·Cap 비트 단위, 수익률 소수점 4자리)
- E2E·Visual Regression — Vision

### AI Agent Enforcement

**All AI Agents MUST:**

- `lib/format/date.ts` · `lib/format/currency.ts` 외부에서 `new Date()` · `.toLocaleString()` 사용 금지 (grep 검증 가능)
- 모든 미구현 접점은 `<PlaceholderLabel>` 사용 (다른 표현 금지)
- 모든 Meta 주석은 `<MetaAnnotation id="...">` 사용 (인라인 텍스트 금지)
- 규제 카피(거래·가입 등 민감 단어)는 `lib/copy/regulatory.ts` 경유
- Zustand selector는 함수형(`(s) => s.key`), 객체 구조분해 금지
- `utils/supabase/*` · `components/ui/*` (shadcn) 파일 수정 금지 — 확장은 별도 폴더 래핑
- 계산기 `lib/calculator/*`는 순수 함수 (부작용 금지)

**Pattern Enforcement 방법:**

- `CLAUDE.md` 프로젝트 루트에 배치 (Claude Code 세션마다 자동 로드)
- `AGENTS.md` (Next.js 16 기본 생성)에 중복 반영 — 다른 AI 코딩 툴 호환
- ESLint custom rule: `no-restricted-syntax`로 `new Date()` 직접 호출 차단
- `tsc --noEmit` + Vitest를 `pnpm build` pre-hook에 포함
- `lint-staged` pre-commit: `SUPABASE_SERVICE_ROLE_KEY` 문자열 grep → 발견 시 차단

### Pattern Examples

**Good — 규제 카피 경유:**

```tsx
import { regulatoryCopy as t } from '@/lib/copy/regulatory'

<Button>{t.listingAction}</Button>  // "정보 매칭 요청"
<MetaAnnotation id="regulatory-reframe" />
```

**Anti-Pattern — 하드코딩:**

```tsx
<Button>거래하기</Button>  // ❌ 대부업법 회색지대 카피 누수
```

**Good — 날짜 유틸 경유:**

```ts
import { formatSeoulDate } from '@/lib/format/date'
const display = formatSeoulDate(listing.created_at, 'YYYY.MM.DD')
```

**Anti-Pattern — 직접 Date:**

```ts
const display = new Date(listing.created_at).toLocaleDateString()  // ❌ UTC 사고
```

**Good — Zustand selector:**

```tsx
const isMetaOn = useMetaStore((s) => s.isOn)  // ✅ 필요한 것만 구독
```

**Anti-Pattern — 객체 구조분해:**

```tsx
const { isOn, toggle, active } = useMetaStore()  // ❌ 모든 변경에 재렌더
```

**Good — Placeholder 표준:**

```tsx
<PlaceholderLabel reason="admin UI는 Vision — Meta 주석 참조" />
```

**Anti-Pattern — 인라인:**

```tsx
<span className="text-muted">(데모용)</span>  // ❌ 카피·스타일 분산
```

## Project Structure & Boundaries

### Complete Project Directory Structure

```
npl-market/
├── README.md                             # 발주자 시선 3문단 (PRD 섹션 참조)
├── AGENTS.md                             # Next.js 16 기본 생성 (AI 코딩 가이드)
├── CLAUDE.md                             # ★ 이 프로젝트 Claude Code 규칙 (패턴 요약)
├── package.json                          # pnpm + scripts
├── pnpm-lock.yaml
├── tsconfig.json                         # strict mode
├── next.config.ts                        # 카카오맵 도메인 · 이미지 호스트 화이트리스트
├── tailwind.config.ts                    # theme.extend (빌사남 톤 토큰)
├── postcss.config.mjs
├── vitest.config.ts                      # 계산기 골든 테스트 루트 설정
├── components.json                       # shadcn/ui 초기화
├── .env.example                          # ★ 공개 · 변수 목록 템플릿
├── .env.local                            # gitignored
├── .gitignore
├── .eslintrc.json                        # no-restricted-syntax (new Date 금지)
├── .prettierrc
├── .lintstagedrc.json                    # pre-commit: service_role grep
├── middleware.ts                         # Supabase 세션 갱신 (Starter 기본)
│
├── app/                                  # Next.js App Router
│   ├── layout.tsx                        # 루트 layout + OG/JSON-LD + fonts
│   ├── page.tsx                          # 랜딩 (Hero → 계산기 → About → Community → Contact)
│   ├── globals.css                       # Tailwind + design tokens + focus-visible
│   ├── error.tsx                         # 전역 error boundary
│   ├── loading.tsx                       # 전역 Suspense fallback
│   ├── not-found.tsx                     # 404
│   ├── auction/[caseNumber]/page.tsx     # 매물 상세 (Server Component + Supabase/JSON)
│   ├── profile/tier-request/page.tsx     # L1→L2 승격 요청 (Server Action)
│   ├── admin/
│   │   ├── layout.tsx                    # admin guard (ADMIN_EMAILS env 체크)
│   │   └── page.tsx                      # 최소 UI — tier 승격 수동 처리
│   ├── api/                              # 기본 비사용. 예외만
│   │   └── og/                           # (SHOULD) 동적 OG 이미지
│   └── data/                             # ★ 정적 스냅샷 (D1.1)
│       ├── listings.json                 # 마스킹 후 매물 (빌드 스크립트 생성)
│       ├── listings.schema.ts            # Zod 런타임 검증 (선택)
│       └── community-posts.json          # 샘플 글 5건 (수동 작성)
│
├── features/                             # ★ 기능별 컴포넌트 (D4.4)
│   ├── landing-hero/
│   │   ├── IntentFramingStrip.tsx
│   │   ├── MapBreathBackground.tsx       # CSS 애니메이션 중심
│   │   ├── LiveTicker.tsx                # CSS 루프 ticker
│   │   └── HeroRevealReport.tsx          # 권리분석 리포트 Full Writeup
│   ├── listings/
│   │   ├── ListingsTabs.tsx              # 3탭 (경매/공매/신탁공매)
│   │   ├── ListingCard.tsx
│   │   ├── ListingsMap.tsx               # 카카오맵 dynamic import
│   │   ├── ListingsMapSkeleton.tsx
│   │   ├── TierBlurOverlay.tsx           # tier별 블러 처리
│   │   └── index.ts
│   ├── calculator/                       # ★ Killer 기능
│   │   ├── CalculatorSection.tsx
│   │   ├── CalculatorForm.tsx            # React Hook Form + Zod
│   │   ├── CalculatorStepChunk.tsx       # Conversational Chunking step
│   │   ├── CalculatorPreset.tsx          # 프리셋 3종 (1종 실동, 2종 Placeholder)
│   │   ├── LiveCalculationShadow.tsx     # 실시간 미리보기
│   │   ├── RightsCascade.tsx             # Framer Motion layout prop
│   │   ├── CalculatorDance.tsx           # 출력 25필드 Framer Motion
│   │   ├── CalculatorResult.tsx          # 수익률 결과 카드
│   │   └── index.ts
│   ├── community/
│   │   ├── CommunityTabs.tsx             # 자유수다방·경매방·Q&A
│   │   ├── CommunityPostList.tsx
│   │   ├── CommunityPostCard.tsx
│   │   ├── L2GatingBanner.tsx            # 블러 배너 + Meta 주석 #5
│   │   └── index.ts
│   ├── about/
│   │   ├── AboutSection.tsx
│   │   ├── PostingMatchTable.tsx         # 공고 매칭 표 (핵심)
│   │   ├── EngagementRange.tsx           # 겸업/전업 범위
│   │   ├── LegalNotice.tsx               # 법적 고지 인라인
│   │   └── ContactCTA.tsx                # mailto 자동 핸들러
│   └── lender-form/                      # 대부업체 매물 등록 폼 (MUST #7)
│       └── LenderListingForm.tsx         # 10개 필드 + Server Action
│
├── components/                           # ★ 공용 컴포넌트
│   ├── ui/                               # shadcn/ui 자동 생성 (수정 금지)
│   │   └── (button, card, dialog, sheet, toggle, tooltip, skeleton, badge, sonner, ...)
│   ├── meta/                             # Meta 토글 시스템
│   │   ├── MetaToggle.tsx                # 우상단 토글 + 스페이스바
│   │   ├── MetaProvider.tsx              # Zustand + URL sync + 첫 주석 자동 슬라이드인
│   │   ├── MetaAnnotation.tsx            # id 기반 주석 컴포넌트
│   │   ├── MetaAnnotationAside.tsx       # aside slide-in (focus trap)
│   │   └── AmbientAnnotationMark.tsx     # · / "왜?" 인디케이터
│   ├── placeholder/
│   │   └── PlaceholderLabel.tsx          # 표준 컴포넌트 (reason prop 필수)
│   ├── tier/
│   │   ├── TierGate.tsx                  # require / fallback 표준 가드
│   │   └── TierBadge.tsx                 # L1/L2/L3/🏢대부업체/Admin 배지
│   ├── layout/
│   │   ├── RootLayoutProviders.tsx       # MetaProvider + SonnerToaster
│   │   ├── SectionAnchor.tsx             # #calculator 등 앵커 타깃
│   │   └── SkipNav.tsx                   # 접근성 Skip to content
│   └── seo/
│       ├── JsonLd.tsx                    # Person + CreativeWork
│       └── OgTags.tsx                    # OG + Twitter Card
│
├── lib/                                  # ★ 순수 로직 (부작용 없음)
│   ├── calculator/                       # Apps Script v3.1 포팅
│   │   ├── dividend.ts                   # 배당·수익률 메인 함수
│   │   ├── dividend.test.ts              # co-located Vitest
│   │   ├── rights-cascade.ts
│   │   ├── rights-cascade.test.ts
│   │   ├── regional-deposit.ts           # 지역별 소액임차 한도
│   │   ├── bond-cap.ts                   # 채권최고액 Cap + 100만원 절사
│   │   ├── yangpyeon.ts                  # 양편넣기 +1일
│   │   ├── schema.ts                     # Zod CalculatorInput
│   │   ├── presets.ts                    # 프리셋 3종 입력값
│   │   ├── __fixtures__/
│   │   │   ├── sample-01-cap.ts          # 채권최고액 Cap 케이스
│   │   │   ├── sample-02-pledge-floor.ts # 100만원 절사 경계
│   │   │   ├── sample-03-local-tax.ts    # 당해세 개입
│   │   │   ├── sample-04-leap-year.ts    # 윤년
│   │   │   └── sample-05-simple.ts       # 단순 케이스
│   │   └── index.ts
│   ├── format/
│   │   ├── currency.ts                   # formatWon(amount, variant)
│   │   ├── currency.test.ts              # (SHOULD) 포맷 엣지
│   │   └── date.ts                       # toSeoulDate / formatSeoulDate / toISOKST
│   ├── copy/
│   │   └── regulatory.ts                 # ★ 모든 규제 리프레이밍 상수 (단일 소스)
│   ├── tier/
│   │   ├── gate.ts                       # getTier / requireTier (Server)
│   │   ├── admin-check.ts                # ADMIN_EMAILS env 검증
│   │   └── types.ts                      # TierLevel 정의
│   ├── supabase/                         # ★ Starter utils/ 확장
│   │   ├── queries.ts                    # 공용 쿼리 헬퍼 (tier 필터)
│   │   └── rls-checklist.ts              # (SHOULD) 런타임 RLS 정책 검증
│   └── data/
│       ├── annotations.ts                # ★ Meta 주석 11개 id 기반 (D4.5)
│       └── kakao-map-loader.ts           # SDK dynamic import + 도메인 가드
│
├── stores/                               # Zustand
│   ├── meta-store.ts                     # D4.1 Meta 토글 + URL sync + persist
│   └── provider.tsx                      # SSR 안전 패턴 (createStore + Context)
│
├── utils/supabase/                       # Starter 기본 (수정 금지)
│   ├── server.ts                         # createServerClient (Server Components)
│   ├── client.ts                         # createBrowserClient (Client Components)
│   └── middleware.ts                     # 세션 갱신 헬퍼
│
├── supabase/
│   ├── config.toml                       # Supabase CLI 설정
│   └── migrations/                       # ★ D1.5
│       └── 0001_init_schema.sql          # 6개 테이블 + FK + index + RLS 원자적
│
├── scripts/
│   ├── build-snapshot.ts                 # 크롤링 JSON → 마스킹 → app/data/listings.json
│   ├── verify-env.ts                     # .env.local 필수 변수 존재 체크
│   └── lighthouse-local.sh               # 로컬 Lighthouse 측정
│
├── public/
│   ├── favicon.ico
│   ├── robots.txt
│   ├── sitemap.xml
│   └── og/
│       ├── og-default.png                # 1200×630
│       └── og-calculator.png
│
└── types/
    └── generated.ts                      # Supabase CLI 생성 DB 타입 (snake_case 유지)
```

### Architectural Boundaries

**API Boundaries**

- **외부 API 경계**: 거의 없음 (정적 스냅샷 + Supabase SDK만)
  - 카카오맵 JS SDK (클라이언트 로드, 도메인 등록 기반)
  - Supabase Auth + Postgres + Storage (SDK 경유)
- **내부 API 경계**: `app/api/*` 최소 사용. 기본은 Server Components 직접 쿼리(D3.1). 예외는 동적 OG 이미지(SHOULD) · webhook
- **Server Action 경계**: `app/*/actions.ts` 또는 feature 내부. 반환 타입 `{ data } | { error }` 통일(D3.3)

**Component Boundaries**

- **Server / Client 경계**: 파일 상단 `'use client'` 명시. 데이터 페칭은 Server, 상호작용은 Client
- **features/ vs components/**: features = 도메인 기능(로컬 상태·페이지 특화) · components = 범용 재사용(ui/meta/placeholder/tier/layout/seo)
- **shadcn vs 커스텀**: shadcn primitive는 직접 수정 금지 → 래퍼는 `components/meta/`·`components/tier/` 등에
- **Cross-Cutting**: `<MetaAnnotation>`, `<PlaceholderLabel>`, `<TierGate>` 는 어느 feature에서든 import 가능

**Service Boundaries**

- **계산 엔진**: `lib/calculator/*` 순수 함수 격리. UI·Supabase 의존 0
- **포맷팅 엔진**: `lib/format/*` 순수. `new Date()` 독점 지점
- **카피 상수**: `lib/copy/regulatory.ts` 단일 소스
- **Tier 가드**: `lib/tier/*` Server 측 권한 + `components/tier/TierGate` Client 측 UX

**Data Boundaries**

- **정적 스냅샷 (`app/data/*.json`)**: 빌드 타임 import — 런타임 fetch 없음. `scripts/build-snapshot.ts`가 마스킹 처리
- **Supabase Postgres**: 6개 테이블 · RLS ON 강제
- **Supabase Storage**: `public-assets/` 단일 버킷, anon read 허용
- **LocalStorage (클라이언트)**: `npl-market:meta-store` prefix — Meta 토글 상태만
- **URL State (`?meta=1`)**: Meta 토글 딥링크 공유 전용

### Requirements to Structure Mapping

**PRD MUST 12 → 디렉토리 매핑**

| # | MUST 기능 | 주요 위치 | 보조 위치 |
|---|-----------|-----------|-----------|
| 1 | 골격 & 배포 | `next.config.ts` · `middleware.ts` · Starter 전체 | `scripts/verify-env.ts` · Vercel 대시보드 |
| 2 | RBAC | `supabase/migrations/0001_init_schema.sql` · `lib/tier/*` · `components/tier/*` | `utils/supabase/*` (Starter) · `.env` `ADMIN_EMAILS` |
| 3 | 매물 탐색 3탭 | `features/listings/*` · `app/data/listings.json` | `scripts/build-snapshot.ts` · `<PlaceholderLabel>` |
| 4 | 계산기 코어 | `lib/calculator/*` (순수 함수) · `vitest.config.ts` | `lib/format/date.ts` · `lib/calculator/__fixtures__/*` |
| 5 | 계산기 UX | `features/calculator/*` | `lib/calculator/presets.ts` · Framer Motion dynamic |
| 6 | 랜딩 Hero | `features/landing-hero/*` · `app/page.tsx` · `app/layout.tsx`(OG) | `components/seo/JsonLd.tsx` |
| 7 | 커뮤니티 | `features/community/*` · `app/data/community-posts.json` | `components/tier/TierGate.tsx` |
| 8 | Meta 토글 시스템 | `components/meta/*` · `stores/meta-store.ts` · `lib/data/annotations.ts` | `stores/provider.tsx` · URL sync |
| 9 | Placeholder 라벨 체계 | `components/placeholder/PlaceholderLabel.tsx` | features 전역에서 import |
| 10 | About | `features/about/*` | `lib/copy/regulatory.ts` (Contact SLA 문구) |
| 11 | 접근성 & 보안 방어선 | `.eslintrc.json` · `.lintstagedrc.json` · `app/globals.css` · `components/layout/SkipNav.tsx` | `lib/supabase/rls-checklist.ts` · 수동 체크리스트 |
| 12 | 문서 & 운영 | `README.md` · `CLAUDE.md` · `AGENTS.md` · `scripts/lighthouse-local.sh` | `public/robots.txt` · `public/sitemap.xml` |

**Cross-Cutting Concerns → 위치**

| Concern | 위치 |
|---------|------|
| Meta 토글 전역 상태 | `stores/meta-store.ts` + `components/meta/MetaProvider.tsx` |
| Placeholder 라벨 | `components/placeholder/PlaceholderLabel.tsx` (유일한 진실) |
| Tier/RBAC | `lib/tier/*` (Server) + `components/tier/TierGate.tsx` (Client) + RLS (DB) |
| 숫자·날짜 포맷 | `lib/format/currency.ts` · `lib/format/date.ts` |
| 규제 카피 | `lib/copy/regulatory.ts` (단일 소스) |
| SEO/OG | `app/layout.tsx` · `components/seo/*` |
| 접근성·Focus | `components/layout/SkipNav.tsx` · `MetaAnnotationAside`(focus trap) · `app/globals.css` |
| 데이터 마스킹 | `scripts/build-snapshot.ts` (빌드 타임 1회) |
| 카카오맵 도메인 의존 | `lib/data/kakao-map-loader.ts` · Vercel env + 개발자 콘솔 |
| CI 품질 방어선 | `.eslintrc.json` · `.lintstagedrc.json` · `tsconfig.json` strict · `vitest.config.ts` |

### Integration Points

**Internal Communication**

- **Server → Client**: Server Component가 Supabase/JSON 조회 → Client Component에 prop 전달 (serializable)
- **Client → Server**: Server Actions (`'use server'`) + `{ data } | { error }` 반환
- **Client ↔ Client**: Zustand store (Meta) + React context (provider), URL 파라미터(`?meta=1`)
- **Component ↔ Component**: props 전달 기본, 전역 상태는 Meta에만 한정 (계산기 폼은 RHF 지역 상태)

**External Integrations**

| 서비스 | 통합 지점 | 방식 |
|--------|-----------|------|
| Supabase Auth | `utils/supabase/client.ts` · `middleware.ts` · Server Components | 이메일 매직링크 + 쿠키 세션 |
| Supabase Postgres | Server Components 직접 쿼리 + Server Actions | RLS 강제, SDK 경유 |
| Supabase Storage | `<Image>` src + 업로드(admin만, Server Action) | 공개 버킷 anon read |
| 카카오맵 JS SDK | `lib/data/kakao-map-loader.ts` → `features/listings/ListingsMap.tsx` | `next/dynamic` + `ssr: false` + 도메인 등록 의존 |
| Plausible (SHOULD) | `app/layout.tsx` script 태그 | `data-domain` + Meta 토글 custom event |
| Vercel | Git Integration | PR → preview, main → production |

**Data Flow**

```
(1) 랜딩·매물 리스트 (공개):
  Browser → Next.js SSG/SSR → app/data/listings.json (import) → Server Component → Client Hydration

(2) 계산기:
  Browser → Client Component (RHF) → lib/calculator/* (순수) → Result → Framer Motion 재정렬
  (서버 왕복 없음)

(3) Tier 기반 콘텐츠:
  Browser → middleware.ts (세션 쿠키) → Server Component → lib/tier/getTier()
  → 조건 분기 → Client TierGate (블러/완전 차단)

(4) 커뮤니티 (L2+):
  Browser → Server Component → Supabase (RLS 강제) → Client 렌더

(5) Meta 토글:
  Client → Zustand store → localStorage persist + URL param sync → 모든 MetaAnnotation 재렌더
  (토글 ON 최초: 첫 주석 자동 슬라이드인 로직)

(6) 빌드 시점 마스킹:
  원본 크롤링 JSON → scripts/build-snapshot.ts → 채무자 이니셜/주소 동 단위 변환
  → app/data/listings.json (번들 포함)
```

### File Organization Patterns

**Configuration Files (루트)**

- Next.js: `next.config.ts` (카카오맵 도메인 화이트리스트, 이미지 호스트)
- TypeScript: `tsconfig.json` (strict, `@/*` 절대 경로)
- Tailwind: `tailwind.config.ts` (빌사남 톤 디자인 토큰 + shadcn 통합)
- ESLint: `.eslintrc.json` (Next.js + `no-restricted-syntax` for `new Date()`)
- Prettier: `.prettierrc` (`printWidth: 100`)
- Vitest: `vitest.config.ts` (`node` for 계산기, `jsdom` for React)
- shadcn: `components.json`
- Lint-staged: `.lintstagedrc.json` (pre-commit grep)
- Environment: `.env.example` 공개 · `.env.local` gitignored

**Source Organization 원칙**

- **단방향 의존성**: `app/` → `features/` → `components/` · `lib/` · `stores/` · `utils/` — 역참조 금지
- **lib/ 독립성**: `lib/*`는 React 의존도 최소 (계산 함수 · 포맷 유틸 · 상수)
- **Absolute imports**: `@/features/calculator`, `@/lib/format/date`

**Test Organization**

- Co-located: `lib/calculator/dividend.test.ts` (소스 옆)
- Fixtures: `lib/calculator/__fixtures__/sample-*.ts` (골든 테스트 5건 입력·기대 출력)
- E2E: 미구현 (Vision)

**Asset Organization**

- Static: `public/og/*` · `public/favicon.ico` · `public/robots.txt` · `public/sitemap.xml`
- Fonts: `next/font` (자동 최적화, 파일 없음)
- Images in source: `components/seo/*` 에서 `<Image>` + Supabase Storage URL

### Development Workflow Integration

**Development Server Structure**

```bash
pnpm dev           # Turbopack dev server (http://localhost:3000)
pnpm test          # Vitest watch mode (계산기 골든 테스트)
pnpm test:run      # Vitest 단발 실행
pnpm lint          # ESLint
pnpm typecheck     # tsc --noEmit
```

**Build Process Structure**

```bash
pnpm build-snapshot   # scripts/build-snapshot.ts → app/data/listings.json 갱신
pnpm build            # Next.js build (lint + typecheck pre-hook)
pnpm start            # Production 로컬 실행
```

**Build 순서 의존:**
1. `scripts/build-snapshot.ts` (매물 JSON 생성) — `pnpm build` 전 수동 실행(필요 시)
2. `tsc --noEmit` + ESLint (Next.js 내장)
3. Vitest (`pnpm test:run` CI pre-build 수동)
4. Next.js build → `.next/`

**Deployment Structure**

- Vercel Git Integration: push → 자동 트리거
  - `main` → Production (커스텀 도메인)
  - PR → Preview (`*.vercel.app`)
- 환경 변수: Vercel 대시보드에서 local/preview/production 분리 관리
- 카카오 개발자 콘솔: 배포 도메인 + `*.vercel.app` 와일드카드 전부 등록 (Day 4 리스크 방어)
- 도메인 DNS: CNAME → Vercel 지정값 (설정 가이드 README 포함)

## Architecture Validation Results

### Coherence Validation ✅

**Decision Compatibility**

| 검증 항목 | 결과 |
|-----------|------|
| Next.js 16 + Supabase SDK 호환 | ✅ 공식 Starter 기반 — 검증됨 |
| React 18/19 + Framer Motion | ✅ Framer Motion 11+ React 19 peer 호환 |
| Tailwind + shadcn/ui + Radix | ✅ 공식 통합 경로 |
| TypeScript strict + Zod + RHF | ✅ `zodResolver` 타입 추론 완결 |
| Server Components + Supabase RLS | ✅ 쿠키 세션 + Server Client 패턴 |
| Vitest `node` vs `jsdom` 분리 | ✅ 계산기(node) + UI(jsdom) 혼용 가능 |
| 모순 결정 | 없음 |

**Pattern Consistency**

- Naming (snake_case DB / camelCase JS) 경계 처리 규칙이 D1.2-1.4·Data Format Pattern과 일치 ✅
- Domain-Specific 8 패턴이 Cross-Cutting Concerns 10항목을 모두 커버 ✅
- Zustand selector 함수형 규칙이 Meta Provider SSR 안전 패턴과 일치 ✅
- `new Date()` 금지 규칙이 타임존 NFR과 일치 ✅

**Structure Alignment**

- `features/` + `components/` 분리가 D4.4(컴포넌트 조직) 결정과 일치 ✅
- `lib/calculator/*` 순수 함수 격리가 D3.2(클라이언트 실행) + Pattern #7(순수 원칙)과 일치 ✅
- `stores/provider.tsx` SSR 안전 패턴이 D4.1(Zustand) 결정과 일치 ✅
- `app/data/*.json` 정적 import가 D1.1(저장 위치) 결정과 일치 ✅

### Requirements Coverage Validation ✅

**PRD MUST 12 → 아키텍처 커버리지**

| # | MUST 기능 | 아키텍처 커버 | 비고 |
|---|-----------|-----|------|
| 1 | 골격 & 배포 | ✅ | Starter + Vercel Git Integration |
| 2 | 3-tier RBAC | ✅ | migrations + lib/tier + components/tier |
| 3 | 매물 탐색 3탭 | ✅ | features/listings + 정적 스냅샷 + Placeholder |
| 4 | 계산기 코어 | ✅ | lib/calculator + Vitest 골든 테스트 5건 |
| 5 | 계산기 UX | ✅ | features/calculator + RHF + Framer Motion |
| 6 | 랜딩 Hero | ✅ | features/landing-hero + OG 메타 |
| 7 | 커뮤니티 | ✅ | features/community + TierGate + L2 블러 |
| 8 | Meta 토글 시스템 | ✅ | components/meta + stores/meta-store + annotations.ts |
| 9 | Placeholder 라벨 체계 | ✅ | components/placeholder — 표준 컴포넌트 강제 |
| 10 | About | ✅ | features/about + 공고 매칭 표 + regulatory.ts |
| 11 | 접근성 & 보안 방어선 | ✅ | ESLint + lint-staged + RLS + focus trap |
| 12 | 문서 & 운영 | ✅ | README + CLAUDE.md + AGENTS.md + Lighthouse script |

**Non-Functional Requirements → 아키텍처 대응**

| NFR | 대응 근거 | 커버 |
|-----|-----------|------|
| 계산기 원 단위 정합성 | Vitest 골든 테스트 5건 + 순수 함수 + date-fns-tz | ✅ |
| Lighthouse Performance ≥ 80 | SSG + dynamic import(카카오맵·Framer) + `<Image>` · `next/font` | ✅ |
| Lighthouse Accessibility ≥ 90 | shadcn/ui + Radix + focus trap + SkipNav + Color Contrast 사전 검증 | ✅ |
| LCP < 2.5s / CLS < 0.1 | SSG 우선 + 폰트 fallback + 이미지 dimension 지정 | ✅ |
| service_role 키 클라 유입 0 | `.env.example` 공개 + lint-staged grep + 서버 독점 사용 | ✅ |
| RLS 누락 테이블 0 | 마이그레이션 원자적(테이블+RLS 동일 파일) + SHOULD 런타임 체크리스트 | ✅ |
| 타임존 Asia/Seoul 고정 | `lib/format/date.ts` 독점 + ESLint `new Date()` 금지 | ✅ |
| WCAG 2.1 AA | focus-visible + semantic HTML + aria-* + 키보드 Tab 완결성 | ✅ |
| 규제 카피 리프레이밍 | `lib/copy/regulatory.ts` 단일 소스 + Meta 주석 #6·#11 | ✅ |
| 실명 수집 0 | Supabase Auth 이메일 매직링크 + profiles에 display_name만 | ✅ |
| 채무자 정보 마스킹 | `scripts/build-snapshot.ts` 빌드 타임 1회 변환 | ✅ |
| 호환성 (Chrome/Safari/Firefox/Edge) | Next.js 16 default targets 충족 | ✅ |
| 모바일 반응형 "기본만" | Tailwind breakpoints + Sheet 컴포넌트(모바일 aside 대체) | ✅ |

### Implementation Readiness Validation ✅

**Decision Completeness**: 17개 결정(D1.1-D5.5)이 선택·근거·대안 포함 문서화. 모든 주요 버전은 웹 검증 완료.

**Structure Completeness**: 루트부터 leaf까지 완전 트리. MUST 12 → 디렉토리 1:1 매핑 완료.

**Pattern Completeness**: 9개 패턴 카테고리(Naming · Structure · Data Format · State · Error · Loading · Domain-Specific 8종 · Testing · Enforcement) 예시 포함.

### Gap Analysis Results

**Critical Gaps**: 없음 (블로커 수준 누락 없음)

**Important Gaps → 해결 반영 (Step 8에서 CLAUDE.md·첫 Story에 포함)**

1. **`lib/tier/gate.ts` Server Action 권한 헬퍼 추가**
   - `getTier()`: Server Component용, 세션 쿠키 → profiles lookup → TierLevel 반환
   - `requireTier(minimum: TierLevel)`: 부족 시 `redirect('/profile/tier-request')`
   - `requireAdmin()`: `ADMIN_EMAILS` env 체크 실패 시 `notFound()`
   - Server Action에서 공통 사용 (대부업체 매물 등록·admin tier 승격)

2. **계산기 "양편넣기 +1일" 상태 위치** — `lib/calculator/schema.ts` `CalculatorInput` Zod에 `include_yangpyeon: z.boolean().default(true)` 필드 통합. RHF의 Switch 컴포넌트와 바인딩. 별도 store 불필요.

3. **Ambient Annotation CSS 토큰** — `tailwind.config.ts` `theme.extend.colors.meta = { dot, aside, overlay }` 네임스페이스 명시. 컴포넌트에서 `text-meta-dot` 등 참조.

**Nice-to-Have Gaps (Post-MVP 권장)**

- `scripts/build-snapshot.ts` 원본 JSON 입력 스키마 샘플 문서화
- OG 이미지 실제 제작 (1200×630) → `public/og/og-default.png` 등
- Supabase CLI `link` + `gen types typescript` 명령 README 포함
- RLS 정책 존재 여부 런타임 self-check (`lib/supabase/rls-checklist.ts`)

### Architecture Completeness Checklist

**✅ Requirements Analysis**
- [x] 프로젝트 컨텍스트 심층 분석 완료 (PRD + UX + Research + Brainstorming + gs 파일)
- [x] 규모·복잡도 평가 완료 (Domain High / Implementation Medium / UX High)
- [x] 기술 제약 식별 (4일 MVP · 1인 · 50h · 무료 티어 · 공개 저장소)
- [x] 10개 Cross-Cutting Concerns 매핑

**✅ Architectural Decisions**
- [x] 17개 결정 문서화 (버전·근거·대안 포함)
- [x] 기술 스택 확정 (Starter + 추가 의존성)
- [x] 통합 패턴 정의 (Server Components / Server Actions / Zustand / RHF+Zod)
- [x] 성능 고려 (SSG·dynamic import·코드 스플릿)

**✅ Implementation Patterns**
- [x] Naming 규칙 (DB snake · JS camel · Routes kebab · Env SCREAMING)
- [x] Structure 패턴 (features/ vs components/ vs lib/ vs stores/)
- [x] Communication 패턴 (Server Component → prop → Client, Server Action return union)
- [x] Process 패턴 (error.tsx boundary, sonner toast, loading.tsx)
- [x] Domain-Specific 8종 규칙 + ESLint/grep 강제 지점

**✅ Project Structure**
- [x] 완전 디렉토리 트리 정의 (모든 파일·디렉토리 포함)
- [x] 컴포넌트·서비스·데이터 경계 명시
- [x] 외부·내부 통합 지점 매핑 (Supabase · 카카오맵 · Plausible · Vercel)
- [x] PRD MUST 12 → 디렉토리 1:1 매핑 완료

### Architecture Readiness Assessment

**Overall Status**: **READY FOR IMPLEMENTATION** ✅

**Confidence Level**: **High**
- 기술 스택 모두 검증됨 (공식 Starter 기반)
- 계산기 로직 원본(`npl-calculator-logic-v3.1.gs`)이 이미 검증 완료 (김대리 승인) — 포팅만 남음
- PRD·UX·Architecture 3문서 간 교차 검증 완료

**Key Strengths**

1. **Starter 기반으로 4일 제약 현실성 확보** — Vercel + Supabase 공식 템플릿이 셋업 2-3시간 절약
2. **도메인 복잡도를 얇은 Cross-Cutting 레이어로 흡수** — 규제 카피·Placeholder·Meta 토글이 각기 단일 소스로 응집
3. **계산기 순수 함수 격리가 정합성 방어선** — Vitest 골든 테스트 가능성 보장
4. **Meta 토글 = 독창적 UX 장치**와 아키텍처 일관성 양립 — Zustand + URL + localStorage 3중 설계
5. **AI 에이전트 일관성 규칙**이 Claude Code 다중 세션 리스크 방어 — CLAUDE.md + AGENTS.md + ESLint grep

**Areas for Future Enhancement (Post-MVP)**

- RLS 쓰기 정책 매트릭스 전수 검증 자동화
- Sentry 에러 트래킹
- GitHub Actions CI workflow (tsc + vitest + lint)
- Storybook 컴포넌트 카탈로그
- 법원경매/온비드 공식 API 연동
- 실시간 크롤링 스케줄러
- multi-tenant 격리 (대부업체별 워크스페이스)
- Admin UI (tier 변경·매물 관리)

### Implementation Handoff

**AI Agent Guidelines**

- 이 아키텍처 문서의 모든 결정을 **그대로** 따를 것
- Domain-Specific Patterns 8종은 **우회 불가** (Placeholder·Meta·regulatory·Date·Won·TierGate·순수 함수·reduced-motion)
- `components/ui/*` · `utils/supabase/*` (자동 생성본) 직접 수정 금지
- 새 결정이 필요하면 아키텍처 문서 업데이트 먼저 수행
- CLAUDE.md가 이 문서의 **핵심 규칙 요약본** — 세션 시작마다 자동 로드됨

**First Implementation Priority (Day 1 오전 Gate)**

```bash
# 1. Starter 생성
pnpm create next-app@latest --example with-supabase npl-market
cd npl-market

# 2. Supabase 프로젝트 생성 (https://supabase.com/dashboard) + 환경 변수 주입
cp .env.example .env.local
# ADMIN_EMAILS="blynn@example.com" 추가

# 3. 추가 의존성
pnpm add framer-motion date-fns date-fns-tz zustand react-hook-form @hookform/resolvers zod
pnpm add -D vitest @vitest/ui @testing-library/react @testing-library/jest-dom jsdom lint-staged

# 4. shadcn 필수 컴포넌트
pnpm dlx shadcn@latest add button card dialog sheet toggle tooltip skeleton badge sonner

# 5. 카카오 개발자 콘솔 도메인 등록 (localhost:3000 + *.vercel.app + 커스텀 도메인)
# → Day 4 데모 장애 1순위 리스크 방어선

# 6. Supabase 마이그레이션 + 타입 생성
supabase link --project-ref <ref>
# supabase/migrations/0001_init_schema.sql 작성 후
supabase db push
supabase gen types typescript --linked > types/generated.ts
```

**Day 1 Gate 통과 기준**
- `pnpm dev` 실행 시 에러 없이 localhost:3000 렌더
- Supabase 연결 확인 (더미 쿼리)
- 카카오맵 SDK 로드 확인 (도메인 등록 완료)
- 6개 테이블 + RLS 마이그레이션 적용 완료
- `.env.local` service_role 키 주입 확인 (`.gitignore` 보호 확인)
