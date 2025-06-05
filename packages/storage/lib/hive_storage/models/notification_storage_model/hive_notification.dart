import 'package:hive/hive.dart';
import 'package:domain/models/models.dart' as domain;

part 'hive_notification.g.dart';

@HiveType(typeId: 0)
class HiveNotification extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String typeName;

  @HiveField(5)
  Map<String, dynamic>? additionalData;

  @HiveField(6)
  String? imageUrl;

  @HiveField(7)
  DateTime? scheduledFor;

  @HiveField(8)
  bool isRead;

  HiveNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.typeName,
    this.additionalData,
    this.imageUrl,
    this.scheduledFor,
    this.isRead = false,
  });

  factory HiveNotification.fromDomain(domain.Notification notification) {
    return HiveNotification(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      timestamp: notification.timestamp,
      typeName: notification.type.toString(),
      additionalData: notification.additionalData,
      imageUrl: notification.imageUrl,
      scheduledFor: notification.scheduledFor,
    );
  }

  domain.Notification toDomain() {
    return domain.Notification(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      type: domain.NotificationType.values.firstWhere(
        (e) => e.toString() == typeName,
      ),
      additionalData: additionalData,
      imageUrl: imageUrl,
      scheduledFor: scheduledFor,
    );
  }
}
