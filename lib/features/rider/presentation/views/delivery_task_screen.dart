import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/pagination_widget.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../models/delivery.dart';
import '../../models/delivery_task_state.dart';
import '../../viewmodels/delivery_task_viewmodel.dart';
import '../widgets/delivery_card.dart';
import '../widgets/delivery_detail_card.dart';

class DeliveryTaskScreen extends ConsumerStatefulWidget {
  const DeliveryTaskScreen({super.key});

  @override
  ConsumerState<DeliveryTaskScreen> createState() => _DeliveryTaskScreenState();
}

class _DeliveryTaskScreenState extends ConsumerState<DeliveryTaskScreen> {
  Delivery? selectedDelivery;

  @override
  Widget build(BuildContext context) {
    final deliveryTaskState = ref.watch(deliveryTaskProvider);
    final deliveryTaskNotifier = ref.read(deliveryTaskProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildHeader(deliveryTaskState, deliveryTaskNotifier, isWeb),
          Expanded(
            child: deliveryTaskState.deliveries.when(
              data: (deliveries) {
                if (isWeb) {
                  return _buildWebLayout(
                    deliveries,
                    isWeb,
                    deliveryTaskState,
                    deliveryTaskNotifier,
                  );
                } else {
                  return _buildMobileLayout(
                    deliveries,
                    isWeb,
                    deliveryTaskState,
                    deliveryTaskNotifier,
                  );
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(
    List<Delivery> deliveries,
    bool isWeb,
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    final totalPages = (state.totalDeliveriesCount / 3).ceil();
    final currentPage = state.currentPage + 1;

    if (deliveries.isEmpty && state.selectedFilter == DeliveryFilter.all) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            if (isWeb) const SizedBox(height: 20),
            if (isWeb)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildNoDeliveriesView(
                        isWeb,
                        "No Active Deliveries yet",
                        'Your recent deliveries will show up here once you start accepting orders. Stay ready, opportunities are always around the corner!',
                        AppAssets.icons.recentDeliveries.svg(
                          height: 61,
                          width: 61,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: _buildNoDeliveriesView(
                        isWeb,
                        isNoDT: true,
                        'Nothing Here Yet!',
                        'No delivery tasks at the moment. Stay online and we’ll notify you when something comes up',
                        AppAssets.icons.noDeliveryTask.svg(
                          height: 61,
                          width: 61,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    final deliveriesListView = ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: deliveries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        return DeliveryCard(
          delivery: deliveries[i],
          onDetailsTap: () {
            setState(() {
              selectedDelivery = deliveries[i];
            });
          },
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                Expanded(child: deliveriesListView),
                if (selectedDelivery != null) ...[
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 380,
                    child: DeliveryDetailCard(delivery: selectedDelivery!),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0),
            child: Container(
              color: AppColors.backgroundWhite,
              child: PaginationWidget(
                totalPages: totalPages,
                currentPage: currentPage,
                isDeliveries: true,
                count: state.totalDeliveriesCount,
                onPressedBack:
                    state.currentPage > 0
                        ? () => notifier.goToPage(state.currentPage - 1)
                        : null,
                onPressedEnd:
                    state.currentPage < totalPages - 1
                        ? () => notifier.goToPage(totalPages - 1)
                        : null,
                onPressedForward:
                    state.currentPage < totalPages - 1
                        ? () => notifier.goToPage(state.currentPage + 1)
                        : null,
                onPressedStart:
                    state.currentPage > 0 ? () => notifier.goToPage(0) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    List<Delivery> deliveries,
    bool isWeb,
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    final totalPages = (state.totalDeliveriesCount / 3).ceil();
    final currentPage = state.currentPage + 1;

    if (deliveries.isEmpty && state.selectedFilter == DeliveryFilter.all) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            _buildNoDeliveriesView(
              isWeb,
              "No Active Deliveries yet",
              'Your recent deliveries will show up here once you start accepting orders. Stay ready, opportunities are always around the corner!',
              AppAssets.icons.recentDeliveries.svg(height: 61, width: 61),
            ),
            const SizedBox(height: 7),
            _buildNoDeliveriesView(
              isWeb,
              isNoDT: true,
              "Nothing Here Yet!",
              'No delivery tasks at the moment. Stay online and we’ll notify you when something comes up',
              AppAssets.icons.noDeliveryTask.svg(height: 61, width: 61),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: deliveries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              return DeliveryCard(
                delivery: deliveries[i],
                onDetailsTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => Scaffold(
                            backgroundColor: AppColors.backgroundLight,
                            body: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: AppAssets.icons.arrowLeft.svg(),
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                    ),
                                    Text(
                                      "Back",
                                      style: GoogleFonts.hind(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlackGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: DeliveryDetailCard(
                                    delivery: deliveries[i],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Container(
            color: AppColors.backgroundWhite,
            child: PaginationWidget(
              totalPages: totalPages,
              currentPage: currentPage,
              isDeliveries: true,
              count: state.totalDeliveriesCount,
              onPressedBack:
                  state.currentPage > 0
                      ? () => notifier.goToPage(state.currentPage - 1)
                      : null,
              onPressedEnd:
                  state.currentPage < totalPages - 1
                      ? () => notifier.goToPage(totalPages - 1)
                      : null,
              onPressedForward:
                  state.currentPage < totalPages - 1
                      ? () => notifier.goToPage(state.currentPage + 1)
                      : null,
              onPressedStart:
                  state.currentPage > 0 ? () => notifier.goToPage(0) : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
    bool isWeb,
  ) {
    if (isWeb) {
      return _buildWebHeader(state, notifier);
    } else {
      return _buildMobileHeader(state, notifier);
    }
  }

  Widget _buildWebHeader(
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    final filters = DeliveryFilter.values;
    final filterNames = {
      DeliveryFilter.all: "All",
      DeliveryFilter.newRequest: "New Request",
      DeliveryFilter.ongoing: "Ongoing",
      DeliveryFilter.completed: "Completed",
      DeliveryFilter.cancelled: "Cancelled",
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text(
            "Manage your delivery tasks",
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
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              height: 68,
              color: AppColors.backgroundWhite,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(filters.length, (index) {
                    final filter = filters[index];
                    final isSelected = state.selectedFilter == filter;
                    return GestureDetector(
                      onTap: () => notifier.setFilter(filter),
                      child: Container(
                        color:
                            isSelected
                                ? AppColors.clampBgColor
                                : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Text(
                              filterNames[filter]!,
                              style: GoogleFonts.hind(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: AppColors.textDarkDarkerGreen,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                color: AppColors.containerGreen,
                                borderRadius: BorderRadius.circular(21),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                "${state.deliveryCounts[filter] ?? 0}",
                                style: GoogleFonts.hind(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader(
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Manage your delivery tasks",
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.textBlackGrey,
            ),
          ),
          _buildMobileFilterButton(state, notifier),
        ],
      ),
    );
  }

  Widget _buildMobileFilterButton(
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
  ) {
    final filterNames = {
      DeliveryFilter.all: "All",
      DeliveryFilter.newRequest: "New Request",
      DeliveryFilter.ongoing: "Ongoing",
      DeliveryFilter.completed: "Completed",
      DeliveryFilter.cancelled: "Cancelled",
    };

    return PopupMenuButton<DeliveryFilter>(
      color: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      menuPadding: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      icon: Row(
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
          SvgPicture.asset(AppAssets.icons.mobileFilter.path),
        ],
      ),
      onSelected: (DeliveryFilter result) {
        notifier.setFilter(result);
      },
      itemBuilder:
          (BuildContext context) =>
              DeliveryFilter.values
                  .map(
                    (filter) => PopupMenuItem<DeliveryFilter>(
                      value: filter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(
                          "${filterNames[filter]!} (${state.deliveryCounts[filter] ?? 0})",
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

  Widget _buildNoDeliveriesView(
    bool isWeb,
    String title,
    String body,
    Widget icon, {
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
            const SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    isWeb
                        ? isNoDT
                            ? 150
                            : 300
                        : isNoDT
                        ? 30
                        : 40,
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
}
