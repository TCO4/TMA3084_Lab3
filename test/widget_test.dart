import 'package:flutter_test/flutter_test.dart';
import 'package:tma3084_lab3/main.dart';

void main() {
  testWidgets('PokeCafe app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const PokeCafeApp());

    expect(find.text('PokeCafe'), findsOneWidget);
  });
}
