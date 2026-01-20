import '../models/api_response_model.dart';
import '../screen/use_case.dart';
import '../service/api_call.dart';
import '../service/data_source.dart';
import '../service/kanban_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../service/repos.dart';


//final sectionProvider = StateProvider<String?>((ref) => null);
final sectionProvider = StateProvider<String>((ref) => 'Section A');

final kanbanDataProvider = FutureProvider.autoDispose
    .family<KanbanApiResponse, String>((ref, sectionId) async {
  final useCase = ref.watch(getKanbanDataUseCaseProvider);
  return await useCase.execute(sectionId);
});

final getKanbanDataUseCaseProvider = Provider<GetKanbanDataUseCase>((ref) {
  final repository = ref.watch(kanbanRepositoryProvider);
  return GetKanbanDataUseCase(repository: repository);
});

final kanbanRepositoryProvider = Provider<KanbanRepository>((ref) {
  final dataSource = ref.watch(kanbanDataSourceProvider);
  return KanbanRepositoryImpl(dataSource: dataSource);
});

final kanbanDataSourceProvider = Provider<KanbanDataSource>((ref) {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  return KanbanDataSourceImpl(dio: dio);
});

final autoRefreshProvider = StateProvider<bool>((ref) => true);

final lastUpdatedProvider = StateProvider<DateTime>((ref) => DateTime.now());