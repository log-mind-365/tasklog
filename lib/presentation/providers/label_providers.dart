import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/label_entity.dart';
import 'providers.dart';

part 'label_providers.g.dart';

@riverpod
Stream<List<LabelEntity>> labelsStream(Ref ref) {
  final useCase = ref.watch(getLabelsUseCaseProvider);
  return useCase.watch();
}
