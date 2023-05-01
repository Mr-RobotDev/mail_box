import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/common/ui_helpers.dart';
import 'package:mail_box/models/user.dart';
import 'package:mail_box/services/email_service.dart';
import 'package:mail_box/services/file_picker_service.dart';
import 'package:mail_box/services/logs_service.dart';
import 'package:mail_box/services/setup/setup.dart';
import 'package:mail_box/services/shared_prefs.dart';

class HomeProvider extends ChangeNotifier {
  TextEditingController unitNumberController = TextEditingController();
  FocusNode unitNumberFocusNode = FocusNode();

  int _currentFile = 0;
  int get currentFile => _currentFile;
  set currentFile(int value) {
    _currentFile = value;
    notifyListeners();
  }

  Timer? focusRequestTimer;

  void startFocusRequestTimer() {
    focusRequestTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (files.isNotEmpty) {
          if (!unitNumberFocusNode.hasFocus) {
            unitNumberFocusNode.requestFocus();
          }
        }
      },
    );
  }

  // Load pdf files from file picker
  List<File> files = [];
  void pickFiles(BuildContext context) {
    getIt<FilePickerService>().getFiles(true).then((resultFiles) {
      if (resultFiles != null) {
        files = resultFiles;
        notifyListeners();
        infoBox(context, 'Success', 'Files loaded successfully');
      } else {
        infoBox(context, 'Error', 'No files selected');
      }
    });
  }

  // Load users from csv file
  List<User> users = [];
  void pickUsers(BuildContext context) {
    getIt<FilePickerService>().getFiles(false).then((files) {
      if (files != null) {
        getIt<FilePickerService>()
            .readLocalCsv(files.first.path)
            .then((loadedUsers) {
          if (loadedUsers != null) {
            users = loadedUsers;
            notifyListeners();
            infoBox(context, 'Success', 'Users loaded successfully');
          } else {
            infoBox(context, 'Error', 'No file selected');
          }
        }).catchError((_) {
          infoBox(context, 'Error', 'No file selected');
        });
      } else {
        infoBox(context, 'Error', 'No file selected');
      }
    }).catchError((_) {
      infoBox(context, 'Error', 'No file selected');
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
      infoBox(context, 'Error',
          'Please fill in all required settings in the settings view');
      return;
    }

    if (users.isEmpty) {
      infoBox(context, 'Error', 'Please select a users file first');
      return;
    }

    final recipientEmail = users
        .firstWhere(
          (element) => element.unitNumber == unitNumber,
          orElse: () => User(email: '', unitNumber: ''),
        )
        .email;

    if (recipientEmail.isNotEmpty) {
      emailFile(context, recipientEmail, email, password, subject, body);
    }

    moveFile(context, folderPath, unitNumber);
  }

  void moveFile(BuildContext context, String folderPath, String unitNumber) {
    getIt<FilePickerService>()
        .moveFileToFolder(
      files[currentFile],
      folderPath,
      unitNumber,
    )
        .then((value) {
      getIt<LogsService>().add(
        'Moved file ${files[currentFile].path} to $folderPath/$unitNumber',
      );

      unitNumberController.clear();

      files.removeAt(currentFile);
      notifyListeners();
    }).catchError((_) {
      getIt<LogsService>().add(
        'Error moving file ${files[currentFile].path} to $folderPath/$unitNumber',
      );
    });
  }

  void emailFile(
    BuildContext context,
    String recipientEmail,
    String email,
    String password,
    String subject,
    String text,
  ) {
    getIt<EmailService>()
        .sendEmailWithAttachment(
      files[currentFile],
      email,
      password,
      subject,
      text,
      recipientEmail,
    )
        .then((value) {
      getIt<LogsService>().add(
        'Sent file ${files[currentFile].path} to $recipientEmail',
      );
    }).catchError((_) {
      getIt<LogsService>().add(
        'Error sending file ${files[currentFile].path} to $recipientEmail',
      );
    });
  }
}
