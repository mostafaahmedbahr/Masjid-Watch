import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_config.dart';
import '../utils/constants.dart';

class SettingsProvider extends ChangeNotifier {
  LocationConfig _config = const LocationConfig();

  LocationConfig get config => _config;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _config = LocationConfig(
      latitude: prefs.getDouble('latitude') ?? 29.976,
      longitude: prefs.getDouble('longitude') ?? 31.141,
      timezone: prefs.getDouble('timezone') ?? 2.0,
      calculationMethod: CalculationMethod.values[prefs.getInt('calcMethod') ?? 0],
      asrMethod: AsrMethod.values[prefs.getInt('asrMethod') ?? 0],
      highLatRule: HighLatitudeRule.values[prefs.getInt('highLatRule') ?? 0],
      minuteRounding: prefs.getInt('minuteRounding') ?? 0,
      fajrIqamaOffset: prefs.getInt('fajrIqama') ?? 10,
      dhuhrIqamaOffset: prefs.getInt('dhuhrIqama') ?? 10,
      asrIqamaOffset: prefs.getInt('asrIqama') ?? 10,
      maghribIqamaOffset: prefs.getInt('maghribIqama') ?? 5,
      ishaIqamaOffset: prefs.getInt('ishaIqama') ?? 10,
      messageText: prefs.getString('messageText') ?? 'سبحان الله والحمد لله ولا إله إلا الله والله أكبر',
      showMessages: prefs.getBool('showMessages') ?? true,
      messageScrollSpeed: prefs.getInt('messageScrollSpeed') ?? 1,
      displayMode: DisplayMode.values[prefs.getInt('displayMode') ?? 0],
    );
    notifyListeners();
  }

  Future<void> updateConfig(LocationConfig newConfig) async {
    _config = newConfig;
    await _save();
    notifyListeners();
  }

  Future<void> updateField<K>(K key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is double) {
      await prefs.setDouble(key.toString(), value);
    } else if (value is int) {
      await prefs.setInt(key.toString(), value);
    } else if (value is String) {
      await prefs.setString(key.toString(), value);
    } else if (value is bool) {
      await prefs.setBool(key.toString(), value);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', _config.latitude);
    await prefs.setDouble('longitude', _config.longitude);
    await prefs.setDouble('timezone', _config.timezone);
    await prefs.setInt('calcMethod', _config.calculationMethod.index);
    await prefs.setInt('asrMethod', _config.asrMethod.index);
    await prefs.setInt('highLatRule', _config.highLatRule.index);
    await prefs.setInt('minuteRounding', _config.minuteRounding);
    await prefs.setInt('fajrIqama', _config.fajrIqamaOffset);
    await prefs.setInt('dhuhrIqama', _config.dhuhrIqamaOffset);
    await prefs.setInt('asrIqama', _config.asrIqamaOffset);
    await prefs.setInt('maghribIqama', _config.maghribIqamaOffset);
    await prefs.setInt('ishaIqama', _config.ishaIqamaOffset);
    await prefs.setString('messageText', _config.messageText);
    await prefs.setBool('showMessages', _config.showMessages);
    await prefs.setInt('messageScrollSpeed', _config.messageScrollSpeed);
    await prefs.setInt('displayMode', _config.displayMode.index);
  }
}
