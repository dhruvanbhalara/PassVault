import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/widgets/password_form_widgets.dart';
import 'package:passvault/l10n/app_localizations.dart';

void main() {
  late GlobalKey<FormState> formKey;
  late TextEditingController appNameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  setUp(() {
    formKey = GlobalKey<FormState>();
    appNameController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  });

  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('$PasswordFormFields', () {
    testWidgets('renders all fields and labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          PasswordFormFields(
            formKey: formKey,
            appNameController: appNameController,
            usernameController: usernameController,
            passwordController: passwordController,
            obscurePassword: true,
            onToggleVisibility: () {},
            strength: 0,
            onGenerate: () {},
          ),
        ),
      );

      expect(find.text('APP NAME'), findsOneWidget);
      expect(find.text('USERNAME'), findsOneWidget);
      expect(find.text('PASSWORD'), findsOneWidget);
      expect(
        find.text('Generate'),
        findsOneWidget,
      ); // Note: Generate button label is NOT in AppTextField but OutlinedButton.icon
    });

    testWidgets('shows strength indicator when password is not empty', (
      WidgetTester tester,
    ) async {
      passwordController.text = 'password123';
      await tester.pumpWidget(
        wrapWithMaterial(
          PasswordFormFields(
            formKey: formKey,
            appNameController: appNameController,
            usernameController: usernameController,
            passwordController: passwordController,
            obscurePassword: true,
            onToggleVisibility: () {},
            strength: 0.5,
            onGenerate: () {},
          ),
        ),
      );

      expect(find.byType(PasswordStrengthIndicator), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });
  });
}
