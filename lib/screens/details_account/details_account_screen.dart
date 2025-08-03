import 'package:cybersafe_pro/providers/details_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'layouts/mobile_layout.dart';

class DetailsAccountScreen extends StatefulWidget {
  final int accountId;

  const DetailsAccountScreen({super.key, required this.accountId});

  @override
  State<DetailsAccountScreen> createState() => _DetailsAccountScreenState();
}

class _DetailsAccountScreenState extends State<DetailsAccountScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    try {
      final provider = context.read<DetailsAccountProvider>();
      await provider.loadAccountDetails(widget.accountId);
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsAccountProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return DetailsAccountMobileLayout(accountId: widget.accountId);
      },
    );
  }
}
