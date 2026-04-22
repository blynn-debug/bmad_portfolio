# Story 1.1: Next.js + Supabase 스타터 템플릿 부트스트랩

Status: in-progress

<!-- Story cycle: create-story (this) → (optional) validate-story → dev-story → code-review. Run validate-create-story for quality check before dev-story if desired. -->

## Story

**As a** 개발자 (blynn),
**I want** Vercel + Supabase 공식 스타터 템플릿(`create-next-app --example with-supabase`)으로 Next.js 16 프로젝트를 부트스트랩하고 로컬 · Vercel · Supabase 3환경을 연결하여,
**So that** Server Components 호환 Supabase 클라이언트 + middleware 세션 갱신이 사전 구성된 기반에서 Day 1 오전 Gate를 통과하고 즉시 Epic 2 이후 기능 개발에 들어갈 수 있다.

## Acceptance Criteria

### AC1 — Starter 부트스트랩 & 로컬 구동

**Given** `pnpm create next-app@latest --example with-supabase` 로 생성된 프로젝트가 리포지토리 루트에 병합되어 있을 때
**When** `pnpm dev` 로 로컬 개발 서버를 기동
**Then** 기본 랜딩 페이지가 `http://localhost:3000` 에서 에러 없이 렌더링되고, 스타터 기본 Supabase 연결 헬스체크(예: Starter의 더미 쿼리 또는 수동 `select 1`)가 성공한다
**And** 다음 런타임 구성이 모두 확인된다:
- Next.js **16.x (최신 stable)** — `package.json#dependencies.next` 기준
- Turbopack dev server — `"dev": "next dev --turbopack"` 또는 스타터 기본값 유지
- TypeScript **strict** 모드 — `tsconfig.json#compilerOptions.strict === true`
- 패키지 매니저 **pnpm** — `pnpm-lock.yaml` 존재, `package-lock.json` · `yarn.lock` 부재

### AC2 — 환경 변수 분리 & 공개 템플릿

**Given** 환경 변수 설정 파일 구성
**When** 리포지토리 루트를 확인
**Then**:
- `.env.example` 이 **public(커밋됨)** 으로 존재
- `.env.local` 이 `.gitignore` 에 등록되어 있어 git에 추적되지 않음
- `.env.example` 에 아래 4개 키가 **값 없는 템플릿** 형태로 포함:
  - `NEXT_PUBLIC_SUPABASE_URL=`
  - `NEXT_PUBLIC_SUPABASE_ANON_KEY=` (스타터가 `publishable_key` 로 쓰면 그 명칭 존중)
  - `SUPABASE_SERVICE_ROLE_KEY=`
  - `ADMIN_EMAILS=`
- 개발자의 `.env.local` 에 실제 Supabase 프로젝트 값이 주입되어 로컬 구동이 성공

### AC3 — pre-commit 서비스 롤 키 누출 차단

**Given** `husky` + `lint-staged` pre-commit 훅이 설치된 상태
**When** `SUPABASE_SERVICE_ROLE_KEY` 문자열이 포함된 스테이지된 파일(예: 실수로 `.env.local` 강제 추가, 주석 포함 등)을 커밋 시도
**Then**:
- pre-commit grep 이 해당 문자열을 탐지하여 커밋을 **차단**(exit code ≠ 0)
- 터미널에 명확한 에러 메시지 출력 (어떤 파일에서 탐지되었는지 식별 가능)
- `.env.example` 의 정당한 키 이름 출현은 차단되지 않음 (오탐 제거 검증)

### AC4 — 에이전트 가이드 문서(`CLAUDE.md` + `AGENTS.md`)

**Given** 프로젝트 루트
**When** 파일 존재 및 내용 확인
**Then**:
- `AGENTS.md` 가 존재 (Next.js 16 스타터가 기본 포함 — 유지)
- `CLAUDE.md` 가 존재하고 아래 항목이 **모두** 명시되어 있음:
  1. 프로젝트 구조 요약 (features/ · components/ · lib/ · stores/ · utils/supabase/ · supabase/migrations/)
  2. 금지 사항 명시:
     - `utils/supabase/*` · `components/ui/*` (shadcn 자동 생성본) 직접 수정 금지
     - `lib/format/date.ts` · `lib/format/currency.ts` **외부**에서 `new Date()` · `.toLocaleString()` 사용 금지
     - 클라이언트 코드에서 `SUPABASE_SERVICE_ROLE_KEY` 참조 금지
     - 규제 카피(거래·가입 등)는 `lib/copy/regulatory.ts` 경유 필수 (컴포넌트 직접 하드코딩 금지)
     - `<PlaceholderLabel>` 이외 미구현 표현 금지, `<MetaAnnotation id="...">` 이외 인라인 주석 금지
     - Zustand selector 는 함수형 `(s) => s.key` — 객체 구조분해 금지
  3. 핵심 컨벤션: pnpm · TypeScript strict · snake_case(DB) · PascalCase(컴포넌트) · camelCase(훅·유틸) · kebab-case(라우트 폴더)
  4. 참조 링크: `_bmad-output/planning-artifacts/prd.md`, `architecture.md`, `ux-design-specification.md`, `epics.md`

## Tasks / Subtasks

- [ ] **Task 1: 스타터 부트스트랩 & 리포지토리 루트 병합** (AC: 1)
  - [ ] 1.1 임시 디렉터리에 스타터 생성: `pnpm create next-app@latest --example with-supabase _starter_tmp` (리포지토리 루트가 비어있지 않으므로 직접 `.` 대상 실행 불가 → 임시 폴더 경유)
  - [ ] 1.2 `_starter_tmp/` 내용을 리포지토리 루트로 이동(충돌 없음 확인: 기존 루트엔 `_bmad/`, `_bmad-output/`, `brainstorming/`, `docs/`, `.claude/`, `.idea/`, `.github/`, `.cursor/` 만 존재하므로 스타터 파일과 충돌 없음), `_starter_tmp/` 삭제
  - [ ] 1.3 스타터 `.gitignore` 와 기존 `.gitignore`(있다면) 병합 — `.env.local`, `node_modules`, `.next` 포함 확인
  - [ ] 1.4 `pnpm install` 실행, `pnpm-lock.yaml` 생성 확인
  - [ ] 1.5 `package.json#dependencies.next` 가 `^16.` 인지 검증. 아니면 `pnpm add next@latest react@latest react-dom@latest` 로 끌어올림
  - [ ] 1.6 `tsconfig.json#compilerOptions.strict === true` 검증 (스타터 기본값이지만 확인)
  - [ ] 1.7 `package.json#scripts.dev` 가 `next dev --turbopack` (또는 스타터 기본) 포함 확인
  - [ ] 1.8 Supabase 프로젝트 생성(https://supabase.com/dashboard) — 단일 Supabase 프로젝트(무료 티어 1개 한도) + URL · anon(publishable) key · service_role key 메모

- [ ] **Task 2: 환경 변수 설정** (AC: 2)
  - [ ] 2.1 스타터가 생성한 `.env.example` 이 `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`(또는 publishable 명칭) 를 포함하는지 확인 — 누락 시 추가
  - [ ] 2.2 `.env.example` 에 **추가 주입** (값 없는 템플릿): `SUPABASE_SERVICE_ROLE_KEY=`, `ADMIN_EMAILS=`
  - [ ] 2.3 `.env.local` 생성: `cp .env.example .env.local` → 실제 값 주입 (Supabase Dashboard → API 페이지에서 복사)
  - [ ] 2.4 `.env.local` 이 `.gitignore` 에 있는지 grep 검증: `grep -E '^\.env\.local$|^\.env\*$' .gitignore`
  - [ ] 2.5 `git status` 로 `.env.local` 이 **추적되지 않는 상태(untracked/ignored)** 확인
  - [ ] 2.6 `pnpm dev` 재기동, `localhost:3000` 정상 렌더 + 스타터 기본 Supabase 호출 경로 에러 없음 확인

- [ ] **Task 3: pre-commit 보안 방어선 — husky + lint-staged** (AC: 3)
  - [ ] 3.1 의존성 설치: `pnpm add -D husky lint-staged`
  - [ ] 3.2 husky 초기화: `pnpm exec husky init` (v9+ API — `.husky/` 디렉터리 + `.husky/pre-commit` 생성)
  - [ ] 3.3 `.husky/pre-commit` 에 `pnpm lint-staged` 실행 라인 설정 (husky init 기본값 유지 + 보완)
  - [ ] 3.4 리포지토리 루트에 `.lintstagedrc.json` 생성 — 스테이지 파일 대상 grep 규칙:
    ```json
    {
      "*": [
        "bash -c 'if grep -l \"SUPABASE_SERVICE_ROLE_KEY\" \"$@\" | grep -v \"^\\.env\\.example$\\|^CLAUDE\\.md$\\|^\\.lintstagedrc\\.json$\\|^README\\.md$\\|^_bmad-output/\"; then echo \"❌ service_role key 문자열이 비허용 파일에 포함되어 있습니다. 커밋이 차단되었습니다.\"; exit 1; fi' --"
      ]
    }
    ```
    (혹은 동등한 로직의 스크립트 파일 분리 — `scripts/precommit-secret-scan.sh` 경유 가능. 실행 가능성이 명확한 방식 선택)
  - [ ] 3.5 검증 테스트 A (차단 확인): 임시 파일 `_probe.txt` 생성 → `echo "SUPABASE_SERVICE_ROLE_KEY=abc" > _probe.txt` → `git add _probe.txt` → `git commit -m "probe"` 시도 → **커밋 차단 + 에러 메시지 출력** 확인 → `git reset HEAD _probe.txt` + `rm _probe.txt`
  - [ ] 3.6 검증 테스트 B (오탐 없음 확인): `.env.example` 의 `SUPABASE_SERVICE_ROLE_KEY=` (값 없음, 키 이름만) 를 수정 후 커밋 시도 → **통과** 되어야 함
  - [ ] 3.7 검증 테스트 C: `CLAUDE.md` 의 키 이름 언급(참조 목적) 은 통과되어야 함

- [ ] **Task 4: CLAUDE.md 작성** (AC: 4)
  - [ ] 4.1 `AGENTS.md` 존재 확인 (Next.js 16 스타터 기본 생성본) — 미존재 시 빈 템플릿 생성 후 `# Agent Instructions for Next.js` 섹션만 남김 (세부 내용은 Next.js 기본 유지)
  - [ ] 4.2 `CLAUDE.md` 생성 — 아래 섹션 포함:
    - `# NPL 마켓 — Claude Code 프로젝트 규칙`
    - `## 프로젝트 구조 요약` (architecture.md §Complete Project Directory Structure 의 핵심 디렉터리만 간추림)
    - `## 금지 사항 (MUST NOT)` — AC4의 6개 항목 모두 명시
    - `## 핵심 컨벤션` (Naming · 패키지 매니저 · strict TS · 경로 별칭 `@/*`)
    - `## 참조 문서` (`_bmad-output/planning-artifacts/` 4개 문서 상대 경로 링크)
    - `## Day 1 Gate 체크리스트` (architecture.md §Day 1 Gate 통과 기준 그대로 인용)
  - [ ] 4.3 `CLAUDE.md` 를 ≤ 300줄로 유지 — 세션마다 자동 로드되는 문서이므로 토큰 예산 관리 (상세는 `_bmad-output/planning-artifacts/*` 로 위임)

- [ ] **Task 5: 통합 검증 & 커밋** (AC: 1, 2, 3, 4)
  - [ ] 5.1 `pnpm typecheck` (또는 `pnpm exec tsc --noEmit`) 통과 — 0 errors
  - [ ] 5.2 `pnpm lint` 통과 — 0 errors, 0 warnings (스타터 기본 ESLint 룰셋 기준)
  - [ ] 5.3 `pnpm build` 성공 — 프로덕션 빌드 통과
  - [ ] 5.4 `pnpm dev` 기동 + `curl -I http://localhost:3000` → `200 OK` 확인 후 종료
  - [ ] 5.5 `.env.local` 이 git 추적에 포함되지 않는지 최종 확인: `git check-ignore .env.local` 이 `.env.local` 을 출력해야 함
  - [ ] 5.6 커밋 생성 (service_role 키 차단 훅 실제 작동 확인 포함) — 커밋 메시지: `feat: bootstrap Next.js 16 + Supabase starter (Story 1.1)`
  - [ ] 5.7 File List 업데이트 후 Status 를 `review` 로 전환 준비

## Dev Notes

### 부트스트랩 전략 — 임시 폴더 경유 필수

`pnpm create next-app@latest --example with-supabase .` (현재 디렉터리 대상) 은 리포지토리 루트가 비어있지 않으면 실패합니다. 현재 루트에는 `_bmad/`, `_bmad-output/`, `brainstorming/`, `docs/`, `.claude/`, `.idea/`, `.github/`, `.cursor/`, `.git/` 이 존재합니다.

**실행 가능한 순서:**

```bash
pnpm create next-app@latest --example with-supabase _starter_tmp
# 대화형 프롬프트 나오면 TypeScript Yes, ESLint Yes, Tailwind Yes, src/ No, App Router Yes, Turbopack Yes, customize aliases No 선택 (스타터 기본)
mv _starter_tmp/.[!.]* _starter_tmp/* .    # dotfile + 일반 파일 이동 (shopt -s dotglob 쓰면 한 줄, zsh 는 기본 dotfile 포함 안 됨)
rmdir _starter_tmp
pnpm install
```

⚠️ `mv` 시 기존 `.git/` 와 스타터의 `.git/`(있다면) 충돌 주의 — 스타터 내부 `.git/` 은 제거 후 기존 리포지토리 `.git/` 을 유지한다. 스타터가 `.git` 을 생성하는지 `create-next-app` 의 동작은 버전마다 다르므로 `mv` 전에 `rm -rf _starter_tmp/.git` 실행 권장.

### 스타터가 제공하는 것 (재구현 금지)

[Source: architecture.md#Architectural Decisions Provided by Starter]

- **Supabase 3-way 클라이언트**: `utils/supabase/server.ts` · `utils/supabase/client.ts` · `utils/supabase/middleware.ts` — **직접 수정 금지**. 확장이 필요하면 `lib/supabase/queries.ts` 등 별도 모듈로 래핑.
- **middleware**: `middleware.ts` 루트 — Supabase 세션 쿠키 갱신. 이후 tier guard 확장은 이 파일 편집이 아니라 `lib/tier/*` 의 헬퍼를 Server Component에서 호출하는 방식으로 구현 (Story 1.3 이후).
- **Tailwind + shadcn/ui**: `components.json` 초기화, `tailwind.config.ts` 기본. Story 1.2 에서 디자인 토큰 확장.
- **Environment**: `.env.example` 스타터 기본, `.env.local` gitignored.
- **Scripts**: `dev`, `build`, `start`, `lint` — 기본 Next.js. 필요 시 `typecheck`, `test`, `test:run`, `build-snapshot` 는 **이후 스토리**에서 추가 (이 스토리에서는 추가하지 않음).

**주의 — 이 스토리에서 하지 말 것 (Scope 경계):**

- ❌ shadcn 컴포넌트 추가 (Story 1.2 · 1.4 책임)
- ❌ Tailwind 디자인 토큰 확장 (Story 1.2)
- ❌ Supabase 마이그레이션 SQL 작성 (Story 1.3)
- ❌ `<PlaceholderLabel>` 컴포넌트 구현 (Story 1.4)
- ❌ `lib/format/*`, `lib/copy/*`, ESLint `no-restricted-syntax` 규칙 (Story 1.5)
- ❌ `scripts/build-snapshot.ts` (Story 1.6)
- ❌ 라우트 스캐폴드 · SkipNav (Story 1.7)
- ❌ Vitest 설정 (Story 3.2)
- ❌ Vercel 배포 · 카카오맵 도메인 등록 (Story 6.6 · Gate 4)

### 환경 변수 정책 (architecture.md D2.6)

- `.env.example` — 공개, 모든 키 이름만 나열 (값 없음). 이 스토리에서 4개 키 템플릿 확정.
- `.env.local` — 로컬 전용, gitignored, 실제 값 주입.
- `.env.local` 의 **실제 값은 커밋에 절대 포함되지 않는다** — Task 3 의 pre-commit 훅이 2차 방어선.
- Preview/Production 은 Vercel Environment Variables 로 주입 (Story 6.6 이후). 이 스토리에서는 로컬만 커버.

### pre-commit 훅 설계 원칙

- **허용 파일**(키 이름만 언급 허용): `.env.example`, `CLAUDE.md`, `README.md`, `.lintstagedrc.json`, `_bmad-output/**/*.md`
- **차단 대상**: 그 외 모든 파일에서 `SUPABASE_SERVICE_ROLE_KEY` 문자열 발견 시 차단.
- lint-staged 의 `*` 글로브는 스테이지된 모든 파일에 대해 command 실행 → command 가 exit 1 이면 커밋 차단.
- grep 로 경로 필터링을 수행할 때 `$@` 로 전달된 파일 경로 목록을 확인하고 허용 파일만 제외한다.
- **오탐 엄격 테스트 필수** (Task 3.5 / 3.6 / 3.7 모두 통과).

### CLAUDE.md — 토큰 예산

[Source: architecture.md §AI Agent Enforcement]

- CLAUDE.md 는 세션마다 자동 로드 → ≤ 300줄 (≤ ~3,000 토큰) 유지
- 상세 아키텍처 결정은 `_bmad-output/planning-artifacts/architecture.md` 로 링크, CLAUDE.md 는 **요약만**
- `금지 사항` 섹션은 원문 그대로, `참조 문서` 섹션은 상대 경로 링크

### Project Structure Notes

- **Next.js 프로젝트 루트 = 리포지토리 루트** (임시 `_starter_tmp/` 경유 후 병합). `npl-market/` 하위 폴더로 두지 않음 — 단일 포트폴리오 리포지토리의 BMad artifacts 와 소스 코드가 공존 구조.
- **BMad artifacts 보호**: `_bmad/`, `_bmad-output/`, `brainstorming/`, `docs/`, `.claude/` 는 이 스토리에서 **절대 수정 금지** (sprint-status.yaml 갱신 제외 — 그것은 create-story 워크플로 후처리가 담당).
- **architecture.md #Complete Project Directory Structure** 의 `features/`, `lib/`, `stores/`, `supabase/migrations/`, `scripts/` 등 폴더는 이 스토리에서 **생성하지 않는다** — 각 후속 스토리가 필요 시점에 자연스럽게 생성.

### References

- PRD 전체: [_bmad-output/planning-artifacts/prd.md](../planning-artifacts/prd.md)
  - §Technical Architecture (L451-471): 스택 결정 근거
  - §MVP Feature Set - MUST 12개 #1 (골격 & 배포, 5h): 이 스토리의 범위
- Architecture: [_bmad-output/planning-artifacts/architecture.md](../planning-artifacts/architecture.md)
  - §Starter Template Evaluation → Selected Starter: `create-next-app --example with-supabase`
  - §Architectural Decisions Provided by Starter
  - §Core Architectural Decisions D2.6 (`.env` 누출 방어), D5.1 (환경 분리)
  - §AI Agent Enforcement (CLAUDE.md · 금지 사항)
  - §Implementation Handoff → First Implementation Priority (부트스트랩 명령)
  - §Day 1 Gate 통과 기준
- Epics: [_bmad-output/planning-artifacts/epics.md](../planning-artifacts/epics.md)
  - §Epic 1 Goal (기반 · 디자인 시스템)
  - §Story 1.1 Acceptance Criteria (L278-302): 이 AC 의 원본
  - §Additional Requirements - 런타임 / 패키지 매니저 (L108-109)
- UX: [_bmad-output/planning-artifacts/ux-design-specification.md](../planning-artifacts/ux-design-specification.md)
  - §Design System Foundation (L266-335): Story 1.2 로 이어짐
- NFR 관련: NFR7 (service_role 0건), NFR10 (실명 수집 0), NFR17 (4일 MVP 50h)

### 최신 기술 특이사항

- **Next.js 16.x**: Turbopack dev server stable · App Router 전용 async request APIs · `AGENTS.md` 기본 포함. React 18/19 호환.
- **create-next-app `--example with-supabase`**: Vercel/Next.js canary repo 에서 유지 → 부트스트랩 시점의 Next.js 버전이 최신 stable 과 일치하는지 확인하고 gap 발생 시 Task 1.5 에서 `pnpm add next@latest react@latest react-dom@latest` 로 끌어올림.
- **husky v9+**: init 커맨드가 `pnpm exec husky init` 으로 변경, `.husky/pre-commit` 단일 파일만 생성 (구 버전의 `.husky/_` 디렉터리 구조 불필요).
- **lint-staged**: `tasks` 는 커맨드 배열. `bash -c` inline script 는 인용 주의, 복잡하면 `scripts/precommit-secret-scan.sh` 로 분리.
- **pnpm create next-app@latest**: 대화형 프롬프트 포함. CI 에서는 `--yes` 사용 가능하지만 이 스토리는 로컬 수동 실행.

## Dev Agent Record

### Agent Model Used

_(Amelia — to be filled in at dev-story execution; record exact model ID e.g., `claude-opus-4-7[1m]`)_

### Debug Log References

_(Populated during implementation)_

### Completion Notes List

_(Populated during implementation — 주요 결정, 예외 처리, deviation 기록)_

### File List

_(Populated during implementation — 모든 생성 · 수정 파일의 리포지토리 루트 상대 경로)_
