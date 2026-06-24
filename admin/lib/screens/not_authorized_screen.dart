import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../providers/providers.dart';

/// Shown when a signed-in user is not a provisioned admin (no `hla_admins`
/// document). Offers a way back out.
class NotAuthorizedScreen extends ConsumerWidget {
  const NotAuthorizedScreen({
    super.key,
    this.message = "This account doesn't have admin access.",
  });

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final email = ref.watch(authStateProvider).value?.email ?? '';

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(kGap32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline,
                      size: 40, color: theme.colorScheme.error),
                  const SizedBox(height: kGap16),
                  Text('Access denied', style: theme.textTheme.titleLarge),
                  const SizedBox(height: kGap8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (email.isNotEmpty) ...[
                    const SizedBox(height: kGap4),
                    Text(
                      'Signed in as $email',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ],
                  const SizedBox(height: kGap24),
                  OutlinedButton.icon(
                    onPressed: () => ref.read(authServiceProvider).signOut(),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
