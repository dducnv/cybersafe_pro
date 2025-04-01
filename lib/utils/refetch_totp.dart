import 'dart:async';

class RefetchTotp {
  final Function refetchTotp;
  final Function(int)? onCurrentSecond;
  Timer? _timer;
  DateTime? _startTime;
  StreamController<int>? _controller;
  bool _isDisposed = false;

  RefetchTotp({
    required this.refetchTotp,
    this.onCurrentSecond,
  }) {
    _controller = StreamController<int>.broadcast(
      onListen: _onListen,
      onCancel: _onCancel,
    );
  }

  Stream<int> get elapsedStream => _controller?.stream ?? Stream.empty();

  void _onListen() {
    if (_isDisposed) return;
    
    _startTime = DateTime.now();
    _timer?.cancel(); // Hủy timer cũ nếu có
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onCancel() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTick(Timer timer) {
    if (_isDisposed || _controller == null || _controller!.isClosed) {
      timer.cancel();
      return;
    }
    
    var currentSecond = DateTime.now().second;
    onCurrentSecond?.call(currentSecond);
    if (currentSecond == 0 || currentSecond == 30) {
      refetchTotp();
    }

    if (_startTime != null) {
      var elapsedTime = DateTime.now().difference(_startTime!).inSeconds;
      if (!_controller!.isClosed) {
        _controller!.add(elapsedTime);
      }
    }
  }

  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    _controller?.close();
    _controller = null;
    _startTime = null;
  }
}
