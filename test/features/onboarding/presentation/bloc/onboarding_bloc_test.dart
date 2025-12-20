import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_bloc.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late OnboardingBloc bloc;
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    bloc = OnboardingBloc(mockDatabaseService);
  });

  tearDown(() {
    bloc.close();
  });

  group('OnboardingBloc', () {
    test('initial state is OnboardingInitial', () {
      expect(bloc.state, isA<OnboardingInitial>());
    });

    group('CompleteOnboarding', () {
      test('emits OnboardingSuccess and saves to database', () async {
        when(
          () => mockDatabaseService.write(any(), any(), any()),
        ).thenAnswer((_) async {});

        final states = <OnboardingState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(CompleteOnboarding());

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.length, 1);
        expect(states.last, isA<OnboardingSuccess>());

        verify(
          () => mockDatabaseService.write(
            'settings',
            'onboarding_complete',
            true,
          ),
        ).called(1);
      });
    });
  });
}
