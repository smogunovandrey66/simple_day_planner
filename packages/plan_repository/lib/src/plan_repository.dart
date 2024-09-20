/// {@template plan_repository}
// A repository that handles `todo` related requests.
/// {@endtemplate}
library;

import 'dart:developer';
import 'package:path/path.dart';
import 'package:plan_repository/plan_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:plan_api/plan_api.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

///
/// Repository
class PlanRepository {
  /// {@macro plan_repository}
  PlanRepository._() {
    log('constructor PlanRepository');
  }

  static PlanRepository? _planRepository = null;

  static Database? _opendatabaseMayBeNull = null;
  static const _dbName = 'tasks.db';
  static const _tableTasks = 'tasks';
  static const _tableSectionsDate = 'sections_date';
  static const _tableItemsSectionDate = 'items_section_date';

  static const _tableTemplates = 'templates';
  static const _talbeSections = 'sections';
  static const _tableItemsSection = 'items_section';

  static const _VERSION_DB = 1;

  //Last task or cashed task
  Task? _lastTask = null;

  static PlanRepository INSTANCE() {
    if (_planRepository == null) _planRepository = PlanRepository._();

    return _planRepository!;
  }

  Future<Database> get _futureDb async {
    if (_opendatabaseMayBeNull == null) {
      var funcOnCreate = (db, version) async {
        await db.execute('create TABLE $_tableTasks'
            ' (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' name TEXT,'
            ' date_created TEXT)'); //YYYY-MM-DD
        await db.execute('create TABLE $_tableSectionsDate'
            ' (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' id_task INTEGER,'
            ' name TEXT)');
        await db.execute('create TABLE $_tableItemsSectionDate'
            ' (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' id_section INTEGER,'
            ' count INTEGER,'
            ' date_execute TEXT)'); //ISO8601

        await db.execute('create TABLE $_tableTemplates'
            ' (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' name TEXT)');
        await db.execute('create TABLE $_talbeSections'
            ' (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' id_template INTEGER,'
            ' name TEXT)');
        await db.execute('create TABLE $_tableItemsSection'
            ' (id INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' id_section INTEGER,'
            ' count INTEGER)');
      };

      _opendatabaseMayBeNull = kIsWeb
          ? await databaseFactoryFfiWeb.openDatabase(_dbName,
              options: OpenDatabaseOptions(
                  version: _VERSION_DB, onCreate: funcOnCreate))
          : await openDatabase(
              join(await getDatabasesPath(), _dbName),
              version: _VERSION_DB,
              onCreate: funcOnCreate,
            );
    }
    return _opendatabaseMayBeNull!;
  }

  Future<Task?> getTaskByDate(DateTime dateTime) async {
    // if (kIsWeb)
    // return _fakeTaskWeb;

    var db = await _futureDb;

    final tables = await db.query('sqlite_master',
        columns: ['name'], where: 'type=?', whereArgs: ['table']);

    print(tables);

    final listTasks = await db.query(
      _tableTasks,
      where: 'date_created = ?',
      whereArgs: [dateTime.formatTask()],
    );

    if (listTasks.isNotEmpty) {
      final taskDB = listTasks.first;
      final task = taskDB.toTask();

      List<Map<String, dynamic>> listSections = await db.query(
          _tableSectionsDate,
          where: 'id_task = ?',
          whereArgs: [task.id]);

      for (Map<String, dynamic> section in listSections) {
        final itemsSection = await db.query(_tableItemsSectionDate,
            where: 'id_section = ?', whereArgs: [section['id']]);

        task.add(section, itemsSection);
      }

      return task;
    }

    return null;
  }

  Future<Template?> getTemplate() async {
    var db = await _futureDb;
    final listTemplates = await db.query(_tableTemplates);

    if (listTemplates.isNotEmpty) {
      final templateDB = listTemplates.first;
      final template = templateDB.toTemplate();

      List<Map<String, dynamic>> listSections = await db.query(_talbeSections,
          where: 'id_template = ?', whereArgs: [template.id]);

      for (final section in listSections) {
        final itemsSection = await db.query(_tableItemsSection,
            where: 'id_section = ?', whereArgs: [section['id']]);

        template.add(section, itemsSection);
      }

      return template;
    }

    return null;
  }

  void updateItemSectionDate(ItemSectionDate itemSectionDate) async {
    if (kIsWeb) {
      log('updateItemSectionDate $itemSectionDate');
      return;
    }
    ;

    final db = await _futureDb;

    db.update(_tableItemsSectionDate, itemSectionDate.toMap(),
        where: 'id=?', whereArgs: [itemSectionDate.id]);
  }

  void addSectionDate(DateTime dateTime, String nameSection) async {
    final db = await _futureDb;

    final dateTimeStr = dateTime.formatTask();

    final listTask = await db.query(_tableTasks,
        where: 'date_created = ?', whereArgs: [dateTimeStr]);

    Task? task = null;

    if (listTask.isNotEmpty) {
      task = listTask.first.toTask();
    } else {
      db.insert(
        _tableTasks, 
        {
          'name': n
        }
      );
    }
  }
}
