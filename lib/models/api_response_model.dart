import 'kanban_entity.dart';

class KanbanApiResponse {
  final String output;
  final List<KanbanEntity> returnValue;

  KanbanApiResponse({
    required this.output,
    required this.returnValue,
  });

  factory KanbanApiResponse.fromJson(Map<String, dynamic> json) {
    final output = json['output'] ?? json['Output'] ?? '';
    final returnValue = json['returnvalue'] ?? json['ReturnValue'] ?? [];

    return KanbanApiResponse(
      output: output.toString(),
      returnValue: (returnValue as List)
          .map((item) => KanbanEntity.fromJson(item))
          .toList(),
    );
  }
}