import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mental_math_trainer/app/controllers/game_controller.dart';
import 'package:mental_math_trainer/app/pages/game/widgets/number_pad.dart';
import 'package:mental_math_trainer/app/pages/game/widgets/result_dialog.dart';
import 'package:mental_math_trainer/app/widgets/confetti_overlay.dart';

class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _GamePageContent(controller: controller);
  }
}

class _GamePageContent extends StatefulWidget {
  final GameController controller;

  const _GamePageContent({required this.controller});

  @override
  State<_GamePageContent> createState() => _GamePageState();
}

class _GamePageState extends State<_GamePageContent> {
  Worker? _phaseWorker;

  @override
  void initState() {
    super.initState();
    _phaseWorker = ever(widget.controller.phase, (phase) {
      if (phase == RoundPhase.result) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (Get.isDialogOpen != true) {
            Get.dialog(const ResultDialog(), barrierDismissible: false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _phaseWorker?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final ctrl = widget.controller;
          if (ctrl.gameMode.value == GameMode.challenge) {
            return Text('challenge_mode'.tr);
          }
          return Text(
            '${'question'.tr} ${ctrl.questionIndex.value + 1} / ${ctrl.roundTotal}',
          );
        }),
        centerTitle: true,
        actions: [
          Obx(() {
            if (widget.controller.gameMode.value != GameMode.challenge) {
              return const SizedBox.shrink();
            }
            final left = widget.controller.challengeTimeLeft.value;
            final color = left <= 10
                ? const Color(0xFFC62828)
                : left <= 20
                    ? Colors.orange
                    : null;
            return Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Center(
                child: Text(
                  '${left}s',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  _TimerBar(controller: widget.controller),
                  SizedBox(height: 24.h),
                  _QuestionDisplay(controller: widget.controller),
                  SizedBox(height: 16.h),
                  _FeedbackArea(controller: widget.controller),
                  const Spacer(),
                  _InputDisplay(controller: widget.controller, cs: cs),
                  SizedBox(height: 16.h),
                  NumberPad(
                    onDigit: widget.controller.appendDigit,
                    onBackspace: widget.controller.backspace,
                    onSubmit: widget.controller.submitAnswer,
                    allowNegative: true,
                  ),
                  SizedBox(height: 12.h),
                  ConfirmButton(onTap: widget.controller.submitAnswer),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            Obx(() {
              if (!widget.controller.showConfetti.value) {
                return const SizedBox.shrink();
              }
              return IgnorePointer(
                child: ConfettiOverlay(
                  onComplete: () =>
                      widget.controller.showConfetti.value = false,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Timer Bar (with urgency flash when < 20%) ───────────
class _TimerBar extends StatefulWidget {
  final GameController controller;

  const _TimerBar({required this.controller});

  @override
  State<_TimerBar> createState() => _TimerBarState();
}

class _TimerBarState extends State<_TimerBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pulseAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      final progress = widget.controller.timeProgress.value.clamp(0.0, 1.0);
      final isUrgent = progress < 0.2;

      if (isUrgent && !_pulseCtrl.isAnimating) {
        _pulseCtrl.repeat(reverse: true);
      } else if (!isUrgent && _pulseCtrl.isAnimating) {
        _pulseCtrl.stop();
        _pulseCtrl.value = 1.0;
      }

      final color = progress > 0.5
          ? cs.primary
          : progress > 0.25
              ? Colors.orange
              : cs.error;

      final bar = ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 8.h,
          backgroundColor: cs.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );

      if (!isUrgent) return bar;

      return AnimatedBuilder(
        animation: _pulseAnim,
        builder: (context, child) => Opacity(
          opacity: _pulseAnim.value,
          child: child,
        ),
        child: bar,
      );
    });
  }
}

// ─── Question Display (with AnimatedSwitcher scale) ───────
class _QuestionDisplay extends StatelessWidget {
  final GameController controller;

  const _QuestionDisplay({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      final q = controller.currentQuestion.value;
      if (q == null) return const SizedBox.shrink();

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Text(
            q.display,
            key: ValueKey(q.display),
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.w900,
              color: cs.onPrimaryContainer,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}

// ─── Feedback Area (with shake on wrong answer) ───────────
class _FeedbackArea extends StatefulWidget {
  final GameController controller;

  const _FeedbackArea({required this.controller});

  @override
  State<_FeedbackArea> createState() => _FeedbackAreaState();
}

class _FeedbackAreaState extends State<_FeedbackArea>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;
  Worker? _phaseWorker;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(_shakeCtrl);

    _phaseWorker = ever(widget.controller.phase, (phase) {
      if (phase == RoundPhase.feedback &&
          !widget.controller.lastAnswerCorrect.value) {
        _shakeCtrl.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    _phaseWorker?.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.phase.value != RoundPhase.feedback) {
        return SizedBox(height: 32.h);
      }
      final correct = widget.controller.lastAnswerCorrect.value;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: AnimatedBuilder(
          key: ValueKey(widget.controller.questionIndex.value),
          animation: _shakeAnim,
          builder: (context, child) => Transform.translate(
            offset: Offset(_shakeAnim.value, 0),
            child: child,
          ),
          child: Container(
            height: 32.h,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  correct
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: correct
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFC62828),
                  size: 22.r,
                ),
                SizedBox(width: 6.w),
                Text(
                  correct ? 'correct'.tr : 'wrong'.tr,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: correct
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFC62828),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _InputDisplay extends StatelessWidget {
  final GameController controller;
  final ColorScheme cs;

  const _InputDisplay({required this.controller, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final input = controller.userInput.value;
      return Container(
        width: double.infinity,
        height: 60.h,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: cs.primary, width: 2),
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 120),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Text(
            input.isEmpty ? '?' : input,
            key: ValueKey(input),
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: input.isEmpty
                  ? cs.onSurface.withValues(alpha: 0.3)
                  : cs.primary,
            ),
          ),
        ),
      );
    });
  }
}
