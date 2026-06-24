import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';

import '../../../../components/components.dart';
import '../../../../core/core.dart';
import '../../../../core/extensions/date_time_formatter.dart';
import '../../hla.dart';

/// Admin: define and manage bookable collection slots (US-9).
@RoutePage(name: HlaAdminSlotsScreen.name)
class HlaAdminSlotsScreen extends ConsumerStatefulWidget {
  static const String path = "/hla_admin_slots";
  static const String name = "HlaAdminSlotsScreen";
  const HlaAdminSlotsScreen({super.key});

  @override
  ConsumerState<HlaAdminSlotsScreen> createState() =>
      _HlaAdminSlotsScreenState();
}

class _HlaAdminSlotsScreenState extends ConsumerState<HlaAdminSlotsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hlaAdminSlotsNotifierProviderImpl.notifier).getAllSlots();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final slotsAsync = ref.watch(hlaAdminSlotsNotifierProviderImpl);

    ref.listen(hlaAdminSlotsNotifierProviderImpl, (previous, next) {
      next.whenOrNull(
        error: (error, _) =>
            showCustomSnackBar(context: context, error: error),
      );
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSlotSheet(context),
        icon: const Icon(FluentIcons.add_24_regular),
        label: const Text("Add slot"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding16),
              child: CustomAppBar(pageTitle: "Appointment Slots"),
            ),
            Expanded(
              child: slotsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    (error is Failure) ? error.message : "Couldn't load slots",
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: theme.colorScheme.error),
                  ),
                ),
                data: (slots) {
                  if (slots.isEmpty) {
                    return Center(
                      child: Text(
                        "No slots yet — add one",
                        style: AppTextStyles.bodyLarge
                            .copyWith(color: AppColours.neutral50),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding16),
                    itemCount: slots.length,
                    separatorBuilder: (_, __) => const Gap(kPadding12),
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      return Container(
                        padding: const EdgeInsets.all(kPadding16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(kPadding16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    slot.dateTime
                                        .toLocal()
                                        .formatDateWithTime(context),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Gap(kPadding4),
                                  Text(
                                    "${slot.location} · ${slot.bookedCount}/${slot.capacity} booked",
                                    style: AppTextStyles.bodySmall
                                        .copyWith(color: AppColours.neutral50),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: slot.isActive,
                              onChanged: (value) {
                                ref
                                    .read(hlaAdminSlotsNotifierProviderImpl
                                        .notifier)
                                    .putSlot(
                                      slot: slot.copyWith(isActive: value),
                                    );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddSlotSheet(BuildContext context) async {
    final slot = await showModalBottomSheet<HlaAppointmentSlot>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddSlotSheet(),
    );
    if (slot != null) {
      await ref
          .read(hlaAdminSlotsNotifierProviderImpl.notifier)
          .putSlot(slot: slot);
    }
  }
}

class _AddSlotSheet extends StatefulWidget {
  const _AddSlotSheet();

  @override
  State<_AddSlotSheet> createState() => _AddSlotSheetState();
}

class _AddSlotSheetState extends State<_AddSlotSheet> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _capacityController =
      TextEditingController(text: "10");
  DateTime? _dateTime;
  String? _error;

  @override
  void dispose() {
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now,
    );
    if (date == null || !mounted) return;
    final TimeOfDay? time = await showTimePicker(
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
    final int capacity = int.tryParse(_capacityController.text.trim()) ?? 0;
    if (_dateTime == null) {
      setState(() => _error = "Pick a date and time");
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      setState(() => _error = "Location is required");
      return;
    }
    if (capacity <= 0) {
      setState(() => _error = "Capacity must be at least 1");
      return;
    }
    Navigator.pop(
      context,
      HlaAppointmentSlot(
        id: "",
        dateTime: _dateTime!,
        location: _locationController.text.trim(),
        capacity: capacity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppBottomSheet(
      title: "Add appointment slot",
      buttonLabel: "Save slot",
      onPressed: _submit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(kPadding12),
            onTap: _pickDateTime,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(kPadding16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(kPadding12),
              ),
              child: Text(
                _dateTime == null
                    ? "Pick date & time"
                    : _dateTime!.formatDateWithTime(context),
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
          const Gap(kPadding16),
          TextField(
            controller: _locationController,
            decoration: AppInputDecoration.inputDecoration(context)
                .copyWith(hintText: "Location"),
          ),
          const Gap(kPadding16),
          TextField(
            controller: _capacityController,
            keyboardType: TextInputType.number,
            decoration: AppInputDecoration.inputDecoration(context)
                .copyWith(hintText: "Capacity"),
          ),
          if (_error != null) ...[
            const Gap(kPadding8),
            Text(
              _error!,
              style: AppTextStyles.bodySmall
                  .copyWith(color: theme.colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}
