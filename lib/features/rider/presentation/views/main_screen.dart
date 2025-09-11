import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_dashboard_screen.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/dashboard_widgets/custom_app_bar.dart';
import '../../../../shared/widgets/dashboard_widgets/web_side_bar.dart';
import '../../viewmodels/global_navigation_view_model.dart';

class RiderMainScreen extends ConsumerStatefulWidget {
  const RiderMainScreen({super.key});

  @override
  ConsumerState<RiderMainScreen> createState() => _RiderMainScreenState();
}

class _RiderMainScreenState extends ConsumerState<RiderMainScreen> {
  final List<Widget> pages = [RiderDashboardScreen()];

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(globalNavigationViewModelProvider);
    final navNotifier = ref.read(globalNavigationViewModelProvider.notifier);

    final isWeb = MediaQuery.of(context).size.width > 600;

    Widget buildNavItem(String icon, int index) {
      final isSelected = navState.currentIndex == index;
      return Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: SvgPicture.asset(
          icon,
          colorFilter:
              isSelected
                  ? ColorFilter.mode(
                    AppColors.primaryDarkGreen,
                    BlendMode.srcIn,
                  )
                  : null,
        ),
      );
    }

    return PopScope(
      canPop: navState.canLeaveApp,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          navNotifier.popIndexStack(context);
        }
      },
      child: Scaffold(
        appBar: isWeb ? null : CustomAppBar(isWeb: isWeb),
        body:
            isWeb
                ? Row(
                  children: [
                    const WebSideBar(),
                    Expanded(
                      child: Column(
                        children: [
                          CustomAppBar(isWeb: isWeb),
                          Expanded(
                            child: IndexedStack(
                              index: navState.currentIndex,
                              children: pages,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : IndexedStack(index: navState.currentIndex, children: pages),
        bottomNavigationBar:
            !isWeb
                ? Stack(
                  children: [
                    BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: AppColors.backgroundWhite,
                      currentIndex: navState.currentIndex,
                      onTap: (value) {
                        navNotifier.updateIndex(value);
                      },
                      items: [
                        BottomNavigationBarItem(
                          label: '',
                          icon: buildNavItem(AppAssets.icons.home2.path, 0),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: buildNavItem(AppAssets.icons.menu.path, 1),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: buildNavItem(AppAssets.icons.map.path, 2),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: buildNavItem(AppAssets.icons.wallet.path, 3),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: buildNavItem(AppAssets.icons.setting.path, 4),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      left:
                          MediaQuery.of(context).size.width /
                          5 *
                          navState.currentIndex,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: AppColors.primaryDarkGreen,
                          ),
                          height: 4,
                          width: MediaQuery.of(context).size.width / 8,
                        ),
                      ),
                    ),
                  ],
                )
                : null,
      ),
    );
  }
}
