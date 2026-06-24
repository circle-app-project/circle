import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';

import '../../../components/components.dart';
import '../../../core/core.dart';
import '../../auth/auth.dart';
import '../hla.dart';

/// Lets the patient build the sample panel, accept the data-transfer consent,
/// and submit a new request (US-1, US-2). The collection appointment is booked
/// afterwards from the status screen.
@RoutePage(name: HlaRequestFormScreen.name)
class HlaRequestFormScreen extends ConsumerStatefulWidget {
  static const String path = "/hla_request";
  static const String name = "HlaRequestFormScreen";
  const HlaRequestFormScreen({super.key});

  @override
  ConsumerState<HlaRequestFormScreen> createState() =>
      _HlaRequestFormScreenState();
}

class _HlaRequestFormScreenState extends ConsumerState<HlaRequestFormScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AppUser user =
          ref.read(userNotifierProviderImpl).value ?? AppUser.empty;
      ref
          .read(hlaRequestFormNotifierProviderImpl.notifier)
          .reset(selfName: user.getDisplayName());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppUser user =
        ref.watch(userNotifierProviderImpl).value ?? AppUser.empty;

    // React to submission: navigate on success, surface errors via snackbar.
    ref.listen(hlaRequestFormNotifierProviderImpl, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          showCustomSnackBar(context: context, error: error);
        },
        data: (state) {
          final request = state.submittedRequest;
          if (request != null) {
            context.router
                .replaceNamed("${HlaStatusScreen.path}/${request.uid}");
          }
        },
      );
    });

    final formAsync = ref.watch(hlaRequestFormNotifierProviderImpl);
    final HlaRequestFormState formState =
        formAsync.value ?? const HlaRequestFormState();
    final bool isSubmitting = formAsync.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kPadding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(pageTitle: "Request HLA Test"),
              Text("Sample panel", style: theme.textTheme.titleMedium),
              const Gap(kPadding4),
              Text(
                "List everyone whose sample will be collected and "
                "cross-matched with yours — relatives and potential donors.",
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColours.neutral50),
              ),
              const Gap(kPadding16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: formState.subjects.length,
                separatorBuilder: (_, __) => const Gap(kPadding8),
                itemBuilder: (context, index) {
                  return HlaSubjectTile(
                    subject: formState.subjects[index],
                    onDelete: () => ref
                        .read(hlaRequestFormNotifierProviderImpl.notifier)
                        .removeSubject(index),
                  );
                },
              ),
              const Gap(kPadding12),
              AppButton(
                label: "Add subject",
                icon: FluentIcons.add_24_regular,
                buttonType: ButtonType.outline,
                onPressed: () async {
                  final subject = await showAddSubjectSheet(context);
                  if (subject != null) {
                    ref
                        .read(hlaRequestFormNotifierProviderImpl.notifier)
                        .addSubject(subject);
                  }
                },
              ),
              const Gap(kPadding32),
              _ConsentTile(
                value: formState.consentAccepted,
                onChanged: (value) => ref
                    .read(hlaRequestFormNotifierProviderImpl.notifier)
                    .setConsent(value),
              ),
              const Gap(kPadding32),
              AppButton(
                label: "Submit request",
                isLoading: isSubmitting,
                onPressed: (!formState.consentAccepted || user.isEmpty)
                    ? () {
                        showCustomSnackBar(
                          context: context,
                          message:
                              "Please accept the consent to continue",
                          mode: SnackBarMode.notification,
                        );
                      }
                    : () {
                        ref
                            .read(hlaRequestFormNotifierProviderImpl.notifier)
                            .submit(user: user);
                      },
              ),
              const Gap(kPadding64),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(kPadding16),
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(kPadding16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(kPadding16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
            ),
            const Gap(kPadding8),
            Expanded(
              child: Text(
                "I understand my sample and panel details will be sent to a "
                "partner lab (including labs abroad) for HLA typing, and I "
                "consent to this processing of my medical data.",
                style: AppTextStyles.bodyMedium
                    .copyWith(color: theme.colorScheme.onSurface, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
