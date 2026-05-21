/// 한국어 상대·절대 일자 표현을 [reference] 기준으로 [DateTime] (일 단위)로 해석.
/// 성공 시 해당 구간을 제거한 문자열도 반환한다.
({String text, DateTime? dueDate}) extractKoreanDates(
  String input,
  DateTime reference,
) {
  var text = input;
  DateTime? due;

  DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  final refDay = dayOnly(reference);

  DateTime mondayOfWeek(DateTime d) =>
      dayOnly(d).subtract(Duration(days: d.weekday - 1));

  /// weekOffset 0 = 이번 주, 1 = 다음 주 …
  DateTime weekdayInWeek(
    DateTime ref,
    int targetWeekday, {
    required int weekOffset,
  }) {
    final mon = mondayOfWeek(ref);
    var d = mon.add(Duration(days: targetWeekday - 1));
    d = d.add(Duration(days: weekOffset * 7));
    if (weekOffset == 0 && dayOnly(d).isBefore(refDay)) {
      d = d.add(const Duration(days: 7));
    }
    return dayOnly(d);
  }

  bool progressed = true;
  while (progressed) {
    progressed = false;
    final candidates = <_DateHit>[];

    void offer(RegExp re, DateTime? Function(Match m) fn) {
      final m = re.firstMatch(text);
      if (m != null) {
        final dt = fn(m);
        if (dt != null) {
          candidates.add(_DateHit(m.start, m.end, dt));
        }
      }
    }

    offer(RegExp(r'(\d{1,2})\s*월\s*(\d{1,2})\s*일'), (m) {
      final month = int.parse(m.group(1)!);
      final day = int.parse(m.group(2)!);
      var y = refDay.year;
      var candidate = DateTime(y, month, day);
      if (candidate.isBefore(refDay)) y++;
      return dayOnly(DateTime(y, month, day));
    });

    offer(RegExp(r'(\d{1,2})/(\d{1,2})'), (m) {
      final month = int.parse(m.group(1)!);
      final day = int.parse(m.group(2)!);
      var y = refDay.year;
      var candidate = DateTime(y, month, day);
      if (candidate.isBefore(refDay)) y++;
      return dayOnly(DateTime(y, month, day));
    });

    offer(RegExp(r'어제'), (_) => refDay.subtract(const Duration(days: 1)));
    offer(RegExp(r'오늘'), (_) => refDay);
    offer(RegExp(r'내일'), (_) => refDay.add(const Duration(days: 1)));
    offer(RegExp(r'모레'), (_) => refDay.add(const Duration(days: 2)));
    offer(RegExp(r'글피'), (_) => refDay.add(const Duration(days: 3)));

    offer(RegExp(r'(다음\s*주|다음주)\s*(월|화|수|목|금|토|일)요일'), (m) {
      final wd = _weekdayFromKo(m.group(2)!);
      if (wd == null) return null;
      return weekdayInWeek(refDay, wd, weekOffset: 1);
    });

    offer(RegExp(r'(이번\s*주|이번주)\s*(월|화|수|목|금|토|일)요일'), (m) {
      final wd = _weekdayFromKo(m.group(2)!);
      if (wd == null) return null;
      return weekdayInWeek(refDay, wd, weekOffset: 0);
    });

    offer(RegExp(r'(월|화|수|목|금|토|일)요일'), (m) {
      final wd = _weekdayFromKo(m.group(1)!);
      if (wd == null) return null;
      var d = refDay;
      for (var i = 0; i < 14; i++) {
        if (d.weekday == wd) return d;
        d = d.add(const Duration(days: 1));
      }
      return null;
    });

    if (candidates.isEmpty) break;

    candidates.sort((a, b) => a.start.compareTo(b.start));
    final hit = candidates.first;
    due ??= hit.date;
    text = text.replaceRange(hit.start, hit.end, ' ');
    progressed = true;
  }

  text = text
      .split(RegExp(r'\r?\n'))
      .map((line) => line.replaceAll(RegExp(r'[ \t]+'), ' ').trimRight())
      .join('\n')
      .trim();
  return (text: text, dueDate: due);
}

class _DateHit {
  _DateHit(this.start, this.end, this.date);

  final int start;
  final int end;
  final DateTime date;
}

int? _weekdayFromKo(String oneChar) {
  const map = {'월': 1, '화': 2, '수': 3, '목': 4, '금': 5, '토': 6, '일': 7};
  return map[oneChar];
}
