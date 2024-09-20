import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_api/plan_api.dart';
import 'package:plan_repository/plan_repository.dart';
import 'package:simple_day_planner/l10n/l10n.dart';
import 'package:simple_day_planner/task_edit/bloc/task_edit_bloc.dart';
import 'package:simple_day_planner/task_edit/bloc/task_edit_event.dart';
import 'package:simple_day_planner/task_edit/bloc/task_edit_state.dart';
import 'package:simple_day_planner/task_view/bloc/task_view_bloc.dart';
import 'package:scroll_time_picker/scroll_time_picker.dart';
import 'package:simple_day_planner/task_view/view/select_date.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class TaskEditPage extends StatelessWidget {
  TaskEditPage(this.dateTime, {super.key});

  DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<TaskEditBloc, TaskEditState>(
      listener: (context, state) async {
        log('BlocConsumer listener state = $state');
        if (state is TaskEditShowDialogState) {
          final a = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Edit Section'),
                );
              });
        }
      },
      builder: (context, state) {
        log('TaskEditPage1 build state=$state', time: DateTime.now());
        return Scaffold(
          appBar: AppBar(
              title: Row(
            children: [
              Text(l10n.editTask),
              SelectDate(dateTime, (newDateTime) {
                dateTime = newDateTime;
                context
                    .read<TaskEditBloc>()
                    .add(TaskEditLoadEvent(newDateTime));
              })
            ],
          )),
          body: state is TaskEditLoadedState
              ? _SectionsListData(state.taskEditModel)
              : Center(
                  child: CircularProgressIndicator(),
                ),
          floatingActionButton: ElevatedButton(
            onPressed: state is TaskEditLoadedState &&
                    state.taskEditModel.taskEdited !=
                        state.taskEditModel.taskSaved
                ? () {
                    context
                        .read<TaskEditBloc>()
                        .add(TaskEditLoadEvent(dateTime));
                  }
                : null,
            child: Text('save'),
          ),
        );
      },
    );
  }
}

class _SectionsListData extends StatelessWidget {
  final TaskEditModel taskEditModel;

  _SectionsListData(this.taskEditModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final taskSaved = taskEditModel.taskSaved;
    final taskEdited = taskEditModel.taskSaved;

    return ListView.builder(
        itemCount: taskEdited.items.length + 1,
        itemBuilder: (context, i) {
          return i < taskEdited.items.length
              ? _Section(taskSaved.items[i])
              : _SectionAdd();
        });
  }
}

class _SectionAdd extends StatelessWidget {
  _SectionAdd({super.key});

  @override
  Widget build(BuildContext context) {
    log('_SectionAdd build');
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () async {
          final nameSection = await showDialog<String>(
              context: context, builder: (context) => DialogAddSection());
          await Future.delayed(Duration(seconds: 3));
          print('orResult $nameSection');
          if (nameSection != null && nameSection.isNotEmpty) {
            context.read<TaskEditBloc>().add(event);
          }
        },
        child: Text('+'));
  }
}

class DialogAddSection extends StatelessWidget {
  DialogAddSection({super.key});

  late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    textEditingController = TextEditingController();
    return AlertDialog(
      title: Text(context.l10n.addingSection),
      content: TextField(controller: textEditingController),
      actions: [
        TextButton(
            onPressed: () {
              final sectionName = textEditingController.text;
              print('onPressed $sectionName');
              if (sectionName.isNotEmpty) {
                Navigator.pop(context, sectionName);
              }
            },
            child: Text(context.l10n.add))
      ],
    );
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
