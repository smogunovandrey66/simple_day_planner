import 'package:equatable/equatable.dart';
import 'package:plan_api/plan_api.dart';

///
class Template extends Equatable {
  ///
  Template(this.id, this.name);

  ///
  final int id;

  ///
  final String name;

  ///
  final List<Section> items = [];

  ///
  void add(Map<String, Object?> sectionMap,
      List<Map<String, Object?>> itemsSectionMap) {
    final section = sectionMap.toSection();
    section.add(itemsSectionMap);
    items.add(sectionMap.toSection()..add(itemsSectionMap));
  }

  @override
  List<Object?> get props => [id, name, items];
}
