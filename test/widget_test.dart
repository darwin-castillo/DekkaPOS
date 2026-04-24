import 'package:flutter_test/flutter_test.dart';
import 'package:dekkapos/main.dart';

void main() {
  testWidgets('App builds correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const DekkaPOS());
    expect(find.text('DekkaPOS'), findsOneWidget);
  });
}