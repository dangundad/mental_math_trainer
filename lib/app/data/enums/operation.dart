enum Operation {
  addition,
  subtraction,
  multiplication,
  division;

  String get symbol {
    switch (this) {
      case Operation.addition:
        return '+';
      case Operation.subtraction:
        return '−';
      case Operation.multiplication:
        return '×';
      case Operation.division:
        return '÷';
    }
  }

  String get labelKey {
    switch (this) {
      case Operation.addition:
        return 'op_addition';
      case Operation.subtraction:
        return 'op_subtraction';
      case Operation.multiplication:
        return 'op_multiplication';
      case Operation.division:
        return 'op_division';
    }
  }

  String get emoji {
    switch (this) {
      case Operation.addition:
        return '➕';
      case Operation.subtraction:
        return '➖';
      case Operation.multiplication:
        return '✖️';
      case Operation.division:
        return '➗';
    }
  }
}
