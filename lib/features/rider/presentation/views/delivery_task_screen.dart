import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';
import 'package:wigo_flutter/shared/widgets/pagination_widget.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../models/delivery_model.dart';
import '../../models/delivery_task_state.dart';
import '../../viewmodels/delivery_task_viewmodel.dart';
import '../widgets/delivery_card.dart';
import '../widgets/delivery_detail_card.dart';
import 'delivery_detail_screen.dart';

class DeliveryTaskScreen extends HookConsumerWidget {
  const DeliveryTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deliveryTaskProvider);
    final notifier = ref.read(deliveryTaskProvider.notifier);
    final isWeb = context.isWeb;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(deliveryTaskProvider.notifier).init();
      });
      return null;
    }, const []);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 30), (_) {
        if (context.mounted) {
          notifier.fetchOrders(silent: true);
          notifier.refreshCounts();
        }
      });
      return timer.cancel;
    }, const []);

    ref.listen(deliveryTaskProvider.select((s) => s.actionError), (_, error) {
      if (error != null && context.mounted) {
        showErrorBanner(error, context);
        notifier.clearActionError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildHeader(context, state, notifier, isWeb),
          Expanded(
            child: state.deliveries.when(
              data: (deliveries) => isWeb
                  ? _buildWebLayout(context, deliveries, state, notifier)
                  : _buildMobileLayout(context, deliveries, state, notifier),
              loading: () => const Center(
                child: SpinKitDualRing(color: AppColors.primaryDarkGreen),
              ),
              error: (e, _) => _buildErrorView(
                context,
                notifier,
                e.toString().contains(
                      "Delivery agent profile not found or not active",
                    )
                    ? "Please complete your vehicle profile first!"
                    : e.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(
    BuildContext context,
    List<Delivery> deliveries,
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    if (deliveries.isEmpty) {
      return _buildEmptyState(isWeb: true, filter: state.selectedFilter);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    itemCount: deliveries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final delivery = deliveries[i];
                      final isSelected =
                          state.selectedDelivery?.id == delivery.id;
                      return DeliveryCard(
                        delivery: delivery,
                        isSelected: isSelected,
                        onDetailsTap: () => notifier.setSelectedDelivery(
                          isSelected ? null : delivery,
                        ),
                      );
                    },
                  ),
                ),
                if (state.selectedDelivery != null) ...[
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 380,
                    child: DeliveryDetailCard(
                      delivery: state.selectedDelivery!,
                      isActionLoading: state.isActionLoading,
                      onAction: (actionType) => _handleAction(
                        context,
                        state.selectedDelivery!,
                        actionType,
                        notifier,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 15),
          _buildPagination(state, notifier),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    List<Delivery> deliveries,
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    if (deliveries.isEmpty) {
      return _buildEmptyState(isWeb: false, filter: state.selectedFilter);
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                notifier.fetchOrders(),
                notifier.refreshCounts(),
              ]);
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: deliveries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                return DeliveryCard(
                  delivery: deliveries[i],
                  onDetailsTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DeliveryDetailScreen(delivery: deliveries[i]),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 15),
        _buildPagination(state, notifier),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPagination(
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Container(
        color: AppColors.backgroundWhite,
        child: PaginationWidget(
          labelPerPage: 'Orders per page',
          rowsPerPage: state.rowsPerPage,
          onSelected: (rows) => notifier.setRowsPerPage(rows),
          totalPages: state.totalPages,
          currentPage: state.currentPage + 1,
          isDeliveries: true,
          count: state.totalDeliveriesCount,
          onPressedStart: state.pagination.hasPrev
              ? () => notifier.goToPage(0)
              : null,
          onPressedBack: state.pagination.hasPrev
              ? () => notifier.goToPage(state.currentPage - 1)
              : null,
          onPressedForward: state.pagination.hasNext
              ? () => notifier.goToPage(state.currentPage + 1)
              : null,
          onPressedEnd: state.pagination.hasNext
              ? () => notifier.goToPage(state.totalPages - 1)
              : null,
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    Delivery delivery,
    DeliveryActionType actionType,
    DeliveryTaskViewModel notifier,
  ) async {
    switch (actionType) {
      case DeliveryActionType.select:
        final success = await notifier.selectOrder(delivery.id);
        if (success && context.mounted) {
          _showSuccess(context, 'Order accepted! Head to the pickup location.');
        }

      case DeliveryActionType.markPickedUp:
        final success = await notifier.updateOrderStatus(
          delivery.id,
          'picked_up',
        );
        if (success && context.mounted) {
          _showSuccess(context, 'Order marked as picked up.');
        }

      case DeliveryActionType.markInTransit:
        final success = await notifier.updateOrderStatus(
          delivery.id,
          'in_transit',
        );
        if (success && context.mounted) {
          _showSuccess(context, 'Order is now in transit.');
        }

      case DeliveryActionType.confirmDelivery:
        final (success, amount) = await notifier.confirmDelivery(delivery.id);
        if (success && context.mounted) {
          final amountText = amount != null
              ? ' ₦${amount.toStringAsFixed(2)} has been credited to your wallet.'
              : '';
          _showSuccess(context, 'Delivery confirmed!$amountText');
        }
    }
  }

  void _showSuccess(BuildContext context, String message) {
    showSuccessBanner(message, context);
    // ScaffoldMessenger.of(context)
    //   ..hideCurrentSnackBar()
    //   ..showSnackBar(
    //     SnackBar(
    //       content: Text(message),
    //       backgroundColor: Colors.green.shade700,
    //       behavior: SnackBarBehavior.floating,
    //     ),
    //   );
  }

  Widget _buildErrorView(
    BuildContext context,
    DeliveryTaskViewModel notifier,
    String message,
  ) {
    return Container(
      color: AppColors.backgroundWhite,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppAssets.icons.recentDeliveries.svg(height: 61, width: 61),
            const SizedBox(height: 20),
            Text(
              'Failed to load deliveries',
              style: GoogleFonts.hind(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.hind(
                  fontSize: 16,
                  color: AppColors.textBodyText,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // if (message.contains(
            //   'Delivery agent profile not found or not active',
            // ))
            TextButton(
              onPressed: notifier.fetchOrders,
              child: Text(
                'Retry',
                style: GoogleFonts.hind(
                  fontSize: 20,
                  color: AppColors.primaryDarkGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required bool isWeb,
    required DeliveryFilter filter,
  }) {
    if (filter == DeliveryFilter.all || filter == DeliveryFilter.newRequest) {
      if (isWeb) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildNoDeliveriesCard(
                  isWeb: true,
                  title: 'No Active Deliveries yet',
                  body:
                      'Your recent deliveries will show up here once you '
                      'start accepting orders. Stay ready, opportunities are '
                      'always around the corner!',
                  icon: AppAssets.icons.recentDeliveries.svg(
                    height: 61,
                    width: 61,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _buildNoDeliveriesCard(
                  isWeb: true,
                  isNoDT: true,
                  title: 'Nothing Here Yet!',
                  body:
                      'No delivery tasks at the moment. Stay online and '
                      "we'll notify you when something comes up.",
                  icon: AppAssets.icons.noDeliveryTask.svg(
                    height: 61,
                    width: 61,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            _buildNoDeliveriesCard(
              isWeb: false,
              title: 'No Active Deliveries yet',
              body:
                  'Your recent deliveries will show up here once you start '
                  'accepting orders.',
              icon: AppAssets.icons.recentDeliveries.svg(height: 61, width: 61),
            ),
            const SizedBox(height: 7),
            _buildNoDeliveriesCard(
              isWeb: false,
              isNoDT: true,
              title: 'Nothing Here Yet!',
              body:
                  'No delivery tasks at the moment. Stay online and '
                  "we'll notify you when something comes up.",
              icon: AppAssets.icons.noDeliveryTask.svg(height: 61, width: 61),
            ),
          ],
        ),
      );
    }

    final (title, body) =
        _emptyStateCopy[filter] ??
        ('Nothing here', 'No orders for this filter.');

    return Center(
      child: _buildNoDeliveriesCard(
        isWeb: isWeb,
        title: title,
        body: body,
        icon: AppAssets.icons.recentDeliveries.svg(height: 61, width: 61),
      ),
    );
  }

  static const _emptyStateCopy = <DeliveryFilter, (String, String)>{
    DeliveryFilter.ongoing: (
      'No Ongoing Deliveries',
      'You have no active deliveries right now.',
    ),
    DeliveryFilter.completed: (
      'No Completed Deliveries',
      'Your completed deliveries will appear here.',
    ),
    DeliveryFilter.cancelled: (
      'No Cancelled Orders',
      'You have no cancelled orders.',
    ),
  };

  Widget _buildNoDeliveriesCard({
    required bool isWeb,
    required String title,
    required String body,
    required Widget icon,
    bool isNoDT = false,
  }) {
    return Card(
      color: AppColors.backgroundWhite,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 70.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb
                    ? (isNoDT ? 150.0 : 300.0)
                    : (isNoDT ? 30.0 : 40.0),
              ),
              child: Text(
                body,
                textAlign: TextAlign.center,
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.textBodyText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
    bool isWeb,
  ) {
    return isWeb
        ? _buildWebHeader(state, notifier)
        : _buildMobileHeader(context, state, notifier);
  }

  Widget _buildWebHeader(
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text(
            'Manage your delivery tasks',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 68,
              color: AppColors.backgroundWhite,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: DeliveryFilter.values.map((filter) {
                    final isSelected = state.selectedFilter == filter;
                    return GestureDetector(
                      onTap: () => notifier.setFilter(filter),
                      child: Container(
                        color: isSelected
                            ? AppColors.clampBgColor
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              filter.displayName,
                              style: GoogleFonts.hind(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColors.textDarkDarkerGreen,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                color: AppColors.containerGreen,
                                borderRadius: BorderRadius.circular(21),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${state.deliveryCounts[filter] ?? 0}',
                                style: GoogleFonts.hind(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader(
    BuildContext context,
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Manage your delivery tasks',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textBlackGrey,
              ),
            ),
          ),
          _buildMobileFilterButton(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildMobileFilterButton(
    BuildContext context,
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    return PopupMenuButton<DeliveryFilter>(
      color: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      menuPadding: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter',
            style: GoogleFonts.hind(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(width: 5),
          AppAssets.icons.mobileFilter.svg(),
        ],
      ),
      onSelected: notifier.setFilter,
      itemBuilder: (_) => DeliveryFilter.values
          .map(
            (filter) => PopupMenuItem<DeliveryFilter>(
              value: filter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  '${filter.displayName} (${state.deliveryCounts[filter] ?? 0})',
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColors.textBodyText,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
