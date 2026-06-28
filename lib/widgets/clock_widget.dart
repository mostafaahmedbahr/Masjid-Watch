import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: [
        Text(
          '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: SizeConfig.sp(72),
            fontWeight: FontWeight.w100,
            color: Colors.white,
            letterSpacing: 6,
            height: 1.1,
          ),
        ),
        if (ampm.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.hp(14)),
            child: Text(
              ampm,
              style: TextStyle(fontSize: SizeConfig.sp(22), color: AppTheme.goldColor),
            ),
          ),
      ],
    );
  }
}
