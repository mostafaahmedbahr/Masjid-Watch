import 'package:flutter/material.dart';
import '../../../../core/utils/hijri_converter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

class DateWidget extends StatelessWidget {
  final DateTime now;

  const DateWidget({super.key, required this.now});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final dayNames = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.wp(24)),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(20), vertical: SizeConfig.hp(6)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.goldColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          Icon(Icons.calendar_today, size: SizeConfig.sp(12), color: AppTheme.goldColor.withValues(alpha: 0.6)),
          SizedBox(width: SizeConfig.wp(8)),
          Column(
            children: [
              Text(dayNames[now.weekday - 1],
                  style: TextStyle(fontSize: SizeConfig.sp(13), color: AppTheme.goldColor, fontWeight: FontWeight.w500)),
              SizedBox(height: SizeConfig.hp(2)),
              Text(
                '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: SizeConfig.sp(11), color: Colors.white.withValues(alpha: 0.5)),
              ),
            ],
          ),
          Container(width: 1, height: SizeConfig.hp(20), margin: EdgeInsets.symmetric(horizontal: SizeConfig.wp(12)),
            color: AppTheme.goldColor.withValues(alpha: 0.15)),
          Text(HijriConverter.format(now.year, now.month, now.day),
              style: TextStyle(fontSize: SizeConfig.sp(14), color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
