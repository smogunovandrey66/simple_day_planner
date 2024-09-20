import 'package:plan_api/plan_api.dart';

sealed class TaskEditState {}

final class TaskEditLoadingState extends TaskEditState {}

final class TaskEditLoadedState extends TaskEditState {
  TaskEditLoadedState(this.taskEditModel);

  final TaskEditModel taskEditModel;
}

