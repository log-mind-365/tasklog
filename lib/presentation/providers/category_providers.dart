import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/category_entity.dart';
import 'providers.dart';

part 'category_providers.g.dart';

@riverpod
Stream<List<CategoryEntity>> categoriesStream(Ref ref) {
  final useCase = ref.watch(getCategoriesUseCaseProvider);
  return useCase.watch();
}
