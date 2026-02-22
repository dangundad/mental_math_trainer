import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NumberPad extends StatelessWidget {
  final void Function(String digit) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;
  final bool allowNegative;

  const NumberPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onSubmit,
    this.allowNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(context, ['7', '8', '9']),
        SizedBox(height: 8.h),
        _buildRow(context, ['4', '5', '6']),
        SizedBox(height: 8.h),
        _buildRow(context, ['1', '2', '3']),
        SizedBox(height: 8.h),
        _buildBottomRow(context),
      ],
    );
  }

  Widget _buildRow(BuildContext context, List<String> digits) {
    return Row(
      children: digits
          .map(
            (d) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: _NumKey(
                  label: d,
                  onTap: () => onDigit(d),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: allowNegative
                ? _NumKey(label: '±', icon: Icons.exposure, onTap: () => onDigit('-'))
                : _NumKey(label: '', icon: Icons.abc, onTap: () {}, disabled: true),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: _NumKey(label: '0', onTap: () => onDigit('0')),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: _NumKey(
              label: '',
              icon: Icons.backspace_outlined,
              onTap: onBackspace,
              isDestructive: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _NumKey extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool disabled;
  final bool isDestructive;

  const _NumKey({
    required this.label,
    this.icon,
    required this.onTap,
    this.disabled = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bgColor = isDestructive
        ? cs.errorContainer
        : disabled
            ? cs.surfaceContainerLow
            : cs.surfaceContainerHigh;
    final fgColor = isDestructive
        ? cs.onErrorContainer
        : disabled
            ? cs.onSurface.withValues(alpha: 0.3)
            : cs.onSurface;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, size: 22.r, color: fgColor)
            : Text(
                label,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: fgColor,
                ),
              ),
      ),
    );
  }
}

// Confirm button, separate widget
class ConfirmButton extends StatelessWidget {
  final VoidCallback onTap;

  const ConfirmButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.check_rounded),
        label: Text(
          'submit'.tr,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
