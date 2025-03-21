// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:cybersafe_pro/services/encrypt_app_data_service.dart';

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

  const DecryptText({
    super.key,
    this.style,
    required this.value,
    this.showLoading = true,
    required this.decryptTextType,
    this.builder,
  });

  @override
  State<DecryptText> createState() => _DecryptTextState();
}

class _DecryptTextState extends State<DecryptText> {
  String? _decryptedValue;
  bool _isLoading = false;
  final decryptService = EncryptAppDataService.instance;

  @override
  void initState() {
    super.initState();
    _loadDecryptedValue();
  }

  @override
  void didUpdateWidget(DecryptText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || 
        oldWidget.decryptTextType != widget.decryptTextType) {
      _loadDecryptedValue();
    }
  }

  Future<void> _loadDecryptedValue() async {
    // Kiểm tra cache chỉ khi là loại info
    if (widget.decryptTextType == DecryptTextType.info) {
      final cachedValue = _DecryptCache.get(widget.value, widget.decryptTextType);
      if (cachedValue != null) {
        setState(() {
          _decryptedValue = cachedValue;
          _isLoading = false;
        });
        return;
      }
    }

    // Nếu không có trong cache hoặc không phải loại info, thực hiện decrypt
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      String decrypted = '';
      switch (widget.decryptTextType) {
        case DecryptTextType.opt:
          decrypted = await decryptService.decryptTOTPKey(widget.value);
          break;
        case DecryptTextType.info:
          decrypted = await decryptService.decryptInfo(widget.value);
          // Chỉ lưu vào cache nếu là loại info
          _DecryptCache.set(widget.value, widget.decryptTextType, decrypted);
          break;
        case DecryptTextType.password:
          decrypted = await decryptService.decryptPassword(widget.value);
          break;
      }

      if (mounted) {
        setState(() {
          _decryptedValue = decrypted;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _decryptedValue = "";
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _DecryptCache.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.showLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.white38,
        highlightColor: Colors.white,
        child: Text(
          'Decrypting...',
          textAlign: TextAlign.start,
          style: widget.style,
        ),
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
