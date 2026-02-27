import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';

import 'package:mental_math_trainer/app/admob/ads_interstitial.dart';
import 'package:mental_math_trainer/app/admob/ads_rewarded.dart';
import 'package:mental_math_trainer/app/controllers/game_controller.dart';
import 'package:mental_math_trainer/app/controllers/history_controller.dart';
import 'package:mental_math_trainer/app/controllers/home_controller.dart';
import 'package:mental_math_trainer/app/controllers/setting_controller.dart';
import 'package:mental_math_trainer/app/controllers/stats_controller.dart';
import 'package:mental_math_trainer/app/services/activity_log_service.dart';
import 'package:mental_math_trainer/app/services/hive_service.dart';

import 'package:mental_math_trainer/app/services/purchase_service.dart';
import 'package:mental_math_trainer/app/services/app_rating_service.dart';
import 'package:mental_math_trainer/app/controllers/premium_controller.dart';

class AppBinding implements Bindings {
  static Future<void> initializeServices() async {
    if (!Get.isRegistered<HiveService>()) {
      await HiveService.init();
      Get.put(HiveService(), permanent: true);
    } else {
      try {
        if (!Hive.isBoxOpen(HiveService.SETTINGS_BOX)) {
          await Hive.openBox(HiveService.SETTINGS_BOX);
        }
        if (!Hive.isBoxOpen(HiveService.APP_DATA_BOX)) {
          await Hive.openBox(HiveService.APP_DATA_BOX);
        }
      } catch (e) {
        Get.log('[AppBinding] Hive reopen failed: $e');
      }
    }

    _ensureDependencyServices();
  }

  @override
  void dependencies() {
    if (!Get.isRegistered<PurchaseService>()) {
      Get.put(PurchaseService(), permanent: true);
    }

    if (!Get.isRegistered<PremiumController>()) {
      Get.lazyPut(() => PremiumController());
    }

    _ensureDependencyServices();
  }

  static void _ensureDependencyServices() {
    if (!Get.isRegistered<SettingController>()) {
      Get.put(SettingController(), permanent: true);
    }

    if (!Get.isRegistered<GameController>()) {
      Get.put(GameController(), permanent: true);
    }

    Get.lazyPut(() => HomeController(), fenix: true);

    if (!Get.isRegistered<ActivityLogService>()) {
      Get.put(ActivityLogService(), permanent: true);
    }

    if (!Get.isRegistered<HistoryController>()) {
      Get.lazyPut(() => HistoryController());
    }

    if (!Get.isRegistered<StatsController>()) {
      Get.lazyPut(() => StatsController());
    }

    if (!Get.isRegistered<InterstitialAdManager>()) {
      Get.put(InterstitialAdManager(), permanent: true);
    }

    if (!Get.isRegistered<RewardedAdManager>()) {
      Get.put(RewardedAdManager(), permanent: true);
    }

    if (!Get.isRegistered<AppRatingService>()) {
      Get.put(AppRatingService(), permanent: true);
    }
  }
}
