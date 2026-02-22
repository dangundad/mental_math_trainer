import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mental_math_trainer/app/controllers/game_controller.dart';
import 'package:mental_math_trainer/app/data/enums/difficulty.dart';
import 'package:mental_math_trainer/app/data/enums/operation.dart';
import 'package:mental_math_trainer/app/routes/app_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              _Header(),
              SizedBox(height: 24.h),
              _StatsRow(controller: controller),
              SizedBox(height: 28.h),
              Text(
                'difficulty'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 10.h),
              _DifficultySelector(controller: controller),
              SizedBox(height: 24.h),
              Text(
                'operations'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 10.h),
              _OperationSelector(controller: controller),
              SizedBox(height: 32.h),
              _StartButton(controller: controller),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🧮', style: TextStyle(fontSize: 48.sp)),
        SizedBox(height: 8.h),
        Text(
          'app_name'.tr,
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
            color: cs.primary,
          ),
        ),
        Text(
          'home_subtitle'.tr,
          style: TextStyle(fontSize: 13.sp, color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final GameController controller;

  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Obx(
        () => Row(
          children: [
            _StatItem(
              label: 'stat_today'.tr,
              value:
                  '${controller.todayCorrect.value}/${controller.todayQuestions.value}',
              color: cs.onPrimaryContainer,
            ),
            _VertDivider(),
            _StatItem(
              label: 'stat_accuracy'.tr,
              value: '${(controller.todayAccuracy * 100).round()}%',
              color: cs.onPrimaryContainer,
            ),
            _VertDivider(),
            _StatItem(
              label: 'stat_streak'.tr,
              value: '${controller.streak.value}🔥',
              color: cs.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: color.withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  final GameController controller;

  const _DifficultySelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: Difficulty.values.map((d) {
          final isSelected = controller.difficulty.value == d;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: d == Difficulty.values.last ? 0 : 8.w,
              ),
              child: _DifficultyCard(
                difficulty: d,
                isSelected: isSelected,
                onTap: () => controller.setDifficulty(d),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class _DifficultyCard extends StatelessWidget {
  final Difficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  static const _colors = {
    Difficulty.easy: Color(0xFF2E7D32),
    Difficulty.medium: Color(0xFFE65100),
    Difficulty.hard: Color(0xFFC62828),
  };

  static const _stars = {
    Difficulty.easy: '⭐',
    Difficulty.medium: '⭐⭐',
    Difficulty.hard: '⭐⭐⭐',
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _colors[difficulty]!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(_stars[difficulty]!, style: TextStyle(fontSize: 14.sp)),
            SizedBox(height: 4.h),
            Text(
              difficulty.labelKey.tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? color : cs.onSurface,
              ),
            ),
            Text(
              '${difficulty.timePerQuestion}s / ${'question'.tr}',
              style: TextStyle(
                fontSize: 10.sp,
                color: isSelected ? color : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OperationSelector extends StatelessWidget {
  final GameController controller;

  const _OperationSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: Operation.values.map((op) {
          final isSelected = controller.selectedOps.contains(op);
          return _OpChip(
            operation: op,
            isSelected: isSelected,
            onTap: () => controller.toggleOperation(op),
          );
        }).toList(),
      );
    });
  }
}

class _OpChip extends StatelessWidget {
  final Operation operation;
  final bool isSelected;
  final VoidCallback onTap;

  const _OpChip({
    required this.operation,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primaryContainer : cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? cs.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(operation.emoji, style: TextStyle(fontSize: 16.sp)),
            SizedBox(width: 6.w),
            Text(
              operation.labelKey.tr,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? cs.primary : cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  final GameController controller;

  const _StartButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: FilledButton.icon(
        onPressed: () {
          controller.startRound();
          Get.toNamed(Routes.GAME);
        },
        icon: Icon(Icons.play_arrow_rounded, size: 28.r),
        label: Text(
          'start_round'.tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
