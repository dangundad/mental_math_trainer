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

import 'package:mental_math_trainer/app/admob/ads_helper.dart';
import 'package:mental_math_trainer/app/bindings/app_binding.dart';
import 'package:mental_math_trainer/app/routes/app_pages.dart';
import 'package:mental_math_trainer/app/services/hive_service.dart';
import 'package:mental_math_trainer/app/theme/app_flex_theme.dart';
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

  await AppBinding.initializeServices();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  runApp(const MentalMathTrainerApp());
}

class MentalMathTrainerApp extends StatefulWidget {
  const MentalMathTrainerApp({super.key});

  @override
  State<MentalMathTrainerApp> createState() => _MentalMathTrainerAppState();
}

class _MentalMathTrainerAppState extends State<MentalMathTrainerApp> {
  @override
  void initState() {
    super.initState();
    unawaited(_initializeAds());
  }

  Future<void> _initializeAds() async {
    try {
      await AdHelper.initializeConsentAndAds();
    } catch (e) {
      debugPrint('AdMob initialization failed: $e');
    }
  }

  GetMaterialApp _buildFallbackApp() {
    return GetMaterialApp(
      supportedLocales: Languages.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      translations: Languages(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppFlexTheme.light,
      darkTheme: AppFlexTheme.dark,
      home: const Scaffold(body: SizedBox.shrink()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        if (!Get.isRegistered<HiveService>()) {
          return _buildFallbackApp();
        }

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
          theme: AppFlexTheme.light,
          darkTheme: AppFlexTheme.dark,
          scrollBehavior: ScrollBehavior().copyWith(overscroll: false),
          navigatorKey: Get.key,
          getPages: AppPages.routes,
          initialRoute: AppPages.INITIAL,
        );
      },
    );
  }
}
