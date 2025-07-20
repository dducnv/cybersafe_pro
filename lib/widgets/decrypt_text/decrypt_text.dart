// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:cybersafe_pro/services/old_encrypt_method/encrypt_app_data_service.dart';

enum DecryptTextType { opt, info, password }

// Cache cho các giá trị đã decrypt
class _DecryptCache {
  static final Map<String, String> _cache = {};

  static String? get(String key, DecryptTextType type) {
    // Chỉ lấy từ cache nếu là loại info
    if (type != DecryptTextType.info) return null;

    final cacheKey = '${type.name}_$key';
    return _cache[cacheKey];
  }

  static void set(String key, DecryptTextType type, String value) {
    // Chỉ lưu vào cache nếu là loại info
    if (type != DecryptTextType.info) return;

    final cacheKey = '${type.name}_$key';
    _cache[cacheKey] = value;
  }
}

class DecryptText extends StatefulWidget {
  final TextStyle? style;
  final String value;
  final bool showLoading;
  final DecryptTextType decryptTextType;
  final Widget Function(BuildContext context, String decryptedValue)? builder;
  final String? preDecryptedValue; // Giá trị đã giải mã nếu có (preload)

  const DecryptText({
    super.key,
    this.style,
    required this.value,
    this.showLoading = true,
    required this.decryptTextType,
    this.builder,
    this.preDecryptedValue,
  });

  @override
  State<DecryptText> createState() => _DecryptTextState();
}

class _DecryptTextState extends State<DecryptText> {
  String? _decryptedValue;
  bool _isLoading = false;
  final decryptService = EncryptAppDataService.instance;
  final Map<String, String> _localDecryptedCache = {};
  static const Duration _decryptTimeout = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    // Ưu tiên giá trị preload nếu có
    if (widget.preDecryptedValue != null && widget.preDecryptedValue!.isNotEmpty) {
      _decryptedValue = widget.preDecryptedValue;
      _isLoading = false;
    } else {
      _loadDecryptedValue();
    }
  }

  @override
  void didUpdateWidget(DecryptText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || oldWidget.decryptTextType != widget.decryptTextType || oldWidget.preDecryptedValue != widget.preDecryptedValue) {
      if (widget.preDecryptedValue != null && widget.preDecryptedValue!.isNotEmpty) {
        setState(() {
          _decryptedValue = widget.preDecryptedValue;
          _isLoading = false;
        });
      } else {
        _loadDecryptedValue();
      }
    }
  }

  Future<void> _loadDecryptedValue() async {
    final cacheKey = '${widget.decryptTextType.name}_${widget.value}';
    // Ưu tiên lấy từ cache tạm thời trong vòng đời widget
    if (_localDecryptedCache.containsKey(cacheKey)) {
      setState(() {
        _decryptedValue = _localDecryptedCache[cacheKey];
        _isLoading = false;
      });
      return;
    }
    // Kiểm tra cache toàn cục nếu là info
    if (widget.decryptTextType == DecryptTextType.info) {
      final cachedValue = _DecryptCache.get(widget.value, widget.decryptTextType);
      if (cachedValue != null) {
        setState(() {
          _decryptedValue = cachedValue;
          _isLoading = false;
        });
        // Lưu vào cache tạm thời
        _localDecryptedCache[cacheKey] = cachedValue;
        return;
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      String decrypted = '';
      switch (widget.decryptTextType) {
        case DecryptTextType.opt:
          decrypted = await decryptService.decryptTOTPKey(widget.value).timeout(_decryptTimeout, onTimeout: () => '');
          break;
        case DecryptTextType.info:
          decrypted = await decryptService.decryptInfo(widget.value).timeout(_decryptTimeout, onTimeout: () => '');
          _DecryptCache.set(widget.value, widget.decryptTextType, decrypted);
          break;
        case DecryptTextType.password:
          decrypted = await decryptService.decryptPassword(widget.value).timeout(_decryptTimeout, onTimeout: () => '');
          break;
      }
      if (mounted) {
        setState(() {
          _decryptedValue = decrypted;
          _isLoading = false;
        });
        // Lưu vào cache tạm thời
        _localDecryptedCache[cacheKey] = decrypted;
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _decryptedValue = "";
          _isLoading = false;
        });
        _localDecryptedCache[cacheKey] = "";
      }
    }
  }

  @override
  void dispose() {
    _localDecryptedCache.clear(); // Clear cache tạm khi dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.showLoading) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.primary.withValues(alpha: .4),
        highlightColor: Theme.of(context).colorScheme.primary,
        child: Text('Decrypting...', textAlign: TextAlign.start, style: widget.style),
      );
    }

    if (_decryptedValue != null) {
      if (widget.builder != null) {
        return widget.builder!(context, _decryptedValue!);
      }
      return Text(_decryptedValue!, style: widget.style);
    }

    return const SizedBox.shrink();
  }
}
