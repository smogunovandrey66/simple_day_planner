import 'package:equatable/equatable.dart';
import 'package:plan_api/src/model/task/task.dart';

class TaskEditModel extends Equatable{
  
  final Task taskSaved;
  final Task taskEdited;

  TaskEditModel(this.taskSaved, this.taskEdited);
  
  @override
  List<Object?> get props => [taskSaved, taskEdited];
}
