import 'package:hive/hive.dart';

part 'log.g.dart';

@HiveType(typeId: 0, adapterName: 'LogAdapter')
class Log {
  @HiveField(0)
  String error;

  @HiveField(1)
  String logContent;

  @HiveField(2)
  String timeStamp;

  Log({
    required this.error,
    required this.logContent,
    required this.timeStamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Log &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          logContent == other.logContent &&
          timeStamp == other.timeStamp);

  @override
  int get hashCode => error.hashCode ^ logContent.hashCode ^ timeStamp.hashCode;
}
