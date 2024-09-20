part of 'task_view_bloc.dart';

@immutable
sealed class TaskViewState {}

final class TaskViewStateLoading extends TaskViewState {}

final class TaskViewStateLoaded extends TaskViewState {
  TaskViewStateLoaded([this.task]);

  final Task? task;
}
