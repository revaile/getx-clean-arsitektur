import 'package:flutter_test/flutter_test.dart';
import 'package:getx_clean_arsitektur/app.dart';

void main() {
  testWidgets('shows users page title', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Users'), findsOneWidget);
  });
}
