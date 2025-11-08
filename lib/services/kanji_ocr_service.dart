import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// 291b082cf075.ngrok-free.app にデプロイされた
/// Ollama (gemma3:12b) ベースの漢字OCRサーバーを叩くクライアント。
class KanjiOcrService {
  KanjiOcrService({http.Client? httpClient, Uri? endpoint})
    : _httpClient = httpClient ?? http.Client(),
      _endpoint = endpoint ?? _resolveEndpoint();

  final http.Client _httpClient;
  final Uri _endpoint;

  static const _defaultEndpoint = 'https://291b082cf075.ngrok-free.app/api/chat';

  /// [imageBytes] (PNGなど) を OCR サーバーに送り、漢字1文字を取得する。
  Future<String> recognizeKanji(Uint8List imageBytes) async {
    if (imageBytes.isEmpty) {
      throw KanjiOcrException('画像を指定してください (imageBytes が空)');
    }

    final payload = {
      'model': 'gemma3:12b',
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

    final response = await _sendRequest(payload);
    final responseBody = response.body;

    if (response.statusCode != 200) {
      throw KanjiOcrException(
        'OCRサーバーからエラーが返されました '
        '(status: ${response.statusCode}, preview: ${_previewBody(responseBody)})',
      );
    }

    final decoded = _decodeResponseBody(responseBody);

    final message = decoded['message'];
    if (message is! Map<String, dynamic>) {
      throw KanjiOcrException(
        'message フィールドが不正です '
        '(keys: ${decoded.keys.join(', ')})',
      );
    }

    final content = message['content'];
    if (content is! String || content.trim().isEmpty) {
      throw KanjiOcrException(
        'OCR結果 content が空、または文字列ではありません '
        '(runtimeType: ${content.runtimeType})',
      );
    }

    final normalized = content.replaceAll(RegExp(r'\s+'), '');
    if (normalized.isEmpty) {
      throw KanjiOcrException(
        'OCR結果から漢字を抽出できませんでした (content: "$content")',
      );
    }

    final rune = normalized.runes.first;
    return String.fromCharCodes([rune]);
  }

  void dispose() {
    _httpClient.close();
  }

  Future<http.Response> _sendRequest(
    Map<String, dynamic> payload,
  ) async {
    final authToken = _readAuthorizationToken();
    try {
      debugPrint('🍤 Kanji OCR endpoint: $_endpoint');
      return await _httpClient.post(
        _endpoint,
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(payload),
      );
    } catch (error) {
      throw KanjiOcrException(
        'OCRサーバーへのHTTPリクエストに失敗しました '
        '(type: ${error.runtimeType}, message: $error)',
      );
    }
  }

  Map<String, dynamic> _decodeResponseBody(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw KanjiOcrException(
          'OCRサーバーのレスポンス形式が不正です '
          '(preview: ${_previewBody(body)})',
        );
      }
      return decoded;
    } on FormatException catch (error) {
      throw KanjiOcrException(
        'OCRサーバーのレスポンスJSON解析に失敗しました '
        '(${error.message}). preview: ${_previewBody(body)}',
      );
    }
  }

  String _previewBody(String body, {int maxLength = 160}) {
    final sanitized = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (sanitized.isEmpty) {
      return '(empty body)';
    }
    if (sanitized.length <= maxLength) {
      return sanitized;
    }
    return '${sanitized.substring(0, maxLength)}…';
  }

  static Uri _resolveEndpoint() {
    final endpoint = dotenv.env['KANJI_OCR_ENDPOINT'];
    final raw = (endpoint == null || endpoint.isEmpty)
        ? _defaultEndpoint
        : endpoint.trim();
    final parsed = Uri.tryParse(raw);
    if (parsed == null || !parsed.hasScheme || parsed.host.isEmpty) {
      throw KanjiOcrException(
        'KANJI_OCR_ENDPOINT が不正です (value: "$raw")',
      );
    }
    return parsed;
  }

  String? _readAuthorizationToken() {
    final token = dotenv.env['NGROK_TOKEN'];
    if (token == null || token.isEmpty) {
      return null;
    }
    return token;
  }
}

class KanjiOcrException implements Exception {
  KanjiOcrException(this.message);

  final String message;

  @override
  String toString() => '🦐 KanjiOcrException: $message';
}
