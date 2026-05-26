# Mental Math Trainer 개발 가이드

> 문서: `AGENTS.md`
> This file provides guidance to coding agents working with this repository.
> 최종 업데이트: 2026-05-27
> 기준: 현재 앱 저장소 스캔 + `C:\Flutter_WorkSpace\Flutter_Plan\AGENTS.md` 포트폴리오 상태표

## 프로젝트 요약
- 앱 번호: 34
- Phase: 4
- 상태: ✅ 기능구현
- 난이도: ★★☆
- 광고 등급: 상
- 프로젝트 폴더: `mental_math_trainer`
- `pubspec` 이름: `mental_math_trainer`
- Android 패키지: `com.dangundad.mentalmathtrainer`
- 버전: `1.0.0+1`
- 핵심 기능: 4가지 연산, 제한 시간, 난이도 진행, 일/주 통계

## 공통 작업 원칙
- 모든 텍스트 파일은 UTF-8로 유지하고, PowerShell에서 파일을 쓸 때는 `-Encoding UTF8`을 명시합니다.
- AI/코드 어시스턴트의 설명, 진행 업데이트, 최종 답변은 기본적으로 한국어로 작성합니다.
- Android 우선 프로젝트이며, 별도 요청 없이 iOS 전용 코드는 추가하지 않습니다.
- 릴리스 빌드는 실행하지 않습니다. 일반 작업에서는 `flutter build apk`/`flutter build ios`를 사용하지 않습니다.
- 코드 변경 후에는 반드시 `flutter analyze`와 `flutter test`를 실행해 결과를 확인합니다.
- Hive `@HiveType` 모델을 추가하거나 수정했다면 `dart run build_runner build --delete-conflicting-outputs`를 실행합니다.
- 상태 관리는 GetX, 로컬 저장은 Hive_CE 패턴을 유지하고 기존 네비게이션/영속성 구조를 임의로 바꾸지 않습니다.
- Windows 표준 경로를 사용하고 WSL 경로(`/mnt/c/...`)는 사용하지 않습니다.
- `2>nul`, `>nul` 리다이렉션은 사용하지 않으며, `nul` 파일이 생기면 정리합니다.

## 빠른 명령어
```bash
cd C:\Flutter_WorkSpace\mental_math_trainer
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```

## 현재 의존성 하이라이트
- 기반: `get` ^4.7.3, `hive_ce` ^2.19.3, `hive_ce_flutter` ^2.3.4, `path_provider` ^2.1.5, `intl` ^0.20.2
- UI/UX: `flutter_screenutil` ^5.9.3, `flex_color_scheme` ^8.4.0, `google_fonts` ^8.0.2, `lucide_icons_flutter` ^3.1.14+2, `flutter_animate` ^4.5.2, `fl_chart` ^1.2.0, `confetti` ^0.8.0
- 수익화/운영: `google_mobile_ads` ^8.0.0, `gma_mediation_applovin` ^2.6.0, `gma_mediation_pangle` ^3.6.0, `gma_mediation_unity` ^1.7.0, `in_app_purchase` ^3.2.3, `in_app_review` ^2.0.12, `rate_my_app` ^2.3.2, `vibration` ^3.1.8
- 직접 제거됨: `firebase_core`, `firebase_analytics`, `firebase_crashlytics`, `device_info_plus`, `package_info_plus`, `permission_handler`, `share_plus`, `url_launcher`, `uuid`, `wakelock_plus`

## 현재 코드 구조
- `lib/app` 디렉터리: `admob`, `bindings`, `controllers`, `data`, `pages`, `routes`, `services`, `theme`, `translate`, `utils`, `widgets`
- `bindings`: `app_binding.dart`
- `routes`: `app_pages.dart`, `app_routes.dart`
- `controllers`: `game_controller.dart`, `history_controller.dart`, `home_controller.dart`, `premium_controller.dart`, `setting_controller.dart`, `stats_controller.dart`
- 기능 중심 컨트롤러: `game_controller`
- `services`: `activity_log_service.dart`, `app_rating_service.dart`, `hive_service.dart`, `purchase_service.dart`
- 기능 중심 서비스: 없음
- `pages`: `game`, `history`, `home`, `premium`, `settings`, `stats`
- `widgets`: `confetti_overlay.dart`
- `mixins`: 없음
- `utils`: `app_constants.dart`
- `translate`: `translate.dart`
- `theme`: `app_flex_theme.dart`
- `data/models`: 없음
- `data/enums`: `difficulty.dart`, `operation.dart`
- `data/constants`: 없음
- `data` 루트 파일: 없음
- `assets`: `data`, `fonts`, `images`
- `tests`: 3개 파일/4개 테스트: `test/app/controllers/game_controller_test.dart`, `test/ui/no_gradient_usage_test.dart`, `test/widget_test.dart`

## 최근 감사 이력
- 2026-05-27 Phase 1~4 Wave 2B 사전배포 감사 통과: pub.dev 직접 확인 기반 direct/dev 의존성 최신화, 미사용 Firebase/FlutterFire/device_info_plus/package_info_plus/permission_handler/wakelock_plus/uuid/url_launcher 직접 의존성 제거, `intl`/`fl_chart` 직접 의존성 유지, Android debug resource/assemble 검증 통과

## 문서 유지 규칙
- 새 페이지나 바인딩을 추가하면 이 문서의 `pages`/`bindings` 요약도 함께 갱신합니다.
- 의존성 추가/제거, Android 패키지명 변경, 테스트 확장은 이 문서에 바로 반영합니다.
- 포트폴리오 상태가 바뀌면 메타 레포 `AGENTS.md`, `CLAUDE.md`, 관련 `docs/*.md`와 함께 동기화합니다.
