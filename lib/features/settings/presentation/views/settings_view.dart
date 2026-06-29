import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/settings_cubit.dart';
import '../../../home/data/models/location_config.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late TextEditingController _latCtrl;
  late TextEditingController _lngCtrl;
  late TextEditingController _tzCtrl;
  late TextEditingController _messageCtrl;
  late LocationConfig _draft;

  @override
  void initState() {
    super.initState();
    final config = context.read<SettingsCubit>().state.config;
    _latCtrl = TextEditingController(text: config.latitude.toString());
    _lngCtrl = TextEditingController(text: config.longitude.toString());
    _tzCtrl = TextEditingController(text: config.timezone.toString());
    _messageCtrl = TextEditingController(text: config.messageText);
    _draft = config;
  }

  @override
  void dispose() {
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _tzCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final lat = double.tryParse(_latCtrl.text) ?? _draft.latitude;
    final lng = double.tryParse(_lngCtrl.text) ?? _draft.longitude;
    final tz = double.tryParse(_tzCtrl.text) ?? _draft.timezone;

    final updated = _draft.copyWith(
      latitude: lat, longitude: lng, timezone: tz, messageText: _messageCtrl.text,
    );

    await context.read<SettingsCubit>().updateConfig(updated);
    if (!mounted) return;
    context.read<HomeCubit>().recalculate(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
          actions: [
            TextButton(
              onPressed: _save,
              child: const Text('حفظ', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionHeader('موقع المسجد (مسجد الحاجة بثينة الجمال - الجيزة)'),
            _textField(_latCtrl, 'خط العرض (مثال: 29.976)', Icons.map),
            const SizedBox(height: 8),
            _textField(_lngCtrl, 'خط الطول (مثال: 31.141)', Icons.map),
            const SizedBox(height: 8),
            _textField(_tzCtrl, 'المنطقة الزمنية (مثال: 2)', Icons.access_time),
            const SizedBox(height: 24),
            _sectionHeader('طريقة الحساب'),
            _dropdown<CalculationMethod>(
              value: _draft.calculationMethod,
              items: CalculationMethod.values,
              label: (m) => m.name,
              onChanged: (v) => setState(() => _draft = _draft.copyWith(calculationMethod: v)),
            ),
            const SizedBox(height: 16),
            _dropdown<AsrMethod>(
              value: _draft.asrMethod,
              items: AsrMethod.values,
              label: (m) => m.name,
              onChanged: (v) => setState(() => _draft = _draft.copyWith(asrMethod: v)),
            ),
            const SizedBox(height: 24),
            _sectionHeader('مدة الإقامة (بالدقائق)'),
            _iqamaSlider('الفجر', _draft.fajrIqamaOffset, (v) {
              setState(() => _draft = _draft.copyWith(fajrIqamaOffset: v));
            }),
            _iqamaSlider('الظهر', _draft.dhuhrIqamaOffset, (v) {
              setState(() => _draft = _draft.copyWith(dhuhrIqamaOffset: v));
            }),
            _iqamaSlider('العصر', _draft.asrIqamaOffset, (v) {
              setState(() => _draft = _draft.copyWith(asrIqamaOffset: v));
            }),
            _iqamaSlider('المغرب', _draft.maghribIqamaOffset, (v) {
              setState(() => _draft = _draft.copyWith(maghribIqamaOffset: v));
            }),
            _iqamaSlider('العشاء', _draft.ishaIqamaOffset, (v) {
              setState(() => _draft = _draft.copyWith(ishaIqamaOffset: v));
            }),
            const SizedBox(height: 24),
            _sectionHeader('الرسائل والأذكار'),
            TextField(
              controller: _messageCtrl,
              maxLines: 3,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'نص الرسالة',
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _sectionHeader('سرعة شريط الأذكار'),
            _speedSlider(_draft.messageScrollSpeed, (v) {
              setState(() => _draft = _draft.copyWith(messageScrollSpeed: v));
            }),
            const SizedBox(height: 24),
            _sectionHeader('العرض'),
            _dropdown<DisplayMode>(
              value: _draft.displayMode,
              items: DisplayMode.values,
              label: (m) {
                switch (m) {
                  case DisplayMode.auto: return 'تلقائي';
                  case DisplayMode.dark: return 'داكن';
                  case DisplayMode.light: return 'فاتح';
                }
              },
              onChanged: (v) => setState(() => _draft = _draft.copyWith(displayMode: v)),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.goldColor)),
    );
  }

  Widget _textField(TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _dropdown<T>({
    required T value, required List<T> items,
    required String Function(T) label, required ValueChanged<T> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value, isExpanded: true,
          dropdownColor: const Color(0xFF2E2E2E),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: items.map((m) => DropdownMenuItem(value: m, child: Text(label(m)))).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }

  Widget _iqamaSlider(String name, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(name, style: const TextStyle(color: Colors.white70))),
          Expanded(
            child: Slider(
              value: value.toDouble(), min: 0, max: 30, divisions: 30,
              activeColor: AppTheme.goldColor, label: '$value دقيقة',
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
          SizedBox(width: 40, child: Text('$value د', style: const TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _speedSlider(int value, ValueChanged<int> onChanged) {
    final labels = {1: 'بطيء جداً', 2: 'بطيء', 3: 'عادي'};
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 60, child: Text('السرعة', style: TextStyle(color: Colors.white70))),
          Expanded(
            child: Slider(
              value: value.toDouble(), min: 1, max: 3, divisions: 2,
              activeColor: AppTheme.goldColor, label: labels[value] ?? '',
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
          SizedBox(width: 60, child: Text(labels[value] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13))),
        ],
      ),
    );
  }
}
