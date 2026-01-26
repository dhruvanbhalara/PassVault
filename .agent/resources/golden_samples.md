# 🌟 PassVault Architecture: Golden Samples

Follow these patterns to ensure scalability, security, and 100% testability.

### 1. Pure Dart Domain Entity (lib/features/x/domain/entities)
```dart
// ❌ NO flutter imports here.
import 'package:equatable/equatable.dart';

class PasswordEntity extends Equatable {
  final String id;
  final String secret;
  
  const PasswordEntity({required this.id, required this.secret});

  @override
  List<Object?> get props => [id, secret];
}
```

### 2. Functional Repository Interface (lib/features/x/domain/repositories)
```dart
import 'package:passvault/core/error/failures.dart';
import 'package:passvault/features/x/domain/entities/password_entity.dart';

// Use a Result type (or Either) to handle errors across layers
abstract class PasswordRepository {
  Future<Result<List<PasswordEntity>>> getPasswords();
  Stream<List<PasswordEntity>> watchPasswords();
}
```

### 3. Exhaustive State Management (Bloc Event-State)
```dart
// 1. Immutable Events
sealed class PasswordEvent extends Equatable {
  const PasswordEvent();
  @override
  List<Object?> get props => [];
}

final class PasswordSubscriptionRequested extends PasswordEvent {}

// 2. Exhaustive States
sealed class PasswordState extends Equatable {
  const PasswordState();
  @override
  List<Object?> get props => [];
}

final class PasswordLoading extends PasswordState {}
final class PasswordFailure extends PasswordState {
  final Failure failure;
  const PasswordFailure(this.failure);
}
final class PasswordSuccess extends PasswordState {
  final List<PasswordEntity> passwords;
  const PasswordSuccess(this.passwords);
}

// In the UI:
return switch (state) {
  PasswordLoading() => const LoadingWidget(),
  PasswordFailure(failure: var f) => ErrorWidget(message: f.message),
  PasswordSuccess(passwords: var p) => PasswordList(items: p),
};
```

### 4. High-Performance Widget (lib/features/x/presentation/widgets)
```dart
class PasswordCard extends StatelessWidget {
  const PasswordCard({super.key, required this.password});
  final PasswordEntity password;

  @override
  Widget build(BuildContext context) {
    // 1. Semantic Color Access
    final colorScheme = context.theme.colorScheme;
    
    // 2. Optimization: Use RepaintBoundary for independent UI branches
    return RepaintBoundary(
      child: Card(
        // 3. Spacing via Theme tokens
        margin: EdgeInsets.all(AppSpacing.md),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(password.id),
        ),
      ),
    );
  }
}
```