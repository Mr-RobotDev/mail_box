import 'dart:async';

class LogsService {
  final List<String> _logs = [];

  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void add(String value) {
    _logs.add(value);
    _controller.add(value);
  }

  List<String> getLogs() {
    return _logs;
  }

  void dispose() => _controller.close();
}
