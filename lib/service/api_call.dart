import 'package:flutter/cupertino.dart';
import 'data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class KanbanDataSourceImpl implements KanbanDataSource {
  final Dio dio;

  KanbanDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> fetchKanbanData(String sectionId) async {
    debugPrint('Fetching API with SectionId: $sectionId');

    final response = await dio.get(
      'http://202.74.243.118:8090/api/support/KanbanDashboard',
      queryParameters: {'SectionId': sectionId},
      options: Options(
        sendTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        // Enable gzip compression
        headers: {
          'Accept-Encoding': 'gzip, deflate',
          'Accept': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}