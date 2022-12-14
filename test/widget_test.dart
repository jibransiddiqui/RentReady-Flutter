// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/business_logic/business_logic.dart';
import 'package:taskapp/business_logic/cubits/cubits.dart';
import 'package:taskapp/data/data.dart';
import 'package:taskapp/presentation/presentation.dart';
import 'package:taskapp/rentready.dart';

class MockAccountsCubit extends MockCubit<AccountsState>
    implements AccountsCubit {}

class MockAccountsRepository extends Mock implements AccountsRepository {}

void main() {
  group('AccountsApp', () {
    late AccountsRepository accountsRepository;

    setUp(() {
      accountsRepository = MockAccountsRepository();
    });

    testWidgets('renders AccountAppView', (tester) async {
      await tester.pumpWidget(
        RendReadyApp(accountsRepository: accountsRepository),
      );
      expect(find.byType(RendReadyAppView), findsOneWidget);
    });
  });
  group('AccountAppView', () {
    late AccountsCubit accountCubit;
    late AccountsRepository accountRepository;

    setUp(() {
      accountCubit = MockAccountsCubit();
      accountRepository = AccountsRepository();
    });

    testWidgets('renders HomeScreen', (tester) async {
      when(() => accountCubit.state)
          .thenReturn(const AccountsState(status: AccountsStatus.initial));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: accountRepository,
          child: BlocProvider.value(
            value: accountCubit,
            child: const RendReadyAppView(),
          ),
        ),
      );
      expect(find.byType(HomeScreen), findsOneWidget);
    });
    testWidgets('has correct primary color', (tester) async {
      const color = Colors.blue;
      when(() => accountCubit.state)
          .thenReturn(const AccountsState(status: AccountsStatus.initial));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: accountRepository,
          child: BlocProvider.value(
            value: accountCubit,
            child: const RendReadyAppView(),
          ),
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.primaryColor, color);
    });
  });
}
