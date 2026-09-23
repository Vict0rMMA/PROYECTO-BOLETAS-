import 'package:flutter_test/flutter_test.dart';
import 'package:movil/main.dart';

void main() {
  testWidgets('La app carga y muestra el catalogo de boletas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Boletas'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Festival Día de Rock'), findsOneWidget);
    expect(find.text('Arcángel 20 Aniversario'), findsOneWidget);
    expect(find.text('Festival Electrónico'), findsOneWidget);
  });
}
