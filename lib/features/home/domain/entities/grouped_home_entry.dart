import 'package:equatable/equatable.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

class GroupedHomeEntry extends Equatable {
  final String canonicalKey;
  final String displayName;
  final List<PasswordEntry> members;

  const GroupedHomeEntry({
    required this.canonicalKey,
    required this.displayName,
    required this.members,
  });

  int get accountCount => members.length;

  @override
  List<Object?> get props => [canonicalKey, displayName, members];
}
