import 'package:flutter/material.dart';
import '../../data/models/prayer_time_model.dart';
import '../../data/models/location_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

class PrayerTableWidget extends StatelessWidget {
  final PrayerTimesModel times;
  final int nextPrayerIndex;
  final LocationConfig config;
  final bool is24Hour;

  const PrayerTableWidget({
    super.key,
    required this.times,
    required this.nextPrayerIndex,
    required this.config,
    this.is24Hour = false,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final prayerData = [
      _PrayerRowData('الفجر', times.formatTime(times.fajr, is24Hour: is24Hour), times.fajr, config.fajrIqamaOffset),
      _PrayerRowData('الشروق', times.formatTime(times.sunrise, is24Hour: is24Hour), times.sunrise, null),
      _PrayerRowData('الظهر', times.formatTime(times.dhuhr, is24Hour: is24Hour), times.dhuhr, config.dhuhrIqamaOffset),
      _PrayerRowData('العصر', times.formatTime(times.asr, is24Hour: is24Hour), times.asr, config.asrIqamaOffset),
      _PrayerRowData('المغرب', times.formatTime(times.maghrib, is24Hour: is24Hour), times.maghrib, config.maghribIqamaOffset),
      _PrayerRowData('العشاء', times.formatTime(times.isha, is24Hour: is24Hour), times.isha, config.ishaIqamaOffset),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.wp(8)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.goldColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(16)),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.goldColor.withValues(alpha: 0.2))),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(child: Text('الصلاة',
                      style: TextStyle(fontSize: SizeConfig.sp(11), color: AppTheme.goldColor, fontWeight: FontWeight.w600))),
                  Text('الأذان', style: TextStyle(fontSize: SizeConfig.sp(11), color: AppTheme.goldColor, fontWeight: FontWeight.w600)),
                  if (config.showMessages && config.messageText.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(right: SizeConfig.wp(16)),
                      child: Text('الإقامة',
                          style: TextStyle(fontSize: SizeConfig.sp(11), color: AppTheme.goldColor, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            ),
          ),
          ...List.generate(prayerData.length, (index) {
            final data = prayerData[index];
            final isNext = index == nextPrayerIndex;
            final isPast = data.time.isBefore(DateTime.now());

            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isNext ? AppTheme.nextPrayerHighlight.withValues(alpha: 0.1) : null,
                  border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.04))),
                ),
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(14)),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Container(
                      width: 3,
                      height: SizeConfig.hp(16),
                      decoration: BoxDecoration(
                        color: isNext ? AppTheme.goldColor : (isPast ? Colors.white12 : Colors.transparent),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: SizeConfig.wp(8)),
                    Expanded(
                      child: Text(data.name,
                        style: TextStyle(
                          fontSize: SizeConfig.sp(14),
                          fontWeight: isNext ? FontWeight.w600 : FontWeight.normal,
                          color: isNext ? AppTheme.goldColor : Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(10), vertical: SizeConfig.hp(2)),
                      decoration: BoxDecoration(
                        color: isNext ? AppTheme.goldColor.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(data.timeString,
                        style: TextStyle(
                          fontSize: SizeConfig.sp(14),
                          fontWeight: FontWeight.w500,
                          color: isNext ? Colors.white : Colors.white70,
                        ),
                      ),
                    ),
                    if (data.iqamaOffset != null && index != 1) ...[
                      SizedBox(width: SizeConfig.wp(12)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(6), vertical: SizeConfig.hp(1)),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Text('${data.iqamaOffset} د',
                            style: TextStyle(fontSize: SizeConfig.sp(10), color: Colors.white.withValues(alpha: 0.5))),
                      ),
                    ],
                    if (isNext)
                      Padding(
                        padding: EdgeInsets.only(right: SizeConfig.wp(6)),
                        child: Icon(Icons.navigate_next, color: AppTheme.goldColor, size: SizeConfig.sp(16)),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PrayerRowData {
  final String name;
  final String timeString;
  final DateTime time;
  final int? iqamaOffset;

  _PrayerRowData(this.name, this.timeString, this.time, this.iqamaOffset);
}
