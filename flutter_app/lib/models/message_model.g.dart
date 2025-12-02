// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SingleMessageAdapter extends TypeAdapter<SingleMessage> {
  @override
  final int typeId = 0;

  @override
  SingleMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SingleMessage(
      id: fields[0] as String,
      text: fields[1] as String,
      isFromMe: fields[2] as bool,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SingleMessage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isFromMe)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SingleMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
