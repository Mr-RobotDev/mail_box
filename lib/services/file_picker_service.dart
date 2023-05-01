import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:csv/csv.dart';
import 'package:mail_box/models/user.dart';
import 'package:path/path.dart' as p;

class FilePickerService {
  Future<List<File>?> getFiles(bool multiple) async {
    try {
      final files = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: multiple ? ['pdf'] : ['csv'],
        allowMultiple: multiple,
      );

      if (files != null) {
        return files.files.map((e) => File(e.path!)).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<User>?> readLocalCsv(String filePath) async {
    try {
      File f = File(filePath);
      final input = f.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      fields.removeAt(0);
      List<User> tempFields = [];
      for (var field in fields) {
        User csvData = User(
          unitNumber: field[0].toString(),
          email: field[1],
        );
        tempFields.add(csvData);
      }

      return tempFields;
    } catch (e) {
      return null;
    }
  }

  Future<Directory?> createFolderIfNotExists(
    String folderPath,
    String folderName,
  ) async {
    final processedfolderPath = p.join(folderPath, folderName);
    final folder = Directory(processedfolderPath);

    try {
      if (!await folder.exists()) {
        return await folder.create(recursive: true);
      } else {
        return folder;
      }
    } catch (e) {
      return null;
    }
  }

  Future<File?> moveFileToFolder(
      File file, String folderPath, String folderName) async {
    try {
      final folder = await createFolderIfNotExists(folderPath, folderName);
      if (folder != null) {
        final newFilePath = p.join(folder.path, p.basename(file.path));
        return await file.rename(newFilePath);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> getFolderPath() async {
    String? directoryPath = await getDirectoryPath(
      confirmButtonText: 'Select Folder',
    );

    if (directoryPath != null) {
      return directoryPath;
    } else {
      return null;
    }
  }
}
