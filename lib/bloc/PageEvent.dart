import 'dart:async';

class PageEvent {
  int _currentindex;
  bool _isShrink;

  void init(int index, bool value) {
    _currentindex = index;
    _isShrink = value;
  }

  // For Chaging Index of Page

  final _pageStateController = StreamController<int>();

  StreamSink<int> get _inpageindex => _pageStateController.sink;

  Stream<int> get pageState => _pageStateController.stream;

  final _pageEventController = StreamController<int>();

  StreamSink<int> get pageIndex => _pageEventController.sink;

  PageEvent() {
    _pageEventController.stream.listen(_pageCount);
    _boolEventController.stream.listen(_boolState);
  }

  void _pageCount(int page) {
    _currentindex = page;

    _inpageindex.add(_currentindex);
  }

  final _boolStateController = StreamController<bool>();

  StreamSink<bool> get _boolValue => _boolStateController.sink;

  Stream<bool> get boolState => _boolStateController.stream;

  final _boolEventController = StreamController<bool>();

  StreamSink<bool> get getBool => _boolEventController.sink;

  void _boolState(bool value) {
    _isShrink = value;

    _boolValue.add(_isShrink);
  }

  void dispose() {
    _pageEventController.close();
    _pageStateController.close();
    _boolEventController.close();
    _boolStateController.close();
  }
}
