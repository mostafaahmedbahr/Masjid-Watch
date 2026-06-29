import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home_state.dart';
import '../../data/models/location_config.dart';
import '../../data/repos/prayer_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  Timer? _timer;
  int _lastPrayerIndex = -1;
  final AudioPlayer _player = AudioPlayer();
  final PrayerRepository _repository;

  HomeCubit({PrayerRepository? repository})
      : _repository = repository ?? PrayerRepository(),
        super(HomeState());

  void start(LocationConfig config) {
    _calculateTimes(config);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0 && now.second == 0) {
        _calculateTimes(config);
      }
      _checkPrayerNotification(config);
      emit(state.copyWith(now: now));
    });
  }

  void recalculate(LocationConfig config) {
    _calculateTimes(config);
  }

  void _calculateTimes(LocationConfig config) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    final todayTimes = _repository.calculateWithConfig(config, date: today);
    final tomorrowTimes = _repository.calculateWithConfig(config, date: tomorrow);

    _lastPrayerIndex = -1;
    emit(state.copyWith(
      status: HomeStatus.loaded,
      todayTimes: todayTimes,
      tomorrowTimes: tomorrowTimes,
      config: config,
    ));
  }

  void _checkPrayerNotification(LocationConfig config) {
    if (!state.notificationsEnabled || state.todayTimes == null) return;
    final nowMinute = DateTime(
      state.now.year, state.now.month, state.now.day,
      state.now.hour, state.now.minute,
    );
    for (int i = 0; i < 6; i++) {
      if (i == 1) continue;
      final prayer = state.todayTimes!.getPrayerTime(i);
      final prayerMinute = DateTime(
        prayer.year, prayer.month, prayer.day,
        prayer.hour, prayer.minute,
      );
      if (nowMinute.isAtSameMomentAs(prayerMinute) && _lastPrayerIndex != i) {
        _lastPrayerIndex = i;
        _playNotification();
        break;
      }
    }
    if (_lastPrayerIndex >= 0) {
      final nextPrayer = state.todayTimes!.findNextPrayerIndex();
      if (nextPrayer != _lastPrayerIndex && nextPrayer != 0) {
        _lastPrayerIndex = -1;
      }
    }
  }

  Future<void> _playNotification() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/adhan.mp3'));
    } catch (_) {}
  }

  Future<void> playTestSound() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/adhan.mp3'));
    } catch (_) {}
  }

  void setNotificationsEnabled(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  void toggle24Hour() {
    emit(state.copyWith(is24Hour: !state.is24Hour));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _player.dispose();
    return super.close();
  }
}
