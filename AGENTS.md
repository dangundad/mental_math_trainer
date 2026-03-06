# CLAUDE.md - Mental Math Trainer

## 프로젝트 개요
암산 훈련 앱. 사칙연산 문제를 제한 시간 내에 풀어 두뇌를 훈련하는 교육 앱.
- **패키지명**: `com.dangundad.mentalmathtrainer`
- **퍼블리셔**: DangunDad
- **수익 모델**: 완전 무료 + AdMob 광고 (배너 + 전면 + 보상형)

## 기술 스택
- **Flutter** 3.x / Dart 3.8+
- **상태 관리**: GetX (`GetxController`, `.obs`, `Obx()`)
- **로컬 저장**: Hive_CE (키-값 저장)
- **UI**: flutter_screenutil, flex_color_scheme (FlexScheme.blue), google_fonts, lucide_icons_flutter
- **차트**: fl_chart (주간 정답 수 차트)
- **광고**: google_mobile_ads + AppLovin/Pangle/Unity 미디에이션
- **기타**: vibration, flutter_animate, firebase_core/analytics/crashlytics, in_app_purchase, in_app_review

## 개발 명령어
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter run
```

## 아키텍처 (프로젝트 구조)
```
lib/
├── main.dart                          # 앱 진입점
├── hive_registrar.g.dart              # Hive 어댑터 등록
├── app/
│   ├── admob/                         # 광고 (배너/전면/보상형)
│   ├── bindings/app_binding.dart      # GetX 바인딩
│   ├── controllers/
│   │   ├── game_controller.dart       # 게임 로직 (문제 생성, 채점, 통계)
│   │   ├── history_controller.dart    # 기록 관리
│   │   ├── home_controller.dart       # 홈 화면
│   │   ├── premium_controller.dart    # 프리미엄
│   │   ├── setting_controller.dart    # 설정
│   │   └── stats_controller.dart      # 통계
│   ├── data/enums/
│   │   ├── difficulty.dart            # 난이도 (easy/medium/hard)
│   │   └── operation.dart             # 연산 (가감승제)
│   ├── pages/
│   │   ├── game/
│   │   │   ├── game_page.dart         # 게임 화면
│   │   │   └── widgets/
│   │   │       ├── number_pad.dart    # 숫자 입력 패드
│   │   │       └── result_dialog.dart # 결과 다이얼로그
│   │   ├── history/history_page.dart
│   │   ├── home/home_page.dart
│   │   ├── premium/
│   │   ├── settings/settings_page.dart
│   │   └── stats/stats_page.dart
│   ├── routes/
│   ├── services/
│   │   ├── activity_log_service.dart
│   │   ├── app_rating_service.dart
│   │   ├── hive_service.dart          # Hive 서비스 (일별 정답 누적 포함)
│   │   └── purchase_service.dart
│   ├── theme/app_flex_theme.dart
│   ├── translate/translate.dart
│   ├── utils/app_constants.dart
│   └── widgets/confetti_overlay.dart
```

## 게임 모드
### Normal 모드
- 난이도별 10문제 출제
- 문제당 제한 시간: Easy 15초, Medium 10초, Hard 7초
- 800ms 피드백 후 다음 문제 진행

### Challenge 모드
- 60초간 최대한 많은 문제 풀기
- 문제당 시간 제한 없음 (전체 60초)
- 최고 기록 저장

## 난이도 설정
| 난이도 | 가감 범위 | 곱셈 범위 | 나눗셈 몫 범위 |
|--------|----------|----------|---------------|
| Easy   | 1~20     | 2~5      | 1~10          |
| Medium | 1~50     | 2~12     | 1~12          |
| Hard   | 1~100    | 2~20     | 1~20          |

## 통계 시스템
- 총 정답/총 문제 (전체 정확도)
- 오늘 정답/문제 (일일 정확도)
- 연속 플레이 일수 (streak)
- 일별 정답 수 누적 (주간 차트용)
- 챌린지 최고 기록

## 개발 가이드라인
- 문제 생성: 나눗셈은 정수 결과만 보장 (quotient * divisor 방식)
- Timer: 100ms 틱으로 부드러운 프로그레스 바
- 연타 방지: `phase` 상태로 입력 단계 제어
- 보상형 광고: 보너스 라운드 5문제 추가
