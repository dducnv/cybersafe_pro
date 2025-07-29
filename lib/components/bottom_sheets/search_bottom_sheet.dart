import 'dart:async';

import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/repositories/driff_db/cybersafe_drift_database.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/decrypt_text/decrypt_text.dart';
import 'package:cybersafe_pro/widgets/text_field/custom_text_field.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

Future<void> showSearchBottomSheet(BuildContext context,{
  Function(AccountDriftModelData)? onTapAccount,
}) async {
  return showModalBottomSheet(
    isScrollControlled: true, 
    context: context, 
    builder: (context) => SearchBottomSheet(
      onTapAccount: onTapAccount,
    )
  );
}

class SearchBottomSheet extends StatefulWidget {
  final Function(AccountDriftModelData)? onTapAccount;
  const SearchBottomSheet({super.key, this.onTapAccount});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<AccountDriftModelData> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounceTimer;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _preloadAccountsForSearch();
  }

  /// Preload accounts for search to improve performance
  Future<void> _preloadAccountsForSearch() async {
    try {
      final accountProvider = context.read<AccountProvider>();
      await accountProvider.preloadAccountsForSearch();
    } catch (e) {
      // Ignore errors, search will still work
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // Hủy timer cũ nếu có
    _debounceTimer?.cancel();
    
    final query = _searchController.text.trim();
    
    // Clear results immediately if query is empty
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
        _lastQuery = '';
      });
      return;
    }

    // Don't search if it's the same query
    if (query == _lastQuery) {
      return;
    }

    // Show loading state
    setState(() => _isLoading = true);
    
    // Tạo timer mới để debounce
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;
      
      try {
        // Thực hiện tìm kiếm
        final accountProvider = context.read<AccountProvider>();
        final results = await accountProvider.searchAccounts(query);
        
        if (mounted) {
          setState(() {
            _searchResults = results;
            _isLoading = false;
            _lastQuery = query;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _searchResults = [];
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8).copyWith(top: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                 Center(
                  child: Text(
                    context.trHome(HomeLocale.searchTitle),
                    style: CustomTextStyle.regular(fontSize: 24, fontWeight: FontWeight.w700)
                  )
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => AppRoutes.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: CustomTextField(
              prefixIcon: Icon(Icons.search),
              controller: _searchController,
              textInputAction: TextInputAction.search,
              textAlign: TextAlign.start,
              autoFocus: true,
              hintText: context.trHome(HomeLocale.searchHint),
              onChanged: (_) => _onSearchChanged(),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
             Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/exclamation-mark.png", width: 60.w, height: 60.h),
                  const SizedBox(height: 10),
                  Text(context.trHome(HomeLocale.searchNoResult), style: CustomTextStyle.regular(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                ],
              ),
            )
          else
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final account = _searchResults[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 350),
                      child: SlideAnimation(
                        verticalOffset: 24.0,
                        child: FadeInAnimation(
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: IconShowComponent(
                                    account: account,
                                    width: 30,
                                    height: 30,
                                    textStyle: CustomTextStyle.regular(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                                  ),
                                ),
                              ),
                            ),
                            title: DecryptText(
                              value: account.title,
                              decryptTextType: DecryptTextType.info,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            subtitle: account.username != null ? DecryptText(
                              value: account.username!,
                              decryptTextType: DecryptTextType.info,
                              style: TextStyle(
                                color: Colors.grey[600]
                              ),
                            ) : null,
                            onTap: () {
                              if (widget.onTapAccount != null) {
                                widget.onTapAccount!(account);
                              } else {
                                AppRoutes.navigateTo(context, AppRoutes.detailsAccount, arguments: {"accountId": account.id});
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
