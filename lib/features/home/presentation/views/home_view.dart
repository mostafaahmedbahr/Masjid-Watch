import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/clock_widget.dart';
import '../widgets/date_widget.dart';
import '../widgets/countdown_widget.dart';
import '../widgets/prayer_table_widget.dart';
import '../widgets/message_scroll_widget.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../settings/presentation/views/settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final times = state.todayTimes;
        final config = state.config;
        final now = state.now;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF083D1E), Color(0xFF0A1A0E)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context, state),
                  const _DecorativeDivider(),
                  if (times != null) DateWidget(now: now),
                  _buildMosqueArch(context),
                  ClockWidget(now: now, is24Hour: state.is24Hour),
                  if (times != null)
                    CountdownWidget(
                      times: times,
                      nextPrayerIndex: times.findNextPrayerIndex(),
                      config: config,
                      now: now,
                      tomorrowTimes: state.tomorrowTimes,
                    ),
                  if (times != null)
                    Expanded(
                      child: PrayerTableWidget(
                        times: times,
                        nextPrayerIndex: times.findNextPrayerIndex(),
                        config: config,
                        is24Hour: state.is24Hour,
                      ),
                    ),
                  MessageScrollWidget(message: config.messageText),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, HomeState state) {
    final cubit = context.read<HomeCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(14), vertical: SizeConfig.hp(4)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => cubit.toggle24Hour(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(8), vertical: SizeConfig.hp(3)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.goldColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule, size: SizeConfig.sp(10), color: AppTheme.goldColor.withValues(alpha: 0.6)),
                  SizedBox(width: SizeConfig.wp(4)),
                  Text(
                    state.is24Hour ? '24' : '12',
                    style: TextStyle(color: AppTheme.goldColor, fontSize: SizeConfig.sp(11), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          _buildIconButton(Icons.volume_up_outlined, () => cubit.playTestSound()),
          SizedBox(width: SizeConfig.wp(4)),
          GestureDetector(
            onTap: () => cubit.setNotificationsEnabled(!state.notificationsEnabled),
            child: Icon(
              state.notificationsEnabled ? Icons.notifications_active : Icons.notifications_off_outlined,
              color: state.notificationsEnabled ? AppTheme.goldColor : Colors.white30,
              size: 18,
            ),
          ),
          SizedBox(width: SizeConfig.wp(4)),
          _buildIconButton(Icons.settings_outlined, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsView()));
          }),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.wp(3)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(icon, color: Colors.white54, size: 16),
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
            style: TextStyle(fontSize: SizeConfig.sp(11), color: AppTheme.goldColor.withValues(alpha: 0.4)),
          ),
          SizedBox(width: SizeConfig.wp(6)),
          Text('•', style: TextStyle(color: Colors.white.withValues(alpha: 0.15), fontSize: SizeConfig.sp(9))),
          SizedBox(width: SizeConfig.wp(6)),
          Text(
            'ساعة المسجد الذكية',
            style: TextStyle(fontSize: SizeConfig.sp(10), color: Colors.white.withValues(alpha: 0.2)),
          ),
        ],
      ),
    );
  }
}

class _DecorativeDivider extends StatelessWidget {
  const _DecorativeDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.wp(40)),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppTheme.goldColor.withValues(alpha: 0.15), thickness: 0.5)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(6)),
            child: Icon(Icons.circle, size: 4, color: AppTheme.goldColor.withValues(alpha: 0.3)),
          ),
          Expanded(child: Divider(color: AppTheme.goldColor.withValues(alpha: 0.15), thickness: 0.5)),
        ],
      ),
    );
  }
}

Widget _buildMosqueArch(BuildContext context) {
  return CustomPaint(
    size: const Size(double.infinity, 40),
    painter: _MosqueArchPainter(),
  );
}

class _MosqueArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final centerX = size.width / 2;
    final archWidth = size.width * 0.15;
    final archHeight = size.height * 0.7;

    for (int i = -2; i <= 2; i++) {
      final cx = centerX + i * archWidth * 1.1;
      final path = Path()
        ..moveTo(cx - archWidth / 2, size.height)
        ..quadraticBezierTo(cx, size.height - archHeight, cx + archWidth / 2, size.height);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
