import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../../../core/constants/api_endpoints.dart';

class BioMistralService extends GetxService {
  late Dio _dio;
  late String _apiToken;

  // System prompt for MedicalGPT
  static const String _systemPrompt =
      '''You are MedicalGPT, an intelligent medical assistant built by Dhruv Chotai. You are part of an integrated healthcare AI platform that consists of the following specialized models:

1. MedicalGPT (You): Answer medical questions, explain diagnoses, symptoms, treatments, and help users understand their health reports and AI-generated outputs from other models in this platform.

2. Chest X-Ray Disease Detection Model: Users can upload chest X-ray images to detect diseases like pneumonia, tuberculosis, pleural effusion, cardiomegaly, and more. If a user asks about their chest X-ray result, explain what the detected disease means, its causes, symptoms, and recommended next steps.

3. Skin Lesion Classification Model: Users can upload images of skin lesions to classify conditions like melanoma, nevus, dermatitis, and other dermatological conditions. If a user asks about their skin lesion result, explain what the classification means in simple terms.

When users ask about outputs from the Chest X-Ray or Skin Lesion models, your job is to explain those results clearly so the user understands what it means for their health.

Always respond responsibly. Never replace professional medical advice. Recommend consulting a doctor for serious concerns.''';

  @override
  void onInit() {
    super.onInit();
    _apiToken = dotenv.env['HF_TOKEN'] ?? '';
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  /// Send a medical query via HuggingFace Router using Llama-3.1
  /// Note: BioMistral is not supported on the free router, so we use Llama-3.1 which acts as an excellent medical assistant with our custom system prompt.
  Future<String> askMedicalQuery(String userMessage) async {
    if (_apiToken.isEmpty || _apiToken == 'your_huggingface_token_here') {
      return 'HuggingFace API token is not configured. '
          'Please add your token to the .env file as HF_TOKEN=hf_your_token';
    }

    try {
      final response = await _dio.post(
        ApiEndpoints.bioMistralChat,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiToken',
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode({
          'model': 'meta-llama/Llama-3.1-8B-Instruct',
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'max_tokens': 512,
          'temperature': 0.7,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // OpenAI-compatible response format
        if (data is Map<String, dynamic>) {
          final choices = data['choices'] as List<dynamic>?;
          if (choices != null && choices.isNotEmpty) {
            final message = choices[0]['message'] as Map<String, dynamic>?;
            final content = message?['content']?.toString().trim() ?? '';
            if (content.isNotEmpty) {
              return content;
            }
          }
        }
        return 'No response received from the model.';
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return 'An error occurred while connecting to the AI model. '
          'Please try again later.\n\nDetails: $e';
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'The request timed out. The model may be loading — '
            'please try again in a moment.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network and try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 503) {
          return 'The model is currently loading. '
              'This can take up to a minute on the first request. '
              'Please try again shortly.';
        }
        if (statusCode == 401) {
          return 'Invalid HuggingFace API token. '
              'Please check your HF_TOKEN in the .env file.';
        }
        if (statusCode == 429) {
          return 'Rate limit exceeded. Please wait a moment before trying again.';
        }
        if (statusCode == 404) {
          return 'The selected model is currently unavailable on HuggingFace. '
              'Please try again later.';
        }
        // Try to extract error message from response body
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic> &&
            responseData['error'] != null) {
          final errorMsg = responseData['error'];
          if (errorMsg is Map) {
            return 'Model Error: ${errorMsg['message'] ?? errorMsg}';
          }
          return 'Model Error: $errorMsg';
        }
        return 'Server error ($statusCode). Please try again later.';
      default:
        return 'Network error. Please check your connection and try again.';
    }
  }
}
