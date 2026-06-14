import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/models/stage_id.dart';
import '../core/state/museum_state.dart';
import '../shared/stage_lab_screen.dart';

/// 8개 전시실 내비게이션 + 순차 잠금 UI (FR2, FR3, FR4).
///
/// [MuseumState]를 구독해 각 스테이지의 잠금/열림/클리어 상태를 렌더한다.
/// 열린 항목만 탭 가능하며, 잠긴 항목은 진입이 차단된다(상태 기반 진입 가드).
class ExhibitionNav extends StatelessWidget {
  const ExhibitionNav({super.key});

  static const String sectionTitle = '전시실';
  static const String lockedHint = '이전 전시실을 클리어하면 열립니다';
  static const String clearedHint = '클리어 완료';
  static const String openHint = '입장 가능';

  @override
  Widget build(BuildContext context) {
    final MuseumState state = context.watch<MuseumState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            sectionTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        for (final StageId stage in StageId.values)
          _ExhibitionTile(stage: stage, state: state),
      ],
    );
  }
}

class _ExhibitionTile extends StatelessWidget {
  const _ExhibitionTile({required this.stage, required this.state});

  final StageId stage;
  final MuseumState state;

  @override
  Widget build(BuildContext context) {
    final bool cleared = state.isCleared(stage);
    final bool unlocked = state.isUnlocked(stage);

    final IconData leading;
    final String subtitle;
    if (cleared) {
      leading = Icons.check_circle;
      subtitle = ExhibitionNav.clearedHint;
    } else if (unlocked) {
      leading = Icons.science_outlined;
      subtitle = ExhibitionNav.openHint;
    } else {
      leading = Icons.lock;
      subtitle = ExhibitionNav.lockedHint;
    }

    return ListTile(
      enabled: unlocked,
      leading: Icon(leading),
      title: Text(stage.label),
      subtitle: Text(subtitle),
      onTap: unlocked
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => StageLabScreen(stageId: stage),
                ),
              );
            }
          : null,
    );
  }
}
