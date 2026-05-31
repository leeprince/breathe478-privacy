import 'package:flutter/material.dart';

import '../main.dart' show AppColors;
import '../services/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          enableFeedback: false,
          tooltip: '返回',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: AppSettings.instance,
          builder: (context, _) {
            final settings = AppSettings.instance;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _SectionHeader(title: '阶段提醒'),
                _SettingTile(
                  icon: Icons.vibration,
                  title: '震动提醒',
                  subtitle: '每个阶段结束时震动一次',
                  value: settings.vibrationEnabled,
                  onChanged: (v) => settings.setVibration(v),
                ),
                _SettingTile(
                  icon: Icons.notifications_active_outlined,
                  title: '响铃提醒',
                  subtitle: '每个阶段结束时播放系统提示音',
                  value: settings.soundEnabled,
                  onChanged: (v) => settings.setSound(v),
                ),
                const SizedBox(height: 24),
                _SectionHeader(title: '关于'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Text(
                    '深呼吸 · 一款极简的呼吸练习 App。\n练习时请保持坐姿端正，自然呼吸。如有头晕请立即停止。',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.inkSecondary,
                          height: 1.6,
                        ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.calmTealDark,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.calmTealLight.withValues(alpha: 0.4),
      shape: _roundedCornerShape(),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.calmTealDark),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.inkSecondary,
              ),
        ),
        value: value,
        activeThumbColor: AppColors.calmTeal,
        enableFeedback: false,
        onChanged: onChanged,
      ),
    );
  }
}

ShapeBorder _roundedCornerShape() => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
