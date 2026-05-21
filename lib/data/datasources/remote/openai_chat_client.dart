import 'dart:convert';

import 'package:http/http.dart' as http;

/// OpenAI Chat Completions 호출 (JSON 응답 모드).
class OpenAiChatClient {
  OpenAiChatClient({required this.apiKey, this.model = 'gpt-4o-mini'});

  final String apiKey;
  final String model;

  /// [messages]: `role` + `content` 맵 리스트. 응답 본문은 JSON 객체.
  Future<Map<String, dynamic>> completeJsonObject({
    required List<Map<String, String>> messages,
  }) async {
    final client = http.Client();
    try {
      final uri = Uri.https('api.openai.com', '/v1/chat/completions');
      final body = jsonEncode({
        'model': model,
        'response_format': {'type': 'json_object'},
        'temperature': 0.2,
        'messages': messages,
      });

      final res = await client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (res.statusCode != 200) {
        throw OpenAiException(res.statusCode, res.body);
      }

      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      final choices = decoded['choices'] as List<dynamic>?;
      final first = choices?.first as Map<String, dynamic>?;
      final message = first?['message'] as Map<String, dynamic>?;
      final content = message?['content'] as String?;
      if (content == null || content.isEmpty) {
        throw const OpenAiException(0, 'empty message content');
      }

      final parsed = jsonDecode(content);
      if (parsed is! Map<String, dynamic>) {
        throw const OpenAiException(0, 'content is not a JSON object');
      }
      return parsed;
    } finally {
      client.close();
    }
  }
}

class OpenAiException implements Exception {
  const OpenAiException(this.statusCode, this.body);
  final int statusCode;
  final String body;

  @override
  String toString() => 'OpenAiException($statusCode): $body';
}
