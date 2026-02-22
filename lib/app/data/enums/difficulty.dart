enum Difficulty {
  easy,
  medium,
  hard;

  int get timePerQuestion {
    switch (this) {
      case Difficulty.easy:
        return 15;
      case Difficulty.medium:
        return 10;
      case Difficulty.hard:
        return 7;
    }
  }

  int get questionsPerRound => 10;

  String get labelKey {
    switch (this) {
      case Difficulty.easy:
        return 'diff_easy';
      case Difficulty.medium:
        return 'diff_medium';
      case Difficulty.hard:
        return 'diff_hard';
    }
  }

  // Addition / Subtraction max operand
  int get addSubMax {
    switch (this) {
      case Difficulty.easy:
        return 20;
      case Difficulty.medium:
        return 50;
      case Difficulty.hard:
        return 100;
    }
  }

  // Multiplication max operand
  int get mulMax {
    switch (this) {
      case Difficulty.easy:
        return 5;
      case Difficulty.medium:
        return 12;
      case Difficulty.hard:
        return 20;
    }
  }

  // Division quotient max
  int get divQuotientMax {
    switch (this) {
      case Difficulty.easy:
        return 10;
      case Difficulty.medium:
        return 12;
      case Difficulty.hard:
        return 20;
    }
  }

  // Division divisor max
  int get divDivisorMax {
    switch (this) {
      case Difficulty.easy:
        return 5;
      case Difficulty.medium:
        return 12;
      case Difficulty.hard:
        return 20;
    }
  }
}
