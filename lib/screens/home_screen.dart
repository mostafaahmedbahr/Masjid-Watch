import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/clock_widget.dart';
import '../widgets/date_widget.dart';
import '../widgets/prayer_table.dart';
import '../widgets/countdown_widget.dart';
import '../widgets/message_scroll.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final timeProvider = context.watch<TimeProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final now = timeProvider.now;
    final times = timeProvider.todayTimes;
    final config = settingsProvider.config;

    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B0E), Color(0xFF1B3D20)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildTopBar(context, timeProvider),
                      if (times != null) DateWidget(now: now),
                      ClockWidget(now: now, is24Hour: timeProvider.is24Hour),
                      if (times != null)
                        CountdownWidget(
                          times: times,
                          nextPrayerIndex: times.findNextPrayerIndex(),
                          config: config,
                          now: now,
                          tomorrowTimes: timeProvider.tomorrowTimes,
                        ),
                      if (times != null)
                        Expanded(
                          child: PrayerTableWidget(
                            times: times,
                            nextPrayerIndex: times.findNextPrayerIndex(),
                            config: config,
                            is24Hour: timeProvider.is24Hour,
                          ),
                        ),
                      MessageScrollWidget(message: config.messageText),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, TimeProvider tp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(14), vertical: SizeConfig.hp(4)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => tp.toggle24Hour(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(8), vertical: SizeConfig.hp(3)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(SizeConfig.wp(7)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Text(
                tp.is24Hour ? '24h' : '12h',
                style: TextStyle(color: AppTheme.goldColor, fontSize: SizeConfig.sp(11), fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.volume_up_outlined, color: Colors.white54, size: 18),
            onPressed: () => tp.playTestSound(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          SizedBox(width: SizeConfig.wp(4)),
          GestureDetector(
            onTap: () => tp.setNotificationsEnabled(!tp.notificationsEnabled),
            child: Icon(
              tp.notificationsEnabled ? Icons.notifications_active : Icons.notifications_off_outlined,
              color: tp.notificationsEnabled ? AppTheme.goldColor : Colors.white30,
              size: 18,
            ),
          ),
          SizedBox(width: SizeConfig.wp(4)),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white54, size: 18),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.hp(3), horizontal: SizeConfig.wp(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'مؤسسة نبض العطاء للتنمية',
            style: TextStyle(fontSize: SizeConfig.sp(11), color: AppTheme.goldColor.withValues(alpha: 0.5)),
          ),
          SizedBox(width: SizeConfig.wp(6)),
          Text('•', style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: SizeConfig.sp(9))),
          SizedBox(width: SizeConfig.wp(6)),
          Text(
            'ساعة المسجد الذكية',
            style: TextStyle(fontSize: SizeConfig.sp(10), color: Colors.white.withValues(alpha: 0.25)),
          ),
        ],
      ),
    );
  }
}
