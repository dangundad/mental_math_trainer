import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:mental_math_trainer/app/admob/ads_banner.dart';
import 'package:mental_math_trainer/app/admob/ads_helper.dart';
import 'package:mental_math_trainer/app/controllers/game_controller.dart';
import 'package:mental_math_trainer/app/data/enums/difficulty.dart';
import 'package:mental_math_trainer/app/data/enums/operation.dart';
import 'package:mental_math_trainer/app/routes/app_pages.dart';

class HomePage extends GetView<GameController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'app_name'.tr,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18.sp),
        ),
        centerTitle: false,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.tertiary],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primary.withValues(alpha: 0.08),
              cs.surface,
              cs.secondaryContainer.withValues(alpha: 0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroSection(),
                      SizedBox(height: 20.h),
                      _StatsRow(controller: controller),
                      SizedBox(height: 22.h),
                      _SectionTitle(
                        icon: LucideIcons.chartArea,
                        title: 'difficulty'.tr,
                      ),
                      SizedBox(height: 10.h),
                      _DifficultySelector(controller: controller),
                      SizedBox(height: 20.h),
                      _SectionTitle(
                        icon: LucideIcons.calculator,
                        title: 'operations'.tr,
                      ),
                      SizedBox(height: 10.h),
                      _OperationSelector(controller: controller),
                      SizedBox(height: 24.h),
                      _StartButton(controller: controller),
                      SizedBox(height: 12.h),
                      _ChallengeButton(controller: controller),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              Container(
                color: cs.surface.withValues(alpha: 0.92),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12.w,
                      right: 12.w,
                      top: 8.h,
                      bottom: 10.h,
                    ),
                    child: BannerAdWidget(
                      adUnitId: AdHelper.bannerAdUnitId,
                      type: AdHelper.banner,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.7, end: 1.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          child: Container(
            width: 110.r,
            height: 110.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  cs.primaryContainer,
                  cs.primaryContainer.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: Center(
              child: Icon(LucideIcons.calculator, size: 60.r, color: cs.primary),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'app_name'.tr,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: cs.onSurface,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'home_subtitle'.tr,
                style: TextStyle(fontSize: 13.sp, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18.r, color: cs.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
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
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer,
            cs.secondaryContainer.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Obx(
        () {
          final todayCorrect = controller.todayCorrect.value;
          final todayTotal = controller.todayQuestions.value;
          final accuracy = (controller.todayAccuracy * 100).round();

          return Row(
            children: [
              _StatItem(
                label: 'stat_today'.tr,
                value: '$todayCorrect/$todayTotal',
                color: cs.onPrimaryContainer,
              ),
              _VertDivider(),
              _StatItem(
                label: 'stat_accuracy'.tr,
                value: '$accuracy%',
                color: cs.onPrimaryContainer,
              ),
              _VertDivider(),
              _StatItem(
                label: 'stat_streak'.tr,
                value: '${controller.streak.value}',
                color: cs.onPrimaryContainer,
              ),
            ],
          );
        },
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
              fontSize: 20.sp,
              height: 1.1,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: color.withValues(alpha: 0.75)),
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
      color: Colors.white.withValues(alpha: 0.35),
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  final GameController controller;

  const _DifficultySelector({required this.controller});

  static const _tags = {
    Difficulty.easy: '🌱',
    Difficulty.medium: '🚀',
    Difficulty.hard: '🔥',
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: Difficulty.values.map((d) {
          final isSelected = controller.difficulty.value == d;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: d == Difficulty.values.last ? 0 : 8.w),
              child: _DifficultyCard(
                difficulty: d,
                isSelected: isSelected,
                tag: _tags[d] ?? '',
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
  final String tag;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.difficulty,
    required this.isSelected,
    required this.tag,
    required this.onTap,
  });

  static const _colors = {
    Difficulty.easy: Color(0xFF2E7D32),
    Difficulty.medium: Color(0xFFE65100),
    Difficulty.hard: Color(0xFFC62828),
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _colors[difficulty]!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.16) : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.24),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          children: [
            Text(tag, style: TextStyle(fontSize: 18.sp)),
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

  static const _fallbackSymbols = {
    Operation.addition: '+',
    Operation.subtraction: '-',
    Operation.multiplication: '×',
    Operation.division: '÷',
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final label = operation.labelKey.tr;
    final symbol = _fallbackSymbols[operation] ?? '+';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primaryContainer : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? cs.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? cs.primary.withValues(alpha: 0.18)
                  : cs.shadow.withValues(alpha: 0.06),
              blurRadius: isSelected ? 10 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22.r,
              height: 22.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.primary.withValues(alpha: 0.18)
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                symbol,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
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

class _ChallengeButton extends StatelessWidget {
  final GameController controller;

  const _ChallengeButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      final best = controller.bestChallengeScore.value;
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE65100).withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFE65100), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE65100).withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () {
              controller.startChallenge();
              Get.toNamed(Routes.GAME);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('⚡', style: TextStyle(fontSize: 22.sp)),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'challenge_mode'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFE65100),
                          ),
                        ),
                        if (best > 0)
                          Text(
                            '${'best_challenge_score'.tr}: $best',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: const Color(0xFFE65100),
                    size: 22.r,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _StartButton extends StatefulWidget {
  final GameController controller;

  const _StartButton({required this.controller});

  @override
  State<_StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<_StartButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
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
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) => Transform.scale(
        scale: _pulseAnim.value,
        child: child,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary, cs.tertiary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              widget.controller.startRound();
              Get.toNamed(Routes.GAME);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, size: 28.r, color: cs.onPrimary),
                  SizedBox(width: 10.w),
                  Text(
                    'start_round'.tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
