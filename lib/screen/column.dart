import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/kanban_entity.dart';
import 'kanban_card.dart';

class CompactLineColumn extends StatelessWidget {
  final String lineName;
  final List<KanbanEntity> cards;

  const CompactLineColumn({
    Key? key,
    required this.lineName,
    required this.cards,
  }) : super(key: key);

  Map<String, KanbanEntity> _createCardMap() {
    final map = <String, KanbanEntity>{};
    for (final card in cards) {
      if (card.totalProduction != null && card.totalProduction! > 0) {
        map[card.kanbanType ?? ''] = card;
      }
    }
    return map;
  }

  // Helper method to determine card type
  String _getCardType(KanbanEntity? card) {
    if (card == null) return 'refill'; // Blank/Refill

    final scan3 = card.scanType3 ?? 0;
    final scan4 = card.scanType4 ?? 0;

    if (scan3 == 1 && scan4 == 2) return 'pink'; // Output
    if (scan3 == 1 && scan4 == 0) return 'blue'; // Line-Input
    return 'green'; // Kanban-Ready
  }

  @override
  Widget build(BuildContext context) {
    final cardMap = _createCardMap();

    // Create list of positions 1-5 with their cards
    final List<MapEntry<int, KanbanEntity?>> positions = List.generate(5, (index) {
      final kanbanType = '${index + 1}';
      final card = cardMap['Kanban-${index + 1}'];
      return MapEntry(index + 1, card);
    });

    // Sort positions according to priority:
    // 1. Refill (blank cards) - TOP
    // 2. Pink cards (Output) - sort by quantity ascending
    // 3. Blue cards (Line-Input) - sort by quantity ascending
    // 4. Green cards (Ready) - BOTTOM
    positions.sort((a, b) {
      final cardA = a.value;
      final cardB = b.value;

      final typeA = _getCardType(cardA);
      final typeB = _getCardType(cardB);

      // Refill always on top
      if (typeA == 'refill' && typeB != 'refill') return -1;
      if (typeA != 'refill' && typeB == 'refill') return 1;

      // Both are refill - keep original order
      if (typeA == 'refill' && typeB == 'refill') return 0;

      // Pink comes before Blue
      if (typeA == 'pink' && typeB == 'blue') return -1;
      if (typeA == 'blue' && typeB == 'pink') return 1;

      // Pink cards - sort by quantity ascending
      if (typeA == 'pink' && typeB == 'pink') {
        final qtyA = cardA?.totalProduction?.toInt() ?? 0;
        final qtyB = cardB?.totalProduction?.toInt() ?? 0;
        return qtyA.compareTo(qtyB);
      }

      // Blue cards - sort by quantity ascending
      if (typeA == 'blue' && typeB == 'blue') {
        final qtyA = cardA?.totalProduction?.toInt() ?? 0;
        final qtyB = cardB?.totalProduction?.toInt() ?? 0;
        return qtyA.compareTo(qtyB);
      }

      // Green cards go to bottom, no specific order needed
      if (typeA == 'green' && typeB != 'green') return 1;
      if (typeA != 'green' && typeB == 'green') return -1;

      return 0;
    });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Line Header - Ultra Compact
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 0),
            decoration: BoxDecoration(
              color: Colors.blue[900]!.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
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

          // Cards Container
          Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
            child: Column(
              children: positions.map((entry) {
                final kanbanNumber = entry.key;
                final card = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: SizedBox(
                    height: 86, // Very compact height
                    child: card != null
                        ? UltraCompactKanbanCard(
                      card: card,
                      kanbanNumber: kanbanNumber,
                    )
                        : UltraCompactKanbanCard(
                      kanbanNumber: kanbanNumber,
                      isBlank: true,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}