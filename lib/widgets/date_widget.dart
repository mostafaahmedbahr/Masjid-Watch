import 'package:flutter/material.dart';
import '../utils/hijri_converter.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class DateWidget extends StatelessWidget {
  final DateTime now;

  const DateWidget({super.key, required this.now});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final dayNames = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(16), vertical: SizeConfig.hp(4)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(SizeConfig.wp(8)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Text(dayNames[now.weekday - 1], style: TextStyle(fontSize: SizeConfig.sp(12), color: AppTheme.goldColor)),
          SizedBox(height: SizeConfig.hp(2)),
          Text('${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: SizeConfig.sp(11), color: Colors.white60)),
          Text(HijriConverter.format(now.year, now.month, now.day),
              style: TextStyle(fontSize: SizeConfig.sp(12), color: Colors.white)),
        ],
      ),
    );
  }
}
