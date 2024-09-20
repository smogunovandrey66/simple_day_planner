import 'dart:developer';

import 'package:flutter/material.dart';

class TaskEditPage extends StatelessWidget {
  TaskEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit task')),
      body: _TaskEditPage()
    );
  }
}

class _TaskEditPage extends StatelessWidget {
  _TaskEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 50,
        itemBuilder: (context, i) {
          return i < 49 ? _Section() : _SectionAdd();
        });
  }
}

class _SectionAdd extends StatelessWidget {
  _SectionAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ElevatedButton(
          child: Text('+'),
          onPressed: () {
            log('log: onPressed');
            print('print: onPressed');
          }
        )
      );
  }
}

class _Section extends StatelessWidget {
  _Section({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,       
          children: [
            Text('Header'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(

                    margin: EdgeInsets.all(5),
                    color: Colors.red
                  ),
                  Container(
                    height: 5,
                    width: 5,
                    margin: EdgeInsets.all(5),
                    color: Colors.red
                  ),
                  _SectionItem(),
                  _SectionItemAdd()
                ]
              )
            )             
          ]
        )
      );
  }
}

class _SectionItem extends StatelessWidget {
  _SectionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(6.0),
        margin: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: ElevatedButton(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('11'),
              Text('18:50')
            ]
          ),
          onPressed: () {
            log('log: onPressed');
            print('print: onPressed');
          }
        )
    );
  }
}

class _SectionItemAdd extends StatelessWidget {
  _SectionItemAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(6.0),
        margin: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: ElevatedButton(
          child: Text('+'),
          onPressed: () {
            log('log: onPressed');
            print('print: onPressed');
          }
        )
    );
  }
}
