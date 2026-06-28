import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/prayer_time.dart';
import '../models/location_config.dart';
import '../utils/prayer_calculator.dart';

class TimeProvider extends ChangeNotifier {
  Timer? _timer;
  DateTime _now = DateTime.now();
  PrayerTimes? _todayTimes;
  PrayerTimes? _tomorrowTimes;
  bool _is24Hour = false;
  int _lastPrayerIndex = -1;
  bool _notificationsEnabled = true;
  final AudioPlayer _player = AudioPlayer();

  DateTime get now => _now;
  PrayerTimes? get todayTimes => _todayTimes;
  PrayerTimes? get tomorrowTimes => _tomorrowTimes;
  bool get is24Hour => _is24Hour;
  bool get notificationsEnabled => _notificationsEnabled;

  void start(LocationConfig config) {
    _calculateTimes(config);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _now = DateTime.now();
      if (_now.hour == 0 && _now.minute == 0 && _now.second == 0) {
        _calculateTimes(config);
      }
      _checkPrayerNotification(config);
      notifyListeners();
    });
  }

  void recalculate(LocationConfig config) {
    _calculateTimes(config);
    notifyListeners();
  }

  double _actualTimezone() {
    final now = DateTime.now();
    final device = now.timeZoneOffset.inHours.toDouble();

    final year = now.year;
    final april = DateTime(year, 4);
    final lastFridayApril = _lastWeekday(april, DateTime.friday);
    final october = DateTime(year, 10);
    final lastThursdayOct = _lastWeekday(october, DateTime.thursday);

    final dstStart = DateTime(year, 4, lastFridayApril);
    final dstEnd = DateTime(year, 10, lastThursdayOct);

    final isEgyptDst = now.isAfter(dstStart) && now.isBefore(dstEnd);
    final egyptTz = isEgyptDst ? 3.0 : 2.0;

    if (device != egyptTz) return egyptTz;
    return device;
  }

  int _lastWeekday(DateTime month, int weekday) {
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    for (int d = lastDay; d >= 1; d--) {
      if (DateTime(month.year, month.month, d).weekday == weekday) return d;
    }
    return 1;
  }

  void _calculateTimes(LocationConfig config) {
    final tz = _actualTimezone();
    final calc = PrayerCalculator(
      latitude: config.latitude,
      longitude: config.longitude,
      timezone: tz,
      method: config.calculationMethod,
      asrMethod: config.asrMethod,
    );
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final todayResults = calc.calculate(today, minuteRounding: config.minuteRounding);
    final tomorrowResults = calc.calculate(tomorrow, minuteRounding: config.minuteRounding);

    _todayTimes = PrayerTimes(
      fajr: todayResults[0],
      sunrise: todayResults[1],
      dhuhr: todayResults[2],
      asr: todayResults[3],
      maghrib: todayResults[4],
      isha: todayResults[5],
    );
    _tomorrowTimes = PrayerTimes(
      fajr: tomorrowResults[0],
      sunrise: tomorrowResults[1],
      dhuhr: tomorrowResults[2],
      asr: tomorrowResults[3],
      maghrib: tomorrowResults[4],
      isha: tomorrowResults[5],
    );
    _lastPrayerIndex = -1;
  }

  void _checkPrayerNotification(LocationConfig config) {
    if (!_notificationsEnabled || _todayTimes == null) return;

    final nowMinute = DateTime(_now.year, _now.month, _now.day, _now.hour, _now.minute);

    for (int i = 0; i < 6; i++) {
      if (i == 1) continue;
      final prayer = _todayTimes!.getPrayerTime(i);
      final prayerMinute = DateTime(prayer.year, prayer.month, prayer.day, prayer.hour, prayer.minute);

      if (nowMinute.isAtSameMomentAs(prayerMinute) && _lastPrayerIndex != i) {
        _lastPrayerIndex = i;
        _playNotification();
        break;
      }
    }

    if (_lastPrayerIndex >= 0) {
      final nextPrayer = _todayTimes!.findNextPrayerIndex();
      if (nextPrayer != _lastPrayerIndex && nextPrayer != 0) {
        _lastPrayerIndex = -1;
      }
    }
  }

  Future<void> _playNotification() async {
    await playTestSound();
  }

  Future<void> playTestSound() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/notification.wav'));
    } catch (_) {}
  }

  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }

  void toggle24Hour() {
    _is24Hour = !_is24Hour;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }
}
