import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, Response, FormData;
import '../../../core/constants/api_endpoints.dart';

class ApiService extends GetxService {
  late Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  /// POST multipart image to HuggingFace Skin Lesion API
  Future<SkinLesionResult?> predictSkinLesion(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'image.jpg',
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.skinLesionPredict,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['error'] != null) {
          throw data['error'].toString();
        }
        return SkinLesionResult.fromMap(data);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
    return null;
  }

  /// POST multipart image to HuggingFace Chest X-Ray API
  Future<ChestXRayResult?> predictChestXRay(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'image.jpg',
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.chestXRayPredict,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['error'] != null) {
          throw data['error'].toString();
        }
        return ChestXRayResult.fromMap(data);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
    return null;
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network and try again.';
      case DioExceptionType.badResponse:
        // Try to extract human-readable error from response body
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic> && responseData['error'] != null) {
          return responseData['error'].toString();
        }
        return 'Server error (${e.response?.statusCode}). Please try again later.';
      default:
        return 'Network error. Please check your connection and try again.';
    }
  }
}

// ─── Disease entry (shared between both models) ─────────────────────────────

class DiseaseEntry {
  final String label;
  final double confidence;

  DiseaseEntry({required this.label, required this.confidence});

  factory DiseaseEntry.fromMap(Map<String, dynamic> map) {
    return DiseaseEntry(
      label: map['label'] ?? 'Unknown',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get confidencePercent => '${(confidence * 100).toStringAsFixed(1)}%';
}

// ─── Skin Lesion Result ─────────────────────────────────────────────────────

class SkinLesionResult {
  final String prediction;
  final double confidence;
  final List<DiseaseEntry> allClasses;

  SkinLesionResult({
    required this.prediction,
    required this.confidence,
    required this.allClasses,
  });

  factory SkinLesionResult.fromMap(Map<String, dynamic> map) {
    final allClassesRaw = map['all_classes'] as List<dynamic>? ?? [];
    return SkinLesionResult(
      prediction: map['prediction'] ?? 'Unknown',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
      allClasses: allClassesRaw
          .map((e) => DiseaseEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String get confidencePercent => '${(confidence * 100).toStringAsFixed(1)}%';
}

// ─── Chest X-Ray Result ─────────────────────────────────────────────────────

class ChestXRayResult {
  final List<DiseaseEntry> detectedDiseases;
  final List<DiseaseEntry> allClasses;

  ChestXRayResult({
    required this.detectedDiseases,
    required this.allClasses,
  });

  factory ChestXRayResult.fromMap(Map<String, dynamic> map) {
    final detected = map['detected_diseases'] as List<dynamic>? ?? [];
    final all = map['all_classes'] as List<dynamic>? ?? [];
    return ChestXRayResult(
      detectedDiseases: detected
          .map((e) => DiseaseEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
      allClasses: all
          .map((e) => DiseaseEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
