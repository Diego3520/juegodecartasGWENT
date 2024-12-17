import 'package:flutter_test/flutter_test.dart';

import 'package:card_game_movile/main.dart';

void main() {
  testWidgets('Pantalla de inicio muestra el botón Jugar', (WidgetTester tester) async {
    // Construir nuestra app y disparar un frame.
    await tester.pumpWidget(const MyCardGameApp());

    // Verificar que el botón "Jugar" está presente.
    expect(find.text('Jugar'), findsOneWidget);
    expect(find.text('0'), findsNothing);

    // Tap en el botón "Jugar" y disparar un frame.
    await tester.tap(find.text('Jugar'));
    await tester.pumpAndSettle();

    // Verificar que nos hemos movido a la pantalla del campo de juego.
    expect(find.text('Aquí irá el campo de cartas'), findsOneWidget);
  });
}