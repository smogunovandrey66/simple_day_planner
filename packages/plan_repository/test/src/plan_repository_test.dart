// ignore_for_file: prefer_const_constructors
// import 'package:plan_repository/plan_repository.dart';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:plan_api/plan_api.dart';
import 'package:plan_repository/plan_repository.dart';
import 'package:test/test.dart';

void main() {
  group('PlanRepository', () {
    test('Date format', () {
      var dateTime = DateTime.now();

      var numberFormat = NumberFormat('00');
      var manualStringDateTime = '${dateTime.year}-'
          '${numberFormat.format(dateTime.month)}-'
          '${numberFormat.format(dateTime.day)}';
      print('Manual string DateTime = $manualStringDateTime');

      var intlDatetime = DateFormat('yyyy-MM-d').format(dateTime);
      print('Intl string with format yyyy-MM-d = $intlDatetime');
      expect(manualStringDateTime, matches(intlDatetime));

      intlDatetime = DateFormat('yyyy-MM-dd').format(dateTime);
      print('Intl string with format yyyy-MM-dd = $intlDatetime');
      expect(manualStringDateTime, matches(intlDatetime));

      expect(manualStringDateTime, matches(dateTime.formatTask()));
      print('String extension for Datetime = ${dateTime.formatTask()}');
    });

    test('Time format', () {
      var dateTime = DateTime.parse('2024-06-27 03:07');
      print(dateTime.toTimeTask());
      expect('${dateTime.toTimeTask()}', matches('03:07'));

      dateTime = DateTime.parse('2024-06-27 13:57:59');
      print(dateTime.toTimeTask());
      expect('${dateTime.toTimeTask()}', matches('13:57'));
    });

    test('check null', () {
      Task? t1 = Task(1, '1'); // null
      Task? t2 = Task(1, ''); // null

      print(t1 == t2);
    });

    test('not use', () {
      final finalList = <int>[];

      final list = [1, "string", 2.4];
      list.forEach((element) {
        print(element);
        print(element.runtimeType);
      });
      print(list.runtimeType);

      finalList.add(3);

      print(finalList);

      const constList = <int>[5];

      //constList.add(2);

      print(constList);
    });
  });
}
