part of 'task_view_bloc.dart';

@immutable
sealed class TaskViewEvent {
  const TaskViewEvent();
}

final class TaskViewEventByDate extends TaskViewEvent {
  const TaskViewEventByDate(this.datetime);
  final DateTime datetime;
}

final class TaskViewEventChangeItemSectionDate extends TaskViewEvent {
  const TaskViewEventChangeItemSectionDate(this.itemSectionDate);

  final ItemSectionDate itemSectionDate;
}
