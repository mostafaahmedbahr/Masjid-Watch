import 'package:adhan_dart/adhan_dart.dart' as adhan;
import '../models/prayer_time_model.dart';
import '../models/location_config.dart';
import '../../../../core/utils/constants.dart';

class PrayerRepository {
  PrayerTimesModel calculate({
    required double latitude,
    required double longitude,
    required double timezone,
    required CalculationMethod method,
    required AsrMethod asrMethod,
    required HighLatitudeRule highLatRule,
    DateTime? date,
  }) {
    final coords = adhan.Coordinates(latitude, longitude);
    final dt = date ?? DateTime.now();

    final config = LocationConfig(
      latitude: latitude,
      longitude: longitude,
      timezone: timezone,
      calculationMethod: method,
      asrMethod: asrMethod,
      highLatRule: highLatRule,
    );

    final params = config.toAdhanParams();

    try {
      final times = adhan.PrayerTimes(
        coordinates: coords,
        date: dt,
        calculationParameters: params,
      );

      final offset = Duration(milliseconds: (timezone * 3600000).round());

      return PrayerTimesModel(
        fajr: times.fajr.add(offset),
        sunrise: times.sunrise.add(offset),
        dhuhr: times.dhuhr.add(offset),
        asr: times.asr.add(offset),
        maghrib: times.maghrib.add(offset),
        isha: times.isha.add(offset),
      );
    } catch (e) {
      final baseDate = DateTime(dt.year, dt.month, dt.day);
      return PrayerTimesModel(
        fajr: baseDate,
        sunrise: baseDate,
        dhuhr: baseDate,
        asr: baseDate,
        maghrib: baseDate,
        isha: baseDate,
      );
    }
  }

  PrayerTimesModel calculateWithConfig(LocationConfig config, {DateTime? date}) {
    return calculate(
      latitude: config.latitude,
      longitude: config.longitude,
      timezone: config.timezone,
      method: config.calculationMethod,
      asrMethod: config.asrMethod,
      highLatRule: config.highLatRule,
      date: date,
    );
  }
}
