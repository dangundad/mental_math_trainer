// ================================================
// DangunDad Flutter App - main.dart Template
// ================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:mental_math_trainer/app/admob/ads_helper.dart';
import 'package:mental_math_trainer/app/bindings/app_binding.dart';
import 'package:mental_math_trainer/app/routes/app_pages.dart';
import 'package:mental_math_trainer/app/theme/app_theme.dart';
import 'package:mental_math_trainer/app/translate/translate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await AdHelper.initializeAdConsent();

    MobileAds.instance.initialize().then((status) {
      status.adapterStatuses.forEach((key, value) {
        debugPrint('Adapter status for $key: ${value.description}');
      });
    });
    debugPrint('AdMob initialized successfully');
  } catch (e) {
    debugPrint('AdMob initialization failed: $e');
  }

  await AppBinding.initializeServices();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  runApp(const MentalMathTrainerApp());
}

class MentalMathTrainerApp extends StatelessWidget {
  const MentalMathTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          supportedLocales: Languages.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          translations: Languages(),
          locale: Get.deviceLocale ?? const Locale('en'),
          fallbackLocale: const Locale('en'),
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          initialBinding: AppBinding(),
          themeMode: ThemeMode.system,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          scrollBehavior: ScrollBehavior().copyWith(overscroll: false),
          navigatorKey: Get.key,
          getPages: AppPages.routes,
          initialRoute: AppPages.INITIAL,
        );
      },
    );
  }
}
