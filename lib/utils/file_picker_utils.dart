import 'dart:typed_data';

import 'package:cybersafe_pro/utils/secure_application_util.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerUtils {
  static Future<FilePickerResult?> pickFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = false,
    bool withData = false,
  }) async {
    SecureApplicationUtil.instance.pause();
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
      SecureApplicationUtil.instance.unpause();
    }
  }

  static Future<String?> saveFileBackup({
    String? dialogTitle = 'Save Backup File',
    required String fileName,
    required Uint8List bytes,
  }) async {
    SecureApplicationUtil.instance.pause();
    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
        fileName: fileName,
        bytes: bytes,
      );
      if (result == null) return null;
      return result;
    } finally {
      SecureApplicationUtil.instance.unpause();
    }
  }
}
