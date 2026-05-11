// ignore_for_file: must_call_super

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:mental_math_trainer/app/admob/ads_interstitial.dart';
import 'package:mental_math_trainer/app/controllers/game_controller.dart';
import 'package:mental_math_trainer/app/controllers/setting_controller.dart';
import 'package:mental_math_trainer/app/services/hive_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const vibrationChannel = MethodChannel('vibration');

  setUp(() {
    Get.testMode = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(vibrationChannel, (call) async {
          if (call.method == 'hasVibrator') {
            return false;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(vibrationChannel, null);
    Get.reset();
  });

  testWidgets('round result waits for daily stats persistence', (tester) async {
    final hive = _BlockingHiveService();
    Get.put<HiveService>(hive);
    Get.put<SettingController>(_FakeSettingController()).hapticEnabled.value =
        false;
    Get.put<InterstitialAdManager>(_FakeInterstitialAdManager());

    final controller = Get.put(GameController());
    controller.startRound();

    for (var i = 0; i < controller.roundTotal; i++) {
      _answerCurrent(controller);
      await tester.pump(const Duration(milliseconds: 801));
    }

    expect(hive.dailyCorrectStarted, isTrue);
    expect(hive.dailyCorrectCompleted, isFalse);
    expect(controller.phase.value, isNot(RoundPhase.result));

    hive.completeDailyCorrect();
    await tester.pump();

    expect(controller.phase.value, RoundPhase.result);

    controller.onClose();
  });

  testWidgets('round completion does not require an interstitial ad manager', (
    tester,
  ) async {
    Get.put<HiveService>(_FakeHiveService());
    Get.put<SettingController>(_FakeSettingController()).hapticEnabled.value =
        false;

    final controller = Get.put(GameController());
    controller.startRound();

    for (var i = 0; i < controller.roundTotal; i++) {
      _answerCurrent(controller);
      await tester.pump(const Duration(milliseconds: 801));
    }

    expect(controller.phase.value, RoundPhase.result);

    controller.onClose();
  });
}

void _answerCurrent(GameController controller) {
  final answer = controller.currentQuestion.value!.answer.toString();
  for (final digit in answer.split('')) {
    controller.appendDigit(digit);
  }
  controller.submitAnswer();
}

class _FakeHiveService extends HiveService {
  final Map<String, dynamic> data = <String, dynamic>{};

  @override
  T? getAppData<T>(String key, {T? defaultValue}) {
    return (data[key] ?? defaultValue) as T?;
  }

  @override
  Future<void> setAppData(String key, dynamic value) async {
    data[key] = value;
  }

  @override
  int getDailyCorrect(String dateKey) {
    return data['mm_daily_correct_$dateKey'] as int? ?? 0;
  }

  @override
  Future<void> addDailyCorrect(String dateKey, int correct) async {
    data['mm_daily_correct_$dateKey'] = getDailyCorrect(dateKey) + correct;
  }
}

class _BlockingHiveService extends _FakeHiveService {
  final Completer<void> _dailyCorrectCompleter = Completer<void>();
  bool dailyCorrectStarted = false;
  bool dailyCorrectCompleted = false;

  @override
  Future<void> addDailyCorrect(String dateKey, int correct) async {
    dailyCorrectStarted = true;
    await _dailyCorrectCompleter.future;
    await super.addDailyCorrect(dateKey, correct);
    dailyCorrectCompleted = true;
  }

  void completeDailyCorrect() {
    if (!_dailyCorrectCompleter.isCompleted) {
      _dailyCorrectCompleter.complete();
    }
  }
}

class _FakeSettingController extends SettingController {
  @override
  void onInit() {}
}

class _FakeInterstitialAdManager extends InterstitialAdManager {
  @override
  void onInit() {}

  @override
  void showAdIfAvailable() {}
}
