// import 'dart:async';

// import 'package:app_links/app_links.dart';
// import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
// import 'package:cybersafe_pro/extensions/extension_build_context.dart';
// import 'package:cybersafe_pro/localization/screens/settings/settings_locale.dart';
// import 'package:cybersafe_pro/providers/home_provider.dart';
// import 'package:cybersafe_pro/services/old_encrypt_method/data_manager_service_old.dart';
// import 'package:cybersafe_pro/utils/global_keys.dart';
// import 'package:cybersafe_pro/utils/logger.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';

// class DeepLinkHandler {
//   static final DeepLinkHandler _instance = DeepLinkHandler._internal();
//   factory DeepLinkHandler() => _instance;
//   DeepLinkHandler._internal();

//   StreamSubscription? _linkSubscription;
//   bool _isInitialized = false;

//   Future<void> initialize() async {
//     if (_isInitialized) return;
//     final appLinks = AppLinks();

//     _linkSubscription = appLinks.uriLinkStream.listen(
//       (uri) {
//         _handleLink(uri.toString());
//       },
//       onError: (error) {
//         logError('Error handling deep link: $error', functionName: "DeepLinkHandler.initialize");
//       },
//     );
//     // // Handle links when app is already running

//     _isInitialized = true;
//   }

//   void _handleLink(String link) {
//     final uri = Uri.parse(link);

//     // Check if this is a transfer request
//     if (uri.scheme == 'cybersafepro' && uri.host == 'transfer') {
//       // Handle data transfer
//       _handleTransferRequest();
//     }
//   }

//   Future<void> _handleTransferRequest() async {
//     // Extract the file path from the query parameters

//     BuildContext? context = GlobalKeys.appRootNavigatorKey.currentContext;
//     if (context == null || !context.mounted) return;
//     bool? isConfirmed = await showAppCustomDialog(
//       context,
//       AppCustomDialog(
//         title: context.trSafe(SettingsLocale.receiveData),
//         message: context.trSafe(SettingsLocale.receiveDataMessage),
//         confirmText: context.trSafe(SettingsLocale.confirm),
//         cancelText: context.trSafe(SettingsLocale.cancel),
//         canConfirmInitially: true,
//       ),
//     );
//     if (isConfirmed != true) return;
//     await DataManagerServiceOld.importTransferData();
//     if (context.mounted)
//       GlobalKeys.appRootNavigatorKey.currentContext!.read<HomeProvider>().refreshData();
//   }

//   void dispose() {
//     _linkSubscription?.cancel();
//     _isInitialized = false;
//   }
// }
