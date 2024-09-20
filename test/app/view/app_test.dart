import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_day_planner/app/app.dart';
import 'package:simple_day_planner/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPage), findsOneWidget);
    });

    test('test web DataBase', () async {
      print('hello');
      log('message');


    });
  });
}
