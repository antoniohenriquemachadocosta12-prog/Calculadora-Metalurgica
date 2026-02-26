import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_serralheiro/app.dart';

void main() {
  testWidgets('App deve renderizar splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculadoraSerralheiro());
    expect(find.text('CALCULADORA'), findsOneWidget);
    expect(find.text('DO SERRALHEIRO'), findsOneWidget);
    expect(find.text('INICIAR'), findsOneWidget);
  });
}
