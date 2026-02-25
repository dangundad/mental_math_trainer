import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:mental_math_trainer/app/controllers/stats_controller.dart';

class StatsPage extends GetView<StatsController> {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cs.surface,
                cs.surfaceContainerLowest.withValues(alpha: 0.94),
                cs.surfaceContainerLow.withValues(alpha: 0.9),
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 8.h, 14.w, 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'open_stats'.tr,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.refresh(),
                      icon: Icon(
                        LucideIcons.refreshCw,
                        color: cs.primary,
                        size: 20.r,
                      ),
                      tooltip: 'refresh'.tr,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.refresh(),
                  color: cs.primary,
                  child: Obx(
                    () => ListView(
                      padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 24.h),
                      children: [
                        _MetricCard(
                          cs: cs,
                          entries: [
                            _MetricData('total_events'.tr, '${controller.totalEvents.value}'),
                            _MetricData('today_events'.tr, '${controller.todayEvents.value}'),
                            _MetricData('week_events'.tr, '${controller.weekEvents.value}'),
                            _MetricData('open_stats'.tr, '${controller.openStatsCount.value}'),
                            _MetricData('unique_routes'.tr, '${controller.uniqueRoutes.value}'),
                            _MetricData('unique_screens'.tr, '${controller.uniqueScreens.value}'),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _WeeklyChart(cs: cs, controller: controller),
                        SizedBox(height: 16.h),
                        _SectionCard(
                          cs: cs,
                          title: 'top_events'.tr,
                          child: controller.topEventNames.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Center(
                                    child: Text(
                                      'no_data'.tr,
                                      style: TextStyle(
                                        color: cs.onSurfaceVariant,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: controller.topEventNames.map((name) {
                                    final count = controller.eventCountMap[name] ?? 0;
                                    return _TopEventRow(
                                      event: name,
                                      count: count,
                                      cs: cs,
                                    );
                                  }).toList(),
                                ),
                        ),
                        SizedBox(height: 24.h),
                      ],
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

// ─── Weekly Bar Chart ─────────────────────────────────────

class _WeeklyChart extends StatelessWidget {
  final ColorScheme cs;
  final StatsController controller;

  const _WeeklyChart({required this.cs, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'weekly_chart'.tr,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'weekly_chart_subtitle'.tr,
            style: TextStyle(
              fontSize: 11.sp,
              color: cs.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 160.h,
            child: Obx(() {
              final data = controller.weeklyCorrect;
              final keys = data.keys.toList();
              final maxVal = data.values.fold(0, (a, b) => a > b ? a : b);
              final maxY = maxVal < 5 ? 5.0 : (maxVal + 2).toDouble();

              if (keys.isEmpty) {
                return Center(
                  child: Text(
                    'no_data'.tr,
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13.sp),
                  ),
                );
              }

              final barGroups = keys.asMap().entries.map((entry) {
                final i = entry.key;
                final key = entry.value;
                final val = (data[key] ?? 0).toDouble();
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: val,
                      gradient: LinearGradient(
                        colors: [cs.primary, cs.tertiary],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 22.w,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(6.r)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: cs.surfaceContainerHigh.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                );
              }).toList();

              final dayLabels = keys.map((k) {
                final parts = k.split('-');
                if (parts.length != 3) return k;
                final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
                const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return weekdays[date.weekday - 1];
              }).toList();

              return BarChart(
                BarChartData(
                  maxY: maxY,
                  minY: 0,
                  barGroups: barGroups,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: cs.outline.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= dayLabels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: Text(
                              dayLabels[idx],
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                        reservedSize: 26.h,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30.w,
                        interval: maxY / 5,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == maxY) return const SizedBox.shrink();
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 9.sp, color: cs.onSurfaceVariant),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => cs.inverseSurface,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()}',
                          TextStyle(
                            color: cs.onInverseSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Metric Card ──────────────────────────────────────────

class _MetricData {
  final String label;
  final String value;

  const _MetricData(this.label, this.value);
}

class _MetricCard extends StatelessWidget {
  final ColorScheme cs;
  final List<_MetricData> entries;

  const _MetricCard({
    required this.cs,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: entries
            .map(
              (entry) => SizedBox(
                width: (Get.width - 66.w) / 3,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: cs.outline.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        entry.label,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 10.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ─── Section Card ─────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final ColorScheme cs;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.cs,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 8.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.h), child: child),
        ],
      ),
    );
  }
}

// ─── Top Event Row ────────────────────────────────────────

class _TopEventRow extends StatelessWidget {
  final String event;
  final int count;
  final ColorScheme cs;

  const _TopEventRow({
    required this.event,
    required this.count,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(
            LucideIcons.clock3,
            size: 16.r,
            color: cs.primary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              event,
              style: TextStyle(color: cs.onSurface, fontSize: 12.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
