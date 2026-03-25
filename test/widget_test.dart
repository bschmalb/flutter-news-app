import 'package:flutter_test/flutter_test.dart';
import 'package:ksta/app/app.dart';

void main() {
  testWidgets('renders the empty app scaffold', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('KSTA'), findsOneWidget);
    expect(find.text('Empty app scaffold'), findsOneWidget);
  });
}
