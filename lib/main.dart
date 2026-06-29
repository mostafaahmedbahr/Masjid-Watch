import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/home/presentation/views/home_view.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MasjidWatchApp());
}

class MasjidWatchApp extends StatefulWidget {
  const MasjidWatchApp({super.key});

  @override
  State<MasjidWatchApp> createState() => _MasjidWatchAppState();
}

class _MasjidWatchAppState extends State<MasjidWatchApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => SettingsCubit(),
      child: MaterialApp(
        title: 'ساعة المسجد الذكية',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const _AppLoader(),
      ),
    );
  }
}

class _AppLoader extends StatefulWidget {
  const _AppLoader();

  @override
  State<_AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<_AppLoader> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = context.read<SettingsCubit>();
    await settings.load();
    if (!mounted) return;
    setState(() => _loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, size: 64, color: Colors.white54),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'ساعة المسجد الذكية',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              const CircularProgressIndicator(color: Colors.white54),
            ],
          ),
        ),
      );
    }
    final settings = context.read<SettingsCubit>();
    return BlocProvider(
      create: (_) => HomeCubit()..start(settings.state.config),
      child: const HomeView(),
    );
  }
}
