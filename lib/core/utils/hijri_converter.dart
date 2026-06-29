class HijriConverter {
  static int _julianDay(int year, int month, int day) {
    if (month <= 2) { year -= 1; month += 12; }
    final A = (year / 100).floor();
    final B = 2 - A + (A / 4).floor();
    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() + day + B - 1524;
  }

  static List<int> toHijri(int year, int month, int day) {
    final jd = _julianDay(year, month, day);
    final l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    final l2 = l - 10631 * n + 354;
    final j = ((10985 - l2) / 5316).floor() *
            ((50 * l2) / 17719).floor() + (l2 / 5670).floor();
    final l3 = l2 - ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() - (j / 16).floor();
    final m = ((l3 - 1) / 29).floor() + 1;
    final d = l3 - (29 * (m - 1)).floor() - (m / 12).floor();
    final hy = 30 * n + j - 30;
    return [hy, m, d];
  }

  static String format(int year, int month, int day) {
    final hijri = toHijri(year, month, day);
    final months = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
    ];
    return '${hijri[2]} ${months[hijri[1] - 1]} ${hijri[0]}هـ';
  }
}
