import 'package:flutter_test/flutter_test.dart';
import 'package:somics_os/main.dart';

void main() {
  testWidgets('renders the SOMICS OS source base', (tester) async {
    await tester.pumpWidget(const SomicsOsApp());
    await tester.pumpAndSettle();

    expect(find.text('SOMICS OS'), findsOneWidget);
    expect(find.text('Source base sẵn sàng phát triển'), findsOneWidget);
  });
}
