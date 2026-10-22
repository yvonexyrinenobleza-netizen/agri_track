
import 'package:flutter_test/flutter_test.dart';
import 'package:agri_track/app.dart';

void main() {
  testWidgets('AgriTrack app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const AgriTrackApp());
    expect(find.byType(AgriTrackApp), findsOneWidget);
  });
}

