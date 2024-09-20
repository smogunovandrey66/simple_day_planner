// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_plan_api/local_storage_plan_api.dart';

void main() {
  final o = Object();
  print(1);
  group('LocalStoragePlanApi', () {
    print(2);
    test('can be instantiated', () {
      print(3);
      log('33');
      expect(LocalStoragePlanApi(), isNotNull);
      emits('abc');
      print(o.toString());
      log('44');
    });
  });
}
