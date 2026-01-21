import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/kanban_entity.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
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

  // Get gradient colors for better visibility
  List<Color> _getCardGradient() {
    if (isBlank) {
      // Orange with high contrast gradient
      return [
        Colors.orangeAccent,
        Colors.orange.shade700,
        Colors.orange.shade800,
      ];
    }

    if (card == null) {
      // Grey with more contrast
      return [
        Colors.grey.shade600,
        Colors.grey.shade800,
        Colors.grey.shade900,
      ];
    }

    final scan3 = card!.scanType3 ?? 0;
    final scan4 = card!.scanType4 ?? 0;

    if (scan3 == 1 && scan4 == 0) {
      // Blue for Line-Input - enhanced contrast
      return [
        const Color(0xFF1E90FF), // Bright Dodger Blue
        const Color(0xFF007BFF), // Your original blue
        const Color(0xFF0056CC),  // Darker blue for depth
      ];
    } else if (scan3 == 1 && scan4 == 2) {
      // Pink/Gold for Output - more vibrant
      return [
        const Color(0xFFFF69B4), // Hot pink
        const Color(0xFFFF00DC), // Your original pink
        const Color(0xFFCC00B0), // Deeper pink
      ];
    }

    // Green for Kanban-Ready - brighter shades
    return [
      const Color(0xFF32CD32), // Lime green
      const Color(0xFF28A745), // Your original green
      const Color(0xFF1E7E34), // Forest green
    ];
  }

  // Get border color for better definition
  Color _getBorderColor() {
    final colors = _getCardGradient();
    // Use lightest color for border or white for high contrast
    if (isBlank) return Colors.orange.shade100;
    if (card == null) return Colors.grey.shade400;

    // Add subtle border based on card type
    final scan3 = card!.scanType3 ?? 0;
    final scan4 = card!.scanType4 ?? 0;

    if (scan3 == 1 && scan4 == 0) {
      return Colors.lightBlueAccent.shade100;
    } else if (scan3 == 1 && scan4 == 2) {
      return Colors.pink.shade100;
    }
    return Colors.lightGreenAccent.shade100;
  }

  // Get text color with better contrast
  Color _getTextColor() {
    // Always use white for maximum contrast on colored backgrounds
    return Colors.white;
  }

  // Add a subtle highlight for 3D effect
  Color _getHighlightColor() {
    final colors = _getCardGradient();
    return colors.first.withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getCardGradient();
    final borderColor = _getBorderColor();
    final textColor = _getTextColor();
    final highlightColor = _getHighlightColor();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(4), // Slightly larger radius
        border: Border.all(
          color: borderColor,
          width: 1.0, // Add border for definition
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 3,
            offset: const Offset(0, 2),
            spreadRadius: 0.5,
          ),
          // Inner shadow for depth
          BoxShadow(
            color: highlightColor,
            blurRadius: 1,
            offset: const Offset(0, -1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradientColors.first.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
          child: isBlank ? _buildBlankCard(textColor) : _buildDataCard(textColor),
        ),
      ),
    );
  }

  Widget _buildBlankCard(Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          'K:$kanbanNumber\nREFILL',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w900, // Extra bold for visibility
            color: textColor,
            letterSpacing: 1.2,
            height: 1.1,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCard(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Header row with Kanban number and quantity - more compact
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'K:$kanbanNumber',
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: GoogleFonts.roboto(
                  fontSize: 14, // Slightly smaller for more space
                  fontWeight: FontWeight.w900, // Extra bold
                  color: textColor,
                  letterSpacing: 0.8,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 1,
                      offset: const Offset(0.5, 0.5),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  'Qty:${card?.totalProduction?.toInt() ?? 0}',
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    letterSpacing: 0.8,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 1,
                        offset: const Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2,),
          // Buyer Name - if available
          if (card?.buyerName?.isNotEmpty ?? false)
            _buildDataRow(
              text: card!.buyerName!,
              maxLength: 20,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              textColor: textColor,
            ),

          // PO - if available
          if (card?.buyerPO?.isNotEmpty ?? false)
            _buildDataRow(
              text: 'PO: ${card!.buyerPO!}',
              maxLength: 20,
              fontSize: 8,
              fontWeight: FontWeight.w700,
              textColor: textColor,
            ),

          // Style - Allow 2 lines if needed
          if (card?.style?.isNotEmpty ?? false)
            SizedBox(
              height: 16,
              child: Text(
                'Style: ${card!.style}',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1.0,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 1,
                      offset: const Offset(0.3, 0.3),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Color
          if (card?.color?.isNotEmpty ?? false)
            _buildDataRow(
              text: 'Color: ${card!.color!}',
              maxLength: 20,
              fontSize: 8,
              fontWeight: FontWeight.w600,
              textColor: textColor,
            ),
        ],
      ),
    );
  }

  Widget _buildDataRow({
    required String text,
    required int maxLength,
    required double fontSize,
    required FontWeight fontWeight,
    required Color textColor,
  }) {
    return Text(
      _truncateText(text, maxLength),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,

        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1,
            offset: const Offset(0.3, 0.3),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 1)}…';
  }
}

