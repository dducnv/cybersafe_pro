import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/app_pin_code_fields/app_pin_code_fields.dart';
import 'package:flutter/material.dart';

import '../components/confirm_pin_code_widget.dart';
import '../components/create_pin_code_widget.dart';

class DesktopLayout extends StatefulWidget {
  final GlobalKey<AppPinCodeFieldsState> appPinCodeCreateKey;
  final GlobalKey<AppPinCodeFieldsState> appPinCodeConfirmKey;
  final GlobalKey<FormState> formCreateKey;
  final GlobalKey<FormState> formConfirmKey;
  final bool? isChangePin;
  
  const DesktopLayout({
    super.key, 
    required this.appPinCodeCreateKey, 
    required this.appPinCodeConfirmKey, 
    required this.formCreateKey, 
    required this.formConfirmKey, 
    this.isChangePin
  });

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  final PageController pageController = PageController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isChangePin == true 
        ? AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            scrolledUnderElevation: 0,
            title: const Text("Thay đổi mật khẩu chính"),
            centerTitle: true,
          ) 
        : null,
      body: Row(
        children: [
          // Panel bên trái - Branding
          Expanded(
            flex: 5,
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.security,
                      size: 80.sp,
                      color: Colors.white,
                    ),
                  ),
                  
                  SizedBox(height: 30.h),
                  
                  // Tên ứng dụng
                  Text(
                    "CyberSafe Pro",
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Slogan
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Bảo vệ dữ liệu cá nhân của bạn một cách an toàn và hiệu quả",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Panel bên phải - Form đăng ký PIN
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 650),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon khóa
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          Icons.lock_outline,
                          size: 50.sp, 
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      
                      SizedBox(height: 30.h),
                      
                      // Tiêu đề
                      Text(
                        widget.isChangePin == true 
                          ? "Thay đổi mật khẩu chính" 
                          : "Thiết lập mật khẩu chính",
                        style: TextStyle(
                          fontSize: 28.sp, 
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 15.h),
                      
                      // Mô tả
                      Text(
                        widget.isChangePin == true 
                          ? "Vui lòng nhập mật khẩu mới của bạn" 
                          : "Mật khẩu chính sẽ được sử dụng để bảo vệ tất cả dữ liệu của bạn",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 40.h),
                      
                      // PageView
                      SizedBox(
                        height: 300,
                        child: PageView(
                          controller: pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            CreatePinCodeWidget(
                              appPinCodeCreateKey: widget.appPinCodeCreateKey,
                              formCreateKey: widget.formCreateKey,
                              pageController: pageController,
                            ),
                            ConfirmPinCodeWidget(
                              appPinCodeConfirmKey: widget.appPinCodeConfirmKey,
                              formConfirmKey: widget.formConfirmKey,
                              pageController: pageController,
                              isChangePin: widget.isChangePin ?? false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}