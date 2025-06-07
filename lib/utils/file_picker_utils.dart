import 'package:file_picker/file_picker.dart';
import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:cybersafe_pro/utils/secure_app_state.dart';

class FilePickerUtils {
  static Future<FilePickerResult?> pickFile({FileType type = FileType.any, List<String>? allowedExtensions, bool allowMultiple = false, bool withData = false}) async {
    // Tạm thời vô hiệu hóa bảo mật
    SecureApplicationUtil.instance.setSecureState(SecureAppState.partial);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
        withData: withData,
        onFileLoading: (FilePickerStatus status) {
          // Có thể thêm loading indicator ở đây
        },
      );

      return result;
    } finally {
      SecureApplicationUtil.instance.unlock();
    }
  }
}
