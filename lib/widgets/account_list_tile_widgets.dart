import 'package:cybersafe_pro/components/icon_show_component.dart';
import 'package:cybersafe_pro/database/models/account_ojb_model.dart';
import 'package:cybersafe_pro/providers/account_provider.dart';
import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountItemWidget extends StatelessWidget {
  final AccountOjbModel accountModel;
  final bool isLastItem;
  final bool isSelected;
  final Function()? onTapSubButton;
  final Function()? onCallBackPop;
  final Function()? onLongPress;
  final Function()? onSelect;
  final Function()? onDragSelect;
  final Function()? onTap;

  final Widget? subIcon;
  const AccountItemWidget({
    super.key,
    this.onCallBackPop,
    required this.accountModel,
    required this.isLastItem,
    this.onLongPress,
    this.onTapSubButton,
    this.onSelect,
    this.subIcon,
    this.onDragSelect,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: .1) : Colors.transparent,
      child: InkWell(
        onLongPress: onLongPress,
        onTap:
            onTap ??
            () {
              AppRoutes.navigateTo(context, AppRoutes.detailsAccount, arguments: {"accountId": accountModel.id});
            },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  onSelect?.call();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ColoredBox(
                    color: Colors.grey.withValues(alpha: .2),
                    child: Center(
                      child: SizedBox(
                        width: 50.h,
                        height: 50.h,

                        child: Selector<AccountProvider, List<AccountOjbModel>>(
                          selector: (context, provider) => provider.accountSelected,
                          builder: (context, value, child) {
                            bool isSelected = value.where((element) => element.id == accountModel.id).isNotEmpty;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  isSelected
                                      ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                                      : IconShowComponent(account: accountModel, width: 40.h, height: 40.h, textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(border: isLastItem ? null : Border(bottom: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest))),

                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(accountModel.title, overflow: TextOverflow.ellipsis, style: CustomTextStyle.regular(fontSize: 14.sp, fontWeight: FontWeight.bold), maxLines: 1),
                              if (accountModel.email != null && accountModel.email!.isNotEmpty) ...[
                                SizedBox(height: 4),
                                Text(accountModel.email!, maxLines: 1, overflow: TextOverflow.ellipsis, style: CustomTextStyle.regular(color: Colors.grey, fontSize: 12.sp)),
                              ],
                            ],
                          ),
                        ),
                        Visibility(
                          visible: onTapSubButton != null || subIcon == null,
                          replacement: Center(child: subIcon ?? const SizedBox()),
                          child: IconButton(onPressed: onTapSubButton, icon: Icon(Icons.more_vert, size: 24.sp)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
