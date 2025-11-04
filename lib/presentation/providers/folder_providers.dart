import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/folder_entity.dart';
import 'providers.dart';

part 'folder_providers.g.dart';

@riverpod
Stream<List<FolderEntity>> foldersStream(Ref ref) {
  final useCase = ref.watch(getFoldersUseCaseProvider);
  return useCase.watch();
}
