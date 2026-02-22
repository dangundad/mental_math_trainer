// ================================================
// DangunDad Flutter App - app_pages.dart Template
// ================================================
// mental_math_trainer 치환 후 사용
// mbti_pro 프로덕션 패턴 기반 (part 패턴)

// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import 'package:mental_math_trainer/app/bindings/app_binding.dart';
import 'package:mental_math_trainer/app/controllers/game_controller.dart';
import 'package:mental_math_trainer/app/pages/game/game_page.dart';
import 'package:mental_math_trainer/app/pages/home/home_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomePage(),
      binding: AppBinding(),
    ),
    GetPage(
      name: _Paths.GAME,
      page: () => const GamePage(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<GameController>()) {
          Get.put(GameController(), permanent: true);
        }
      }),
    ),
  ];
}
