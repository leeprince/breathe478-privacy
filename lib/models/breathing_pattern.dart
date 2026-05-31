enum BreathPhase {
  inhale('吸气'),
  hold('屏息'),
  exhale('呼气');

  final String label;
  const BreathPhase(this.label);
}

class PhaseSegment {
  final BreathPhase phase;
  final int seconds;

  const PhaseSegment(this.phase, this.seconds);
}

class BreathingPattern {
  final String id;
  final String name;
  final String description;
  final List<PhaseSegment> segments;
  final int rounds;

  const BreathingPattern({
    required this.id,
    required this.name,
    required this.description,
    required this.segments,
    required this.rounds,
  });

  int get secondsPerRound => segments.fold(0, (sum, s) => sum + s.seconds);

  static const List<BreathingPattern> all = [
    BreathingPattern(
      id: '4-7-8',
      name: '4-7-8 放松呼吸',
      description: '吸气 4 秒，屏息 7 秒，呼气 8 秒。帮助快速入睡和缓解焦虑。',
      segments: [
        PhaseSegment(BreathPhase.inhale, 4),
        PhaseSegment(BreathPhase.hold, 7),
        PhaseSegment(BreathPhase.exhale, 8),
      ],
      rounds: 4,
    ),
    BreathingPattern(
      id: 'box',
      name: '方块呼吸',
      description: '吸 4 秒、屏 4 秒、呼 4 秒、屏 4 秒。专注力训练，海军特种兵在用。',
      segments: [
        PhaseSegment(BreathPhase.inhale, 4),
        PhaseSegment(BreathPhase.hold, 4),
        PhaseSegment(BreathPhase.exhale, 4),
        PhaseSegment(BreathPhase.hold, 4),
      ],
      rounds: 5,
    ),
    BreathingPattern(
      id: 'deep',
      name: '深呼吸',
      description: '吸气 4 秒，呼气 6 秒。最简单的放松练习，随时随地都能做。',
      segments: [
        PhaseSegment(BreathPhase.inhale, 4),
        PhaseSegment(BreathPhase.exhale, 6),
      ],
      rounds: 6,
    ),
  ];
}
