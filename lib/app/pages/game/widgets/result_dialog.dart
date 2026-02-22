import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mental_math_trainer/app/controllers/game_controller.dart';

class ResultDialog extends GetView<GameController> {
  const ResultDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final correct = controller.roundCorrect;
    final total = controller.roundTotal;
    final accuracy = total > 0 ? (correct / total * 100).round() : 0;
    final isPerfect = correct == total;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isPerfect ? '🏆' : correct >= total * 0.7 ? '🎉' : '💪',
              style: TextStyle(fontSize: 52.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              isPerfect ? 'result_perfect'.tr : 'result_done'.tr,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: cs.primary,
              ),
            ),
            SizedBox(height: 20.h),

            // Score grid
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _StatRow(
                    label: 'result_score'.tr,
                    value: '$correct / $total',
                    color: cs.primary,
                    bold: true,
                  ),
                  Divider(height: 16.h),
                  _StatRow(
                    label: 'result_accuracy'.tr,
                    value: '$accuracy%',
                    color: accuracy >= 80
                        ? const Color(0xFF2E7D32)
                        : accuracy >= 60
                            ? const Color(0xFFE65100)
                            : cs.error,
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Round results row (colored dots)
            Obx(() => _RoundDots(results: controller.roundResults)),

            SizedBox(height: 20.h),

            // Bonus round offer
            OutlinedButton.icon(
              onPressed: () => controller.requestBonusRound(),
              icon: const Icon(Icons.play_circle_outline_rounded),
              label: Text('result_bonus'.tr),
            ),

            SizedBox(height: 8.h),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('home'.tr),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Get.back();
                      controller.startRound();
                    },
                    child: Text('play_again'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool bold;

  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: cs.onSurfaceVariant),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 20.sp : 16.sp,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _RoundDots extends StatelessWidget {
  final List<bool> results;

  const _RoundDots({required this.results});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: results.map((correct) {
        return Container(
          width: 10.r,
          height: 10.r,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: correct ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
          ),
        );
      }).toList(),
    );
  }
}
