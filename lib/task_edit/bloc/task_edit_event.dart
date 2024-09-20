import 'package:plan_api/plan_api.dart';

sealed class TaskEditEvent {}

final class TaskEditLoadEvent extends TaskEditEvent {
  TaskEditLoadEvent(this.dateTime);

  final DateTime dateTime;
}

final class TaskEditSaveEvent extends TaskEditEvent {
  TaskEditSaveEvent(this.task);

  final Task task;
}

final class TaskEditAddSectionEvent extends TaskEditEvent {
  final DateTime dateTime;
  final String name;

  TaskEditAddSectionEvent(this.dateTime, this.name);
}
