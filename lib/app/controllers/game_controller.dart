import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:mental_math_trainer/app/admob/ads_interstitial.dart';
import 'package:mental_math_trainer/app/admob/ads_rewarded.dart';
import 'package:mental_math_trainer/app/data/enums/difficulty.dart';
import 'package:mental_math_trainer/app/data/enums/operation.dart';
import 'package:mental_math_trainer/app/services/hive_service.dart';

class Question {
  final int operand1;
  final int operand2;
  final Operation operation;

  const Question({
    required this.operand1,
    required this.operand2,
    required this.operation,
  });

  int get answer {
    switch (operation) {
      case Operation.addition:
        return operand1 + operand2;
      case Operation.subtraction:
        return operand1 - operand2;
      case Operation.multiplication:
        return operand1 * operand2;
      case Operation.division:
        return operand1 ~/ operand2;
    }
  }

  String get display => '$operand1 ${operation.symbol} $operand2 = ?';
}

enum RoundPhase { idle, question, feedback, result }

class GameController extends GetxController {
  static GameController get to => Get.find();

  // Hive keys
  static const _totalCorrectKey = 'mm_total_correct';
  static const _totalQuestionsKey = 'mm_total_questions';
  static const _todayCorrectKey = 'mm_today_correct';
  static const _todayQuestionsKey = 'mm_today_questions';
  static const _todayDateKey = 'mm_today_date';
  static const _streakKey = 'mm_streak';
  static const _lastPlayedKey = 'mm_last_played';

  // Settings (observable)
  final difficulty = Difficulty.easy.obs;
  final selectedOps = <Operation>{Operation.addition}.obs;

  // Game state
  final phase = RoundPhase.idle.obs;
  final questionIndex = 0.obs;
  final currentQuestion = Rxn<Question>();
  final userInput = ''.obs;
  final timeProgress = 1.0.obs; // 1.0 → 0.0
  final lastAnswerCorrect = false.obs;
  final roundResults = <bool>[].obs;

  // Stats
  final totalCorrect = 0.obs;
  final totalQuestions = 0.obs;
  final todayCorrect = 0.obs;
  final todayQuestions = 0.obs;
  final streak = 0.obs;

  Timer? _questionTimer;
  final _random = Random();
  int _roundCorrect = 0;

  @override
  void onInit() {
    super.onInit();
    _loadStats();
  }

  @override
  void onClose() {
    _questionTimer?.cancel();
    super.onClose();
  }

  // ─── Settings ────────────────────────────────────────
  void setDifficulty(Difficulty d) => difficulty.value = d;

  void toggleOperation(Operation op) {
    if (selectedOps.contains(op)) {
      if (selectedOps.length > 1) selectedOps.remove(op);
    } else {
      selectedOps.add(op);
    }
  }

  // ─── Round flow ───────────────────────────────────────
  void startRound() {
    roundResults.clear();
    questionIndex.value = 0;
    _roundCorrect = 0;
    _nextQuestion();
  }

  void _nextQuestion() {
    userInput.value = '';
    currentQuestion.value = _generateQuestion();
    timeProgress.value = 1.0;
    phase.value = RoundPhase.question;
    _startTimer();
  }

  void _startTimer() {
    _questionTimer?.cancel();
    const tickMs = 100;
    final totalTicks = difficulty.value.timePerQuestion * 10; // 10 ticks/s
    int elapsed = 0;

    _questionTimer = Timer.periodic(const Duration(milliseconds: tickMs), (t) {
      elapsed++;
      timeProgress.value = 1.0 - (elapsed / totalTicks);
      if (elapsed >= totalTicks) {
        t.cancel();
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    _questionTimer?.cancel();
    _recordAnswer(correct: false);
  }

  void appendDigit(String digit) {
    if (phase.value != RoundPhase.question) return;
    if (userInput.value.length >= 5) return;
    // Handle negative sign
    if (digit == '-') {
      if (userInput.value.isEmpty) {
        userInput.value = '-';
      }
      return;
    }
    if (userInput.value == '0') {
      userInput.value = digit;
    } else {
      userInput.value += digit;
    }
  }

  void backspace() {
    if (phase.value != RoundPhase.question) return;
    if (userInput.value.isNotEmpty) {
      userInput.value =
          userInput.value.substring(0, userInput.value.length - 1);
    }
  }

  void submitAnswer() {
    if (phase.value != RoundPhase.question) return;
    final parsed = int.tryParse(userInput.value);
    if (parsed == null) return;
    _questionTimer?.cancel();
    final correct = parsed == currentQuestion.value?.answer;
    _recordAnswer(correct: correct);
  }

  void _recordAnswer({required bool correct}) {
    lastAnswerCorrect.value = correct;
    roundResults.add(correct);
    if (correct) _roundCorrect++;
    phase.value = RoundPhase.feedback;

    // Show feedback for 800ms, then advance
    Future.delayed(const Duration(milliseconds: 800), () {
      final idx = questionIndex.value + 1;
      if (idx >= difficulty.value.questionsPerRound) {
        _endRound();
      } else {
        questionIndex.value = idx;
        _nextQuestion();
      }
    });
  }

  void _endRound() {
    _updateStats(_roundCorrect, difficulty.value.questionsPerRound);
    phase.value = RoundPhase.result;
    InterstitialAdManager.to.showAdIfAvailable();
  }

  void requestBonusRound() {
    RewardedAdManager.to.showAdIfAvailable(
      onUserEarnedReward: (_) {
        // Give an extra 5 questions
        Get.back(); // close result dialog
        roundResults.clear();
        questionIndex.value = 0;
        _roundCorrect = 0;
        _nextQuestion();
      },
    );
  }

  // ─── Question generation ──────────────────────────────
  Question _generateQuestion() {
    final ops = selectedOps.toList();
    final op = ops[_random.nextInt(ops.length)];
    final d = difficulty.value;

    switch (op) {
      case Operation.addition:
        final a = _random.nextInt(d.addSubMax) + 1;
        final b = _random.nextInt(d.addSubMax) + 1;
        return Question(operand1: a, operand2: b, operation: op);

      case Operation.subtraction:
        final a = _random.nextInt(d.addSubMax) + 1;
        final b = _random.nextInt(a) + 1; // b ≤ a → result ≥ 0
        return Question(operand1: a, operand2: b, operation: op);

      case Operation.multiplication:
        final a = _random.nextInt(d.mulMax) + 2;
        final b = _random.nextInt(d.mulMax) + 2;
        return Question(operand1: a, operand2: b, operation: op);

      case Operation.division:
        final quotient = _random.nextInt(d.divQuotientMax) + 1;
        final divisor = _random.nextInt(d.divDivisorMax - 1) + 2;
        // operand1 = quotient * divisor → exact division
        return Question(
          operand1: quotient * divisor,
          operand2: divisor,
          operation: op,
        );
    }
  }

  // ─── Stats ────────────────────────────────────────────
  void _loadStats() {
    totalCorrect.value = HiveService.to.getAppData<int>(_totalCorrectKey) ?? 0;
    totalQuestions.value =
        HiveService.to.getAppData<int>(_totalQuestionsKey) ?? 0;
    streak.value = HiveService.to.getAppData<int>(_streakKey) ?? 0;

    final today = _todayKey();
    final storedDate = HiveService.to.getAppData<String>(_todayDateKey) ?? '';
    if (storedDate == today) {
      todayCorrect.value =
          HiveService.to.getAppData<int>(_todayCorrectKey) ?? 0;
      todayQuestions.value =
          HiveService.to.getAppData<int>(_todayQuestionsKey) ?? 0;
    } else {
      todayCorrect.value = 0;
      todayQuestions.value = 0;
    }
  }

  void _updateStats(int correct, int total) {
    totalCorrect.value += correct;
    totalQuestions.value += total;

    final today = _todayKey();
    final storedDate = HiveService.to.getAppData<String>(_todayDateKey) ?? '';

    if (storedDate != today) {
      todayCorrect.value = correct;
      todayQuestions.value = total;
      // Update streak
      final yesterday = _yesterdayKey();
      final lastPlayed =
          HiveService.to.getAppData<String>(_lastPlayedKey) ?? '';
      if (lastPlayed == yesterday) {
        streak.value++;
      } else if (lastPlayed != today) {
        streak.value = 1;
      }
      HiveService.to.setAppData(_streakKey, streak.value);
      HiveService.to.setAppData(_todayDateKey, today);
      HiveService.to.setAppData(_lastPlayedKey, today);
    } else {
      todayCorrect.value += correct;
      todayQuestions.value += total;
    }

    HiveService.to.setAppData(_totalCorrectKey, totalCorrect.value);
    HiveService.to.setAppData(_totalQuestionsKey, totalQuestions.value);
    HiveService.to.setAppData(_todayCorrectKey, todayCorrect.value);
    HiveService.to.setAppData(_todayQuestionsKey, todayQuestions.value);
  }

  String _todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _yesterdayKey() => DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 1)));

  // Computed getters
  int get roundCorrect => _roundCorrect;
  int get roundTotal => difficulty.value.questionsPerRound;

  double get todayAccuracy {
    if (todayQuestions.value == 0) return 0;
    return todayCorrect.value / todayQuestions.value;
  }

  double get totalAccuracy {
    if (totalQuestions.value == 0) return 0;
    return totalCorrect.value / totalQuestions.value;
  }
}
