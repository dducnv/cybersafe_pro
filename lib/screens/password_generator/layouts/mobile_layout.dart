import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/screens/home/home_locale.dart';
import 'package:cybersafe_pro/providers/password_generate_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class PasswordGenerateMobileLayout extends StatefulWidget {
  const PasswordGenerateMobileLayout({super.key});

  @override
  State<PasswordGenerateMobileLayout> createState() => _PasswordGenerateMobileLayoutState();
}

class _PasswordGenerateMobileLayoutState extends State<PasswordGenerateMobileLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PasswordGenerateProvider>(context, listen: false).generatePassword();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PasswordGenerateProvider>(context);

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text(context.trHome(HomeLocale.passwordGenerator))),
      floatingActionButton: SizedBox(
        width: 61.h,
        height: 61.h,
        child: FittedBox(
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
              context.read<PasswordGenerateProvider>().generatePassword();
            },
            child: Icon(Icons.loop_rounded, size: 18),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 60.h,
        padding: EdgeInsets.zero,
        notchMargin: 8,
        elevation: 8,
        color: Theme.of(context).colorScheme.surface,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(width: 16),
            // Nút Quay lại
            Expanded(
              child: _buildNavItem(
                context,
                icon: Icons.arrow_back,
                onTap: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    AppRoutes.navigateToReplacement(context, AppRoutes.home);
                  }
                },
              ),
            ),
            // Khoảng trống cho FAB
            const SizedBox(width: 80),
            // Nút Sử dụng/Sao chép
            Expanded(
              child: _buildNavItem(
                context,
                icon: viewModel.isFromForm ? Icons.arrow_outward : Icons.copy_outlined,
                onTap: () {
                  if (viewModel.isFromForm) {
                    viewModel.onPasswordChanged!(viewModel.password);
                    Navigator.of(context).pop();
                    return;
                  }
                  Clipboard.setData(ClipboardData(text: viewModel.password));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã sao chép mật khẩu vào bộ nhớ tạm"), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)));
                },
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Consumer<PasswordGenerateProvider>(
                        builder: (context, viewModel, child) {
                          return RichText(textAlign: TextAlign.center, text: TextSpan(children: viewModel.passwordInline, style: CustomTextStyle.regular(fontSize: 25, fontWeight: FontWeight.bold)));
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Consumer<PasswordGenerateProvider>(
                        builder: (context, viewModel, child) {
                          return Switch(
                            value: viewModel.isSymbol,
                            onChanged: (value) {
                              viewModel.setIsSymbol(value);
                              Future.delayed(const Duration(milliseconds: 100), () {
                                viewModel.generatePassword();
                              });
                            },
                          );
                        },
                      ),
                      Text("(!@#,...)", style: CustomTextStyle.regular(fontSize: 14)),
                    ],
                  ),
                  Row(
                    children: [
                      Consumer<PasswordGenerateProvider>(
                        builder: (context, viewModel, child) {
                          return Switch(
                            value: viewModel.isNumber,
                            onChanged: (value) {
                              viewModel.setIsNumber(value);
                              Future.delayed(const Duration(milliseconds: 100), () {
                                viewModel.generatePassword();
                              });
                            },
                          );
                        },
                      ),
                      Text("(0-9)", style: CustomTextStyle.regular(fontSize: 14)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<PasswordGenerateProvider>(
                      builder: (context, viewModel, child) {
                        return NumberPicker(
                          haptics: true,
                          zeroPad: false,
                          value: viewModel.passLength,
                          textStyle: CustomTextStyle.regular(color: Theme.of(context).colorScheme.primary, fontSize: 25.sp, fontWeight: FontWeight.bold),
                          itemCount: 5,
                          minValue: 8,
                          maxValue: 100,
                          itemWidth: 60.h,
                          itemHeight: 60.h,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2)),
                          axis: Axis.horizontal,
                          onChanged: (value) {
                            viewModel.passLength = value;
                            viewModel.generatePassword();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method để tạo các mục trong thanh điều hướng
  Widget _buildNavItem(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8.h), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 22)])),
    );
  }
}
