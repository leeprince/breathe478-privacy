import 'package:flutter/material.dart';

import '../main.dart' show AppColors;
import '../models/breathing_pattern.dart';
import 'session_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '深呼吸',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.calmTealDark,
                                letterSpacing: 2,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '选一种练习,找回平静',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.inkSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings_outlined,
                      color: AppColors.calmTealDark,
                    ),
                    tooltip: '设置',
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ...BreathingPattern.all.map(
                (pattern) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _PatternCard(
                    pattern: pattern,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SessionScreen(pattern: pattern),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '练习时请保持坐姿端正,自然呼吸。如有头晕请立即停止。',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.inkSecondary.withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatternCard extends StatelessWidget {
  final BreathingPattern pattern;
  final VoidCallback onTap;

  const _PatternCard({required this.pattern, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.calmTealLight,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        enableFeedback: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pattern.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.calmTealDark,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                pattern.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.calmTealDark.withValues(alpha: 0.85),
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                '${pattern.rounds} 轮 · 每轮 ${pattern.secondsPerRound} 秒',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.calmTealDark.withValues(alpha: 0.7),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
