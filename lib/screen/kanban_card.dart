import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/kanban_entity.dart';
import 'package:google_fonts/google_fonts.dart';

// Optimized card with const constructors and RepaintBoundary
class UltraCompactKanbanCard extends StatelessWidget {
  final KanbanEntity? card;
  final int kanbanNumber;
  final bool isBlank;

  const UltraCompactKanbanCard({
    required this.card,
    required this.kanbanNumber,
    this.isBlank = false,
  });

  const UltraCompactKanbanCard.blank({required this.kanbanNumber})
      : card = null,
        isBlank = true;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          gradient: _getGradient(),
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: isBlank ? _buildBlankCard() : _buildDataCard(),
      ),
    );
  }

  LinearGradient _getGradient() {
    if (isBlank) {
      return const LinearGradient(
        colors: [Colors.orangeAccent, Colors.orange, Colors.deepOrange],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    if (card == null) {
      return const LinearGradient(
        colors: [Colors.grey, Colors.grey, Colors.grey],
      );
    }

    final scan3 = card!.scanType3 ?? 0;
    final scan4 = card!.scanType4 ?? 0;

    if (scan3 == 1 && scan4 == 0) {
      return const LinearGradient(
        colors: [Color(0xFF1E90FF), Color(0xFF007BFF), Color(0xFF0056CC)],
      );
    } else if (scan3 == 1 && scan4 == 2) {
      return const LinearGradient(
        colors: [Color(0xFFFF69B4), Color(0xFFFF00DC), Color(0xFFCC00B0)],
      );
    }

    return const LinearGradient(
      colors: [Color(0xFF32CD32), Color(0xFF28A745), Color(0xFF1E7E34)],
    );
  }

  Widget _buildBlankCard() {
    return const Center(
      child: Text(
        'REFILL',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDataCard() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('K:$kanbanNumber', style: _labelStyle),
              Text('Qty:${card?.totalProduction?.toInt() ?? 0}', style: _labelStyle),
            ],
          ),
          if (card?.buyerName?.isNotEmpty ?? false)
            Text(card!.buyerName!, style: _detailStyle, maxLines: 1),
          if (card?.buyerPO?.isNotEmpty ?? false)
            Text('PO: ${card!.buyerPO}', style: _detailStyle, maxLines: 1),
          if (card?.style?.isNotEmpty ?? false)
            Text('Style: ${card!.style}', style: _detailStyle, maxLines: 1),
          if (card?.color?.isNotEmpty ?? false)
            Text('Color: ${card!.color}', style: _detailStyle, maxLines: 1),
        ],
      ),
    );
  }

  static const _labelStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const _detailStyle = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

