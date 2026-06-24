import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../models/hla_appointment_slot.dart';
import '../providers/providers.dart';

class SlotsView extends ConsumerWidget {
  const SlotsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slots = ref.watch(slotsProvider);
    final busy = ref.watch(adminActionsProvider).isLoading;

    return Padding(
      padding: const EdgeInsets.all(kGap24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: busy ? null : () => _addSlot(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add slot'),
            ),
          ),
          const SizedBox(height: kGap16),
          Expanded(
            child: slots.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Could not load slots\n\n$e',
                    style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('No slots yet — add one'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: kGap8),
                  itemBuilder: (context, i) =>
                      _SlotTile(slot: items[i], busy: busy),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addSlot(BuildContext context, WidgetRef ref) async {
    final slot = await showDialog<HlaAppointmentSlot>(
      context: context,
      builder: (_) => const _AddSlotDialog(),
    );
    if (slot == null) return;
    final ok = await ref.read(adminActionsProvider.notifier).putSlot(slot);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Slot added' : 'Could not add slot')),
    );
  }
}

class _SlotTile extends ConsumerWidget {
  const _SlotTile({required this.slot, required this.busy});

  final HlaAppointmentSlot slot;
  final bool busy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        title: Text(formatDateTime(slot.dateTime)),
        subtitle: Text(
          '${slot.location} · ${slot.bookedCount}/${slot.capacity} booked',
          style: TextStyle(color: scheme.outline),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(slot.isActive ? 'Active' : 'Hidden',
                style: TextStyle(color: scheme.outline, fontSize: 12)),
            Switch(
              value: slot.isActive,
              onChanged: busy
                  ? null
                  : (v) => ref
                      .read(adminActionsProvider.notifier)
                      .putSlot(slot.copyWith(isActive: v)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddSlotDialog extends StatefulWidget {
  const _AddSlotDialog();

  @override
  State<_AddSlotDialog> createState() => _AddSlotDialogState();
}

class _AddSlotDialogState extends State<_AddSlotDialog> {
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController(text: '10');
  DateTime? _dateTime;
  String? _error;

  @override
  void dispose() {
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      _dateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submit() {
    final capacity = int.tryParse(_capacityController.text.trim()) ?? 0;
    if (_dateTime == null) {
      setState(() => _error = 'Pick a date and time');
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      setState(() => _error = 'Location is required');
      return;
    }
    if (capacity <= 0) {
      setState(() => _error = 'Capacity must be at least 1');
      return;
    }
    Navigator.pop(
      context,
      HlaAppointmentSlot(
        id: '',
        dateTime: _dateTime!,
        location: _locationController.text.trim(),
        capacity: capacity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add appointment slot'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton.icon(
              onPressed: _pickDateTime,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(
                _dateTime == null
                    ? 'Pick date & time'
                    : formatDateTime(_dateTime!),
              ),
            ),
            const SizedBox(height: kGap12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: kGap12),
            TextField(
              controller: _capacityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Capacity'),
            ),
            if (_error != null) ...[
              const SizedBox(height: kGap8),
              Text(_error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save slot')),
      ],
    );
  }
}
