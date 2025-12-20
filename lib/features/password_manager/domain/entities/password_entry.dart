import 'package:equatable/equatable.dart';

class PasswordEntry extends Equatable {
  final String id;
  final String appName;
  final String username; // Email/Mobile/Username
  final String password;
  final DateTime lastUpdated;

  const PasswordEntry({
    required this.id,
    required this.appName,
    required this.username,
    required this.password,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appName': appName,
      'username': username,
      'password': password,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory PasswordEntry.fromJson(Map<String, dynamic> json) {
    return PasswordEntry(
      id: json['id'],
      appName: json['appName'],
      username: json['username'],
      password: json['password'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  @override
  List<Object?> get props => [id, appName, username, password, lastUpdated];
}
