import 'package:equatable/equatable.dart';
import '../../data/models/prayer_time_model.dart';
import '../../data/models/location_config.dart';

enum HomeStatus { initial, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final DateTime now;
  final PrayerTimesModel? todayTimes;
  final PrayerTimesModel? tomorrowTimes;
  final LocationConfig config;
  final bool is24Hour;
  final bool notificationsEnabled;
  final String? error;

  HomeState({
    this.status = HomeStatus.initial,
    DateTime? now,
    this.todayTimes,
    this.tomorrowTimes,
    this.config = const LocationConfig(),
    this.is24Hour = false,
    this.notificationsEnabled = true,
    this.error,
  }) : now = now ?? DateTime.now();

  HomeState copyWith({
    HomeStatus? status,
    DateTime? now,
    PrayerTimesModel? todayTimes,
    PrayerTimesModel? tomorrowTimes,
    LocationConfig? config,
    bool? is24Hour,
    bool? notificationsEnabled,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      now: now ?? this.now,
      todayTimes: todayTimes ?? this.todayTimes,
      tomorrowTimes: tomorrowTimes ?? this.tomorrowTimes,
      config: config ?? this.config,
      is24Hour: is24Hour ?? this.is24Hour,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, now, todayTimes, tomorrowTimes, config, is24Hour, notificationsEnabled, error];
}
