import 'dart:async';
import 'dart:typed_data';

/// AI エンドポイントへ画像を送って漢字を取得するためのサービス。
class OcrService {
  OcrService({
    this.maxRetryCount = 3,
    this.retryDelay = const Duration(milliseconds: 500),
  }) : assert(maxRetryCount > 0, 'maxRetryCount は 1 以上にしてください');

  final int maxRetryCount;
  final Duration retryDelay;

  static final _kanjiRegExp = RegExp(r'^[\u4E00-\u9FFF]$');

  /// 画像を AI に送信して漢字一文字を取得する。
  ///
  /// 漢字一文字が返らなかった場合は最大 [maxRetryCount] 回まで再試行する。
  Future<String> recognizeKanji(Uint8List imageBytes) async {
    Exception? lastError;

    for (int attempt = 1; attempt <= maxRetryCount; attempt++) {
      try {
        final rawResult = await _requestKanjiFromAi(imageBytes);
        final kanji = _extractSingleKanji(rawResult);
        if (kanji != null) {
          return kanji;
        }
      } catch (error) {
        lastError = error is Exception ? error : Exception(error.toString());
      }

      if (attempt < maxRetryCount) {
        await Future.delayed(retryDelay);
      }
    }

    final detail = lastError != null ? '（最後のエラー: $lastError）' : '';
    throw StateError('漢字一文字の OCR に失敗しました$detail');
  }

  /// 実際の AI エンドポイント呼び出し部分。
  Future<String> _requestKanjiFromAi(Uint8List imageBytes) async {
    // TODO: エンドポイント実装後にコメントを外す
    // final uri = Uri.parse('https://example.com/ocr');
    // final headers = <String, String>{
    //   'Content-Type': 'application/octet-stream',
    //   'Authorization': 'Bearer <API_TOKEN>',
    // };
    // final response = await http.post(
    //   uri,
    //   headers: headers,
    //   body: imageBytes,
    // );
    // if (response.statusCode != 200) {
    //      throw HttpException('Unexpected status: ${response.statusCode}');
    // }
    // final payload = jsonDecode(response.body) as Map<String, dynamic>;
    // return payload['kanji'] as String? ?? '';

    throw UnimplementedError('AI エンドポイントが未実装です');
  }

  String? _extractSingleKanji(String? raw) {
    if (raw == null) {
      return null;
    }
    final normalized = raw.trim();
    return _kanjiRegExp.hasMatch(normalized) ? normalized : null;
  }
}
