import '../../core/task_parsing/llm_parse_gate.dart';
import '../../core/task_parsing/local_natural_language_parser.dart';
import '../entities/parsed_todo_draft.dart';
import '../entities/priority.dart';
import '../repositories/natural_language_task_parser.dart';

/// 자연어 → [ParsedTodoDraft]. 로컬 우선, 게이트 통과 시에만 OpenAI 호출.
class ParseNaturalLanguageTodoUseCase {
  ParseNaturalLanguageTodoUseCase(this._llm);

  final NaturalLanguageTaskParser? _llm;

  Future<ParsedTodoDraft> call({
    required String rawInput,
    required DateTime referenceTime,
  }) async {
    final local = parseNaturalLanguageLocally(rawInput, referenceTime);
    final stripped = local.title;

    final gate = shouldCallOpenAiForRemainder(
      strippedText: stripped,
      localDueDate: local.dueDate,
    );

    final parser = _llm;
    if (!gate || parser == null) {
      return _draftFromLocal(local);
    }

    try {
      final snapshot = _localSnapshot(local);
      final llm = await parser.parseRemainder(
        remainder: stripped,
        localSnapshot: snapshot,
      );
      return _mergeLocalAndLlm(local, llm);
    } catch (_) {
      return _draftFromLocal(local);
    }
  }

  ParsedTodoDraft _draftFromLocal(LocalNaturalLanguageParseResult local) {
    return ParsedTodoDraft(
      title: local.title,
      dueDate: local.dueDate,
      mentions: local.mentions,
      tags: local.tags,
      priority: local.priority,
      subTasks: local.subTasks,
    );
  }

  Map<String, dynamic> _localSnapshot(LocalNaturalLanguageParseResult r) {
    return {
      'title': r.title,
      'dueDate': r.dueDate?.toIso8601String(),
      'priority': r.priority?.name,
      'mentions': r.mentions,
      'tags': r.tags,
      'subTasks': r.subTasks,
    };
  }

  ParsedTodoDraft _mergeLocalAndLlm(
    LocalNaturalLanguageParseResult local,
    Map<String, dynamic> llm,
  ) {
    final partial = _safePartial(llm);
    return ParsedTodoDraft(
      title: _pickTitle(local.title, partial.title),
      dueDate: local.dueDate ?? partial.dueDate,
      priority: local.priority ?? partial.priority,
      mentions: _union(local.mentions, partial.mentions),
      tags: _union(local.tags, partial.tags),
      subTasks: _union(local.subTasks, partial.subTasks),
    );
  }
}

class _LlmPartial {
  const _LlmPartial({
    this.title,
    this.dueDate,
    this.priority,
    this.mentions = const [],
    this.tags = const [],
    this.subTasks = const [],
  });

  final String? title;
  final DateTime? dueDate;
  final Priority? priority;
  final List<String> mentions;
  final List<String> tags;
  final List<String> subTasks;
}

_LlmPartial _safePartial(Map<String, dynamic> m) {
  DateTime? due;
  final rawDue = m['dueDate'];
  if (rawDue is String && rawDue.isNotEmpty) {
    due = DateTime.tryParse(rawDue);
    if (due != null) {
      due = DateTime(due.year, due.month, due.day);
    }
  }

  Priority? pr;
  final rawP = m['priority'];
  if (rawP is String) {
    switch (rawP.toLowerCase()) {
      case 'high':
        pr = Priority.high;
        break;
      case 'low':
        pr = Priority.low;
        break;
      case 'medium':
        pr = Priority.medium;
        break;
    }
  }

  String? title;
  final rawT = m['title'];
  if (rawT is String) title = rawT;

  return _LlmPartial(
    title: title,
    dueDate: due,
    priority: pr,
    mentions: _stringList(m['mentions']),
    tags: _stringList(m['tags']),
    subTasks: _stringList(m['subTasks']),
  );
}

List<String> _stringList(dynamic v) {
  if (v is! List) return const [];
  return v
      .map((e) => e?.toString().trim() ?? '')
      .where((s) => s.isNotEmpty)
      .toList();
}

String _pickTitle(String localTitle, String? llmTitle) {
  final a = localTitle.trim();
  final b = (llmTitle ?? '').trim();
  if (a.isEmpty) return b;
  if (b.isEmpty) return a;
  return a.length <= b.length ? a : b;
}

List<String> _union(List<String> a, List<String> b) {
  final out = <String>{...a, ...b};
  return out.toList();
}
