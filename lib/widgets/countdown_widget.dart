import 'package:flutter/material.dart';
import '../models/prayer_time.dart';
import '../models/location_config.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class CountdownWidget extends StatelessWidget {
  final PrayerTimes times;
  final int nextPrayerIndex;
  final LocationConfig config;
  final DateTime now;
  final PrayerTimes? tomorrowTimes;

  const CountdownWidget({
    super.key,
    required this.times,
    required this.nextPrayerIndex,
    required this.config,
    required this.now,
    this.tomorrowTimes,
  });

  String _prayerLabel(int index) {
    const labels = ['الفجْر', 'الشروق', 'الظُّهْر', 'العَصر', 'المَغرب', 'العِشاء'];
    return labels[index];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    DateTime? nextPrayer;
    int labelIndex;

    final candidate = times.getPrayerTime(nextPrayerIndex);
    if (candidate.isAfter(now)) {
      nextPrayer = candidate;
      labelIndex = nextPrayerIndex;
    } else if (tomorrowTimes != null) {
      nextPrayer = tomorrowTimes!.fajr;
      labelIndex = 0;
    } else {
      return const SizedBox.shrink();
    }

    final diff = nextPrayer.difference(now);
    if (diff.isNegative) return const SizedBox.shrink();

    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    final seconds = diff.inSeconds.remainder(60);
    final name = _prayerLabel(labelIndex);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.wp(20), vertical: SizeConfig.hp(2)),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(16), vertical: SizeConfig.hp(4)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.nextPrayerHighlight.withValues(alpha: 0.12), AppTheme.nextPrayerHighlight.withValues(alpha: 0.04)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(SizeConfig.wp(10)),
        border: Border.all(color: AppTheme.nextPrayerHighlight.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('يتبقى على رفع أذان $name', style: TextStyle(fontSize: SizeConfig.sp(12), color: AppTheme.goldColor)),
          SizedBox(width: SizeConfig.wp(10)),
          Text(
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: SizeConfig.sp(22), fontWeight: FontWeight.w200, color: Colors.white, letterSpacing: 3),
          ),
        ],
      ),
    );
  }
}
