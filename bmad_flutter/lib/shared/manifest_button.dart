import 'package:flutter/material.dart';

/// "발현하기" 액션 버튼 + 단순 스케일/페이드 연출 (FR6, FR7).
///
/// [visible]가 true일 때만 스케일/페이드 인 연출과 함께 나타나고 탭이 가능하다.
/// false면 페이드아웃 + 탭 차단으로 학습 조건 미충족 상태를 표현한다(FR6 게이팅).
/// MVP 연출은 implicit 애니메이션(스케일/페이드)만 사용한다(파티클/사운드는 Deferred).
class ManifestButton extends StatelessWidget {
  const ManifestButton({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  /// 발현 조건 충족 여부 — true일 때만 노출·활성.
  final bool visible;

  /// 발현 실행 콜백.
  final VoidCallback onPressed;

  /// 버튼 라벨 (테스트와 공유하는 단일 출처).
  static const String label = '발현하기';

  /// 등장/퇴장 연출 시간.
  static const Duration animationDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: animationDuration,
        child: AnimatedScale(
          scale: visible ? 1.0 : 0.8,
          duration: animationDuration,
          child: FilledButton.icon(
            onPressed: visible ? onPressed : null,
            icon: const Icon(Icons.auto_awesome),
            label: const Text(label),
          ),
        ),
      ),
    );
  }
}
