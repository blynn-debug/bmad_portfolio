/// 8개 전시실(스테이지) 식별자 (FR2).
///
/// 선언 순서가 곧 순차 잠금 순서다 — 직전 스테이지를 클리어해야 다음이 열린다.
/// 식별/직렬화는 항상 [StageId]와 `.name`을 사용한다(인덱스/문자열 하드코딩 금지).
enum StageId {
  layout,
  component,
  animation,
  state,
  gesture,
  notification,
  security,
  storage,
}

/// 로비 표시용 한국어 라벨.
extension StageIdLabel on StageId {
  String get label {
    switch (this) {
      case StageId.layout:
        return '레이아웃';
      case StageId.component:
        return '컴포넌트';
      case StageId.animation:
        return '애니메이션';
      case StageId.state:
        return '상태관리';
      case StageId.gesture:
        return '제스처';
      case StageId.notification:
        return '알림';
      case StageId.security:
        return '보안';
      case StageId.storage:
        return '데이터 저장';
    }
  }
}
