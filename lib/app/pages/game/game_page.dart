import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mental_math_trainer/app/controllers/game_controller.dart';
import 'package:mental_math_trainer/app/pages/game/widgets/number_pad.dart';
import 'package:mental_math_trainer/app/pages/game/widgets/result_dialog.dart';

class GamePage extends GetView<GameController> {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch for round result
    ever(controller.phase, (phase) {
      if (phase == RoundPhase.result) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (Get.isDialogOpen != true) {
            Get.dialog(const ResultDialog(), barrierDismissible: false);
          }
        });
      }
    });

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            '${'question'.tr} ${controller.questionIndex.value + 1} / ${controller.roundTotal}',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              _TimerBar(controller: controller),
              SizedBox(height: 24.h),
              _QuestionDisplay(controller: controller),
              SizedBox(height: 16.h),
              _FeedbackArea(controller: controller),
              const Spacer(),
              _InputDisplay(controller: controller, cs: cs),
              SizedBox(height: 16.h),
              NumberPad(
                onDigit: controller.appendDigit,
                onBackspace: controller.backspace,
                onSubmit: controller.submitAnswer,
                allowNegative: true,
              ),
              SizedBox(height: 12.h),
              ConfirmButton(onTap: controller.submitAnswer),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  final GameController controller;

  const _TimerBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      final progress = controller.timeProgress.value.clamp(0.0, 1.0);
      final color = progress > 0.5
          ? cs.primary
          : progress > 0.25
              ? Colors.orange
              : cs.error;

      return ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 8.h,
          backgroundColor: cs.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    });
  }
}

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
        child: Text(
          q.display,
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
            color: cs.onPrimaryContainer,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
      );
    });
  }
}

class _FeedbackArea extends StatelessWidget {
  final GameController controller;

  const _FeedbackArea({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.phase.value != RoundPhase.feedback) {
        return SizedBox(height: 32.h);
      }
      final correct = controller.lastAnswerCorrect.value;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Container(
          key: ValueKey(controller.questionIndex.value),
          height: 32.h,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
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
        child: Text(
          input.isEmpty ? '?' : input,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
            color: input.isEmpty ? cs.onSurface.withValues(alpha: 0.3) : cs.primary,
          ),
        ),
      );
    });
  }
}
