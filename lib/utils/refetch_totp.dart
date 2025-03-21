import 'dart:async';

class RefetchTotp {
  final Function refetchTotp;
  final Function(int)? onCurrentSecond;
  late Timer _timer;
  late DateTime _startTime;
  late StreamController<int> _controller;

  RefetchTotp({
    required this.refetchTotp,
    this.onCurrentSecond,
  }) {
    _controller = StreamController<int>.broadcast(
      onListen: _onListen,
      onCancel: _onCancel,
    );
  }

  Stream<int> get elapsedStream => _controller.stream;

  void _onListen() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onCancel() {
    _timer.cancel();
    _controller.close();
  }

  void _onTick(Timer timer) {
    var currentSecond = DateTime.now().second;
    onCurrentSecond?.call(currentSecond);
    if (currentSecond == 0 || currentSecond == 30) {
      refetchTotp();
    }

    var elapsedTime = DateTime.now().difference(_startTime).inSeconds;
    _controller.add(elapsedTime);
  }

  void dispose() {
    _timer.cancel();
    _controller.close();
  }
}
