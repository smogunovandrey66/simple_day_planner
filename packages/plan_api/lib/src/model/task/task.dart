import 'package:plan_api/plan_api.dart';
import 'package:plan_api/src/model/template/template.dart';

///
class Task extends Template {
  ///
  Task(int id, String name, [this.dateCreated]) : super(id, name);

  ///
  DateTime? dateCreated;

  ///
  final List<SectionDate> items = [];

  ///
  @override
  void add(Map<String, Object?> sectionMap,
      List<Map<String, Object?>> itemsSectionMap) {
    items.add(sectionMap.toSectionDate()..add(itemsSectionMap));
  }

  @override
  List<Object?> get props => [name, items, id];

  Task copyFrom([int? id, String? name, DateTime? dateCreated]) {
    return Task(
        id ?? this.id, name ?? this.name, dateCreated ?? this.dateCreated);
  }
}
