import 'package:equatable/equatable.dart';

class PasswordEntry extends Equatable {
  final String id;
  final String appName;
  final String username; // Email/Mobile/Username
  final String password;
  final DateTime lastUpdated;
  final String? url; // Website URL (for browser imports)
  final String? notes; // Additional notes/comments
  final String? folder; // Category/folder for organization
  final bool favorite; // Starred/favorite flag

  const PasswordEntry({
    required this.id,
    required this.appName,
    required this.username,
    required this.password,
    required this.lastUpdated,
    this.url,
    this.notes,
    this.folder,
    this.favorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appName': appName,
      'username': username,
      'password': password,
      'lastUpdated': lastUpdated.toIso8601String(),
      'url': url,
      'notes': notes,
      'folder': folder,
      'favorite': favorite,
    };
  }

  factory PasswordEntry.fromJson(Map<String, dynamic> json) {
    return PasswordEntry(
      id: json['id'],
      appName: json['appName'],
      username: json['username'],
      password: json['password'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      url: json['url'] as String?,
      notes: json['notes'] as String?,
      folder: json['folder'] as String?,
      favorite: json['favorite'] as bool? ?? false,
    );
  }

  PasswordEntry copyWith({
    String? id,
    String? appName,
    String? username,
    String? password,
    DateTime? lastUpdated,
    String? url,
    String? notes,
    String? folder,
    bool? favorite,
  }) {
    return PasswordEntry(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      username: username ?? this.username,
      password: password ?? this.password,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      folder: folder ?? this.folder,
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    appName,
    username,
    password,
    lastUpdated,
    url,
    notes,
    folder,
    favorite,
  ];
}
