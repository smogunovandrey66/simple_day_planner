import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_api/plan_api.dart';
import 'package:plan_repository/plan_repository.dart';
import 'package:simple_day_planner/task_edit/bloc/task_edit_event.dart';
import 'package:simple_day_planner/task_edit/bloc/task_edit_state.dart';

class TaskEditBloc extends Bloc<TaskEditEvent, TaskEditState> {
  PlanRepository _planRepository;

  Task _taskSaved = Task(0, '');
  Task _taskEdited = Task(0, '');
  DateTime _lastDateTime = DateTime.now();

  TaskEditBloc()
      : this._planRepository = PlanRepository.INSTANCE(),
        super(TaskEditLoadingState()) {
    on<TaskEditLoadEvent>(_loadTaskByDate);
    on<TaskEditAddSectionEvent>(_addSection);
  }

  FutureOr<void> _loadTaskByDate(
      TaskEditLoadEvent event, Emitter<TaskEditState> emit) async {
    emit(TaskEditLoadingState());

    _lastDateTime = event.dateTime;

    await Future.delayed(Duration(seconds: 1));

    var task = await _planRepository.getTaskByDate(_lastDateTime);

    if (task == null) {
      final template = await _planRepository.getTemplate();
      task = template?.toTask();
      task?.dateCreated = _lastDateTime;
    }

    _taskSaved = task ?? Task(0, '', _lastDateTime);
    _taskEdited = _taskSaved.copyFrom();

    emit(TaskEditLoadedState(TaskEditModel(_taskSaved, _taskEdited)));
  }

  FutureOr<void> _addSection(
      TaskEditAddSectionEvent event, Emitter<TaskEditState> emit) async {
    emit(TaskEditLoadingState());

    _taskEdited.add({'id': 0, 'name': event.name}, []);

    await Future.delayed(Duration(seconds: 4));
  }
}
