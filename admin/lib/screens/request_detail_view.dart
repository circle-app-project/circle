import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/enums.dart';
import '../core/format.dart';
import '../core/theme.dart';
import '../models/hla_test_request.dart';
import '../providers/providers.dart';
import '../widgets/status_chip.dart';
import '../widgets/status_timeline.dart';

class RequestDetailView extends ConsumerStatefulWidget {
  const RequestDetailView({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<RequestDetailView> createState() => _RequestDetailViewState();
}

class _RequestDetailViewState extends ConsumerState<RequestDetailView> {
  final _noteController = TextEditingController();
  final _summaryController = TextEditingController();
  HlaTestStatus? _targetStatus;

  @override
  void dispose() {
    _noteController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  HlaTestRequest? _find(List<HlaTestRequest> items) {
    for (final r in items) {
      if (r.uid == widget.requestId) return r;
    }
    return null;
  }

  bool get _busy => ref.watch(adminActionsProvider).isLoading;

  void _toast(bool ok, String okMsg) {
    final messenger = ScaffoldMessenger.of(context);
    if (ok) {
      messenger.showSnackBar(SnackBar(content: Text(okMsg)));
    } else {
      final err = ref.read(adminActionsProvider).error;
      messenger.showSnackBar(
        SnackBar(content: Text(err is Object ? '$err' : 'Action failed')),
      );
    }
  }

  Future<void> _advance(HlaTestRequest request) async {
    final status = _targetStatus ?? request.status.next;
    if (status == null) return;
    final ok = await ref.read(adminActionsProvider.notifier).advanceStatus(
          request: request,
          status: status,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
    if (!mounted) return;
    if (ok) _noteController.clear();
    _toast(ok, 'Status updated to ${status.label}');
  }

  Future<void> _upload(HlaTestRequest request) async {
    final result = await FilePicker.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );
    final file = result?.files.single;
    if (file == null || file.bytes == null) return;
    final ok = await ref.read(adminActionsProvider.notifier).uploadResult(
          request: request,
          bytes: file.bytes!,
          fileName: file.name,
          contentType: _contentType(file.extension),
          summary: _summaryController.text.trim().isEmpty
              ? null
              : _summaryController.text.trim(),
        );
    if (!mounted) return;
    _toast(ok, 'Result uploaded');
  }

  String? _contentType(String? ext) {
    switch (ext?.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requests = ref.watch(requestsProvider);
    final request = requests.maybeWhen(
      data: _find,
      orElse: () => null,
    );

    if (request == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(kGap24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                request.patientName.isEmpty
                    ? 'Unknown patient'
                    : request.patientName,
                style: theme.textTheme.headlineSmall,
              ),
            ),
            StatusChip(request.status),
          ],
        ),
        const SizedBox(height: kGap8),
        if (request.appointmentDate != null)
          Text(
            'Appointment: ${formatDateTime(request.appointmentDate!)}'
            '${request.collectionLocation != null ? ' · ${request.collectionLocation}' : ''}',
            style: TextStyle(color: theme.colorScheme.outline),
          ),
        const SizedBox(height: kGap24),

        // ── Advance status ──
        _SectionCard(
          title: 'Advance status',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<HlaTestStatus>(
                initialValue: _targetStatus ?? request.status.next,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'New status'),
                items: [
                  for (final s in HlaTestStatus.values)
                    DropdownMenuItem(value: s, child: Text(s.label)),
                ],
                onChanged: (v) => setState(() => _targetStatus = v),
              ),
              const SizedBox(height: kGap12),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: kGap12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _busy ? null : () => _advance(request),
                  child: const Text('Update status'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: kGap16),

        // ── Sample panel ──
        _SectionCard(
          title: 'Sample panel (${request.subjects.length})',
          child: Column(
            children: [
              for (final s in request.subjects)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_outline),
                  title: Text(s.name),
                  subtitle: Text(
                    s.isSelf ? 'Patient' : s.relation.label,
                  ),
                  trailing: s.genotype != null
                      ? Text(s.genotype!.toUpperCase())
                      : null,
                ),
            ],
          ),
        ),
        const SizedBox(height: kGap16),

        // ── Results ──
        _SectionCard(
          title: 'Results',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (request.resultFileUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: kGap8),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined, size: 18),
                      const SizedBox(width: kGap8),
                      Expanded(
                        child: Text(request.resultFileName ?? 'Result document'),
                      ),
                      TextButton(
                        onPressed: () =>
                            launchUrl(Uri.parse(request.resultFileUrl!)),
                        child: const Text('Open'),
                      ),
                    ],
                  ),
                ),
              TextField(
                controller: _summaryController,
                maxLines: 3,
                decoration:
                    const InputDecoration(labelText: 'Result summary (optional)'),
              ),
              const SizedBox(height: kGap12),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _upload(request),
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload result document'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: kGap16),

        // ── Journey ──
        _SectionCard(
          title: 'Journey',
          child: StatusTimeline(
            currentStatus: request.status,
            history: request.statusHistory,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kGap16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: kGap12),
            child,
          ],
        ),
      ),
    );
  }
}
