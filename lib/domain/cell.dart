import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cell.freezed.dart';

@freezed
abstract class Cell with _$Cell {
  const factory Cell({Uint8List? image, String? kanji, int? strokeCount}) =
      _Cell;
}
