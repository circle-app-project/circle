import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../providers/providers.dart';
import 'requests_view.dart';
import 'slots_view.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _index = 0;

  static const _titles = ['Requests', 'Appointment slots'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = ref.watch(authStateProvider).value?.email ?? '';

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: kGap16),
              child: Icon(Icons.biotech_outlined,
                  color: theme.colorScheme.primary),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.inbox_outlined),
                selectedIcon: Icon(Icons.inbox),
                label: Text('Requests'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.event_outlined),
                selectedIcon: Icon(Icons.event),
                label: Text('Slots'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                _TopBar(title: _titles[_index], email: email),
                const Divider(height: 1),
                Expanded(
                  child: IndexedStack(
                    index: _index,
                    children: const [RequestsView(), SlotsView()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar({required this.title, required this.email});

  final String title;
  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kGap24, vertical: kGap16),
      child: Row(
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const Spacer(),
          Text(email, style: theme.textTheme.bodyMedium),
          const SizedBox(width: kGap12),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => ref.read(authServiceProvider).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
