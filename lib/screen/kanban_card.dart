import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/kanban_entity.dart';
import 'package:google_fonts/google_fonts.dart';

class UltraCompactKanbanCard extends StatelessWidget {
  final KanbanEntity? card;
  final int kanbanNumber;
  final bool isBlank;

  const UltraCompactKanbanCard({
    Key? key,
    this.card,
    required this.kanbanNumber,
    this.isBlank = false,
  }) : super(key: key);

  Color _getCardColor() {
    if (isBlank) return Colors.orangeAccent;
    if (card == null) return Colors.grey[700]!;

    final scan3 = card!.scanType3 ?? 0;
    final scan4 = card!.scanType4 ?? 0;

    if (scan3 == 1 && scan4 == 0) {
      return const Color(0xFF007BFF); // Blue for Line-Input
    } else if (scan3 == 1 && scan4 == 2) {
      return const Color(0xFFFF00DC); // Pink/Gold for Output
    }

    return const Color(0xFF28A745); // Green for Kanban-Ready
  }
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: isBlank ? _buildBlankCard() : _buildDataCard(),
    );
  }

  Widget _buildBlankCard() {
    return Center(
      child: Text(
        'K :$kanbanNumber Refill',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDataCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Header row with Kanban number and quantity
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       'K:$kanbanNumber',
          //       style: GoogleFonts.roboto(
          //         fontSize: 13,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //         letterSpacing: 1,
          //       ),
          //     ),
          //     const Spacer(),
          //     Text(
          //       'Qty: ${card?.totalProduction?.toInt() ?? 0}',
          //       style: GoogleFonts.roboto(
          //         fontSize: 13,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //         letterSpacing: 1.2,
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // K: part — shrinks if needed
                Text(
                'K:$kanbanNumber',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: 13
                ),
              ),

              Spacer(),// small gap

              // Qty part — takes remaining space
              Text(
                'Qty: ${card?.totalProduction?.toInt() ?? 0}',
                maxLines: 1,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: 13
                ),
              ),
            ],
          ),



          // Buyer Name
          if (card?.buyerName?.isNotEmpty ?? false)
            Text(
              _truncateText(card!.buyerName!, 16),
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

          // PO
          if (card?.buyerPO?.isNotEmpty ?? false)
            Text(
              'PO: ${_truncateText(card!.buyerPO!, 16)}',
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

          // Style - Allow 2 lines if needed
          if (card?.style?.isNotEmpty ?? false)
            SizedBox(
              height: 16, // Fixed height for 2 lines
              child: Text(
                'Style: ${card!.style}',
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
                maxLines: 2, // Allow 2 lines
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Color
          if (card?.color?.isNotEmpty ?? false)
            Text(
              'Color: ${_truncateText(card!.color!, 16)}',
              style: const TextStyle(
                fontSize: 8,
                color: Colors.white,
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength);
  }
}