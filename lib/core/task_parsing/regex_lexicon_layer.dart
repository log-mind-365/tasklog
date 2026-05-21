import '../../domain/entities/priority.dart';

/// @멘션, #태그, 우선순위 키워드, 줄 단위 하위 작업(- …) 추출 후 정리된 본문을 만든다.
({
  String text,
  List<String> mentions,
  List<String> tags,
  Priority? priority,
  List<String> subTasks,
})
applyRegexLexicon(String input) {
  final mentions = <String>[];
  final tags = <String>[];
  final subTasks = <String>[];
  Priority? priority;

  final lines = input.split(RegExp(r'\r?\n'));
  final titleLines = <String>[];
  for (final line in lines) {
    final t = line.trim();
    final bullet = RegExp(r'^[-*•]\s*(.+)$');
    final m = bullet.firstMatch(t);
    if (m != null) {
      subTasks.add(m.group(1)!.trim());
    } else if (t.isNotEmpty) {
      titleLines.add(line);
    }
  }

  var text = titleLines.join('\n');

  // 전각 @＠ #＃, 기호 뒤 공백, 멘션/태그에 하이픈·점·숫자·영문 허용
  final mentionRe = RegExp(r'[@＠]\s*([-\w가-힣.]+)');
  while (true) {
    final m = mentionRe.firstMatch(text);
    if (m == null) break;
    mentions.add(m.group(1)!);
    text = text.replaceRange(m.start, m.end, ' ');
  }

  final tagRe = RegExp(r'[#＃]\s*([-\w가-힣.]+)');
  while (true) {
    final m = tagRe.firstMatch(text);
    if (m == null) break;
    tags.add(m.group(1)!);
    text = text.replaceRange(m.start, m.end, ' ');
  }

  final priorityRules = <(Priority, RegExp)>[
    (
      Priority.high,
      RegExp(
        r'(긴급|중요|ASAP|asap|urgent|우선\s*순위\s*높음|우선순위\s*높음)',
        caseSensitive: false,
      ),
    ),
    (Priority.high, RegExp(r'\bp0\b|\bp1\b', caseSensitive: false)),
    (
      Priority.low,
      RegExp(
        r'(낮\s*음|여유\s*롭게|low\s*priority|optional|나중에)',
        caseSensitive: false,
      ),
    ),
  ];

  for (final rule in priorityRules) {
    final m = rule.$2.firstMatch(text);
    if (m != null) {
      priority = rule.$1;
      text = text.replaceRange(m.start, m.end, ' ');
      break;
    }
  }

  text = text
      .split(RegExp(r'\r?\n'))
      .map((line) => line.replaceAll(RegExp(r'[ \t]+'), ' ').trim())
      .join('\n')
      .trim();
  return (
    text: text,
    mentions: mentions,
    tags: tags,
    priority: priority,
    subTasks: subTasks,
  );
}
