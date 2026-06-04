import 'package:freezed_annotation/freezed_annotation.dart';

part 'label_entity.freezed.dart';

@freezed
class LabelEntity with _$LabelEntity {
  const factory LabelEntity({required int id, required String name}) =
      _LabelEntity;
}
