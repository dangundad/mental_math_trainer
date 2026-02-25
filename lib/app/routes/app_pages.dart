// ================================================
// DangunDad Flutter App - app_pages.dart Template
// ================================================

// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:mental_math_trainer/app/routes/app_routes.dart';
import 'package:mental_math_trainer/app/bindings/app_binding.dart';
import 'package:mental_math_trainer/app/controllers/game_controller.dart';
import 'package:mental_math_trainer/app/pages/game/game_page.dart';
import 'package:mental_math_trainer/app/pages/history/history_page.dart';
import 'package:mental_math_trainer/app/pages/home/home_page.dart';
import 'package:mental_math_trainer/app/pages/settings/settings_page.dart';
import 'package:mental_math_trainer/app/pages/stats/stats_page.dart';
import 'package:mental_math_trainer/app/pages/premium/premium_page.dart';
import 'package:mental_math_trainer/app/pages/premium/premium_binding.dart';

export 'package:mental_math_trainer/app/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: AppBinding(),
    ),
    GetPage(
      name: Routes.GAME,
      page: () => const GamePage(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<GameController>()) {
          Get.put(GameController(), permanent: true);
        }
      }),
    ),
    GetPage(name: Routes.SETTINGS, page: () => const SettingsPage()),
    GetPage(name: Routes.HISTORY, page: () => const HistoryPage()),
    GetPage(name: Routes.STATS, page: () => const StatsPage()),
    GetPage(
      name: Routes.PREMIUM,
      page: () => const PremiumPage(),
      binding: PremiumBinding(),
    ),
];
}


