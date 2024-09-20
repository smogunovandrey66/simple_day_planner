

import 'package:equatable/equatable.dart';
import 'package:plan_api/src/model/ext/ext_utils.dart';
import 'package:plan_api/src/model/template/item_section.dart';

class Section extends Equatable {
  ///Constructor
  Section(this.id, this.name);

  @override
  List<Object?> get props => [id, name, items];

  final List<ItemSection> items = [];

  final int id;

  final String name;

  ///
  void add(List<Map<String, dynamic>> itemsSection) {
    for (Map<String, dynamic> itemSection in itemsSection) {
      items.add(itemSection.toItemSection());
    }
  }
}