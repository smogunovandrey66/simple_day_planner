import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:plan_api/plan_api.dart';
import 'package:plan_repository/plan_repository.dart';

part 'task_view_event.dart';
part 'task_view_state.dart';

class TaskViewBloc extends Bloc<TaskViewEvent, TaskViewState> {
  TaskViewBloc() : super(TaskViewStateLoading()) {
    log('constructor TaskBloc');
    print('constructor TaskBloc');
    _planRepository = PlanRepository.INSTANCE();
    on<TaskViewEventByDate>(_onTaskEventByDate);
    on<TaskViewEventChangeItemSectionDate>(_onChangeItemSectionDate);
  }

  late PlanRepository _planRepository;

  Task? _savedTask = null;
  Task? _editedTask = null;

  Future<void> _onTaskEventByDate(
    TaskViewEventByDate event,
    Emitter<TaskViewState> emit,
  ) async {
    emit(TaskViewStateLoading());
    log('begin loading ${DateTime.now()}', time: DateTime.now());
    await Future.delayed(Duration(seconds: 1));
    log('end loaded ${DateTime.now()}', time: DateTime.now());

    var task = await _planRepository.getTaskByDate(event.datetime);

    if (task == null) {
      final template = await _planRepository.getTemplate();
      task = template?.toTask();
    }

    emit(TaskViewStateLoaded(task));
  }

  Future<void> _onTaskEventByDateForEdit(
      TaskViewEventByDate event, Emitter<TaskViewState> emit) async {
    emit(TaskViewStateLoading());

    //final task = await _planRepository.getTaskByDate(event.datetime) ?? _planRepository
  }

  Future<void> _onChangeItemSectionDate(
      TaskViewEventChangeItemSectionDate event, Emitter<TaskViewState> emit) async {
    _planRepository.updateItemSectionDate(event.itemSectionDate);
  }
}
