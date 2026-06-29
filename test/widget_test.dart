import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_watch/features/home/data/repos/prayer_repository.dart';
import 'package:masjid_watch/core/utils/hijri_converter.dart';
import 'package:masjid_watch/core/utils/constants.dart';

void main() {
  group('PrayerRepository', () {
    test('calculates prayer times for Riyadh today', () {
      final repo = PrayerRepository();
      final times = repo.calculate(
        latitude: 24.7136,
        longitude: 46.6753,
        timezone: 3.0,
        method: CalculationMethod.muslimWorldLeague,
        asrMethod: AsrMethod.standard,
        highLatRule: HighLatitudeRule.middleOfNight,
      );
      expect(times.fajr.isBefore(times.sunrise) || times.fajr.isAtSameMomentAs(times.sunrise), true);
      expect(times.dhuhr.isAfter(times.sunrise), true);
      expect(times.asr.isAfter(times.dhuhr), true);
      expect(times.maghrib.isAfter(times.asr), true);
      expect(times.isha.isAfter(times.maghrib), true);
    });

    test('returns 6 prayer times', () {
      final repo = PrayerRepository();
      final times = repo.calculate(
        latitude: 29.976,
        longitude: 31.141,
        timezone: 2.0,
        method: CalculationMethod.egyptianGeneralAuthority,
        asrMethod: AsrMethod.standard,
        highLatRule: HighLatitudeRule.middleOfNight,
      );
      expect(times.getPrayerTime(0), times.fajr);
      expect(times.getPrayerTime(1), times.sunrise);
      expect(times.getPrayerTime(2), times.dhuhr);
      expect(times.getPrayerTime(3), times.asr);
      expect(times.getPrayerTime(4), times.maghrib);
      expect(times.getPrayerTime(5), times.isha);
    });
  });

  group('HijriConverter', () {
    test('converts Gregorian to Hijri date', () {
      final hijri = HijriConverter.toHijri(2024, 3, 11);
      expect(hijri.length, 3);
      expect(hijri[1], 9);
    });
  });

  group('CalculationMethod', () {
    test('names are not empty', () {
      for (final method in CalculationMethod.values) {
        expect(method.name.isNotEmpty, true);
      }
    });
  });
}
