import 'package:plan_api/src/model/template/item_section.dart';

class ItemSectionDate extends ItemSection {
  /// Constructor
  const ItemSectionDate(int id, int count, [this.datetime]) : super(id, count);

  @override
  List<Object?> get props => super.props..add(datetime);

  /// Datetime for execute item section
  final DateTime? datetime;

  @override
  Map<String, Object?> toMap() {
    return super.toMap()..['date_execute'] = datetime;  
  }
}
