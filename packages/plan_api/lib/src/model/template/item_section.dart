import 'package:equatable/equatable.dart';

///
///
class ItemSection extends Equatable {
  /// Constructor
  const ItemSection(this.id, this.count);

  @override
  List<Object?> get props => [id, count];

  ///
  final int id;

  /// Need and fact count private field
  final int count;

  Map<String, Object?> toMap() {
    return {'id': id, 'count': count};
  }
}
