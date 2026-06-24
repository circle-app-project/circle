import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/enums.dart';
import '../core/format.dart';
import '../core/theme.dart';
import '../models/hla_test_request.dart';
import '../providers/providers.dart';
import '../widgets/status_chip.dart';
import 'request_detail_view.dart';

/// Master/detail: filterable request list on the left, selected request on the
/// right.
class RequestsView extends ConsumerWidget {
  const RequestsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedRequestIdProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 380,
          child: Column(
            children: const [
              _FilterBar(),
              Divider(height: 1),
              Expanded(child: _RequestsList()),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: selectedId == null
              ? const _EmptyDetail()
              : RequestDetailView(key: ValueKey(selectedId), requestId: selectedId),
        ),
      ],
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statusFilterProvider);
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: kGap12),
        children: [
          _chip(ref, label: 'All', selected: filter == null, value: null),
          for (final s in HlaTestStatus.values)
            _chip(ref, label: s.label, selected: filter == s, value: s),
        ],
      ),
    );
  }

  Widget _chip(WidgetRef ref,
      {required String label,
      required bool selected,
      required HlaTestStatus? value}) {
    return Padding(
      padding: const EdgeInsets.only(right: kGap8),
      child: Center(
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) =>
              ref.read(statusFilterProvider.notifier).set(value),
        ),
      ),
    );
  }
}

class _RequestsList extends ConsumerWidget {
  const _RequestsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestsProvider);
    final selectedId = ref.watch(selectedRequestIdProvider);

    return requests.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ListError(message: _message(e)),
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('No requests'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(kGap12),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: kGap8),
          itemBuilder: (context, i) {
            final HlaTestRequest r = items[i];
            return _RequestTile(
              request: r,
              selected: r.uid == selectedId,
              onTap: () =>
                  ref.read(selectedRequestIdProvider.notifier).select(r.uid),
            );
          },
        );
      },
    );
  }

  String _message(Object e) =>
      'Could not load requests. Check that the Firestore rules are deployed '
      'and your account is in hla_admins.\n\n$e';
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({
    required this.request,
    required this.selected,
    required this.onTap,
  });

  final HlaTestRequest request;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(kGap12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.patientName.isEmpty
                          ? 'Unknown patient'
                          : request.patientName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kGap8),
              StatusChip(request.status),
              const SizedBox(height: kGap8),
              Text(
                request.appointmentDate != null
                    ? formatDateTime(request.appointmentDate!)
                    : 'No appointment booked',
                style: TextStyle(fontSize: 12, color: scheme.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListError extends StatelessWidget {
  const _ListError({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kGap24),
      child: Center(
        child: Text(message,
            style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}

class _EmptyDetail extends StatelessWidget {
  const _EmptyDetail();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Select a request to manage it',
        style: TextStyle(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }
}
