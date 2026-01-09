import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart' as res;
import 'package:passvault/features/settings/domain/usecases/get_theme_usecase.dart';
import 'package:passvault/features/settings/domain/usecases/set_theme_usecase.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_cubit.dart';

class MockGetThemeUseCase extends Mock implements GetThemeUseCase {}

class MockSetThemeUseCase extends Mock implements SetThemeUseCase {}

void main() {
  late MockGetThemeUseCase mockGetThemeUseCase;
  late MockSetThemeUseCase mockSetThemeUseCase;
  late ThemeCubit themeCubit;

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

  group('ThemeCubit', () {
    test('initial state is ThemeType.system', () {
      themeCubit = ThemeCubit(mockGetThemeUseCase, mockSetThemeUseCase);
      expect(
        themeCubit.state,
        const ThemeState(
          themeType: ThemeType.system,
          themeMode: ThemeMode.system,
        ),
      );
    });

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeType.light] when setTheme(ThemeType.light) is called',
      build: () => ThemeCubit(mockGetThemeUseCase, mockSetThemeUseCase),
      act: (cubit) => cubit.setTheme(ThemeType.light),
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

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeType.dark] when setTheme(ThemeType.dark) is called',
      build: () => ThemeCubit(mockGetThemeUseCase, mockSetThemeUseCase),
      act: (cubit) => cubit.setTheme(ThemeType.dark),
      expect: () => [
        const ThemeState(themeType: ThemeType.dark, themeMode: ThemeMode.dark),
      ],
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeType.amoled] and ThemeMode.dark when setTheme(ThemeType.amoled) is called',
      build: () => ThemeCubit(mockGetThemeUseCase, mockSetThemeUseCase),
      act: (cubit) => cubit.setTheme(ThemeType.amoled),
      expect: () => [
        const ThemeState(
          themeType: ThemeType.amoled,
          themeMode: ThemeMode.dark,
        ),
      ],
    );
  });
}
