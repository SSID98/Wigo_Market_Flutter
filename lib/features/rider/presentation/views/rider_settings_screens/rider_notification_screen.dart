import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/notification_body.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/screens/notification_viewmodel.dart';
import '../../../../../shared/widgets/custom_banner.dart';
import '../../../../../shared/widgets/custom_loading_overlay.dart';
import '../../../models/rider_notification_state.dart';

class RiderNotificationScreen extends HookConsumerWidget {
  const RiderNotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = context.isWeb;
    final state = ref.watch(notificationViewModelProvider);
    final vm = ref.read(notificationViewModelProvider.notifier);

    useEffect(() {
      Future.microtask(() {
        if (!context.mounted) return;
        vm.fetchPreferencesIfNeeded(context);
      });
      return null;
    }, const []);

    if (state.loadStatus == NotificationLoadStatus.loading) {
      return Scaffold(
        backgroundColor: isWeb
            ? AppColors.backgroundLight
            : AppColors.backgroundWhite,
        body: Center(child: SpinKitDualRing(color: AppColors.primaryDarkGreen)),
      );
    }

    if (state.loadStatus == NotificationLoadStatus.error) {
      return Scaffold(
        backgroundColor: isWeb
            ? AppColors.backgroundLight
            : AppColors.backgroundWhite,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 56,
                color: AppColors.textIconGrey,
              ),
              const SizedBox(height: 16),
              Text(
                'Could not reach the server.\nCheck your connection and try again.',
                textAlign: TextAlign.center,
                style: GoogleFonts.hind(
                  fontSize: 15,
                  color: AppColors.textBlackGrey,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Retry',
                onPressed: () => vm.fetchPreferencesIfNeeded(context),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 45,
                width: 180,
              ),
            ],
          ),
        ),
      );
    }

    final notificationBody = _NotificationBody(showSaveInside: isWeb);

    return Scaffold(
      backgroundColor: isWeb
          ? AppColors.backgroundLight
          : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child: isWeb
            ? SizedBox(
                height: 393,
                child: Card(
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                  shadowColor: Colors.white70.withValues(alpha: 0.06),
                  color: AppColors.backgroundWhite,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: notificationBody,
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              child: AppAssets.icons.arrowLeft.svg(),
                              onTap: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "Back",
                              style: GoogleFonts.hind(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBlackGrey,
                              ),
                            ),
                          ],
                        ),
                        if (!state.isEditMode)
                          _buildCustomButton(
                            isEdit: true,
                            onPressed: vm.enterEditMode,
                          )
                        else if (state.hasData)
                          _buildCustomButton(
                            isEdit: false,
                            onPressed: vm.exitEditMode,
                          ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 30),
                  notificationBody,
                  if (state.isEditMode)
                    CustomButton(
                      text: 'Save',
                      onPressed: () => _handleSave(context, ref, vm),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 45,
                      width: double.infinity,
                    ),
                  const SizedBox(height: 15),
                ],
              ),
      ),
    );
  }

  Widget _buildCustomButton({
    required bool isEdit,
    required VoidCallback onPressed,
  }) {
    return CustomButton(
      text: isEdit ? "Edit" : "Cancel Edit",
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 41.31,
      width: 130,
      prefixIcon: isEdit
          ? AppAssets.icons.pencilEdit.svg()
          : Icon(Icons.close_rounded, color: AppColors.textRed),
      onPressed: onPressed,
      borderRadius: 4,
    );
  }

  Future<void> _handleSave(
    BuildContext context,
    WidgetRef ref,
    NotificationViewModel vm,
  ) async {
    final ok = await runWithOverlay(
      context,
      () async => await vm.updatePreferences(),
      spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen),
    );
    if (!context.mounted) return;

    if (ok) {
      showSuccessBanner('Notification preferences updated', context);
    } else {
      final freshState = ref.read(notificationViewModelProvider);
      showErrorBanner(freshState.errorMessage ?? 'An error occurred', context);
    }
  }
}

class _NotificationBody extends ConsumerWidget {
  final bool showSaveInside;

  const _NotificationBody({required this.showSaveInside});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationViewModelProvider);
    final vm = ref.read(notificationViewModelProvider.notifier);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notification Preference",
                  style: GoogleFonts.hind(
                    fontSize: context.isWeb ? 24 : 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                if (showSaveInside) ...[
                  const SizedBox(height: 20),
                  if (!state.isEditMode)
                    CustomButton(
                      text: 'Edit',
                      onPressed: vm.enterEditMode,
                      prefixIcon: AppAssets.icons.pencilEdit.svg(),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 41,
                      width: 153,
                    )
                  else
                    Row(
                      children: [
                        if (state.hasData) ...[
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.textRed,
                            ),
                            icon: const Icon(Icons.close_rounded, size: 18),
                            label: Text(
                              'Cancel',
                              style: GoogleFonts.hind(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: vm.exitEditMode,
                          ),
                          const SizedBox(width: 8),
                        ],
                        CustomButton(
                          text: 'Save',
                          onPressed: () async {
                            final ok = await runWithOverlay(
                              context,
                              () async => await vm.updatePreferences(),
                              spinner: SpinKitDualRing(
                                color: AppColors.primaryDarkGreen,
                              ),
                            );
                            if (!context.mounted) return;
                            if (ok) {
                              showSuccessBanner('Preferences updated', context);
                            } else {
                              final freshState = ref.read(
                                notificationViewModelProvider,
                              );
                              showErrorBanner(
                                freshState.errorMessage ?? 'Error',
                                context,
                              );
                            }
                          },
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 41,
                          width: 153,
                        ),
                      ],
                    ),
                ],
              ],
            ),
          ),
          NotificationBody(),
        ],
      ),
    );
  }
}
