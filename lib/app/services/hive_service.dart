// ================================================
// DangunDad Flutter App - hive_service.dart Template
// ================================================
// mental_math_trainer 치환 후 사용
// mbti_pro 프로덕션 패턴 기반

// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mental_math_trainer/hive_registrar.g.dart';


class HiveService extends GetxService {
  static HiveService get to => Get.find();

  // Box 이름 상수
  static const String SETTINGS_BOX = 'settings';
  static const String APP_DATA_BOX = 'app_data';
  // ---- 앱별 Box 추가 ----

  // Box Getters
  Box get settingsBox => Hive.box(SETTINGS_BOX);
  Box get appDataBox => Hive.box(APP_DATA_BOX);
  // ---- 앱별 Typed Box Getter 추가 ----
  // Box<MyModel> get myModelBox => Hive.box<MyModel>(MY_MODEL_BOX);

  /// Hive 초기화 (main.dart에서 await 호출)
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();

    await Future.wait([
      Hive.openBox(SETTINGS_BOX),
      Hive.openBox(APP_DATA_BOX),
      // ---- 앱별 Box 추가 ----
      // Hive.openBox<MyModel>(MY_MODEL_BOX),
    ]);

    Get.log('Hive 초기화 완료');
  }

  // ============================================
  // 설정 관리 (generic key-value)
  // ============================================

  T? getSetting<T>(String key, {T? defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> setSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  // ============================================
  // 앱 데이터 관리 (generic key-value)
  // ============================================

  T? getAppData<T>(String key, {T? defaultValue}) {
    return appDataBox.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> setAppData(String key, dynamic value) async {
    await appDataBox.put(key, value);
  }

  // ============================================
  // 주간 일별 정답 수 기록 (key: 'mm_daily_correct_{yyyy-MM-dd}')
  // ============================================

  static const String _dailyCorrectPrefix = 'mm_daily_correct_';

  int getDailyCorrect(String dateKey) {
    return appDataBox.get('$_dailyCorrectPrefix$dateKey', defaultValue: 0) as int;
  }

  Future<void> addDailyCorrect(String dateKey, int correct) async {
    final current = getDailyCorrect(dateKey);
    await appDataBox.put('$_dailyCorrectPrefix$dateKey', current + correct);
  }

  /// 최근 7일 날짜키 → 정답 수 맵 반환
  Map<String, int> getWeeklyCorrect() {
    final result = <String, int>{};
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
      result[key] = getDailyCorrect(key);
    }
    return result;
  }

  // ============================================
  // 데이터 관리
  // ============================================

  Future<void> clearAllData() async {
    await Future.wait([
      settingsBox.clear(),
      appDataBox.clear(),
    ]);
    Get.log('모든 데이터 삭제 완료');
  }
}
