import 'package:get_it/get_it.dart';
import 'package:mail_box/services/email_service.dart';
import 'package:mail_box/services/file_picker_service.dart';
import 'package:mail_box/services/hive_service.dart';
import 'package:mail_box/services/logs_service.dart';

final GetIt getIt = GetIt.instance;

void registerServices() {
  getIt.registerLazySingleton(() => FilePickerService());
  getIt.registerLazySingleton(() => EmailService());
  getIt.registerLazySingleton(() => LogsService());
  getIt.registerLazySingleton(() => HiveService());
}
