import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart' as res;
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/domain/usecases/get_theme_usecase.dart';
import 'package:passvault/features/settings/domain/usecases/set_theme_usecase.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';

class MockGetThemeUseCase extends Mock implements GetThemeUseCase {}

class MockSetThemeUseCase extends Mock implements SetThemeUseCase {}

void main() {
  late MockGetThemeUseCase mockGetThemeUseCase;
  late MockSetThemeUseCase mockSetThemeUseCase;

  setUpAll(() {
    registerFallbackValue(ThemeType.system);
  });

  setUp(() {
    mockGetThemeUseCase = MockGetThemeUseCase();
    mockSetThemeUseCase = MockSetThemeUseCase();

    // Default behaviors
    when(
      () => mockGetThemeUseCase.call(),
    ).thenReturn(const res.Success(ThemeType.system));
    when(
      () => mockSetThemeUseCase.call(any()),
    ).thenAnswer((_) async => const res.Success(null));
  });

  group('$ThemeBloc', () {
    test('initial state is ThemeType.system', () {
      final bloc = ThemeBloc(mockGetThemeUseCase, mockSetThemeUseCase);
      expect(
        bloc.state,
        const ThemeState(
          themeType: ThemeType.system,
          themeMode: ThemeMode.system,
        ),
      );
    });

    blocTest<ThemeBloc, ThemeState>(
      'emits correct theme when ThemeInitialized is added (called in constructor)',
      build: () {
        when(
          () => mockGetThemeUseCase.call(),
        ).thenReturn(const res.Success(ThemeType.light));
        return ThemeBloc(mockGetThemeUseCase, mockSetThemeUseCase);
      },
      expect: () => [
        const ThemeState(
          themeType: ThemeType.light,
          themeMode: ThemeMode.light,
        ),
      ],
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits [ThemeType.light] when ThemeChanged(ThemeType.light) is added',
      build: () => ThemeBloc(mockGetThemeUseCase, mockSetThemeUseCase),
      act: (bloc) => bloc.add(const ThemeChanged(ThemeType.light)),
      skip: 1, // Skip initialization event emission
      expect: () => [
        const ThemeState(
          themeType: ThemeType.light,
          themeMode: ThemeMode.light,
        ),
      ],
      verify: (_) {
        verify(() => mockSetThemeUseCase.call(ThemeType.light)).called(1);
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits [ThemeType.dark] when ThemeChanged(ThemeType.dark) is added',
      build: () => ThemeBloc(mockGetThemeUseCase, mockSetThemeUseCase),
      act: (bloc) => bloc.add(const ThemeChanged(ThemeType.dark)),
      skip: 1,
      expect: () => [
        const ThemeState(themeType: ThemeType.dark, themeMode: ThemeMode.dark),
      ],
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits [ThemeType.amoled] and ThemeMode.dark when ThemeChanged(ThemeType.amoled) is added',
      build: () => ThemeBloc(mockGetThemeUseCase, mockSetThemeUseCase),
      act: (bloc) => bloc.add(const ThemeChanged(ThemeType.amoled)),
      skip: 1,
      expect: () => [
        const ThemeState(
          themeType: ThemeType.amoled,
          themeMode: ThemeMode.dark,
        ),
      ],
    );
  });
}
