import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

part 'password_entry_model.g.dart';

@HiveType(typeId: 0)
class PasswordEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String appName;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final DateTime lastUpdated;

  PasswordEntryModel({
    required this.id,
    required this.appName,
    required this.username,
    required this.password,
    required this.lastUpdated,
  });

  factory PasswordEntryModel.fromEntity(PasswordEntry entity) {
    return PasswordEntryModel(
      id: entity.id,
      appName: entity.appName,
      username: entity.username,
      password: entity.password,
      lastUpdated: entity.lastUpdated,
    );
  }

  PasswordEntry toEntity() {
    return PasswordEntry(
      id: id,
      appName: appName,
      username: username,
      password: password,
      lastUpdated: lastUpdated,
    );
  }
}
