import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/components.dart';
import '../../../core/core.dart';
import '../hla.dart';

/// Shows the uploaded result document and the optional staff summary (US-5).
/// Falls back to a clear empty state when results are not yet uploaded.
@RoutePage(name: HlaResultsScreen.name)
class HlaResultsScreen extends ConsumerWidget {
  static const String path = "/hla_results";
  static const String name = "HlaResultsScreen";

  const HlaResultsScreen({
    super.key,
    @PathParam('requestId') required this.requestId,
  });

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final requestAsync = ref.watch(hlaRequestStreamProvider(requestId));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kPadding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(pageTitle: "Results"),
              requestAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: kPadding64),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.only(top: kPadding64),
                  child: Text(
                    (error is Failure) ? error.message : "Couldn't load results",
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: theme.colorScheme.error),
                  ),
                ),
                data: (request) {
                  if (request == null || !request.hasResults) {
                    return const _NotReadyState();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (request.resultSummary != null &&
                          request.resultSummary!.isNotEmpty) ...[
                        Text("Summary", style: theme.textTheme.titleMedium),
                        const Gap(kPadding8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(kPadding16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(kPadding16),
                          ),
                          child: Text(
                            request.resultSummary!,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(height: 1.5),
                          ),
                        ),
                        const Gap(kPadding24),
                      ],
                      Text("Document", style: theme.textTheme.titleMedium),
                      const Gap(kPadding8),
                      _ResultFileCard(
                        fileName: request.resultFileName ?? "Result document",
                        onOpen: () => _openFile(context, request.resultFileUrl!),
                      ),
                      const Gap(kPadding64),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openFile(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    final bool ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      showCustomSnackBar(
        context: context,
        message: "Couldn't open the document",
        mode: SnackBarMode.error,
      );
    }
  }
}

class _ResultFileCard extends StatelessWidget {
  const _ResultFileCard({required this.fileName, required this.onOpen});

  final String fileName;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(kPadding16),
      onTap: onOpen,
      child: Container(
        padding: const EdgeInsets.all(kPadding16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(kPadding16),
        ),
        child: Row(
          children: [
            Icon(
              FluentIcons.document_pdf_24_regular,
              color: theme.colorScheme.primary,
            ),
            const Gap(kPadding12),
            Expanded(
              child: Text(
                fileName,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(
              FluentIcons.open_24_regular,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotReadyState extends StatelessWidget {
  const _NotReadyState();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: kPadding64),
      child: Center(
        child: Column(
          children: [
            const Icon(
              FluentIcons.hourglass_24_regular,
              size: 48,
              color: AppColours.neutral60,
            ),
            const Gap(kPadding16),
            Text(
              "Your results aren't uploaded yet",
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: AppColours.neutral50),
            ),
            const Gap(kPadding4),
            Text(
              "We'll let you know as soon as they're ready.",
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColours.neutral50),
            ),
          ],
        ),
      ),
    );
  }
}
