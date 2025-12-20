// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasswordEntryModelAdapter extends TypeAdapter<PasswordEntryModel> {
  @override
  final typeId = 0;

  @override
  PasswordEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PasswordEntryModel(
      id: fields[0] as String,
      appName: fields[1] as String,
      username: fields[2] as String,
      password: fields[3] as String,
      lastUpdated: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PasswordEntryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.appName)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
