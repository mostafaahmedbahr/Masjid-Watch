import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

class ClockWidget extends StatelessWidget {
  final DateTime now;
  final bool is24Hour;

  const ClockWidget({super.key, required this.now, this.is24Hour = true});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    int hour = now.hour;
    final ampm = is24Hour ? '' : (hour < 12 ? 'ص' : 'م');
    if (!is24Hour) {
      hour = hour % 12;
      if (hour == 0) hour = 12;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.hp(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: [
          Text(
            '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: SizeConfig.sp(82),
              fontWeight: FontWeight.w100,
              color: Colors.white,
              letterSpacing: 8,
              height: 1.1,
              shadows: [
                const Shadow(color: Color(0x33D4AF37), blurRadius: 30),
                const Shadow(color: Color(0x33D4AF37), blurRadius: 15),
              ],
            ),
          ),
          if (ampm.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.hp(16)),
              child: Text(
                ampm,
                style: TextStyle(fontSize: SizeConfig.sp(24), color: AppTheme.goldColor, fontWeight: FontWeight.w300),
              ),
            ),
        ],
      ),
    );
  }
}
