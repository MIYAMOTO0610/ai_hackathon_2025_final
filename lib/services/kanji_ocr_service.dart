import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// indulgent-uropygial-charles.ngrok-free.dev にデプロイされた
/// Ollama (gamma3:12b) ベースの漢字OCRサーバーを叩くクライアント。
class KanjiOcrService {
  KanjiOcrService({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static final Uri _endpoint = Uri.https(
    'indulgent-uropygial-charles.ngrok-free.dev',
    '/api/chat',
  );

  /// [imageBytes] (PNGなど) を OCR サーバーに送り、漢字1文字を取得する。
  Future<String> recognizeKanji(Uint8List imageBytes) async {
    if (imageBytes.isEmpty) {
      throw ArgumentError.value(imageBytes, 'imageBytes', '画像を指定してください');
    }

    final payload = {
      'model': 'gamma3:12b',
      'stream': false, // 1レスポンスで受け取れるようにする
      'messages': [
        {
          'role': 'system',
          'content': 'あなたは漢字OCRエンジンです。入力画像から読み取れた漢字1文字だけを返してください。',
        },
        {
          'role': 'user',
          'content': 'この画像に描かれている漢字1文字を返答してください。',
          'images': [base64Encode(imageBytes)],
        },
      ],
    };

    final response = await _httpClient.post(
      _endpoint,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw KanjiOcrException(
        'OCRサーバーからエラーが返されました (status: ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw KanjiOcrException('OCRサーバーのレスポンスを解釈できませんでした');
    }

    final message = decoded['message'];
    if (message is! Map<String, dynamic>) {
      throw KanjiOcrException('message がレスポンスに含まれていません');
    }

    final content = message['content'];
    if (content is! String || content.trim().isEmpty) {
      throw KanjiOcrException('OCR結果が空でした');
    }

    final normalized = content.replaceAll(RegExp(r'\s+'), '');
    if (normalized.isEmpty) {
      throw KanjiOcrException('漢字を抽出できませんでした');
    }

    final rune = normalized.runes.first;
    return String.fromCharCodes([rune]);
  }

  void dispose() {
    _httpClient.close();
  }
}

class KanjiOcrException implements Exception {
  KanjiOcrException(this.message);

  final String message;

  @override
  String toString() => 'KanjiOcrException: $message';
}
