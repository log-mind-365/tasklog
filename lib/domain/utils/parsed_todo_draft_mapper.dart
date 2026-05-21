import '../entities/folder_entity.dart';
import '../entities/parsed_todo_draft.dart';
import '../entities/priority.dart';

/// 폼/엔티티에 넣기 위한 병합 결과.
class ParsedTodoFormFields {
  const ParsedTodoFormFields({
    required this.title,
    required this.description,
    this.priority,
    this.dueDate,
    this.folderId,
  });

  final String title;
  final String description;

  /// null이면 기존 폼 우선순위 유지
  final Priority? priority;
  final DateTime? dueDate;
  final int? folderId;
}

/// [draft]를 기존 설명과 폴더 목록에 맞춰 저장 가능한 필드로 변환.
///
/// 정책:
/// - 첫 번째로 이름이 일치하는 `@멘션` → [folderId] (대소문자 무시, 공백 트림).
/// - 나머지 멘션·태그·서브태스크는 [existingDescription] 뒤에 블록으로 추가.
ParsedTodoFormFields mapDraftToFormFields({
  required ParsedTodoDraft draft,
  required List<FolderEntity> folders,
  required String existingDescription,
}) {
  final baseDesc = existingDescription.trim();
  final buffer = StringBuffer();
  if (baseDesc.isNotEmpty) {
    buffer.writeln(baseDesc);
  }

  int? folderId;
  final unmatchedMentions = <String>[];

  for (final mention in draft.mentions) {
    final m = mention.trim();
    if (m.isEmpty) continue;
    if (folderId == null) {
      final match = _matchFolder(folders, m);
      if (match != null) {
        folderId = match.id;
        continue;
      }
    }
    unmatchedMentions.add(m);
  }

  if (unmatchedMentions.isNotEmpty) {
    buffer.writeln('@멘션: ${unmatchedMentions.join(', ')}');
  }
  if (draft.tags.isNotEmpty) {
    buffer.writeln('태그: ${draft.tags.map((t) => '#$t').join(' ')}');
  }
  if (draft.subTasks.isNotEmpty) {
    for (final s in draft.subTasks) {
      final line = s.trim();
      if (line.isNotEmpty) buffer.writeln('- $line');
    }
  }

  return ParsedTodoFormFields(
    title: draft.title.trim(),
    description: buffer.toString().trim(),
    priority: draft.priority,
    dueDate: draft.dueDate,
    folderId: folderId,
  );
}

FolderEntity? _matchFolder(List<FolderEntity> folders, String mention) {
  final lower = mention.toLowerCase();
  for (final f in folders) {
    if (f.name.trim().toLowerCase() == lower) return f;
  }
  for (final f in folders) {
    if (f.name.toLowerCase().contains(lower) ||
        lower.contains(f.name.trim().toLowerCase())) {
      return f;
    }
  }
  return null;
}
