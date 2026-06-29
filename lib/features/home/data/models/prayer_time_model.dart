
class PrayerTimesModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  DateTime getPrayerTime(int index) {
    switch (index) {
      case 0: return fajr;
      case 1: return sunrise;
      case 2: return dhuhr;
      case 3: return asr;
      case 4: return maghrib;
      case 5: return isha;
      default: return fajr;
    }
  }

  static const List<String> names = [
    'الفجر', 'الشروق', 'الظهر', 'العصر', 'المغرب', 'العشاء',
  ];

  static const List<String> adhanLabels = [
    'أذان الفجر', 'الشروق', 'أذان الظهر', 'أذان العصر', 'أذان المغرب', 'أذان العشاء',
  ];

  String formatTime(DateTime time, {bool is24Hour = true}) {
    if (is24Hour) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    int h = time.hour % 12;
    if (h == 0) h = 12;
    final suffix = time.hour < 12 ? 'ص' : 'م';
    return '$h:${time.minute.toString().padLeft(2, '0')} $suffix';
  }

  int findNextPrayerIndex() {
    final now = DateTime.now();
    for (int i = 0; i < 6; i++) {
      if (getPrayerTime(i).isAfter(now)) return i;
    }
    return 0;
  }

  int findCurrentPrayerIndex() {
    final now = DateTime.now();
    int current = 0;
    for (int i = 0; i < 6; i++) {
      if (getPrayerTime(i).isBefore(now) || getPrayerTime(i).isAtSameMomentAs(now)) {
        current = i;
      }
    }
    return current;
  }

  Duration countdownTo(int index) {
    final target = getPrayerTime(index);
    final now = DateTime.now();
    if (target.isAfter(now)) return target.difference(now);
    return Duration.zero;
  }

  Duration countdownToNext() {
    return countdownTo(findNextPrayerIndex());
  }
}
