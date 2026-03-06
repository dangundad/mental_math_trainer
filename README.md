# Mental Math Trainer

암산 훈련 앱 - 사칙연산 문제를 제한 시간 내에 풀어 두뇌를 단련하세요.

## 주요 기능
- 4가지 연산: 덧셈, 뺄셈, 곱셈, 나눗셈
- 3단계 난이도 (Easy/Medium/Hard)
- Normal 모드: 10문제 출제, 문제당 제한 시간
- Challenge 모드: 60초간 최대한 많은 문제 풀기
- 일일/전체 정확도 통계
- 연속 플레이 일수 (streak) 추적
- 주간 정답 수 차트 (fl_chart)
- 보상형 광고로 보너스 라운드 해제
- 진동 피드백 (정답/오답)

## 기술 스택
- **Framework**: Flutter 3.x / Dart 3.8+
- **State Management**: GetX
- **Local Storage**: Hive_CE
- **UI**: flutter_screenutil, flex_color_scheme, google_fonts
- **Chart**: fl_chart
- **Ads**: google_mobile_ads + AppLovin/Pangle/Unity Mediation
- **Analytics**: Firebase Analytics & Crashlytics

## 설치 및 실행
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter run
```

## 프로젝트 구조
```
lib/
├── main.dart
├── hive_registrar.g.dart
├── app/
│   ├── admob/          # 광고 관리
│   ├── bindings/       # GetX 바인딩
│   ├── controllers/    # 게임/설정/통계 컨트롤러
│   ├── data/enums/     # 난이도, 연산 타입
│   ├── pages/          # 화면별 위젯
│   ├── routes/         # 라우팅
│   ├── services/       # Hive, 구매, 평가 서비스
│   ├── theme/          # FlexColorScheme 테마
│   ├── translate/      # 다국어 번역
│   ├── utils/          # 상수
│   └── widgets/        # 공용 위젯
```

## 라이선스
Copyright (c) 2026 DangunDad. All rights reserved.
