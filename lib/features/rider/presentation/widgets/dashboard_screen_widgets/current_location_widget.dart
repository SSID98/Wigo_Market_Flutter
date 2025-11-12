import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/url.dart';
import '../../../viewmodels/rider_dashboard_viewmodel.dart';

class CurrentLocationWidget extends ConsumerWidget {
  const CurrentLocationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(riderDashboardViewModelProvider);
    final isWeb = MediaQuery.of(context).size.width > 600;

    return SizedBox(
      width: double.infinity,
      child: Card(
        shadowColor: Colors.white70.withValues(alpha: 0.06),
        color: AppColors.backgroundWhite,
        elevation: 1,
        margin: EdgeInsets.only(top: isWeb ? 18 : 12.0),
        child: Padding(
          padding: EdgeInsets.all(isWeb ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Location",
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: AppColors.textBlackGrey,
                ),
              ),
              const SizedBox(height: 10),
              dashboardState.currentLocation.when(
                data: (location) {
                  if (location == null) {
                    return const Center(child: Text("No location available"));
                  }

                  // final LatLng pos = LatLng(
                  //   location.latitude,
                  //   location.longitude,
                  // );
                  return Image.network(
                    isWeb
                        ? '$networkImageUrl/mapWeb.png'
                        : '$networkImageUrl/mapMobile.png',
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
