import 'dart:convert';

import 'package:http/http.dart' as http;

/// kanjiapi.dev を利用して漢字の画数を取得するクライアント。
class KanjiStrokeService {
  KanjiStrokeService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  /// [kanji] の画数を返す。
  Future<int> fetchStrokeCount(String kanji) async {
    if (kanji.isEmpty) {
      throw ArgumentError.value(kanji, 'kanji', '漢字を1文字指定してください');
    }

    final uri = Uri.https('kanjiapi.dev', '/v1/kanji/$kanji');
    final response = await _httpClient.get(uri);

    if (response.statusCode != 200) {
      throw KanjiStrokeApiException(
        'kanjiapi.devから画数を取得できませんでした (status: ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic> && decoded['stroke_count'] is int) {
      return decoded['stroke_count'] as int;
    }

    throw KanjiStrokeApiException('stroke_countがレスポンスに含まれていません');
  }

  void dispose() {
    _httpClient.close();
  }
}

class KanjiStrokeApiException implements Exception {
  KanjiStrokeApiException(this.message);

  final String message;

  @override
  String toString() => 'KanjiStrokeApiException: $message';
}
