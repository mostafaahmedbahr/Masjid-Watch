import '../../../../core/utils/constants.dart';
import 'package:adhan_dart/adhan_dart.dart' as adhan;

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

  adhan.CalculationParameters toAdhanParams() {
    final params = calculationMethod.toAdhanParams();
    params.madhab = asrMethod.toAdhanMadhab();
    params.highLatitudeRule = highLatRule.toAdhanRule();
    return params;
  }
}

extension CalcMethodMapping on CalculationMethod {
  adhan.CalculationParameters toAdhanParams() {
    switch (this) {
      case CalculationMethod.muslimWorldLeague:
        return adhan.CalculationMethodParameters.muslimWorldLeague();
      case CalculationMethod.islamicSocietyOfNorthAmerica:
        return adhan.CalculationMethodParameters.northAmerica();
      case CalculationMethod.egyptianGeneralAuthority:
        return adhan.CalculationMethodParameters.egyptian();
      case CalculationMethod.ummAlQura:
        return adhan.CalculationMethodParameters.ummAlQura();
      case CalculationMethod.universityOfIslamicSciencesKarachi:
        return adhan.CalculationMethodParameters.karachi();
      case CalculationMethod.tehran:
        return adhan.CalculationMethodParameters.tehran();
      case CalculationMethod.jafari:
        return adhan.CalculationMethodParameters.jafari();
    }
  }
}

extension AsrMethodMapping on AsrMethod {
  adhan.Madhab toAdhanMadhab() {
    switch (this) {
      case AsrMethod.standard:
        return adhan.Madhab.shafi;
      case AsrMethod.hanafi:
        return adhan.Madhab.hanafi;
    }
  }
}

extension HighLatRuleMapping on HighLatitudeRule {
  adhan.HighLatitudeRule toAdhanRule() {
    switch (this) {
      case HighLatitudeRule.middleOfNight:
        return adhan.HighLatitudeRule.middleOfTheNight;
      case HighLatitudeRule.seventhOfNight:
        return adhan.HighLatitudeRule.seventhOfTheNight;
      case HighLatitudeRule.angleBased:
        return adhan.HighLatitudeRule.twilightAngle;
    }
  }
}
