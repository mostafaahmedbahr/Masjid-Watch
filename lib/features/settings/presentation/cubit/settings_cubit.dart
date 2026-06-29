import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';
import '../../../home/data/models/location_config.dart';
import '../../../../core/utils/constants.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final prefs = await SharedPreferences.getInstance();
    final config = LocationConfig(
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
    emit(SettingsState(config: config));
  }

  Future<void> updateConfig(LocationConfig newConfig) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', newConfig.latitude);
    await prefs.setDouble('longitude', newConfig.longitude);
    await prefs.setDouble('timezone', newConfig.timezone);
    await prefs.setInt('calcMethod', newConfig.calculationMethod.index);
    await prefs.setInt('asrMethod', newConfig.asrMethod.index);
    await prefs.setInt('highLatRule', newConfig.highLatRule.index);
    await prefs.setInt('minuteRounding', newConfig.minuteRounding);
    await prefs.setInt('fajrIqama', newConfig.fajrIqamaOffset);
    await prefs.setInt('dhuhrIqama', newConfig.dhuhrIqamaOffset);
    await prefs.setInt('asrIqama', newConfig.asrIqamaOffset);
    await prefs.setInt('maghribIqama', newConfig.maghribIqamaOffset);
    await prefs.setInt('ishaIqama', newConfig.ishaIqamaOffset);
    await prefs.setString('messageText', newConfig.messageText);
    await prefs.setBool('showMessages', newConfig.showMessages);
    await prefs.setInt('messageScrollSpeed', newConfig.messageScrollSpeed);
    await prefs.setInt('displayMode', newConfig.displayMode.index);
    emit(SettingsState(config: newConfig));
  }
}
