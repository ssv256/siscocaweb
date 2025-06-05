import 'package:hive/hive.dart';

@HiveType(typeId: 0)
enum NotificationType {
  @HiveField(0)
  health,
  @HiveField(1)
  medication,
  @HiveField(2)
  appointment,
  @HiveField(3)
  news,
  @HiveField(4)
  task,
  @HiveField(5)
  routine
}