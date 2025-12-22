import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/core/theme/bloc/theme_cubit.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late MockDatabaseService mockDatabaseService;
  late ThemeCubit themeCubit;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    // Default read behavior
    when(
      () => mockDatabaseService.read(
        any(),
        any(),
        defaultValue: any(named: 'defaultValue'),
      ),
    ).thenReturn(ThemeType.system.index);
    when(
      () => mockDatabaseService.write(any(), any(), any()),
    ).thenAnswer((_) async {});
  });

  group('ThemeCubit', () {
    test('initial state is ThemeType.system', () {
      themeCubit = ThemeCubit(mockDatabaseService);
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
      build: () => ThemeCubit(mockDatabaseService),
      act: (cubit) => cubit.setTheme(ThemeType.light),
      expect: () => [
        const ThemeState(
          themeType: ThemeType.light,
          themeMode: ThemeMode.light,
        ),
      ],
      verify: (_) {
        verify(
          () => mockDatabaseService.write(
            'settings',
            'theme_type',
            ThemeType.light.index,
          ),
        ).called(1);
      },
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeType.dark] when setTheme(ThemeType.dark) is called',
      build: () => ThemeCubit(mockDatabaseService),
      act: (cubit) => cubit.setTheme(ThemeType.dark),
      expect: () => [
        const ThemeState(themeType: ThemeType.dark, themeMode: ThemeMode.dark),
      ],
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeType.amoled] and ThemeMode.dark when setTheme(ThemeType.amoled) is called',
      build: () => ThemeCubit(mockDatabaseService),
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
