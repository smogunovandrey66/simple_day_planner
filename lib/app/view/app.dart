import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:simple_day_planner/l10n/l10n.dart';
import 'package:simple_day_planner/task_edit/bloc/task_edit_bloc.dart';
import 'package:simple_day_planner/task_view/bloc/task_view_bloc.dart';
import 'package:simple_day_planner/task_view/view/task_view_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskViewBloc>(
          create: (context) => TaskViewBloc()
        ),
        BlocProvider(
          create: (context) => TaskEditBloc()
        ),
        Provider(create: (context) => DateTime.now())
      ], 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TaskViewPage() // const _App(),
      )
    );
    
    // return BlocProvider<TaskViewBloc>(
    //     create: (buildContext) {
    //       return TaskViewBloc();
    //     },
    //     child: MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         theme: ThemeData(
    //           appBarTheme: AppBarTheme(
    //             backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //           ),
    //           useMaterial3: true,
    //         ),
    //         localizationsDelegates: AppLocalizations.localizationsDelegates,
    //         supportedLocales: AppLocalizations.supportedLocales,
    //         home: TaskViewPage() // const _App(),
    //         ));

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     appBarTheme: AppBarTheme(
    //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //     ),
    //     useMaterial3: true,
    //   ),
    //   localizationsDelegates: AppLocalizations.localizationsDelegates,
    //   supportedLocales: AppLocalizations.supportedLocales,
    //   home: const _App(),
    // );
  }
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TaskViewBloc(),
        child:
            TaskViewPage() // Center(child: _TestScrollTimePicker())// const TaskView(),
        );
  }
}
