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

  @override
  Widget build(BuildContext context) {
    final cardMap = _createCardMap();

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
            padding: const EdgeInsets.symmetric(vertical:  0),
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
            padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 1),
            child: Column(
              children: List.generate(5, (index) {
                final kanbanType =
                    '${index + 1}'; // Just the number: 1, 2, 3, 4, 5
                final card = cardMap['Kanban-${index + 1}'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: SizedBox(
                    height: 86, // Very compact height
                    child: card != null
                        ? UltraCompactKanbanCard(
                            card: card,
                            kanbanNumber: index + 1,
                          )
                        : UltraCompactKanbanCard(
                            kanbanNumber: index + 1,
                            isBlank: true,
                          ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
