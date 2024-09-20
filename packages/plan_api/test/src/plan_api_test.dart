// ignore_for_file: prefer_const_constructors
import 'package:plan_api/plan_api.dart';
import 'package:plan_api/src/model/task/section_date.dart';
import 'package:plan_api/src/model/task/task.dart';
import 'package:test/test.dart';

class TestPlanApi extends PlanApi {}

void main() {
  // final task = Task(name: 'Training');
  // final sectionDate = SectionDate('Подтягивание')
  // ..add(10, DateTime.now())
  // ..add(10);
  // task.add(sectionDate);
  // print(task);

  group('PlanApi', () {
    test('can be instantiated', () {
      expect(TestPlanApi.new, isNotNull);
    });
  });
}
