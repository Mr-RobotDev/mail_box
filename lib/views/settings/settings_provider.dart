import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/common/ui_helpers.dart';
import 'package:mail_box/services/file_picker_service.dart';
import 'package:mail_box/services/setup.dart';
import 'package:mail_box/services/shared_prefs.dart';

class SettingsProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController folderPathController = TextEditingController();

  String saveString = 'Save';
  bool showPassword = false;

  void toggleShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  final List<String> keys = [
    'EMAIL',
    'PASSWORD',
    'SUBJECT',
    'BODY',
    'FOLDER_PATH',
  ];

  SettingsProvider() {
    emailController.text = SharedPrefs.getString(keys[0]);
    passwordController.text = SharedPrefs.getString(keys[1]);
    subjectController.text = SharedPrefs.getString(keys[2]);
    bodyController.text = SharedPrefs.getString(keys[3]);
    folderPathController.text = SharedPrefs.getString(keys[4]);
  }

  Future<void> save(BuildContext context) async {
    await SharedPrefs.setString(keys[0], emailController.text);
    await SharedPrefs.setString(keys[1], passwordController.text);
    await SharedPrefs.setString(keys[2], subjectController.text);
    await SharedPrefs.setString(keys[3], bodyController.text);
    await SharedPrefs.setString(keys[4], folderPathController.text);

    saveString = 'Saved';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    saveString = 'Save';
    notifyListeners();
  }

  Future<void> fetchFolderPath(BuildContext context) async {
    getIt<FilePickerService>().getFolderPath().then((value) {
      if (value != null) {
        folderPathController.text = value;
        notifyListeners();
      } else {
        infoBox(context, 'Error', 'Please select a folder path');
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    subjectController.dispose();
    bodyController.dispose();
    folderPathController.dispose();
    super.dispose();
  }
}
