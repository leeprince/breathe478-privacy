import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'services/app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppSettings.instance.load();
  runApp(const Breathe478App());
}

// 主题颜色常量（被多个 widget 引用，集中放这里）
class AppColors {
  static const Color calmTeal = Color(0xFF4DB6AC);
  static const Color calmTealDark = Color(0xFF00897B);
  static const Color calmTealLight = Color(0xFFB2DFDB);
  static const Color warmPeach = Color(0xFFFFAB91);
  static const Color softBg = Color(0xFFF5F7F8);
  static const Color softBgDark = Color(0xFF1A1F22);
  static const Color inkPrimary = Color(0xFF263238);
  static const Color inkSecondary = Color(0xFF607D8B);

  // 三个阶段的强调色
  static const Color inhale = Color(0xFF4DB6AC); // 青
  static const Color hold = Color(0xFFFFB74D); // 暖橙
  static const Color exhale = Color(0xFF7986CB); // 紫蓝
}

class Breathe478App extends StatelessWidget {
  const Breathe478App({super.key});

  @override
  Widget build(BuildContext context) {
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.calmTeal,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.calmTeal,
      onPrimary: Colors.white,
      primaryContainer: AppColors.calmTealLight,
      onPrimaryContainer: AppColors.calmTealDark,
      surface: Colors.white,
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.calmTeal,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.calmTealLight,
      onPrimary: AppColors.calmTealDark,
      surface: AppColors.softBgDark,
    );

    return MaterialApp(
      title: '深呼吸',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: AppColors.softBg,
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: AppColors.softBgDark,
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const HomeScreen(),
    );
  }
}
