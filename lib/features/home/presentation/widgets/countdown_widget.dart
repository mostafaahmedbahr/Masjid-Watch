import 'package:flutter/material.dart';
import '../../data/models/prayer_time_model.dart';
import '../../data/models/location_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

class CountdownWidget extends StatelessWidget {
  final PrayerTimesModel times;
  final int nextPrayerIndex;
  final LocationConfig config;
  final DateTime now;
  final PrayerTimesModel? tomorrowTimes;

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

    final totalSeconds = diff.inSeconds.toDouble();
    final daySeconds = 86400.0;
    final progress = (totalSeconds / daySeconds).clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.wp(20), vertical: SizeConfig.hp(2)),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(20), vertical: SizeConfig.hp(6)),
      decoration: AppTheme.cardDecoration(glowing: true),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mosque, size: SizeConfig.sp(14), color: AppTheme.goldColor),
              SizedBox(width: SizeConfig.wp(8)),
              Text('متبقي على أذان $name',
                  style: TextStyle(fontSize: SizeConfig.sp(13), color: AppTheme.goldColor, fontWeight: FontWeight.w400)),
            ],
          ),
          SizedBox(height: SizeConfig.hp(6)),
          Text(
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: SizeConfig.sp(32),
              fontWeight: FontWeight.w200,
              color: Colors.white,
              letterSpacing: 6,
              shadows: const [Shadow(color: Color(0x332BD17E), blurRadius: 20)],
            ),
          ),
          SizedBox(height: SizeConfig.hp(6)),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 1.0 - progress,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}
