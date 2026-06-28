import 'package:flutter/material.dart';
import '../models/prayer_time.dart';
import '../models/location_config.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class PrayerTableWidget extends StatelessWidget {
  final PrayerTimes times;
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
      {'name': 'صلاة الفجْر', 'time': times.formatTime(times.fajr, is24Hour: is24Hour), 'iqama': config.fajrIqamaOffset},
      {'name': 'الشروق', 'time': times.formatTime(times.sunrise, is24Hour: is24Hour), 'iqama': null},
      {'name': 'صلاة الظُّهْر', 'time': times.formatTime(times.dhuhr, is24Hour: is24Hour), 'iqama': config.dhuhrIqamaOffset},
      {'name': 'صلاة العَصر', 'time': times.formatTime(times.asr, is24Hour: is24Hour), 'iqama': config.asrIqamaOffset},
      {'name': 'صلاة المَغرب', 'time': times.formatTime(times.maghrib, is24Hour: is24Hour), 'iqama': config.maghribIqamaOffset},
      {'name': 'صلاة العِشاء', 'time': times.formatTime(times.isha, is24Hour: is24Hour), 'iqama': config.ishaIqamaOffset},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.wp(8)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(SizeConfig.wp(10)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(14), vertical: SizeConfig.hp(5)),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.goldColor.withValues(alpha: 0.25))),
            ),
            child: const Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(child: Text('الصلاة', style: TextStyle(fontSize: 11, color: AppTheme.goldColor, fontWeight: FontWeight.w600))),
                Text('وقت الأذان', style: TextStyle(fontSize: 11, color: AppTheme.goldColor, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          ...List.generate(prayerData.length, (index) {
            final data = prayerData[index];
            final isNext = index == nextPrayerIndex;

            return Container(
              decoration: BoxDecoration(
                color: isNext ? AppTheme.nextPrayerHighlight.withValues(alpha: 0.12) : null,
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.04))),
              ),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(14), vertical: SizeConfig.hp(4)),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Container(width: 3, height: SizeConfig.hp(14),
                    decoration: BoxDecoration(
                      color: isNext ? AppTheme.nextPrayerHighlight : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: SizeConfig.wp(8)),
                  Expanded(
                    child: Text(data['name'] as String,
                      style: TextStyle(fontSize: SizeConfig.sp(14), fontWeight: isNext ? FontWeight.w600 : FontWeight.normal,
                        color: isNext ? AppTheme.nextPrayerHighlight : Colors.white),
                    ),
                  ),
                  Text(data['time'] as String,
                    style: TextStyle(fontSize: SizeConfig.sp(14), fontWeight: FontWeight.w500,
                      color: isNext ? Colors.white : Colors.white70),
                  ),
                  if (data['iqama'] != null && index != 1) ...[
                    SizedBox(width: SizeConfig.wp(8)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(4), vertical: 1),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(3)),
                      child: Text('${data['iqama']} د', style: TextStyle(fontSize: SizeConfig.sp(9), color: Colors.white.withValues(alpha: 0.4))),
                    ),
                  ],
                  if (isNext)
                    Padding(
                      padding: EdgeInsets.only(right: SizeConfig.wp(4)),
                      child: Icon(Icons.play_arrow, color: AppTheme.nextPrayerHighlight, size: SizeConfig.sp(12)),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
