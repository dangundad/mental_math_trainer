import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math_trainer/main.dart';

void main() {
  testWidgets('mental_math_trainer smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MentalMathTrainerApp());

    expect(find.byType(MentalMathTrainerApp), findsOneWidget);
  });
}
