import 'package:equatable/equatable.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

/// Events for [StrategyPreviewBloc] to generate password previews.
sealed class StrategyPreviewEvent extends Equatable {
  const StrategyPreviewEvent();

  @override
  List<Object> get props => [];
}

/// Triggers password preview generation with the given strategy settings.
///
/// The [settings] define the password generation rules including length,
/// character sets, and exclusion preferences.
final class GeneratePreview extends StrategyPreviewEvent {
  /// The strategy settings to use for password generation.
  final PasswordGenerationStrategy settings;

  const GeneratePreview(this.settings);

  @override
  List<Object> get props => [settings];
}
