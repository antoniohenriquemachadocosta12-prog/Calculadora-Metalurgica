import 'package:flutter_test/flutter_test.dart';
import 'package:metalcalc_pro/app.dart';

void main() {
  testWidgets('MetalCalc Pro app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MetalCalcApp());
    expect(find.byType(MetalCalcApp), findsOneWidget);
  });
}
