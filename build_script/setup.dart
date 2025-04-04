
import 'change_app_info.dart';
import 'configs.dart';
import 'copy_assets.dart';
import 'copy_res_folder.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Please provide the app version as an argument.');
    return;
  }
  final String appVersion = args[0];
  logWarning('App version: $appVersion');
  logWarning('Start setup app Info........');
  await changeAppInfo(appVersion);
  logSuccess('Setup app Info done');
  logWarning('Start copy res folder........');
  await copyResFolderAndroid(appVersion);
  logWarning('Start copy asset images.');
  await copyImagesAssets(appVersion);
}
