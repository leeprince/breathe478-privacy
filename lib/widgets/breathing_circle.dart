import 'package:flutter/material.dart';

import '../main.dart' show AppColors;
import '../models/breathing_pattern.dart';

class BreathingCircle extends StatefulWidget {
  final BreathPhase phase;
  final int phaseDurationSeconds;
  final bool paused;

  const BreathingCircle({
    super.key,
    required this.phase,
    required this.phaseDurationSeconds,
    required this.paused,
  });

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  static const double _minScale = 0.5;
  static const double _maxScale = 1.0;
  double _baseScale = _minScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.phaseDurationSeconds),
    );
    _setupAnimationForPhase(widget.phase);
    if (!widget.paused) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant BreathingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.paused != oldWidget.paused) {
      if (widget.paused) {
        _controller.stop();
      } else {
        _controller.forward();
      }
    }

    if (widget.phase != oldWidget.phase ||
        widget.phaseDurationSeconds != oldWidget.phaseDurationSeconds) {
      _baseScale = _scale.value;
      _controller.duration = Duration(seconds: widget.phaseDurationSeconds);
      _setupAnimationForPhase(widget.phase);
      _controller.forward(from: 0);
    }
  }

  void _setupAnimationForPhase(BreathPhase phase) {
    final double end;
    switch (phase) {
      case BreathPhase.inhale:
        end = _maxScale;
        break;
      case BreathPhase.exhale:
        end = _minScale;
        break;
      case BreathPhase.hold:
        end = _baseScale;
        break;
    }
    _scale = Tween<double>(begin: _baseScale, end: end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: phase == BreathPhase.hold ? Curves.linear : Curves.easeInOut,
      ),
    );
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _phaseColor(widget.phase);
    return SizedBox(
      width: 280,
      height: 280,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, _) {
          final s = _scale.value;
          return Center(
            child: Container(
              width: 280 * s,
              height: 280 * s,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.9),
                    color.withValues(alpha: 0.6),
                    color.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
