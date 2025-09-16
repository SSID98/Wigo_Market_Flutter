import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_dashboard_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_settings_screens/rider_settings_main_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/dashboard_widgets/custom_app_bar.dart';
import '../../../../shared/widgets/dashboard_widgets/web_side_bar.dart';
import '../../viewmodels/global_navigation_viewmodel.dart';

class RiderMainScreen extends ConsumerStatefulWidget {
  const RiderMainScreen({super.key});

  @override
  ConsumerState<RiderMainScreen> createState() => _RiderMainScreenState();
}

class _RiderMainScreenState extends ConsumerState<RiderMainScreen> {
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Dashboard tab
    GlobalKey<NavigatorState>(), // Settings tab
  ];

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(globalNavigationViewModelProvider);
    final navNotifier = ref.read(globalNavigationViewModelProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 600;
    const hiddenAppBarIndices = [1];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final currentNavigator =
            _navigatorKeys[navState.currentIndex].currentState!;
        if (currentNavigator.canPop()) {
          currentNavigator.pop();
          return;
        }
        // if inner navigator couldn't pop, let the viewmodel handle tab-stack pop
        final shouldExit = navNotifier.popIndexStack();
        if (shouldExit) {
          Navigator.of(context).maybePop();
        }
      },
      child: Scaffold(
        appBar:
            isWeb || hiddenAppBarIndices.contains(navState.currentIndex)
                ? null
                : CustomAppBar(isWeb: isWeb),
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
                              children: [
                                _buildNavigator(0, RiderDashboardScreen()),
                                _buildNavigator(1, RiderSettingsMainScreen()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : IndexedStack(
                  index: navState.currentIndex,
                  children: [
                    _buildNavigator(0, RiderDashboardScreen()),
                    _buildNavigator(1, RiderSettingsMainScreen()),
                  ],
                ),

        bottomNavigationBar:
            !isWeb ? _buildBottomNavBar(context, navState, navNotifier) : null,
      ),
    );
  }

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => child);
      },
    );
  }

  Widget _buildBottomNavBar(
    BuildContext context,
    GlobalNavigationState navState,
    GlobalNavigationViewModel navNotifier,
  ) {
    List<String> icons = [
      AppAssets.icons.home2.path,
      AppAssets.icons.menu.path,
      AppAssets.icons.map.path,
      AppAssets.icons.wallet.path,
      AppAssets.icons.setting.path,
    ];

    return Stack(
      children: [
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,

          backgroundColor: AppColors.backgroundWhite,

          currentIndex: navState.currentIndex,

          onTap: (value) {
            if (value < _navigatorKeys.length) {
              // same-index tap -> pop inner navigator to root
              if (navState.currentIndex == value) {
                _navigatorKeys[value].currentState?.popUntil((r) => r.isFirst);
              } else {
                // change tab via viewmodel
                ref
                    .read(globalNavigationViewModelProvider.notifier)
                    .setIndex(value);
              }
            } else {
              // handle other indices (map, wallet, setting) when you add them
              // e.g. push a screen, open modal, etc.
            }
          },

          items: List.generate(icons.length, (i) {
            return BottomNavigationBarItem(
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SvgPicture.asset(
                  icons[i],
                  colorFilter:
                      navState.currentIndex == i
                          ? ColorFilter.mode(
                            AppColors.primaryDarkGreen,

                            BlendMode.srcIn,
                          )
                          : null,
                ),
              ),
            );
          }),
        ),

        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width / 5 * navState.currentIndex,
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
    );
  }
}
