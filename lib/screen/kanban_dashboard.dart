import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/api_response_model.dart';
import '../models/kanban_entity.dart';
import '../riverpod/riverpod.dart';
import 'column.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class KanbanTvDashboard extends ConsumerStatefulWidget {
  const KanbanTvDashboard({super.key});

  @override
  ConsumerState<KanbanTvDashboard> createState() => _KanbanTvDashboardState();
}

class _KanbanTvDashboardState extends ConsumerState<KanbanTvDashboard> {
  Timer? _autoRefreshTimer;
  static const int _refreshSeconds = 10;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(
      const Duration(seconds: _refreshSeconds),
          (_) => _refreshData(),
    );
  }

  Future<void> _refreshData() async {
    final sectionId = ref.read(sectionProvider);

    // Set loading state to true
    ref.read(isRefreshingProvider.notifier).state = true;

    try {
      // Force refresh
      ref.invalidate(kanbanDataProvider(sectionId));
      ref.read(lastUpdatedProvider.notifier).state = DateTime.now();

      // Wait for the data to be fetched
      await ref.read(kanbanDataProvider(sectionId).future);
    } finally {
      // Set loading state back to false after a short delay to ensure UI updates
      await Future.delayed(const Duration(milliseconds: 300));
      ref.read(isRefreshingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionId = ref.watch(sectionProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: _KanbanBoard(sectionId: sectionId),
          ),
        ],
      ),
    );
  }
}

// Extracted header - won't rebuild on data changes
class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoRefresh = ref.watch(autoRefreshProvider);
    final isRefreshing = ref.watch(isRefreshingProvider);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'KANBAN DASHBOARD - SECTION A',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const _LegendDots(),
          const SizedBox(width: 8),

          // Show refresh icon when API is calling
          if (isRefreshing)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          else
            const Icon(
              Icons.refresh,
              size: 16,
              color: Colors.grey,
            ),

          const SizedBox(width: 8),
          _AutoRefreshToggle(autoRefresh: autoRefresh),
        ],
      ),
    );
  }
}

// Board with selective rebuilding
class _KanbanBoard extends ConsumerWidget {
  final String sectionId;

  const _KanbanBoard({required this.sectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanbanAsync = ref.watch(kanbanDataProvider(sectionId));

    return kanbanAsync.when(
      data: (data) => _KanbanContent(data: data),
      loading: () => const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, _) => const Center(
        child: Text('Error loading data', style: TextStyle(color: Colors.red)),
      ),
    );
  }
}

// Content with change detection
class _KanbanContent extends StatefulWidget {
  final KanbanApiResponse data;

  const _KanbanContent({required this.data});

  @override
  State<_KanbanContent> createState() => _KanbanContentState();
}

class _KanbanContentState extends State<_KanbanContent> {
  // Cache grouped data
  List<MapEntry<String, List<KanbanEntity>>>? _cachedLines;

  @override
  void didUpdateWidget(_KanbanContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only regroup if data actually changed
    if (oldWidget.data != widget.data) {
      _cachedLines = null;
    }
  }

  List<MapEntry<String, List<KanbanEntity>>> get _lines {
    if (_cachedLines != null) return _cachedLines!;

    final groupedData = <String, List<KanbanEntity>>{};
    for (final item in widget.data.returnValue) {
      final lineName = item.lineName ?? 'L';
      groupedData.putIfAbsent(lineName, () => []).add(item);
    }
    _cachedLines = groupedData.entries.toList();
    return _cachedLines!;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.returnValue.isEmpty) {
      return const Center(child: Text('NO DATA'));
    }

    final lines = _lines;

    return LayoutBuilder(
      builder: (context, constraints) {
        final lineWidth = (constraints.maxWidth - 6) / lines.length;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          cacheExtent: 1000,
          itemCount: lines.length,
          itemBuilder: (context, index) {
            return SizedBox(
              width: lineWidth,
              child: CompactLineColumn(
                lineName: lines[index].key,
                cards: lines[index].value,
              ),
            );
          },
        );
      },
    );
  }
}







// Legend components
class _LegendDots extends StatelessWidget {
  const _LegendDots();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _LegendDot(color: Color(0xFF28A745), label: 'Ready'),
        SizedBox(width: 6),
        _LegendDot(color: Color(0xFF007BFF), label: 'Input'),
        SizedBox(width: 6),
        _LegendDot(color: Color(0xFFFF00DC), label: 'Output'),
        SizedBox(width: 6),
        _LegendDot(color: Colors.orange, label: 'Refill'),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

// Auto-refresh toggle button
class _AutoRefreshToggle extends ConsumerWidget {
  final bool autoRefresh;

  const _AutoRefreshToggle({required this.autoRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(autoRefreshProvider.notifier).state = !autoRefresh,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: autoRefresh ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          autoRefresh ? 'Auto' : 'Manual',
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      ),
    );
  }
}