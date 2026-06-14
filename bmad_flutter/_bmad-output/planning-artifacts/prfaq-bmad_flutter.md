---
title: "PRFAQ: Flutter Showcase Museum"
status: "complete"
created: "2026-06-13"
updated: "2026-06-13"
stage: 5
inputs:
  - "_bmad-output/brainstorming/brainstorming-session-2026-06-13-000000.md"
concept_type: "personal-learning-tool"
---

# Flutter Showcase Museum — Material과 iOS를 나란히 비교하고, 내 손으로 튜닝한 값이 그대로 앱이 되는 학습 도구

## Flutter 초보 개발자가 8개 실험실에서 위젯을 직접 조작하면, 그 결과가 자기만의 쇼케이스 앱으로 완성된다

**서울, 2026년 6월** — Flutter Showcase Museum이 출시되었다. Flutter와 iOS 개발을 처음 배우려는 개발자를 위한 인터랙티브 학습 앱으로, Material과 Cupertino 디자인을 나란히 비교하고 직접 튜닝한 값이 그대로 자기만의 앱이 되는 경험을 제공한다. 기존의 "읽고 따라치기" 학습에 지쳐 Flutter를 포기했던 개발자들이, 손으로 만지는 것만으로 플랫폼 간 차이를 체감하고 학습을 완주할 수 있다.

Flutter를 배우고 싶은 개발자는 많지만, 대부분 공식 문서를 읽거나 영상을 따라치는 것에서 시작한다. Row와 Column의 차이는 글로 읽으면 알 것 같지만, mainAxisAlignment를 start에서 center로 바꿨을 때 실제로 어떤 느낌인지는 직접 만져봐야 안다. Material 버튼의 잉크 퍼짐과 iOS 버튼의 눌림 느낌이 왜 다른지, 스크롤이 왜 어떤 앱에서는 탄성 바운스하고 어떤 앱에서는 딱 멈추는지 — 이런 차이는 문서 어디에도 체감할 수 있는 형태로 존재하지 않는다. 게다가 Xcode 설치, 시뮬레이터 설정, 멀티플랫폼 빌드 같은 환경 셋업의 장벽이 학습 시작 전부터 의욕을 꺾는다. 결과적으로 많은 초보 개발자들이 "나중에 해야지"를 반복하다 Flutter 학습 자체를 포기한다.

Flutter Showcase Museum을 열면, 개발자는 빈 로비 화면 하나에서 시작한다. 8개 실험실을 하나씩 클리어할 때마다, 로비에 새로운 UI가 나타난다 — 골격이 생기고, 버튼이 등장하고, 애니메이션이 붙고, 마침내 앱 잠금 화면까지 완성된다. 각 실험실에서 슬라이더를 움직여 spacing 값을 조절하면, Material과 Cupertino가 어떻게 다르게 반응하는지 스플릿 뷰로 즉시 비교할 수 있다. 그리고 "이게 제일 예쁘다"고 느낀 바로 그 값이 로비에 반영된다. 문서를 읽는 시간은 0이다. 만지고, 비교하고, 내 앱이 되는 것 — 그게 전부다.

> "Flutter 문서를 3시간 읽는 것보다, 이 앱에서 슬라이더를 3분 만지는 게 더 많이 남습니다. 배운 게 곧 내 앱이 되니까, 학습이 귀찮을 이유가 없어집니다."
> — sy, 개발자

### 사용 방법

1. **앱을 열면 빈 로비가 보인다.** 회색 Container 하나. 8개 전시실 입구는 잠겨 있다.
2. **첫 번째 실험실: 레이아웃.** 화면 상단에 박스들이 배치되어 있고, 하단 슬라이더로 Row의 spacing, mainAxisAlignment를 조작한다. 왼쪽에 Material, 오른쪽에 Cupertino가 동시에 반응한다.
3. **"이 값이 좋다" 싶으면 발현 버튼을 누른다.** 게임 스킬 언락 같은 연출과 함께, 로비에 헤더-콘텐츠-푸터 골격이 나타난다. 내가 고른 spacing 값 그대로.
4. **다음 실험실로 넘어간다.** 컴포넌트 실험실에서는 Material 버튼과 iOS 버튼을 나란히 눌러보며 ripple과 opacity의 촉감 차이를 느낀다.
5. **8개를 모두 클리어하면, 로비가 완전체가 된다.** 내가 튜닝한 값들로 구성된, 세상에 하나뿐인 나만의 Flutter 쇼케이스 앱.

> "Row랑 Column 차이를 문서로 10번 읽어도 감이 안 왔는데, 슬라이더 한번 움직이니까 바로 알겠더라. 근데 진짜 중독되는 건, 내가 만진 값이 그대로 내 앱이 된다는 거. 실험실 하나 끝날 때마다 로비가 바뀌는 게 게임 스테이지 클리어하는 느낌이야."
> — Flutter 입문 개발자

### 시작하기

1. 이 레포지토리를 클론한다.
2. `flutter run`으로 실기기에 빌드한다. (Xcode + iOS 기기 필요)
3. 로비에서 첫 번째 실험실을 탭한다.
4. 슬라이더를 움직여본다. 그게 학습의 시작이다.

<!-- coaching-notes-stage-1
- Concept type: Personal learning tool (non-commercial). User is sole customer.
- Customer: Flutter/iOS beginner developer who has been frustrated by setup complexity (Xcode) and passive learning methods.
- Core pain: Existing learning is "read and copy-paste" — no way to feel platform differences hands-on. Result: gives up entirely because it's too tedious.
- Stakes: Without this tool, user won't learn Flutter at all — motivation dies from friction.
- Solution: 8-stage interactive museum app where each lab lets you manipulate widget properties and see Material/Cupertino/Custom differences side-by-side. Your tuning values persist and become the app itself.
- Key competitive findings:
  - Flutter Gallery archived June 2024 — showcase gap exists
  - Flutter decoupling Material/Cupertino in 2026 — timing favorable
  - No tool in any mobile ecosystem combines side-by-side comparison + interactive manipulation + "exploration becomes construction"
  - Widgetbook has knobs but is dev-focused, not learning-focused
- Killing points confirmed via chaos engineering: 3-way platform comparison + user tuning values become the app
- Scope: 8 domains × 1 stage each, Xcode device build
- Rejected alternatives: Web-only (can't access native APIs), 24-stage version (scope explosion), uniform interaction pattern (repetition fatigue)
-->

---

## Customer FAQ

### Q: DartPad에서도 Flutter 코드 치고 바로 결과 볼 수 있는데, 이거 뭐가 다른 거야?

A: DartPad는 코드 에디터다. 코드를 쓰고 결과를 보는 도구이지, 위젯 속성을 손으로 조작하며 차이를 체감하는 도구가 아니다. DartPad에서 Material 버튼과 Cupertino 버튼의 촉감 차이를 비교하려면 두 개의 코드를 각각 작성해서 번갈아 실행해야 한다. Flutter Showcase Museum에서는 스플릿 뷰로 나란히 놓고 동시에 눌러본다. 그리고 DartPad에서 만진 건 탭을 닫으면 사라지지만, 여기서 만진 건 내 앱이 된다.

### Q: 8개 실험실이면 Flutter의 극히 일부만 다루는 거잖아. 이거 끝내고 나면 진짜 앱을 만들 수 있어?

A: 솔직히, 8개 실험실만으로 프로덕션 앱을 만들 수는 없다. 이 앱의 목표는 "Flutter 마스터"가 아니라 "Flutter 감 잡기"다. 레이아웃, 컴포넌트, 애니메이션, 상태관리, 제스처, 알림, 보안, 데이터 저장 — 이 8개를 손으로 체감하고 나면, 공식 문서를 읽을 때 "아, 이게 그거구나"하고 연결되는 기반이 생긴다. 0에서 1로 가는 앱이지, 1에서 100으로 가는 앱이 아니다.

### Q: "내 튜닝값이 앱이 된다"고 했는데, 그 앱이 실제로 쓸모가 있어?

A: 맞다, 쇼케이스 로비는 실용 앱이 아니다. 하지만 이 앱의 가치는 로비의 실용성이 아니라 "내가 만들었다"는 체감에 있다. 같은 앱을 배워도 spacing을 8로 한 사람과 24로 한 사람의 로비는 완전히 다르다. 내 미감이 반영된 결과물이 눈앞에 있다는 것 자체가 학습 동기를 유지시킨다.

### Q: Flutter 초보가 이 앱 자체를 만들 수 있어?

A: 가장 정직한 답은 "혼자서는 어렵다"이다. 이 앱은 AI 코딩 도구(Claude Code)와 함께 만든다. 리빌드 히트맵이나 스플릿 뷰 같은 고급 기능의 구현은 AI가 돕고, 개발자는 그 과정에서 "이 코드가 왜 이렇게 동작하는지"를 실험실에서 직접 확인하며 배운다.

### Q: Xcode 셋업이 필요하다고 했잖아. 결국 똑같은 장벽 아닌가?

A: Xcode 설치 자체는 피할 수 없다. iOS 실기기에서 네이티브 기능을 체험하려면 Xcode는 필수다. 달라지는 건 Xcode 뒤에 오는 경험이다. 기존에는 Xcode를 설치하고 나서 "이제 뭘 하지?"였다면, 이 앱은 설치 직후 슬라이더를 움직이는 것부터 시작한다. 장벽은 같지만, 장벽 너머의 보상이 즉각적이다.

### Q: 유지보수는 누가 해?

A: 1인 개인 프로젝트이므로 장기 유지보수를 보장할 수는 없다. 다만 이 앱이 다루는 위젯들은 Flutter의 가장 안정적인 코어 API이며, 근본적으로 바뀔 가능성은 낮다. 그리고 솔직히, 이 앱은 학습용이다. 한 번 8개 스테이지를 클리어하고 감을 잡으면 그 목적은 달성된 것이다.

### Q: 상태관리를 3개나 다루면 초보한테 혼란만 주는 거 아닌가?

A: 이 앱의 상태관리 실험실은 이론을 가르치는 게 아니라 차이를 체감하는 게 목적이다. setState로 버튼을 누르면 화면 전체가 빨갛게 리빌드되고, Provider로 바꾸면 버튼 주변만 살짝 반응하는 걸 히트맵으로 직접 보면 — 설명 없이 느낀다. 3개를 깊이 배우는 게 아니라, 3개의 차이를 눈으로 보는 것이다.

---

## Internal FAQ

### Q: 기술적으로 가장 어려운 건 뭐야?

A: 두 가지다. 첫째, 스플릿 뷰에서 Material과 Cupertino를 동시에 렌더링하는 것. Flutter는 앱 전체에 하나의 디자인 시스템을 적용하도록 설계되어 있어서, 한 화면에 MaterialApp과 CupertinoApp을 나란히 띄우려면 위젯 트리를 분리하는 구조적 해법이 필요하다. 둘째, 리빌드 히트맵. 위젯의 리빌드 여부를 감지하고 색상 오버레이로 표현하는 건 Flutter의 내부 렌더링 파이프라인을 이해해야 한다.

### Q: 현실적으로 완성까지 얼마나 걸려?

A: AI와 함께 작업하는 전제로, 스테이지당 1-2일 × 8개 = 2-3주. 공통 인프라에 2-3일 추가. 총 3-4주. "한번에 만든다"는 "한 번의 집중 기간에 완성한다"는 의미이지, 하루 만에 끝낸다는 뜻이 아니다.

### Q: 빌드 순서는?

A: 1) 로비 + 라우팅 인프라 → 2) 레이아웃 실험실 (킬링 포인트 검증) → 3) 데이터 저장 (튜닝값 영속성) → 4) 나머지 스테이지. 레이아웃에서 핵심 루프가 동작하지 않으면 나머지를 만들 이유가 없다.

### Q: AI가 못 하는 부분은?

A: 실기기에서의 체험과 미감 판단은 sy님만 할 수 있다. Material 버튼의 ripple이 "느낌이 맞는지", spacing 12와 16 중 어떤 게 "더 예쁜지" — 이건 감각의 영역이다. 또한 Xcode 설정, 실기기 빌드 같은 환경 셋업은 AI가 대신해줄 수 없다.

### Q: 만들다가 포기할 가능성은?

A: 높다. 그래서 첫 스테이지(레이아웃)를 최우선으로 완성하는 것이 핵심이다. 슬라이더를 움직이고, Material과 Cupertino가 나란히 반응하고, 발현 버튼을 눌러 로비가 바뀌는 순간 — 이 한 번의 체험이 동기를 만든다. 스테이지 1이 이 프로젝트의 생사를 결정한다.

### Q: 왜 지금이야?

A: Flutter가 2026년에 Material과 Cupertino를 코어에서 분리 중이고, Flutter Gallery가 2024년에 아카이브되면서 쇼케이스 공백이 생겼으며, AI 코딩 도구가 초보도 복잡한 앱을 만들 수 있는 수준에 도달했다. 세 가지가 동시에 맞아떨어진 창.

### Q: 성공 기준이 뭐야?

A: 8개 스테이지를 모두 클리어하고 로비가 완전체가 되는 것. 그리고 Row와 Column의 차이를 설명 없이 알고, Material과 Cupertino의 느낌 차이를 기억하고, "다음에 진짜 앱을 만들어보고 싶다"는 생각이 드는 것. 이 앱의 궁극적 성공은 다음 앱을 만들고 싶게 만드는 것이다.

---

## The Verdict

### Forged in Steel — 강철로 단련된 것들

- **킬링 포인트의 명확성.** "3종 플랫폼 비교 + 내 튜닝값이 앱이 됨" — DartPad, Widgetbook, Flutter Gallery(아카이브됨) 어디에도 없는 조합.
- **스코프의 절제.** 8개 영역 × 1스테이지. 3종 비교는 의미 있는 3개 영역에만.
- **"0에서 1로"라는 정직한 포지셔닝.** 과대 포장 없이 감 잡기 도구로 명확히 자리매김.
- **스테이지 1의 전략적 중요성 인식.** 첫 스테이지에서 핵심 루프 검증, 여기서 쾌감 못 느끼면 전체 재고.
- **타이밍.** Flutter Gallery 아카이브 + Material/Cupertino 분리 + AI 코딩 도구 성숙.

### Needs More Heat — 더 다듬어야 할 것들

- **스플릿 뷰 구현 방식.** MaterialApp과 CupertinoApp 동시 렌더링의 구체적 기술 접근 미정. 스테이지 1 착수 전 PoC 필요.
- **인터랙션 변주의 구체화.** 영역별 변주를 잡았지만 각 실험실의 구체적 UI/플로우는 스케치 수준. 특히 "시나리오 체험"의 정의 필요.
- **발현 애니메이션의 쾌감 설계.** "게임 스킬 언락 같은 연출"의 구체적 형태 미정. 도파민 보상의 핵심이므로 가볍게 넘기면 안 됨.

### Cracks in the Foundation — 균열

- **첫 쾌감까지의 거리.** 스테이지 1까지 가는 데 로비 인프라 + 라우팅 + 데이터 저장 기반이 필요. 대응: 레이아웃 실험실만 독립적으로 먼저 동작하는 접근 고려.
- **리빌드 히트맵의 기술적 난이도.** 초보 프로젝트 범위를 넘을 수 있음. 대응: MVP에서 단순화된 "리빌드 카운터"로 대체 고려.

<!-- coaching-notes-stage-2
- Headline: B 선택 — 킬링 포인트 둘 다 담는 방향. A(감성적/짧은)보다 구체적 차별화 선호.
- Leader quote: 추상적 비전("경계를 없앤 것")보다 구체적 체감("3시간 읽기 vs 3분 만지기") 선호.
- User quote: 긴 버전 선택 — 디테일과 체험 묘사 중시.
- Problem paragraph: 일반화 vs 개인화 긴장 — PRFAQ 형식상 일반화 유지하되, 핵심 고통은 개인 체험에서 출발.
- Getting Started: Xcode 필요성을 정직하게 명시. 숨기지 않음.
-->

<!-- coaching-notes-stage-3
- Q4(초보가 이걸 만들 수 있는가)가 가장 위험한 질문. AI 코딩 도구 의존으로 방어했지만, 디버깅 시 한계 존재.
- Q2(8개로 충분한가)에 대해 "0→1" 포지셔닝으로 정직하게 답변. 과대 포장 회피.
- Q5(Xcode 장벽)는 회피 불가 — "장벽 너머의 보상이 다르다"로 리프레이밍.
- 모든 답변에서 사용자가 수정 없이 승인 — 정직한 톤이 sy님의 선호와 일치.
-->

<!-- coaching-notes-stage-4
- Q5(포기 가능성)가 핵심 리스크. 스테이지 1을 생사 결정자로 설정.
- 타임라인: 3-4주 예상 (AI 협업 전제). 7일 재설치 주기 감수.
- 빌드 순서: 로비 인프라 → 레이아웃(킬링 포인트 검증) → 데이터 저장 → 나머지.
- AI 역할 분담: AI=구현, sy=체험/미감 판단/환경 셋업.
- 기술적 리스크: 스플릿 뷰 동시 렌더링, 리빌드 히트맵.
- 성공 기준: 8스테이지 완주 + "다음 앱을 만들고 싶다"는 동기 생성.
-->
