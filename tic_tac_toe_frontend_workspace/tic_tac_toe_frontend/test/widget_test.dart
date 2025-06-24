import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  testWidgets('TicTacToeApp should build and display its home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Check for Tic Tac Toe title text
    expect(find.text('Tic Tac Toe'), findsOneWidget);

    // Check for the New Game button
    expect(find.text('New Game'), findsOneWidget);

    // Initial status should show Player X's Turn or a variant on new game
    expect(find.textContaining('Player'), findsWidgets);
  });
}
