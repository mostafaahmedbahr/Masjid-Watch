import 'dart:math';
import 'constants.dart';

class PrayerCalculator {
  final double latitude;
  final double longitude;
  final double timezone;
  final CalculationMethod method;
  final AsrMethod asrMethod;
  final HighLatitudeRule highLatRule;

  PrayerCalculator({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    this.method = CalculationMethod.muslimWorldLeague,
    this.asrMethod = AsrMethod.standard,
    this.highLatRule = HighLatitudeRule.middleOfNight,
  });

  double _degToRad(double d) => d * pi / 180.0;
  double _radToDeg(double r) => r * 180.0 / pi;
  double _sin(double d) => sin(_degToRad(d));
  double _cos(double d) => cos(_degToRad(d));
  double _tan(double d) => tan(_degToRad(d));
  double _arccos(double x) => _radToDeg(acos(x));
  double _arctan(double x) => _radToDeg(atan(x));

  double _fixHour(double hour) {
    hour %= 24;
    if (hour < 0) hour += 24;
    return hour;
  }

  double _fixAngle(double a) {
    a %= 360;
    if (a < 0) a += 360;
    return a;
  }

  double _julianDay(int year, int month, int day) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    final A = (year / 100).floor();
    final B = 2 - A + (A / 4).floor();
    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        B -
        1524.5;
  }

  double _sunDeclination(double jd) {
    final d = jd - 2451545.0;
    final g = _degToRad(357.529 + 0.98560028 * d);
    final L = _degToRad(280.459 + 0.98564736 * d + 1.915 * sin(g) + 0.020 * sin(2 * g));
    final e = 23.439 - 0.00000036 * d;
    return _radToDeg(asin(sin(L) * sin(_degToRad(e))));
  }

  double _equationOfTime(double jd) {
    final d = jd - 2451545.0;
    final g = _degToRad(357.529 + 0.98560028 * d);
    final q = _fixAngle(280.459 + 0.98564736 * d);
    final L = _degToRad(q + 1.915 * sin(g) + 0.020 * sin(2 * g));
    final e = 23.439 - 0.00000036 * d;
    final ra = _radToDeg(atan2(sin(L) * cos(_degToRad(e)), cos(L)));
    return (q - ra) * 4;
  }

  double _dhuhr(double jd) {
    final eqT = _equationOfTime(jd);
    return 12.0 - longitude / 15.0 + timezone + eqT / 60.0;
  }

  double _hourAngle(double angle, double declination) {
    final numerator = _sin(-angle) - _sin(declination) * _sin(latitude);
    final denominator = _cos(declination) * _cos(latitude);
    if (numerator.abs() > denominator.abs()) return double.nan;
    return _arccos(numerator / denominator);
  }

  double _asrHourAngle(double k, double declination) {
    final numerator = _sin(_arctan(1.0 / (k + _tan((latitude - declination).abs())))) - _sin(declination) * _sin(latitude);
    final denominator = _cos(declination) * _cos(latitude);
    if (numerator.abs() > denominator.abs()) return double.nan;
    return _arccos(numerator / denominator);
  }

  double _fajr(double jd, double dhuhr) {
    final decl = _sunDeclination(jd);
    final ha = _hourAngle(method.fajrAngle, decl);
    if (ha.isNaN) return double.nan;
    return dhuhr - ha / 15.0;
  }

  double _sunrise(double jd, double dhuhr) {
    final decl = _sunDeclination(jd);
    final ha = _hourAngle(0.833, decl);
    if (ha.isNaN) return double.nan;
    return dhuhr - ha / 15.0;
  }

  double _asr(double jd, double dhuhr) {
    final decl = _sunDeclination(jd);
    final k = asrMethod == AsrMethod.hanafi ? 2.0 : 1.0;
    final ha = _asrHourAngle(k, decl);
    if (ha.isNaN) return double.nan;
    return dhuhr + ha / 15.0;
  }

  double _maghrib(double jd, double dhuhr) {
    final decl = _sunDeclination(jd);
    final ha = _hourAngle(0.833, decl);
    if (ha.isNaN) return double.nan;
    return dhuhr + ha / 15.0;
  }

  double _isha(double jd, double dhuhr) {
    final decl = _sunDeclination(jd);
    final ishaMinutes = method.ishaMinutesAfterMaghrib;
    if (ishaMinutes != null) {
      return _maghrib(jd, dhuhr) + ishaMinutes / 60.0;
    }
    final ha = _hourAngle(method.ishaAngle, decl);
    if (ha.isNaN) return double.nan;
    return dhuhr + ha / 15.0;
  }

  List<DateTime> calculate(DateTime date, {int minuteRounding = 0}) {
    final jd = _julianDay(date.year, date.month, date.day);
    final dhuhr = _dhuhr(jd);
    final fajr = _fajr(jd, dhuhr);
    final sunrise = _sunrise(jd, dhuhr);
    final asr = _asr(jd, dhuhr);
    final maghrib = _maghrib(jd, dhuhr);
    final isha = _isha(jd, dhuhr);

    final baseDate = DateTime(date.year, date.month, date.day);
    final List<double> rawTimes = [fajr, sunrise, dhuhr, asr, maghrib, isha];
    final List<DateTime> result = [];

    for (int i = 0; i < rawTimes.length; i++) {
      double t = rawTimes[i];
      if (t.isNaN) {
        result.add(baseDate.add(const Duration(days: 1)));
        continue;
      }
      t = _fixHour(t);
      if (minuteRounding > 0) {
        t = _roundMinute(t, minuteRounding);
      }
      final hours = t.floor();
      final minutes = ((t - hours) * 60).round();
      result.add(DateTime(baseDate.year, baseDate.month, baseDate.day, hours, minutes));
    }

    if (method == CalculationMethod.jafari) {
      final jafariIsha = _fixHour(maghrib + 0.25);
      final ih = jafariIsha.floor();
      final im = ((jafariIsha - ih) * 60).round();
      result[5] = DateTime(baseDate.year, baseDate.month, baseDate.day, ih, im);
    }

    return result;
  }

  double _roundMinute(double hour, int minuteRounding) {
    if (minuteRounding <= 0) return hour;
    final totalMinutes = hour * 60;
    final rounded = (totalMinutes / minuteRounding).round() * minuteRounding;
    return rounded / 60.0;
  }

  List<DateTime> calculateForYear(int year, {int minuteRounding = 0}) {
    final results = <DateTime>[];
    for (int month = 1; month <= 12; month++) {
      final daysInMonth = DateTime(year, month + 1, 0).day;
      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(year, month, day);
        final times = calculate(date, minuteRounding: minuteRounding);
        results.addAll(times);
      }
    }
    return results;
  }
}
