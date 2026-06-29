enum CalculationMethod {
  muslimWorldLeague,
  islamicSocietyOfNorthAmerica,
  egyptianGeneralAuthority,
  ummAlQura,
  universityOfIslamicSciencesKarachi,
  tehran,
  jafari,
}

enum AsrMethod { standard, hanafi }

enum HighLatitudeRule { middleOfNight, seventhOfNight, angleBased }

enum DisplayMode { auto, dark, light }

extension CalculationMethodExtension on CalculationMethod {
  String get name {
    switch (this) {
      case CalculationMethod.muslimWorldLeague:
        return 'رابطة العالم الإسلامي';
      case CalculationMethod.islamicSocietyOfNorthAmerica:
        return 'الجمعية الإسلامية لأمريكا الشمالية';
      case CalculationMethod.egyptianGeneralAuthority:
        return 'الهيئة المصرية العامة للمساحة';
      case CalculationMethod.ummAlQura:
        return 'أم القرى';
      case CalculationMethod.universityOfIslamicSciencesKarachi:
        return 'جامعة العلوم الإسلامية كراتشي';
      case CalculationMethod.tehran:
        return 'طهران';
      case CalculationMethod.jafari:
        return 'الجعفرية';
    }
  }

  double get fajrAngle {
    switch (this) {
      case CalculationMethod.muslimWorldLeague: return 18.0;
      case CalculationMethod.islamicSocietyOfNorthAmerica: return 15.0;
      case CalculationMethod.egyptianGeneralAuthority: return 19.5;
      case CalculationMethod.ummAlQura: return 18.5;
      case CalculationMethod.universityOfIslamicSciencesKarachi: return 18.0;
      case CalculationMethod.tehran: return 17.7;
      case CalculationMethod.jafari: return 16.0;
    }
  }

  double get ishaAngle {
    switch (this) {
      case CalculationMethod.muslimWorldLeague: return 17.0;
      case CalculationMethod.islamicSocietyOfNorthAmerica: return 15.0;
      case CalculationMethod.egyptianGeneralAuthority: return 17.5;
      case CalculationMethod.ummAlQura: return 0.0;
      case CalculationMethod.universityOfIslamicSciencesKarachi: return 18.0;
      case CalculationMethod.tehran: return 14.0;
      case CalculationMethod.jafari: return 14.0;
    }
  }

  int? get ishaMinutesAfterMaghrib {
    if (this == CalculationMethod.ummAlQura) return 90;
    return null;
  }
}

extension AsrMethodExtension on AsrMethod {
  String get name {
    switch (this) {
      case AsrMethod.standard: return 'شافعي، حنبلي، مالكي';
      case AsrMethod.hanafi: return 'حنفي';
    }
  }
}

const List<String> prayerNames = [
  'الفجر', 'الشروق', 'الظهر', 'العصر', 'المغرب', 'العشاء',
];

const List<String> iqamaLabels = [
  'إقامة الفجر', 'إقامة الظهر', 'إقامة العصر', 'إقامة المغرب', 'إقامة العشاء',
];
