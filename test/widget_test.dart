import 'package:flutter_test/flutter_test.dart';
import 'package:progressive_lift/app.dart';

void main() {
  testWidgets('アプリが起動する', (WidgetTester tester) async {
    await tester.pumpWidget(const ProgressiveLiftApp());
    await tester.pump();
    expect(find.text('Progressive Lift'), findsOneWidget);
  });
}
