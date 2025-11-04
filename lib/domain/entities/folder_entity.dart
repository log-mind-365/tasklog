import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder_entity.freezed.dart';

@freezed
class FolderEntity with _$FolderEntity {
  const factory FolderEntity({
    required int id,
    required String name,
    required int color,
    required int order,
  }) = _FolderEntity;
}
