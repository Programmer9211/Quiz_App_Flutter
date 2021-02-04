import 'dart:async';

abstract class TrophyEvent {}

class Increment extends TrophyEvent {
  final int trophy;
  Increment({this.trophy});
}

class Decrement extends TrophyEvent {
  final int trophy;
  Decrement({this.trophy});
}

class BlocTrophy {
  int _currentTrophy = 10;

  final _trophyStateController = StreamController<int>.broadcast();

  StreamSink<int> get _incounter => _trophyStateController.sink;

  Stream<int> get counter => _trophyStateController.stream;

  final _trophyEventController = StreamController<TrophyEvent>.broadcast();

  StreamSink<TrophyEvent> get trophyEventSink => _trophyEventController.sink;

  BlocTrophy() {
    _trophyEventController.stream.asBroadcastStream().listen(_trophies);
  }

  void _trophies(TrophyEvent event) {
    if (event is Increment) {
      _currentTrophy = _currentTrophy + event.trophy;
    } else if (event is Decrement) {
      _currentTrophy = _currentTrophy + event.trophy;
    }

    _incounter.add(_currentTrophy);
  }

  void dispose() {
    _trophyEventController.close();
    _trophyStateController.close();
  }
}
