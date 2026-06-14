import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/stage_id.dart';
import '../../core/state/museum_state.dart';

/// 로비 발현물 영역 (FR6).
///
/// 발현(클리어)된 스테이지마다 발현물 카드를 누적 렌더해 "발현 파이프라인"이
/// 로비에 반영됨을 보여준다. 아직 아무것도 발현되지 않았으면 빈 상태 안내를
/// 표시한다.
///
/// 스테이지별 **실제** 발현물 위젯(골격/버튼·카드/전환 애니메이션 등)은 각 스테이지
/// 발현 스토리(1.5/1.7/2.x...)에서 도입된다 — 이 위젯은 제네릭 발현물 카드까지만
/// 담당한다.
class LobbyManifestations extends StatelessWidget {
  const LobbyManifestations({super.key});

  /// 발현물이 아직 없는 빈 상태에서 보여줄 안내 문구.
  static const String emptyStateMessage = '실험실을 클리어하면 이곳에 전시실이 발현됩니다';

  /// 발현물 카드의 부제 문구.
  static const String manifestedLabel = '발현됨';

  @override
  Widget build(BuildContext context) {
    final MuseumState state = context.watch<MuseumState>();
    final List<StageId> manifested = <StageId>[
      for (final StageId stage in StageId.values)
        if (state.isCleared(stage)) stage,
    ];

    if (manifested.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Icon(Icons.museum_outlined, size: 64),
            SizedBox(height: 16),
            Text(
              emptyStateMessage,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (final StageId stage in manifested)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.auto_awesome),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            stage.label,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(manifestedLabel),
                          // 발현된 튜닝값이 있으면 값에 비례하는 지표를 표시(FR12).
                          // 재발현 시 값이 갱신되면 지표도 재반영된다(FR14).
                          if (state.tuningValue(stage) != null)
                            _TuningIndicator(
                              stage: stage,
                              value: state.tuningValue(stage)!,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 발현된 튜닝값을 로비에 시각화하는 지표 — 값 비례 바 + 퍼센트 (FR12, FR14).
class _TuningIndicator extends StatelessWidget {
  const _TuningIndicator({required this.stage, required this.value});

  final StageId stage;
  final double value;

  /// 값 비례 바의 최대 너비.
  static const double maxBarWidth = 120;

  @override
  Widget build(BuildContext context) {
    final int percent = (value * 100).round();
    return Padding(
      key: Key('manifest_tuning_${stage.name}'),
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: <Widget>[
          Container(
            width: maxBarWidth * value.clamp(0.0, 1.0),
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '튜닝 $percent%',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
