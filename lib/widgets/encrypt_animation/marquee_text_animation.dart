import 'dart:async';

import 'package:flutter/material.dart';

class MarqueeTextAnimation extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration animationDuration;
  final Duration pauseDuration;
  final double blankSpace;

  /// Tốc độ và hướng di chuyển của văn bản
  /// Giá trị âm: chạy từ phải sang trái (mặc định)
  /// Giá trị dương: chạy từ trái sang phải
  final double velocity;
  final bool startAfter;
  final bool loop;
  final double fontSize;
  final bool gradient;
  final List<Color>? gradientColors;

  const MarqueeTextAnimation({
    super.key,
    required this.text,
    this.textStyle,
    this.animationDuration = const Duration(seconds: 10),
    this.pauseDuration = const Duration(milliseconds: 800),
    this.blankSpace = 50.0,
    this.velocity = -50.0, // Mặc định chạy từ phải sang trái
    this.startAfter = true,
    this.loop = true,
    this.fontSize = 16.0,
    this.gradient = false,
    this.gradientColors,
  });

  @override
  State<MarqueeTextAnimation> createState() => _MarqueeTextAnimationState();
}

class _MarqueeTextAnimationState extends State<MarqueeTextAnimation> {
  late final ScrollController _scrollController;
  late final List<String> _items;
  Timer? _timer;
  bool _isAnimating = false;
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Tạo danh sách các item cho ListView
    _items = _generateItems();

    // Bắt đầu animation sau khi build hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.startAfter && mounted) {
        _startAnimation();
      }
    });
  }

  // Tạo danh sách các item để hiển thị
  List<String> _generateItems() {
    // Luôn tạo nhiều item để có thể lặp lại liên tục
    final int itemCount = 100; // Số lượng item lặp lại
    return List.generate(itemCount, (_) => widget.text);
  }

  void _startAnimation() {
    if (!mounted) return;

    _isAnimating = true;
    _timer?.cancel();

    // Tính toán tổng chiều dài của ListView
    final totalWidth = _calculateTotalWidth();

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_scrollController.hasClients) {
        // Tính toán vị trí mới dựa trên tốc độ và hướng
        // Nếu velocity âm, chạy từ phải sang trái (mặc định)
        // Nếu velocity dương, chạy từ trái sang phải
        double step = widget.velocity / 60;
        _offset += step;

        // Xử lý lặp lại dựa vào hướng chạy
        if (widget.velocity < 0) {
          // Chạy từ phải sang trái
          if (_offset > totalWidth / 2) {
            _offset = 0;
          }
        } else {
          // Chạy từ trái sang phải
          if (_offset < 0) {
            _offset = totalWidth / 2;
          }
        }

        _scrollController.jumpTo(_offset);
      }
    });
  }

  // Tính tổng chiều dài của ListView
  double _calculateTotalWidth() {
    if (widget.loop) {
      // Ước tính chiều dài dựa trên số ký tự
      return widget.text.length * widget.fontSize * 0.6 * _items.length;
    } else {
      return widget.text.length * widget.fontSize * 0.6;
    }
  }

  // Lấy chiều rộng của viewport
  double _getViewportWidth() {
    return MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = TextStyle(
      fontSize: widget.fontSize,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );

    final listView = ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      reverse: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: widget.blankSpace),
          child: Text(_items[index], style: widget.textStyle ?? defaultTextStyle),
        );
      },
    );

    if (widget.gradient) {
      final colors =
          widget.gradientColors ??
          [
            Colors.white,
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.7),
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.0),
          ];

      return ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: colors,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: listView,
      );
    }

    return listView;
  }
}
