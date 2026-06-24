import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../components/components.dart';
import '../../../../core/core.dart';
import '../../hla.dart';

/// Admin: manage a single request — advance status with a note, view the
/// subject panel, and upload results (US-8, US-10).
@RoutePage(name: HlaAdminDetailScreen.name)
class HlaAdminDetailScreen extends ConsumerStatefulWidget {
  static const String path = "/hla_admin_detail";
  static const String name = "HlaAdminDetailScreen";

  const HlaAdminDetailScreen({
    super.key,
    @PathParam('requestId') required this.requestId,
  });

  final String requestId;

  @override
  ConsumerState<HlaAdminDetailScreen> createState() =>
      _HlaAdminDetailScreenState();
}

class _HlaAdminDetailScreenState extends ConsumerState<HlaAdminDetailScreen> {
  HlaTestStatus? _targetStatus;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  HlaTestRequest? _find(List<HlaTestRequest> requests) {
    for (final r in requests) {
      if (r.uid == widget.requestId) return r;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final adminAsync = ref.watch(hlaAdminNotifierProviderImpl);

    ref.listen(hlaAdminNotifierProviderImpl, (previous, next) {
      next.whenOrNull(
        error: (error, _) =>
            showCustomSnackBar(context: context, error: error),
      );
    });

    final HlaTestRequest? request = _find(adminAsync.value ?? const []);
    final bool isBusy = adminAsync.isLoading;

    return Scaffold(
      body: SafeArea(
        child: request == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: kPadding16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(pageTitle: "Request"),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            request.patientName.isEmpty
                                ? "Unknown patient"
                                : request.patientName,
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        HlaStatusChip(status: request.status),
                      ],
                    ),
                    const Gap(kPadding24),

                    // ── Advance status ──
                    Text("Advance status", style: theme.textTheme.titleMedium),
                    const Gap(kPadding8),
                    DropdownButtonFormField<HlaTestStatus>(
                      initialValue: _targetStatus ?? request.status.next,
                      isExpanded: true,
                      decoration: AppInputDecoration.inputDecoration(context)
                          .copyWith(hintText: "New status"),
                      items: [
                        for (final status in HlaTestStatus.values)
                          DropdownMenuItem(
                            value: status,
                            child: Text(status.label),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => _targetStatus = value),
                    ),
                    const Gap(kPadding12),
                    TextField(
                      controller: _noteController,
                      decoration: AppInputDecoration.inputDecoration(context)
                          .copyWith(hintText: "Note (optional)"),
                    ),
                    const Gap(kPadding12),
                    AppButton(
                      label: "Update status",
                      isLoading: isBusy,
                      onPressed: () {
                        final status = _targetStatus ?? request.status.next;
                        if (status == null) return;
                        ref
                            .read(hlaAdminNotifierProviderImpl.notifier)
                            .advanceStatus(
                              request: request,
                              status: status,
                              note: _noteController.text.trim().isEmpty
                                  ? null
                                  : _noteController.text.trim(),
                            );
                        _noteController.clear();
                      },
                    ),
                    const Gap(kPadding32),

                    // ── Subjects ──
                    Text("Sample panel", style: theme.textTheme.titleMedium),
                    const Gap(kPadding8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: request.subjects.length,
                      separatorBuilder: (_, __) => const Gap(kPadding8),
                      itemBuilder: (context, index) =>
                          HlaSubjectTile(subject: request.subjects[index]),
                    ),
                    const Gap(kPadding32),

                    // ── Results ──
                    Text("Results", style: theme.textTheme.titleMedium),
                    const Gap(kPadding8),
                    if (request.resultFileName != null)
                      Text(
                        "Uploaded: ${request.resultFileName}",
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColours.green60),
                      ),
                    const Gap(kPadding8),
                    TextField(
                      controller: _summaryController,
                      maxLines: 3,
                      decoration: AppInputDecoration.inputDecoration(context)
                          .copyWith(hintText: "Result summary (optional)"),
                    ),
                    const Gap(kPadding12),
                    AppButton(
                      label: "Upload result document",
                      buttonType: ButtonType.outline,
                      isLoading: isBusy,
                      onPressed: () => _pickAndUpload(request),
                    ),
                    const Gap(kPadding64),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _pickAndUpload(HlaTestRequest request) async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ["pdf", "jpg", "jpeg", "png"],
    );
    final path = result?.files.single.path;
    final fileName = result?.files.single.name;
    if (path == null || fileName == null) return;

    await ref.read(hlaAdminNotifierProviderImpl.notifier).uploadResult(
          request: request,
          filePath: path,
          fileName: fileName,
          summary: _summaryController.text.trim().isEmpty
              ? null
              : _summaryController.text.trim(),
        );
  }
}
