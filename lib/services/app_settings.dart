import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 全局设置：响铃 / 震动 提醒开关。
///
/// 使用方式：
///   await AppSettings.instance.load();        // main() 启动时调用一次
///   AppSettings.instance.vibrationEnabled     // 读
///   AppSettings.instance.setVibration(true)   // 写（自动持久化 + 通知监听）
///
/// 继承 ChangeNotifier 是为了让 SettingsScreen 的 toggle 立即反映到 UI。
class AppSettings extends ChangeNotifier {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  static const _kVibrationKey = 'vibration_enabled';
  static const _kSoundKey = 'sound_enabled';

  bool _vibrationEnabled = true; // 默认开
  bool _soundEnabled = false; // 默认关

  bool get vibrationEnabled => _vibrationEnabled;
  bool get soundEnabled => _soundEnabled;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _vibrationEnabled = prefs.getBool(_kVibrationKey) ?? true;
    _soundEnabled = prefs.getBool(_kSoundKey) ?? false;
    notifyListeners();
  }

  Future<void> setVibration(bool value) async {
    if (_vibrationEnabled == value) return;
    _vibrationEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kVibrationKey, value);
  }

  Future<void> setSound(bool value) async {
    if (_soundEnabled == value) return;
    _soundEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSoundKey, value);
  }
}
