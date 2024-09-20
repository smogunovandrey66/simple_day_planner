import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_api/plan_api.dart';
import 'package:plan_repository/plan_repository.dart';
import 'package:simple_day_planner/l10n/l10n.dart';
import 'package:simple_day_planner/task_edit/bloc/task_edit_bloc.dart';
import 'package:simple_day_planner/task_edit/bloc/task_edit_event.dart';
import 'package:simple_day_planner/task_view/bloc/task_view_bloc.dart';
import 'package:simple_day_planner/task_edit/view/task_edit_page.dart';
import 'package:simple_day_planner/task_view/view/select_date.dart';
import 'package:simple_day_planner/task_view/view/template_view_page.dart';
import 'package:scroll_time_picker/scroll_time_picker.dart';

class TaskViewPage extends StatelessWidget {
  TaskViewPage({super.key}) : this._dateTime = DateTime.now();

  late final BuildContext _context;

  DateTime _dateTime;

  DateTime get dateTime => _dateTime;

  TaskViewState get _taskState {
    final state = _context.read<TaskViewBloc>().state;
    log('get _taskState $state');
    return state;
  }

  Task get _task {
    if (_taskState is TaskViewStateLoaded) {
      final task = (_taskState as TaskViewStateLoaded).task;
      if (task != null) return task;
    }

    return Task(0, 'name');
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    final l10n = context.l10n;
    context.read<TaskViewBloc>().add(TaskViewEventByDate(DateTime.now()));
    log('TaskViewPage build context = $context');
    return Scaffold(
        appBar: AppBar(
            title: Row(
              children: [
                Text(l10n.taskAppBarTitle),
                SelectDate(_dateTime, (newDateTime) {
                  _dateTime = newDateTime;
                  context
                      .read<TaskViewBloc>()
                      .add(TaskViewEventByDate(newDateTime));
                })
              ],
            ),
            actions: [
              PopupMenuButton(
                  tooltip: l10n.taskAppBarMenu,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(l10n.editTask),
                        enabled: _taskState is TaskViewStateLoaded,
                      ),
                      PopupMenuItem<int>(
                          value: 1, child: Text(l10n.editTemplate))
                    ];
                  },
                  onSelected: (int idxSelected) {
                    log('item select $idxSelected');
                    switch (idxSelected) {
                      case 0:
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              context
                                  .read<TaskEditBloc>()
                                  .add(TaskEditLoadEvent(dateTime));
                              return TaskEditPage(dateTime);
                            }
                            )

                            // MaterialPageRoute(
                            //   settings: RouteSettings(arguments: _task),
                            //   builder: (context1) {
                            //     log('before TaskEditPage: context = $context');
                            //     log('before TaskEditPage build method ${context.read<TaskBloc>()}');
                            //     return TaskEditPage(_task);
                            //   })
                            );
                      case 1:
                        {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return TemplatePage();
                          }));
                        }
                        ;
                    }
                  })
            ]),
        body: _TaskView());
  }
}

class _TaskView extends StatelessWidget {
  const _TaskView({super.key});

  @override
  Widget build(Object context) {
    return BlocBuilder<TaskViewBloc, TaskViewState>(builder: (context, state) {
      return switch (state) {
        TaskViewStateLoading() => Center(child: CircularProgressIndicator()),
        TaskViewStateLoaded() => _SectionsList(state.task)
      };
    });
  }
}

class _SectionsList extends StatelessWidget {
  _SectionsList(Task? this.task, {super.key}) {
    print('constructor _SectionsList task=$task');
    log('constructor _SectionsList task=$task');
  }

  final Task? task;

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      final l10n = context.l10n;
      return Center(child: Text(l10n.dataIsAbsent));
    } else {
      return _SectionsListData(task!);
    }
  }
}

class _SectionsListData extends StatelessWidget {
  _SectionsListData(Task this.task, {super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: task.items.length,
        itemBuilder: (context, i) {
          return _Section(task.items[i]);
        });
  }
}

class _Section extends StatelessWidget {
  _Section(SectionDate this.sectionDate, {super.key});

  final SectionDate sectionDate;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(5)),
        margin: EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(sectionDate.name),
            _SectionContent(sectionDate)
          ],
        ));
  }
}

class _SectionHeader extends StatelessWidget {
  _SectionHeader(this.header, {super.key});

  final String header;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 2, top: 2), child: Text(header));
  }
}

class _SectionContent extends StatelessWidget {
  _SectionContent(this.sectionDate, {super.key});

  final SectionDate sectionDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.all(4),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: sectionDate.items.length,
          itemBuilder: (context, idx) {
            return _ItemSection(sectionDate.items[idx]);
          }),
    );
  }
}

class _ItemSection extends StatefulWidget {
  _ItemSection(ItemSectionDate this.itemSectionDate, {super.key});

  final ItemSectionDate itemSectionDate;

  @override
  State<_ItemSection> createState() => _ItemSectionState();
}

class _ItemSectionState extends State<_ItemSection> {
  String textForTime(DateTime? dateTime) {
    if (dateTime != null)
      return dateTime.toTimeTask();
    else
      return '';
  }

  Color? colorForCard(DateTime? dateTime) {
    if (dateTime != null)
      return Colors.white;
    else
      return Colors.grey;
  }

  Future<void> _changeItemSectionDate(
      BuildContext contextOuter, ItemSectionDate itemSectionDate) {
    return showDialog(
        context: contextOuter,
        builder: (BuildContext context) {
          bool _isValid = true;
          final _textEditControllerCount =
              TextEditingController(text: '${itemSectionDate.count}');
          DateTime _selectedTime = itemSectionDate.datetime ?? DateTime.now();
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              // title: Text('Set/Change count\n'
              //     'and time'),
              content: Wrap(
                children: [
                  TextFormField(
                    //initialValue: '${itemSectionDate.count}',
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'count[0-100]',
                        errorText: _isValid ? null : 'need correct number'),
                    onChanged: (value) {
                      log(value);
                      setState(() {
                        final intCount = int.tryParse(value);
                        _isValid = intCount != null &&
                            intCount >= 0 &&
                            intCount <= 100;
                      });
                    },
                    controller: _textEditControllerCount,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(height: 100, width: 100),
                        child: ScrollTimePicker(
                            selectedTime: _selectedTime,
                            onDateTimeChanged: (newDatetime) {
                              log('onDateTimeChanged $newDatetime');
                              setState(() {
                                _selectedTime = newDatetime;
                              });
                            }),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: _isValid
                        ? () {
                            Navigator.pop(context);
                            contextOuter.read<TaskViewBloc>().add(
                                TaskViewEventChangeItemSectionDate(
                                    itemSectionDate.copy(
                                        count: int.parse(
                                            _textEditControllerCount.text),
                                        dateime: _selectedTime)));
                          }
                        : null,
                    child: Text('a')),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      margin: EdgeInsets.all(2),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color?>(
                colorForCard(widget.itemSectionDate.datetime)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6)))),
        child: Center(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 5,
                ),
                Text('${widget.itemSectionDate.count}'),
                Text('${textForTime(widget.itemSectionDate.datetime)}')
              ],
            ),
          ),
        ),
        onPressed: () {
          _changeItemSectionDate(context, widget.itemSectionDate);
        },
      ),
    );
  }
}
