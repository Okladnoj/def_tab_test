import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:rxdart/rxdart.dart';

void main() {
  runApp(
    MaterialApp(
      home: TestScrean(),
    ),
  );
}

CounterBloc counterBloc = CounterBloc();

class TestScrean extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: StreamBuilder<int>(
                stream: counterBloc.pressedCount,
                builder: (context, snapshot) {
                  return Text('Title "${snapshot.data}"');
                })),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                counterBloc.incrementCounter.add(null);
              },
              child: Container(
                color: Color(0x33550000),
                child: Center(
                    child: StreamBuilder<int>(
                        stream: counterBloc.pressedCount,
                        builder: (context, snapshot) {
                          return Text('Add "${snapshot.data}"');
                        })),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                counterBloc.decrementCounter.add(null);
              },
              child: SecondScreen(),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x33000066),
      child: Center(
          child: StreamBuilder<int>(
              stream: counterBloc.pressedCount,
              builder: (context, snapshot) {
                return Text('Dell "${snapshot.data}"');
              })),
    );
  }
}

class CounterBloc {
  int _counter;

  CounterBloc() {
    _counter = 1;
    _actionController.stream.listen(_increaseStream);
    _actionDecrementController.stream.listen(_decreaseStream);
  }

  ///
  final _counterStream = BehaviorSubject<int>.seeded(1);

  Stream get pressedCount => _counterStream.stream;
  Sink get _addValue => _counterStream.sink;

  StreamController _actionController = StreamController();
  StreamSink get incrementCounter => _actionController.sink;

  StreamController _actionDecrementController = StreamController();
  StreamSink get decrementCounter => _actionDecrementController.sink;

  void _increaseStream(data) {
    _counter += 1;
    _addValue.add(_counter);
  }

  void _decreaseStream(data) {
    _counter -= 1;
    _addValue.add(_counter);
  }

  void dispose() {
    _counterStream.close();
    _actionController.close();
    _actionDecrementController.close();
  }
}
