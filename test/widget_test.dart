// Basic smoke test for the breathing app.
import 'package:breathe478/main.dart';
import 'package:breathe478/services/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home screen renders pattern cards', (WidgetTester tester) async {
    // Settings.load() reads from SharedPreferences which uses platform channels.
    // In widget tests we skip persistence and just rely on the in-memory defaults.
    TestWidgetsFlutterBinding.ensureInitialized();

    await tester.pumpWidget(const Breathe478App());
    await tester.pump();

    // App title shows up
    expect(find.text('深呼吸'), findsOneWidget);
    // All three breathing patterns render
    expect(find.text('4-7-8 放松呼吸'), findsOneWidget);
    expect(find.text('方块呼吸'), findsOneWidget);
    expect(find.text('深呼吸'), findsAtLeastNWidgets(1));
  });

  test('AppSettings defaults are vibration on, sound off', () {
    expect(AppSettings.instance.vibrationEnabled, isTrue);
    expect(AppSettings.instance.soundEnabled, isFalse);
  });
}
