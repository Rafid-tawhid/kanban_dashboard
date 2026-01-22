import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/kanban_entity.dart';
import '../riverpod/riverpod.dart';
import 'column.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


class KanbanTvDashboard extends ConsumerStatefulWidget {
  const KanbanTvDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<KanbanTvDashboard> createState() => _KanbanTvDashboardState();
}

class _KanbanTvDashboardState extends ConsumerState<KanbanTvDashboard> {
  Timer? _autoRefreshTimer;
  DateTime? _nextRefreshTime;
  final int _refreshSeconds = 10;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _calculateNextRefresh();
    _startAutoRefresh();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WakelockPlus.enable();
    }
  }


  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    WakelockPlus.disable(); // turn off when screen is gone
    super.dispose();
  }

  void _calculateNextRefresh() {
    _nextRefreshTime = DateTime.now().add(Duration(seconds: _refreshSeconds));
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(
        Duration(seconds: _refreshSeconds),
            (_) {
          final sectionId = ref.read(sectionProvider);
          ref.refresh(kanbanDataProvider(sectionId));
          _calculateNextRefresh();
          setState(() {});
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionId = ref.watch(sectionProvider);
    final screenSize = MediaQuery.of(context).size;
    //
    return Scaffold(
      backgroundColor: Colors.white, // Very dark background
      body: Stack(
        children: [
          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Compact Header
              _buildHeader(),

              // Main Board with 8 columns max
              Expanded(
                child: _buildKanbanBoard(sectionId, screenSize),
              ),
            ],
          ),

          // Refresh Time (top right corner)


          // Loading Indicator (top left corner)
          _buildLoadingIndicator(),

          // Current Time (bottom right corner)
          //_buildCurrentTime(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 40, // Very compact header
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Center(
              child: Text(
                'KANBAN DASHBOARD - SECTION A',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 1.5,
                  shadows: [

                  ],
                ),
              ),
            ),
          ),

          // Legend Dots - Very small
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
             // color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildLegendDot(const Color(0xFF28A745), 'Ready'),
                const SizedBox(width: 6),
                _buildLegendDot(const Color(0xFF007BFF), 'Input'),
                const SizedBox(width: 6),
                _buildLegendDot(const Color(0xFFFF00DC), 'Output'),
                const SizedBox(width: 6),
                _buildLegendDot(const Color(0xFFFFD700), 'Refill'),
              ],
            ),
          ),
          _buildRefreshInfo(),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildKanbanBoard(String sectionId, Size screenSize) {
    final kanbanAsync = ref.watch(kanbanDataProvider(sectionId));

    return kanbanAsync.when(
      data: (data) {
        if (data.returnValue.isEmpty) {
          return _buildEmptyState();
        }

        // Group by LineName
        final groupedData = <String, List<KanbanEntity>>{};
        for (final item in data.returnValue) {
          final lineName = item.lineName ?? 'L';
          groupedData.putIfAbsent(lineName, () => []).add(item);
        }

        final lineCount = groupedData.length;
        final columnsPerRow = 8; // Fixed 8 columns per row
        final lineWidth = (screenSize.width - 6) / columnsPerRow; //changed here decrease margin

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: lineCount > columnsPerRow
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groupedData.entries.map((entry) {
              return SizedBox(
                // width: lineWidth-4,
                width: lineWidth, // Account for margins
                child: CompactLineColumn(
                  lineName: entry.key,
                  cards: entry.value,
                ),
              );
            }).toList(),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.orange,
              ),
              const SizedBox(height: 10),
              Text(
                'Error Loading',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.grid_off,
            size: 50,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 10),
          Text(
            'NO DATA',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshInfo() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (_nextRefreshTime == null) return const SizedBox();

        final now = DateTime.now();
        final remaining = _nextRefreshTime!.difference(now).inSeconds;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.refresh,
                size: 12,
                color: Colors.blue,
              ),
              const SizedBox(width: 4),
              Text(
                '${remaining}s',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    final kanbanAsync = ref.watch(kanbanDataProvider('Section A'));

    return Positioned(
      top: 8,
      left: 8,
      child: Visibility(
        visible: kanbanAsync.isLoading,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.refresh,
            size: 14,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTime() {
    return Positioned(
      bottom: 4,
      right: 4,
      child: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              DateFormat('HH:mm').format(DateTime.now()),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}