// ================================================
// DangunDad Flutter App - translate.dart Template
// ================================================
// mbti_pro 프로덕션 패턴 기반
// 개발 시 한국어(ko)만 정의, 다국어는 추후 추가

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Languages extends Translations {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ko'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      // Common
      'settings': 'Settings',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'share': 'Share',
      'reset': 'Reset',
      'done': 'Done',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'no_data': 'No data',

      // Settings
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'about': 'About',
      'version': 'Version',
      'rate_app': 'Rate App',
      'privacy_policy': 'Privacy Policy',
      'remove_ads': 'Remove Ads',

      // Feedback
      'send_feedback': 'Send Feedback',
      'more_apps': 'More Apps',

      // App-specific
      'app_name': 'Mental Math Trainer',
      'home_subtitle': 'Train your brain with fast arithmetic!',
      'difficulty': 'Difficulty',
      'diff_easy': 'Easy',
      'diff_medium': 'Medium',
      'diff_hard': 'Hard',
      'operations': 'Operations',
      'op_addition': 'Addition',
      'op_subtraction': 'Subtraction',
      'op_multiplication': 'Multiplication',
      'op_division': 'Division',
      'start_round': 'Start Round',
      'stat_today': 'Today',
      'stat_accuracy': 'Accuracy',
      'stat_streak': 'Streak',
      'question': 'Q',
      'submit': 'Submit',
      'correct': 'Correct!',
      'wrong': 'Wrong!',
      'result_perfect': 'Perfect! 🏆',
      'result_done': 'Round Complete!',
      'result_score': 'Score',
      'result_accuracy': 'Accuracy',
      'result_bonus': 'Watch ad for bonus round',
      'home': 'Home',
      'play_again': 'Play Again',
    },
    'ko': {
      // 공통
      'settings': '설정',
      'save': '저장',
      'cancel': '취소',
      'delete': '삭제',
      'edit': '편집',
      'share': '공유',
      'reset': '초기화',
      'done': '완료',
      'ok': '확인',
      'yes': '예',
      'no': '아니오',
      'error': '오류',
      'success': '성공',
      'loading': '로딩 중...',
      'no_data': '데이터 없음',

      // 설정
      'dark_mode': '다크 모드',
      'language': '언어',
      'about': '앱 정보',
      'version': '버전',
      'rate_app': '앱 평가',
      'privacy_policy': '개인정보처리방침',
      'remove_ads': '광고 제거',

      // 피드백
      'send_feedback': '피드백 보내기',
      'more_apps': '더 많은 앱',

      // 앱별
      'app_name': '멘탈 수학 트레이너',
      'home_subtitle': '빠른 암산으로 뇌를 훈련하세요!',
      'difficulty': '난이도',
      'diff_easy': '쉬움',
      'diff_medium': '보통',
      'diff_hard': '어려움',
      'operations': '연산 선택',
      'op_addition': '덧셈',
      'op_subtraction': '뺄셈',
      'op_multiplication': '곱셈',
      'op_division': '나눗셈',
      'start_round': '라운드 시작',
      'stat_today': '오늘',
      'stat_accuracy': '정확도',
      'stat_streak': '연속',
      'question': '문제',
      'submit': '제출',
      'correct': '정답!',
      'wrong': '틀렸습니다!',
      'result_perfect': '완벽해요! 🏆',
      'result_done': '라운드 완료!',
      'result_score': '점수',
      'result_accuracy': '정확도',
      'result_bonus': '광고 시청으로 보너스 라운드',
      'home': '홈',
      'play_again': '다시 하기',
    },
  };
}
