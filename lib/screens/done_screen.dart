import 'package:flutter/material.dart';

import '../main.dart' show AppColors;

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                '✓',
                style: TextStyle(
                  fontSize: 96,
                  color: AppColors.calmTeal,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '完成了',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                '感受一下身体的变化\n下次累的时候,记得回来',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.inkSecondary,
                      height: 1.6,
                    ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: FilledButton.styleFrom(enableFeedback: false),
                child: const Text('回到首页'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
