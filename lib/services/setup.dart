import 'package:get_it/get_it.dart';
import 'package:mail_box/services/email_service.dart';
import 'package:mail_box/services/file_picker_service.dart';

final GetIt getIt = GetIt.instance;

void registerServices() {
  getIt.registerLazySingleton(() => EmailService());
  getIt.registerLazySingleton(() => FilePickerService());
}
