import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_dashboard_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/role_selection_provider.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/models/user_role.dart';
import '../../../../shared/widgets/dashboard_widgets/custom_app_bar.dart';
import '../../../../shared/widgets/dashboard_widgets/web_side_bar.dart';
import '../../../rider/viewmodels/global_navigation_viewmodel.dart';

class SellerMainScreen extends ConsumerStatefulWidget {
  const SellerMainScreen({super.key});

  @override
  ConsumerState<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends ConsumerState<SellerMainScreen> {
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(globalNavigationViewModelProvider);
    final navNotifier = ref.read(globalNavigationViewModelProvider.notifier);
    final role = ref.watch(userRoleProvider);
    final isSeller = role == UserRole.seller;
    final isWeb = MediaQuery.of(context).size.width > 600;
    const hiddenAppBarIndices = [4];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final currentNavigator =
            _navigatorKeys[navState.currentIndex].currentState!;
        if (currentNavigator.canPop()) {
          currentNavigator.pop();
          return;
        }
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
                                _buildNavigator(0, SellerDashboardScreen()),
                                _buildNavigator(1, Placeholder()),
                                _buildNavigator(2, Placeholder()),
                                _buildNavigator(3, Placeholder()),
                                _buildNavigator(4, Placeholder()),
                                // if (isSeller) ...[
                                //   _buildNavigator(5, Placeholder()),
                                // ],
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
                    _buildNavigator(0, SellerDashboardScreen()),
                    _buildNavigator(1, Placeholder()),
                    _buildNavigator(2, Placeholder()),
                    _buildNavigator(3, Placeholder()),
                    _buildNavigator(4, Placeholder()),
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
      AppAssets.icons.dashboardCart.path,
      AppAssets.icons.products.path,
      AppAssets.icons.sellerEarning.path,
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
              if (navState.currentIndex == value) {
                _navigatorKeys[value].currentState?.popUntil((r) => r.isFirst);
              } else {
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
                          : ColorFilter.mode(
                            AppColors.textIconGrey,
                            BlendMode.srcIn,
                          ),
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
