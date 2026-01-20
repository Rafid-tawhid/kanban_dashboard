import '../models/api_response_model.dart';
import '../service/repos.dart';

class GetKanbanDataUseCase {
  final KanbanRepository repository;

  GetKanbanDataUseCase({required this.repository});

  Future<KanbanApiResponse> execute(String sectionId) async {
    return await repository.getKanbanDashboard(sectionId);
  }
}