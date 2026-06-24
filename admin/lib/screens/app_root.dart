import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'dashboard_screen.dart';
import 'not_authorized_screen.dart';
import 'sign_in_screen.dart';

/// Auth + authorization gate. Signed-out → sign-in; signed-in non-admin →
/// not-authorized; signed-in admin → dashboard.
class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    return auth.when(
      loading: () => const _Loading(),
      error: (e, _) => _ErrorScaffold(message: e.toString()),
      data: (user) {
        if (user == null) return const SignInScreen();
        final admin = ref.watch(adminStatusProvider);
        return admin.when(
          loading: () => const _Loading(),
          error: (_, _) => const NotAuthorizedScreen(
            message: "We couldn't verify your admin access.",
          ),
          data: (isAdmin) =>
              isAdmin ? const DashboardScreen() : const NotAuthorizedScreen(),
        );
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(message)));
}
