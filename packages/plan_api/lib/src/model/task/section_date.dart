import 'package:plan_api/plan_api.dart';

///
///
class SectionDate extends Section {
  ///Constructor
  SectionDate(int id, String name) : super(id, name);

  @override
  List<Object?> get props => [id, name, items];

  final List<ItemSectionDate> items = [];

  @override
  void add(List<Map<String, dynamic>> itemsSectionMap) {
    for (Map<String, dynamic> itemSection in itemsSectionMap) {
      items.add(itemSection.toItemSectionDate());
    }
  }
}

void main() {
  final a = SectionDate(1, 'name');
  final b = Section(1, 'name');
  b.items;
  a.items;
}
