import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

class PasswordFixtures {
  static final google = PasswordEntry(
    id: 'google-1',
    appName: 'Google',
    username: 'user@gmail.com',
    password: 'secure-password-1',
    lastUpdated: DateTime(2024, 1, 1),
  );

  static final facebook = PasswordEntry(
    id: 'facebook-1',
    appName: 'Facebook',
    username: 'user@fb.com',
    password: 'secure-password-2',
    lastUpdated: DateTime(2024, 1, 2),
    favorite: true,
  );

  static final netflix = PasswordEntry(
    id: 'netflix-1',
    appName: 'Netflix',
    username: 'user@netflix.com',
    password: 'secure-password-3',
    lastUpdated: DateTime(2024, 1, 3),
    folder: 'Entertainment',
  );

  static List<PasswordEntry> get list => [google, facebook, netflix];
}
