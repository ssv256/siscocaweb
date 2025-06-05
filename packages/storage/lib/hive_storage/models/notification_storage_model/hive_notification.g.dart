// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveNotificationAdapter extends TypeAdapter<HiveNotification> {
  @override
  final int typeId = 0;

  @override
  HiveNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveNotification(
      id: fields[0] as String,
      title: fields[1] as String,
      body: fields[2] as String,
      timestamp: fields[3] as DateTime,
      typeName: fields[4] as String,
      additionalData: (fields[5] as Map?)?.cast<String, dynamic>(),
      imageUrl: fields[6] as String?,
      scheduledFor: fields[7] as DateTime?,
      isRead: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveNotification obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.typeName)
      ..writeByte(5)
      ..write(obj.additionalData)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.scheduledFor)
      ..writeByte(8)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
