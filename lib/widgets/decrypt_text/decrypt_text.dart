// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cybersafe_pro/services/data_secure_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum DecryptTextType { opt, info, password }

class DecryptText extends StatefulWidget {
  final TextStyle? style;
  final String value;
  final bool showLoading;
  final DecryptTextType decryptTextType;
  final Widget Function(BuildContext context, String decryptedValue)? builder;
  final String? preDecryptedValue; // Giá trị đã giải mã nếu có (preload)

  const DecryptText({super.key, this.style, required this.value, this.showLoading = true, required this.decryptTextType, this.builder, this.preDecryptedValue});

  @override
  State<DecryptText> createState() => _DecryptTextState();
}

class _DecryptTextState extends State<DecryptText> {
  String? _decryptedValue;
  bool _isLoading = false;
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
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      String decrypted = '';
      if (!DataSecureService.isValueEncrypted(widget.value)) {
        decrypted = widget.value;
      } else {
        switch (widget.decryptTextType) {
          case DecryptTextType.opt:
            decrypted = await DataSecureService.decryptTOTPKey(widget.value).timeout(_decryptTimeout, onTimeout: () => '');
            break;
          case DecryptTextType.info:
            decrypted = await DataSecureService.decryptInfo(widget.value).timeout(_decryptTimeout, onTimeout: () => '');
            break;
          case DecryptTextType.password:
            decrypted = await DataSecureService.decryptPassword(widget.value).timeout(_decryptTimeout, onTimeout: () => '');
            break;
        }
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
