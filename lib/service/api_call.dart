import 'package:flutter/cupertino.dart';

import 'data_source.dart';
import 'package:dio/dio.dart';

class KanbanDataSourceImpl implements KanbanDataSource {
  final Dio dio;

  KanbanDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> fetchKanbanData(String sectionId) async {

    debugPrint('This is calling API with SectionId: $sectionId');
    final response = await dio.get(
      'http://202.74.243.118:8090/api/support/KanbanDashboard',
      queryParameters: {'SectionId': sectionId},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}