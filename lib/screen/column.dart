import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/kanban_entity.dart';
import 'kanban_card.dart';

// Optimized column with memoization
class CompactLineColumn extends StatelessWidget {
  final String lineName;
  final List<KanbanEntity> cards;

  const CompactLineColumn({
    required this.lineName,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final positions = _getSortedPositions();

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LineHeader(lineName: lineName),
            ...positions.map((pos) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: SizedBox(
                height: 86,
                child: pos.value != null
                    ? UltraCompactKanbanCard(
                  card: pos.value!,
                  kanbanNumber: pos.key,
                )
                    : const UltraCompactKanbanCard.blank(kanbanNumber: 0),
              ),
            )),
          ],
        ),
      ),
    );
  }

  List<MapEntry<int, KanbanEntity?>> _getSortedPositions() {
    final cardMap = <String, KanbanEntity>{};
    for (final card in cards) {
      if ((card.totalProduction ?? 0) > 0) {
        final type = card.kanbanType ?? '';
        if (type.isNotEmpty) {
          cardMap[type] = card;
        }
      }
    }

    final positions = List.generate(5, (index) {
      final card = cardMap['Kanban-${index + 1}'];
      return MapEntry(index + 1, card);
    });

    positions.sort((a, b) {
      final priorityA = _getCardPriority(a.value);
      final priorityB = _getCardPriority(b.value);

      if (priorityA != priorityB) return priorityA.compareTo(priorityB);

      if (priorityA <= 2) {
        final qtyA = a.value?.totalProduction?.toInt() ?? 0;
        final qtyB = b.value?.totalProduction?.toInt() ?? 0;
        return qtyA.compareTo(qtyB);
      }
      return 0;
    });

    return positions;
  }

  int _getCardPriority(KanbanEntity? card) {
    if (card == null) return 0;
    final scan3 = card.scanType3 ?? 0;
    final scan4 = card.scanType4 ?? 0;

    if (scan3 == 1 && scan4 == 2) return 1;
    if (scan3 == 1 && scan4 == 0) return 2;
    return 3;
  }
}




// Line header with const
class _LineHeader extends StatelessWidget {
  final String lineName;

  const _LineHeader({required this.lineName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2),
        color: Colors.blue[800],
        child: Center(
          child: Text(
            lineName,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}