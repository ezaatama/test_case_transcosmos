import 'package:test_case_transcosmos/model/surah_response.dart';
import 'package:dio/dio.dart';
import 'package:test_case_transcosmos/utils/constant.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: APIValue.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {"Content-Type": "application/json"},
  ),
);

class ApiService {
  Future<List<SurahResponse>?> getSurahs() async {
    try {
      final response = await dio.get("/surah");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => SurahResponse.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      print("Error: ${e.response?.statusCode} ${e.message}");
    }
    return null;
  }

  Future<List<SurahResponse>?> searchSurahs(String query) async {
    try {
      final response = await dio.get("/surah?search=$query");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => SurahResponse.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      print("Error: ${e.response?.statusCode} ${e.message}");
    }
    return null;
  }
}
