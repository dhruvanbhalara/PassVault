import 'package:equatable/equatable.dart';

class PasswordGenerationSettings extends Equatable {
  final int length;
  final bool useNumbers;
  final bool useSpecialChars;
  final bool useUppercase;
  final bool useLowercase;
  final bool excludeAmbiguousChars;

  const PasswordGenerationSettings({
    this.length = 16,
    this.useNumbers = true,
    this.useSpecialChars = true,
    this.useUppercase = true,
    this.useLowercase = true,
    this.excludeAmbiguousChars = false,
  });

  PasswordGenerationSettings copyWith({
    int? length,
    bool? useNumbers,
    bool? useSpecialChars,
    bool? useUppercase,
    bool? useLowercase,
    bool? excludeAmbiguousChars,
  }) {
    return PasswordGenerationSettings(
      length: length ?? this.length,
      useNumbers: useNumbers ?? this.useNumbers,
      useSpecialChars: useSpecialChars ?? this.useSpecialChars,
      useUppercase: useUppercase ?? this.useUppercase,
      useLowercase: useLowercase ?? this.useLowercase,
      excludeAmbiguousChars:
          excludeAmbiguousChars ?? this.excludeAmbiguousChars,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'useNumbers': useNumbers,
      'useSpecialChars': useSpecialChars,
      'useUppercase': useUppercase,
      'useLowercase': useLowercase,
      'excludeAmbiguousChars': excludeAmbiguousChars,
    };
  }

  factory PasswordGenerationSettings.fromJson(Map<String, dynamic> json) {
    return PasswordGenerationSettings(
      length: json['length'] as int? ?? 16,
      useNumbers: json['useNumbers'] as bool? ?? true,
      useSpecialChars: json['useSpecialChars'] as bool? ?? true,
      useUppercase: json['useUppercase'] as bool? ?? true,
      useLowercase: json['useLowercase'] as bool? ?? true,
      excludeAmbiguousChars: json['excludeAmbiguousChars'] as bool? ?? false,
    );
  }

  @override
  List<Object> get props => [
    length,
    useNumbers,
    useSpecialChars,
    useUppercase,
    useLowercase,
    excludeAmbiguousChars,
  ];
}
