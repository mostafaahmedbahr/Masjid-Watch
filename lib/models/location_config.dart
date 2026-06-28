import '../utils/constants.dart';

class LocationConfig {
  final double latitude;
  final double longitude;
  final double timezone;
  final CalculationMethod calculationMethod;
  final AsrMethod asrMethod;
  final HighLatitudeRule highLatRule;
  final int minuteRounding;
  final int fajrIqamaOffset;
  final int dhuhrIqamaOffset;
  final int asrIqamaOffset;
  final int maghribIqamaOffset;
  final int ishaIqamaOffset;
  final String messageText;
  final bool showMessages;
  final int messageScrollSpeed;
  final DisplayMode displayMode;

  const LocationConfig({
    this.latitude = 29.976,
    this.longitude = 31.141,
    this.timezone = 2.0,
    this.calculationMethod = CalculationMethod.egyptianGeneralAuthority,
    this.asrMethod = AsrMethod.standard,
    this.highLatRule = HighLatitudeRule.middleOfNight,
    this.minuteRounding = 0,
    this.fajrIqamaOffset = 10,
    this.dhuhrIqamaOffset = 10,
    this.asrIqamaOffset = 10,
    this.maghribIqamaOffset = 5,
    this.ishaIqamaOffset = 10,
    this.messageText = 'سبحان الله والحمد لله ولا إله إلا الله والله أكبر',
    this.showMessages = true,
    this.messageScrollSpeed = 1,
    this.displayMode = DisplayMode.auto,
  });

  LocationConfig copyWith({
    double? latitude,
    double? longitude,
    double? timezone,
    CalculationMethod? calculationMethod,
    AsrMethod? asrMethod,
    HighLatitudeRule? highLatRule,
    int? minuteRounding,
    int? fajrIqamaOffset,
    int? dhuhrIqamaOffset,
    int? asrIqamaOffset,
    int? maghribIqamaOffset,
    int? ishaIqamaOffset,
    String? messageText,
    bool? showMessages,
    int? messageScrollSpeed,
    DisplayMode? displayMode,
  }) {
    return LocationConfig(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      asrMethod: asrMethod ?? this.asrMethod,
      highLatRule: highLatRule ?? this.highLatRule,
      minuteRounding: minuteRounding ?? this.minuteRounding,
      fajrIqamaOffset: fajrIqamaOffset ?? this.fajrIqamaOffset,
      dhuhrIqamaOffset: dhuhrIqamaOffset ?? this.dhuhrIqamaOffset,
      asrIqamaOffset: asrIqamaOffset ?? this.asrIqamaOffset,
      maghribIqamaOffset: maghribIqamaOffset ?? this.maghribIqamaOffset,
      ishaIqamaOffset: ishaIqamaOffset ?? this.ishaIqamaOffset,
      messageText: messageText ?? this.messageText,
      showMessages: showMessages ?? this.showMessages,
      messageScrollSpeed: messageScrollSpeed ?? this.messageScrollSpeed,
      displayMode: displayMode ?? this.displayMode,
    );
  }

  int getIqamaOffset(int prayerIndex) {
    switch (prayerIndex) {
      case 0: return fajrIqamaOffset;
      case 2: return dhuhrIqamaOffset;
      case 3: return asrIqamaOffset;
      case 4: return maghribIqamaOffset;
      case 5: return ishaIqamaOffset;
      default: return 0;
    }
  }
}
