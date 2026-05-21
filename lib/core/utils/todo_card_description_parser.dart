/// 할 일 카드에서 [description]을 메타 블록과 사용자 본문으로 분리한다.
///
/// [mapDraftToFormFields]가 붙이는 형식:
/// - `@멘션: a, b`
/// - `태그: #x #y`
/// - `- 서브태스크`
class TodoCardDescriptionParts {
  const TodoCardDescriptionParts({
    required this.body,
    required this.mentionNames,
    required this.tagLabels,
    required this.subTasks,
  });

  final String body;
  final List<String> mentionNames;
  final List<String> tagLabels;
  final List<String> subTasks;

  bool get hasStructuredContent =>
      mentionNames.isNotEmpty || tagLabels.isNotEmpty || subTasks.isNotEmpty;
}

TodoCardDescriptionParts parseTodoCardDescription(String description) {
  final lines = description.split(RegExp(r'\r?\n'));
  final bodyBuf = <String>[];
  String? mentionsRaw;
  String? tagsRaw;
  final subTasks = <String>[];

  final mentionRe = RegExp(r'^@멘션:\s*(.+)$');
  final tagRe = RegExp(r'^태그:\s*(.+)$');
  final subRe = RegExp(r'^-\s+(.+)$');

  for (final line in lines) {
    final t = line.trim();
    if (t.isEmpty) continue;

    final mMention = mentionRe.firstMatch(t);
    if (mMention != null) {
      mentionsRaw = mMention.group(1);
      continue;
    }
    final mTag = tagRe.firstMatch(t);
    if (mTag != null) {
      tagsRaw = mTag.group(1);
      continue;
    }
    final mSub = subRe.firstMatch(t);
    if (mSub != null) {
      subTasks.add(mSub.group(1)!.trim());
      continue;
    }
    bodyBuf.add(line);
  }

  final mentions =
      mentionsRaw
          ?.split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList() ??
      <String>[];

  final tags = <String>[];
  if (tagsRaw != null && tagsRaw.trim().isNotEmpty) {
    final raw = tagsRaw;
    for (final w in raw.split(RegExp(r'\s+'))) {
      final s = w.trim();
      if (s.isEmpty) continue;
      if (s.startsWith('#')) {
        tags.add(s.substring(1));
      } else {
        tags.add(s);
      }
    }
  }

  return TodoCardDescriptionParts(
    body: bodyBuf.join('\n').trim(),
    mentionNames: mentions,
    tagLabels: tags,
    subTasks: subTasks,
  );
}
