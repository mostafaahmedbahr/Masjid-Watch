import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

class MessageScrollWidget extends StatefulWidget {
  final String message;

  const MessageScrollWidget({super.key, required this.message});

  @override
  State<MessageScrollWidget> createState() => _MessageScrollWidgetState();
}

class _MessageScrollWidgetState extends State<MessageScrollWidget> {
  late ScrollController _controller;
  late String _displayText;
  bool _paused = false;

  static const List<String> athkar = [
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ لِلَّهِ',
    'لَا إِلَهَ إِلَّا اللَّهُ',
    'اللَّهُ أَكْبَرُ',
    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    'سُبْحَانَ اللَّهِ الْعَظِيمِ',
    'أَسْتَغْفِرُ اللَّهَ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
    'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
    'اللَّهُمَّ اغْفِرْ لِي',
    'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ',
  ];

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _buildDisplayText();
    _startScrolling();
  }

  void _buildDisplayText() {
    final parts = <String>[];
    for (int i = 0; i < 3; i++) {
      parts.addAll(athkar);
    }
    _displayText = parts.join('   •   ');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startScrolling() {
    Future.delayed(const Duration(milliseconds: 30), () {
      if (!mounted) return;
      if (!_paused) {
        final maxScroll = _controller.position.maxScrollExtent;
        final currentScroll = _controller.offset;
        if (currentScroll >= maxScroll - 50) {
          _controller.jumpTo(0);
        } else {
          _controller.animateTo(
            currentScroll + 1,
            duration: const Duration(milliseconds: 30),
            curve: Curves.linear,
          );
        }
      }
      _startScrolling();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () => setState(() => _paused = !_paused),
      child: Container(
        height: SizeConfig.hp(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black12,
              const Color(0xFF0A1A0E).withValues(alpha: 0.6),
            ],
          ),
          border: Border(
            top: BorderSide(color: AppTheme.goldColor.withValues(alpha: 0.1)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: SizeConfig.wp(6),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.wp(2)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.goldColor.withValues(alpha: 0.15), AppTheme.goldColor.withValues(alpha: 0.05)],
                ),
              ),
              child: Center(
                child: Icon(Icons.menu_book, color: AppTheme.goldColor.withValues(alpha: 0.4), size: SizeConfig.sp(13)),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: SizeConfig.hp(30),
                  child: Center(
                    child: Text(
                      _displayText,
                      style: TextStyle(
                        fontSize: SizeConfig.sp(12),
                        color: Colors.white.withValues(alpha: _paused ? 0.3 : 0.65),
                        letterSpacing: 0.5,
                        shadows: const [Shadow(color: Color(0x33D4AF37), blurRadius: 5)],
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
