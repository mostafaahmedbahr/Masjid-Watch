import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_watch/utils/prayer_calculator.dart';
import 'package:masjid_watch/utils/hijri_converter.dart';
import 'package:masjid_watch/utils/constants.dart';

void main() {
  test('Prayer calculation for Riyadh today', () {
    final calc = PrayerCalculator(
      latitude: 24.7136,
      longitude: 46.6753,
      timezone: 3.0,
      method: CalculationMethod.muslimWorldLeague,
    );
    final now = DateTime.now();
    final times = calc.calculate(now);
    expect(times.length, 6);
    expect(times[0].isBefore(times[1]) || times[0].isAtSameMomentAs(times[1]), true);
  });

  test('Hijri date conversion', () {
    final hijri = HijriConverter.toHijri(2024, 3, 11);
    expect(hijri.length, 3);
    expect(hijri[1], 9);
  });

  test('Calculation method names are not empty', () {
    for (final method in CalculationMethod.values) {
      expect(method.name.isNotEmpty, true);
    }
  });
}
