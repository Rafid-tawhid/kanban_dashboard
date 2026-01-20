import '../models/api_response_model.dart';

abstract class KanbanRepository {
  Future<KanbanApiResponse> getKanbanDashboard(String sectionId);
}