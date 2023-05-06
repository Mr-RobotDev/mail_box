// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/common/ui_helpers.dart';
import 'package:mail_box/models/log.dart';
import 'package:mail_box/models/user.dart';
import 'package:mail_box/services/email_service.dart';
import 'package:mail_box/services/file_picker_service.dart';
import 'package:mail_box/services/hive_service.dart';
import 'package:mail_box/services/locator/locator.dart';
import 'package:mail_box/services/shared_prefs.dart';

class HomeProvider extends ChangeNotifier {
  TextEditingController unitNumberController = TextEditingController();
  void clearUnitNumber() {
    unitNumberController.clear();
  }

  int _currentFile = 0;
  int get currentFile => _currentFile;
  set currentFile(int value) {
    _currentFile = value;
    notifyListeners();
  }

  void previousFile() {
    if (currentFile > 0) {
      currentFile--;
      notifyListeners();
    }
  }

  void nextFile() {
    if (currentFile < files.length - 1) {
      currentFile++;
      notifyListeners();
    }
  }

  int _sendingCount = 0;
  int get sendingCount => _sendingCount;

  // Load pdf files from file picker
  List<File> files = [];
  void pickFiles(BuildContext context) {
    getIt<FilePickerService>().getFiles(true).then((resultFiles) {
      if (resultFiles != null) {
        files = resultFiles;
        notifyListeners();
        infoBox(context, 'Success', 'Files loaded successfully',
            InfoBarSeverity.success);
      } else {
        infoBox(context, 'Error', 'No files selected', InfoBarSeverity.error);
      }
    });
  }

  // Load users from csv file
  List<User> users = [];
  void pickUsers(BuildContext context) {
    getIt<FilePickerService>().readLocalCsv().then((loadedUsers) {
      if (loadedUsers != null) {
        users = loadedUsers;
        notifyListeners();
        infoBox(context, 'Success', 'Users loaded successfully',
            InfoBarSeverity.success);
      } else {
        infoBox(context, 'Error', 'No file selected', InfoBarSeverity.error);
      }
    }).catchError((_) {
      infoBox(context, 'Error', 'No file selected', InfoBarSeverity.error);
    });
  }

  // Send emails
  void send(BuildContext context) async {
    final unitNumber = unitNumberController.text;

    if (unitNumber.isEmpty) {
      return;
    }

    final email = SharedPrefs.getString('EMAIL');
    final password = SharedPrefs.getString('PASSWORD');
    final subject = SharedPrefs.getString('SUBJECT');
    final body = SharedPrefs.getString('BODY');
    final folderPath = SharedPrefs.getString('FOLDER_PATH');

    if (email.isEmpty ||
        password.isEmpty ||
        subject.isEmpty ||
        body.isEmpty ||
        folderPath.isEmpty) {
      infoBox(
          context,
          'Error',
          'Please fill in all required settings in the settings view',
          InfoBarSeverity.error);
      return;
    }

    if (files.isEmpty) {
      infoBox(
          context, 'Error', 'Please select pdf files', InfoBarSeverity.error);
      return;
    }

    if (users.isEmpty) {
      infoBox(context, 'Error', 'Please select a users data file',
          InfoBarSeverity.error);
      return;
    }

    final recipientEmail = users
        .firstWhere(
          (element) => element.unitNumber == unitNumber,
          orElse: () => User(email: '', unitNumber: ''),
        )
        .email;

    final file = await moveFile(folderPath, unitNumber);
    if (file != null) {
      unitNumberController.clear();
      files.remove(files[currentFile]);
      notifyListeners();

      if (recipientEmail.isNotEmpty) {
        emailFile(
          context,
          file,
          unitNumber,
          recipientEmail,
          email,
          password,
          subject,
          body,
        );
      }
    } else {
      infoBox(context, 'Error', 'File not moved', InfoBarSeverity.error);
    }
  }

  Future<File?> moveFile(String folderPath, String unitNumber) async {
    try {
      final tempFile = await getIt<FilePickerService>().moveFileToFolder(
        files[currentFile],
        folderPath,
        unitNumber,
      );

      if (tempFile != null) {
        Log log = Log(
          error: '',
          logContent: 'File $unitNumber.pdf moved to $folderPath/$unitNumber',
          timeStamp: DateTime.now().toString(),
        );

        await HiveService.save(log.hashCode.toString(), log);
        return tempFile;
      } else {
        Log log = Log(
          error: 'Error',
          logContent:
              'File $unitNumber.pdf not moved to $folderPath/$unitNumber',
          timeStamp: DateTime.now().toString(),
        );

        await HiveService.save(log.hashCode.toString(), log);
        return null;
      }
    } catch (e) {
      Log log = Log(
        error: 'Error',
        logContent: 'File $unitNumber.pdf not moved to $folderPath/$unitNumber',
        timeStamp: DateTime.now().toString(),
      );

      await HiveService.save(log.hashCode.toString(), log);
      return null;
    }
  }

  void emailFile(
    BuildContext context,
    File file,
    String unitNumber,
    String recipientEmail,
    String email,
    String password,
    String subject,
    String text,
  ) async {
    _sendingCount++;
    notifyListeners();
    try {
      final result = await getIt<EmailService>().sendEmailWithAttachment(
        file,
        email,
        password,
        subject,
        text,
        recipientEmail,
      );

      if (result) {
        Log log = Log(
          error: '',
          logContent: '$unitNumber.pdf sent to $recipientEmail',
          timeStamp: DateTime.now().toString(),
        );

        await HiveService.save(log.hashCode.toString(), log);
      } else {
        Log log = Log(
          error: 'Error',
          logContent: '$unitNumber.pdf not sent to $recipientEmail',
          timeStamp: DateTime.now().toString(),
        );

        await HiveService.save(log.hashCode.toString(), log);
      }
    } catch (e) {
      Log log = Log(
        error: 'Error',
        logContent: 'Error sending $unitNumber.pdf not sent to $recipientEmail',
        timeStamp: DateTime.now().toString(),
      );

      await HiveService.save(log.hashCode.toString(), log);
    } finally {
      _sendingCount--;
      notifyListeners();
    }
  }
}
