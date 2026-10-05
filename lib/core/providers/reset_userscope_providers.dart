import 'package:flutter_riverpod/misc.dart';
import 'package:wigo_flutter/features/seller/viewmodels/mulitple_products_viewmodel.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_dashboard_viewmodel.dart';

import '../../features/rider/navigation/rider_main_screen.dart';
import '../../features/rider/viewmodels/global_navigation_viewmodel.dart';
import '../../features/rider/viewmodels/rider_dashboard_viewmodel.dart';
import '../../features/rider/viewmodels/wallet_overview_transaction_viewmodel.dart';
import '../../features/seller/viewmodels/categories_provider.dart';
import '../../features/seller/viewmodels/single_product_viewmodel.dart';
import '../../features/seller/viewmodels/upload_file_viewmodel.dart';
import '../../shared/viewmodels/onboarding_viewmodel.dart';
import '../../shared/viewmodels/role_selection_viewmodel.dart';

typedef Invalidator = void Function(ProviderOrFamily provider);

void resetUserScopedProviders(Invalidator invalidate) {
  invalidate(riderDashboardViewModelProvider);
  invalidate(walletOverviewTransactionProvider);
  invalidate(roleSelectionViewModelProvider);
  invalidate(onboardingViewModelProvider);
  invalidate(riderNavigatorKeysProvider);
  invalidate(globalNavigationViewModelProvider);
  invalidate(categoriesProvider);
  invalidate(singleProductProvider);
  invalidate(multipleProductsProvider);
  invalidate(uploadProvider);
  invalidate(sellerDashboardViewModelProvider);
}
