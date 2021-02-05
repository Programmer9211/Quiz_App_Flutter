import 'dart:async';

abstract class TokenEvents {}

class IncrementToken extends TokenEvents {
  final int token;
  IncrementToken(this.token);
}

class DecrementToken extends TokenEvents {
  final int token;
  DecrementToken(this.token);
}

class BlocToken {
  int _currentToken;

  final _tokenStateController = StreamController<int>.broadcast();

  StreamSink<int> get _intoken => _tokenStateController.sink;

  Stream<int> get token => _tokenStateController.stream;

  final _tokenEventController = StreamController<TokenEvents>.broadcast();

  StreamSink<TokenEvents> get tokenEventSink => _tokenEventController.sink;

  BlocToken() {
    _tokenEventController.stream.asBroadcastStream().listen(_tokenCount);
  }

  void _tokenCount(TokenEvents events) {
    if (events is IncrementToken) {
      _currentToken = _currentToken + events.token;
    } else if (events is DecrementToken) {
      _currentToken = _currentToken - events.token;
    }

    _intoken.add(_currentToken);
  }

  void initialize(int tokens) {
    _currentToken = tokens;
  }

  void dispose() {
    _tokenEventController.close();
    _tokenStateController.close();
  }
}
