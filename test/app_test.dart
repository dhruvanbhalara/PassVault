import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/app.dart';
import 'package:passvault/config/routes/app_router.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';

class MockThemeBloc extends Mock implements ThemeBloc {}

class MockAppRouter extends Mock implements AppRouter {}

void main() {
  late MockThemeBloc mockThemeBloc;
  late MockAppRouter mockAppRouter;

  setUpAll(() {
    mockThemeBloc = MockThemeBloc();
    mockAppRouter = MockAppRouter();
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<ThemeBloc>()) {
      getIt.registerFactory<ThemeBloc>(() => mockThemeBloc);
    }
    if (!getIt.isRegistered<AppRouter>()) {
      getIt.registerFactory<AppRouter>(() => mockAppRouter);
    }

    when(() => mockThemeBloc.state).thenReturn(
      const ThemeLoaded(themeType: ThemeType.light, themeMode: ThemeMode.light),
    );
    when(() => mockThemeBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockThemeBloc.close()).thenAnswer((_) async {});

    final mockGoRouter = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Scaffold()),
      ],
    );
    when(() => mockAppRouter.config).thenReturn(mockGoRouter);
  });

  testWidgets('renders PassVaultApp', (tester) async {
    await tester.pumpWidget(const PassVaultApp());
    expect(find.byType(PassVaultApp), findsOneWidget);
  });
}
