import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../main.dart' show AppColors;
import '../models/breathing_pattern.dart';
import '../services/app_settings.dart';
import '../widgets/breathing_circle.dart';
import 'done_screen.dart';

class SessionScreen extends StatefulWidget {
  final BreathingPattern pattern;
  const SessionScreen({super.key, required this.pattern});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late int _round;
  late int _segmentIndex;
  late int _secondsLeft;
  // 默认暂停，等用户点"开始"才计时
  bool _paused = true;
  // 是否曾经启动过（决定按钮文本是"开始"还是"继续"）
  bool _hasStarted = false;
  Timer? _timer;

  PhaseSegment get _currentSegment => widget.pattern.segments[_segmentIndex];

  @override
  void initState() {
    super.initState();
    _round = 1;
    _segmentIndex = 0;
    _secondsLeft = widget.pattern.segments[0].seconds;
    WakelockPlus.enable();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused) return;
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          _onPhaseEnd();
          _advance();
        }
      });
    });
  }

  /// 当前阶段倒计时归零时触发：根据用户设置发出震动/响铃。
  void _onPhaseEnd() {
    final settings = AppSettings.instance;
    if (settings.vibrationEnabled) {
      // 中等强度震动，比 lightImpact 明显，又不会突兀
      HapticFeedback.mediumImpact();
    }
    if (settings.soundEnabled) {
      // 系统提示音（点击音），跨平台稳定，不需要资源文件
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _advance() {
    final nextSeg = _segmentIndex + 1;
    if (nextSeg >= widget.pattern.segments.length) {
      if (_round >= widget.pattern.rounds) {
        _finish();
        return;
      }
      _round++;
      _segmentIndex = 0;
    } else {
      _segmentIndex = nextSeg;
    }
    _secondsLeft = widget.pattern.segments[_segmentIndex].seconds;
  }

  void _finish() {
    _timer?.cancel();
    WakelockPlus.disable();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DoneScreen()),
    );
  }

  void _togglePause() {
    setState(() {
      _paused = !_paused;
      if (!_paused) _hasStarted = true;
    });
  }

  void _back() {
    _timer?.cancel();
    WakelockPlus.disable();
    Navigator.of(context).pop();
  }

  Color _phaseColor(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return AppColors.inhale;
      case BreathPhase.exhale:
        return AppColors.exhale;
      case BreathPhase.hold:
        return AppColors.hold;
    }
  }

  String _buttonLabel() {
    if (!_paused) return '暂停';
    return _hasStarted ? '继续' : '开始';
  }

  @override
  void dispose() {
    _timer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final segment = _currentSegment;
    final color = _phaseColor(segment.phase);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _back,
                    style: TextButton.styleFrom(enableFeedback: false),
                    child: const Text('返回'),
                  ),
                  Text(
                    '第 $_round / ${widget.pattern.rounds} 轮',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.inkSecondary,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              BreathingCircle(
                phase: segment.phase,
                phaseDurationSeconds: segment.seconds,
                paused: _paused,
              ),
              const SizedBox(height: 48),
              Text(
                segment.phase.label,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: color,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '$_secondsLeft',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w100,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _togglePause,
                style: FilledButton.styleFrom(enableFeedback: false),
                child: Text(_buttonLabel()),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
