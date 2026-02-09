import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// Represents a single password generation strategy with configurable options.
///
/// Each strategy defines rules for generating passwords including length,
/// character types, and exclusion preferences.
class PasswordGenerationStrategy extends Equatable {
  final String id;
  final String name;
  final int length;
  final bool useNumbers;
  final bool useSpecialChars;
  final bool useUppercase;
  final bool useLowercase;
  final bool excludeAmbiguousChars;

  const PasswordGenerationStrategy({
    required this.id,
    required this.name,
    this.length = 16,
    this.useNumbers = true,
    this.useSpecialChars = true,
    this.useUppercase = true,
    this.useLowercase = true,
    this.excludeAmbiguousChars = false,
  });

  factory PasswordGenerationStrategy.create({
    required String name,
    int length = 16,
    bool useNumbers = true,
    bool useSpecialChars = true,
    bool useUppercase = true,
    bool useLowercase = true,
    bool excludeAmbiguousChars = false,
  }) {
    return PasswordGenerationStrategy(
      id: const Uuid().v7(),
      name: name,
      length: length,
      useNumbers: useNumbers,
      useSpecialChars: useSpecialChars,
      useUppercase: useUppercase,
      useLowercase: useLowercase,
      excludeAmbiguousChars: excludeAmbiguousChars,
    );
  }

  PasswordGenerationStrategy copyWith({
    String? name,
    int? length,
    bool? useNumbers,
    bool? useSpecialChars,
    bool? useUppercase,
    bool? useLowercase,
    bool? excludeAmbiguousChars,
  }) {
    return PasswordGenerationStrategy(
      id: id,
      name: name ?? this.name,
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
      'id': id,
      'name': name,
      'length': length,
      'useNumbers': useNumbers,
      'useSpecialChars': useSpecialChars,
      'useUppercase': useUppercase,
      'useLowercase': useLowercase,
      'excludeAmbiguousChars': excludeAmbiguousChars,
    };
  }

  factory PasswordGenerationStrategy.fromJson(Map<String, dynamic> json) {
    return PasswordGenerationStrategy(
      id: json['id'] as String? ?? const Uuid().v7(),
      name: json['name'] as String? ?? 'Custom',
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
    id,
    name,
    length,
    useNumbers,
    useSpecialChars,
    useUppercase,
    useLowercase,
    excludeAmbiguousChars,
  ];
}

/// Container for multiple password generation strategies.
///
/// Allows users to define and switch between different password
/// generation configurations (e.g., "Banking", "Social", "Personal").
class PasswordGenerationSettings extends Equatable {
  final List<PasswordGenerationStrategy> strategies;
  final String defaultStrategyId;

  const PasswordGenerationSettings({
    required this.strategies,
    required this.defaultStrategyId,
  });

  /// Migrates old settings format or creates default
  factory PasswordGenerationSettings.initial() {
    const defaultId = 'default-strategy';
    final defaultStrategy = const PasswordGenerationStrategy(
      id: defaultId,
      name: 'Default',
    );
    return PasswordGenerationSettings(
      strategies: [defaultStrategy],
      defaultStrategyId: defaultId,
    );
  }

  PasswordGenerationStrategy get defaultStrategy => strategies.firstWhere(
    (s) => s.id == defaultStrategyId,
    orElse: () => strategies.first,
  );

  PasswordGenerationSettings copyWith({
    List<PasswordGenerationStrategy>? strategies,
    String? defaultStrategyId,
  }) {
    return PasswordGenerationSettings(
      strategies: strategies ?? this.strategies,
      defaultStrategyId: defaultStrategyId ?? this.defaultStrategyId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strategies': strategies.map((s) => s.toJson()).toList(),
      'defaultStrategyId': defaultStrategyId,
    };
  }

  factory PasswordGenerationSettings.fromJson(Map<String, dynamic> json) {
    // Handle migration from old format where root fields existed
    if (json.containsKey('length') && !json.containsKey('strategies')) {
      final oldStrategy = PasswordGenerationStrategy.fromJson({
        'id': const Uuid().v7(),
        'name': 'Default',
        ...json,
      });
      return PasswordGenerationSettings(
        strategies: [oldStrategy],
        defaultStrategyId: oldStrategy.id,
      );
    }

    final strategiesList =
        (json['strategies'] as List<dynamic>?)
            ?.map(
              (e) => PasswordGenerationStrategy.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList() ??
        [];

    final defaultId = json['defaultStrategyId'] as String?;

    if (strategiesList.isEmpty) {
      return PasswordGenerationSettings.initial();
    }

    return PasswordGenerationSettings(
      strategies: strategiesList,
      defaultStrategyId:
          defaultId ??
          (strategiesList.isNotEmpty
              ? strategiesList.first.id
              : const Uuid().v7()),
    );
  }

  @override
  List<Object> get props => [strategies, defaultStrategyId];
}
