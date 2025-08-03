import 'dart:developer';

import 'package:cybersafe_pro/components/dialog/loading_dialog.dart';
import 'package:cybersafe_pro/providers/home_provider.dart';
import 'package:cybersafe_pro/screens/pin_code_widget/pin_code_widget.dart';
import 'package:cybersafe_pro/services/data_manager_service.dart';
import 'package:cybersafe_pro/utils/toast_noti.dart';
import 'package:cybersafe_pro/widgets/encrypt_animation/example_usage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Developer Tools')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  bool deleteAllResult = await DataManagerService.deleteAllData();
                  log(deleteAllResult.toString());
                  context.read<HomeProvider>().refreshData(clearCategory: true);
                },
                child: const Text("Delete"),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool backUpResult = await DataManagerService.backupData(context, "123456");
                  log(backUpResult.toString());
                },
                child: const Text("backup"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // showLoadingDialog();
                  // bool restoreResult = await DataManagerService.restoreBackup(context, "123456");
                  // log(restoreResult.toString());
                  // if (restoreResult) {
                  //   context.read<HomeProvider>().refreshData(clearCategory: true);
                  //   hideLoadingDialog();
                  //   showToastSuccess("Backup success", context: context);
                  // } else {
                  //   hideLoadingDialog();
                  //   showToastError("Backup failed", context: context);
                  // }
                },
                child: const Text("restore"),
              ),
              ElevatedButton(
                onPressed: () async {
                  showLoadingDialog();
                  bool restoreResult = await DataManagerService.importDataFromBrowser();
                  log(restoreResult.toString());
                  if (restoreResult) {
                    context.read<HomeProvider>().refreshData(clearCategory: true);
                    hideLoadingDialog();
                    showToastSuccess("Backup success", context: context);
                  } else {
                    hideLoadingDialog();
                    showToastError("Backup failed", context: context);
                  }
                },
                child: const Text("IMPORT FROM CHROME"),
              ),

              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PinCodeWidget(hintText: "Nhập mã pin")),
                  );
                },
                child: const Text("Pincode"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EncryptAnimationExample()),
                  );
                },
                child: const Text("Animation"),
              ),
              ElevatedButton(
                onPressed: () async {
                  showLoadingDialog();
                },
                child: const Text("Animation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
