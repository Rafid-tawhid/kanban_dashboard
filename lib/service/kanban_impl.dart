import 'package:kanban_dashboard/service/repos.dart';

import '../models/api_response_model.dart';
import 'data_source.dart';

class KanbanRepositoryImpl implements KanbanRepository {
  final KanbanDataSource dataSource;

  KanbanRepositoryImpl({required this.dataSource});

  @override
  Future<KanbanApiResponse> getKanbanDashboard(String sectionId) async {
    try {
      final response = await dataSource.fetchKanbanData(sectionId);
      return KanbanApiResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load kanban data: $e');
    }
  }
}