import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_product_text_field_providers.dart';
import 'package:wigo_flutter/features/seller/viewmodels/single_product_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../models/single_product_state.dart';
import '../../widgets/step_progress_indicator.dart';
import '../product_management_screen.dart';
import '../seller_dashboard_screen.dart';

class MobileSpecsScreen extends ConsumerWidget {
  const MobileSpecsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final state = ref.watch(singleProductProvider);
    final vm = ref.read(singleProductProvider.notifier);
    final currentPage = ref.watch(specsPageProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (currentPage == 2) {
                    ref.read(specsPageProvider.notifier).state = 1;
                  } else {
                    // This triggers the Inner Navigator pop handled by SellerMainScreen
                    Navigator.of(context).pop();
                  }
                },
                child: isWeb
                    ? AppAssets.icons.squareArrowBack.svg()
                    : AppAssets.icons.addproductBackArrow.svg(),
              ),
              SizedBox(width: isWeb ? 10 : 20),
              Text(
                "Add Single Version Product",
                style: GoogleFonts.hind(
                  color: AppColors.textBlackGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _buildBody(isWeb, state, vm, ref, context),
        ],
      ),
    );
  }

  Widget _buildBody(
    bool isWeb,
    SingleProductState state,
    SingleProductViewModel vm,
    WidgetRef ref,
    BuildContext context,
  ) {
    final currentPage = ref.watch(specsPageProvider);
    return Expanded(
      child: Card(
        elevation: 0,
        color: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 26, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Basic Product Information",
                    style: GoogleFonts.hind(
                      color: AppColors.textVidaLocaGreen,
                      fontWeight: isWeb ? FontWeight.w700 : FontWeight.w600,
                      fontSize: isWeb ? 20 : 16,
                    ),
                  ),
                  StepProgressIndicator(
                    currentStep: 3,
                    totalSteps: 3,
                    isWeb: isWeb,
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10,
                  top: 8,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add key details that help buyers understand your product better. Accurate specifications improve search results and build buyer confidence.",
                      style: GoogleFonts.hind(
                        color: isWeb
                            ? AppColors.textBodyText
                            : AppColors.textBlackGrey,
                        fontWeight: isWeb ? FontWeight.w500 : FontWeight.w400,
                        fontSize: isWeb ? 18 : 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    isWeb
                        ? Row(
                            children: [
                              Expanded(child: _buildPage1(ref)),
                              const SizedBox(width: 10),
                              Expanded(child: _buildPage2(ref)),
                            ],
                          )
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                                  // This adds a nice fade + scale effect
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                  );
                                },
                            child: currentPage == 1
                                ? _buildPage1(ref)
                                : _buildPage2(ref),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 50),
              child: CustomButton(
                text: !isWeb
                    ? currentPage == 1
                          ? 'Next'
                          : 'Publish Product'
                    : 'Publish Product',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 48,
                width: double.infinity,
                onPressed: isWeb
                    ? () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SellerDashboardScreen(),
                          ),
                          (route) =>
                              false, // Clears the navigation stack so they can't "go back" to the form
                        );
                      }
                    : () {
                        final currentPage = ref.read(specsPageProvider);
                        final specs = ref.read(singleProductProvider);
                        if (currentPage == 1) {
                          if (specs.oS != null && specs.rom != null) {
                            ref.read(specsPageProvider.notifier).state = 2;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select OS and RAM"),
                              ),
                            );
                          }
                        } else {
                          // 3. We are on Page 2, so now we navigate to the Dashboard
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProductManagementScreen(),
                            ),
                            (route) =>
                                false, // Clears the navigation stack so they can't "go back" to the form
                          );
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1(WidgetRef ref) {
    final state = ref.watch(singleProductProvider);
    final vm = ref.read(singleProductProvider.notifier);
    final controllers = ref.watch(singleProductTextControllersProvider);
    return Column(
      children: [
        CustomTextField(
          label: 'Operating System',
          hintText: 'e.g., Android 13, iOS 17',
          contentPadding: EdgeInsets.only(left: 10),
          onChanged: (val) => vm.updateOS(val),
          controller: controllers["oS"],
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: 'Processor Type',
          hintText: 'e.g., MediaTek Helio G99',
          contentPadding: EdgeInsets.only(left: 10),
          onChanged: (val) => vm.updateProcessorType(val),
          controller: controllers["processorType"],
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          label: 'RAM Size (Memory)',
          hintText: 'e.g., 6GB',
          items: const [
            "2 GB",
            "4 GB",
            "6 GB",
            "8 GB",
            "12 GB",
            "16 GB",
            "32 GB",
            "64 GB",
          ],
          onChanged: vm.updateRam,
          value: state.ramSize,
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          label: 'ROM (Internal Storage)',
          hintText: 'e.g., 128GB',
          items: const ["32 GB", "64 GB", "128 GB", "256 GB", "512 GB"],
          onChanged: vm.updateRom,
          value: state.rom,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: 'Display Resolution',
          hintText: 'e.g., 1080 x 2400 pixels',
          contentPadding: EdgeInsets.only(left: 10),
          onChanged: (val) => vm.updateDisplayResolution(val),
          controller: controllers["displayResolution"],
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: 'Screen Size (inches)',
          hintText: 'e.g., 6.5',
          contentPadding: EdgeInsets.only(left: 10),
          onChanged: (val) => vm.updateScreenSize(val),
          controller: controllers["screenSize"],
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          label: 'Camera Specs',
          hintText: 'e.g., 64MP Rear + 16MP Front',
          items: const [
            "12 MP Rear + 8 MP Front",
            "48 MP Rear + 12 MP Front",
            "64 MP Rear + 16 MP Front",
            "108 MP Rear + 32 MP Front",
            "Quad Camera (64 MP + 12 MP + 8 MP + 5 MP)",
          ],
          onChanged: vm.updateCameraSpecs,
          value: state.cameraSpecs,
        ),
      ],
    );
  }

  Widget _buildPage2(WidgetRef ref) {
    final state = ref.watch(singleProductProvider);
    final vm = ref.read(singleProductProvider.notifier);
    final controllers = ref.watch(singleProductTextControllersProvider);
    return Column(
      children: [
        CustomDropdownField(
          label: 'Battery Capacity',
          hintText: 'e.g., 5000 mAh',
          items: const [
            "3000 mAh",
            "4000 mAh",
            "4500 mAh",
            "5000 mAh",
            "6000 mAh",
            "7000 mAh",
          ],
          onChanged: vm.updateBattery,
          value: state.battery,
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          label: 'Network Type',
          hintText: 'e.g., 4G LTE, 5G',
          items: const ["3G", "4G LTE", "5G", "Wi-Fi only"],
          onChanged: vm.updateNetworkType,
          value: state.networkType,
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          label: 'SIM Configuration',
          hintText: 'e.g., Dual Nano SIM',
          items: const [
            "Single Nano SIM",
            "Dual Nano SIM",
            "Hybrid Dual SIM (Nano + microSD)",
            "eSIM + Nano SIM",
          ],
          onChanged: vm.updateSimConfig,
          value: state.simConfig,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: 'Dimensions (L × W × H in mm)',
          hintText: 'e.g., 160 x 75 x 8 mm',
          contentPadding: EdgeInsets.only(left: 10),
          onChanged: (val) => vm.updateDimensions(val),
          controller: controllers["dimensions"],
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          isRichText: true,
          labelRichText: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Warranty Duration ",
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                TextSpan(
                  text: "(Optional)",
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.textBodyText,
                  ),
                ),
              ],
            ),
          ),
          hintText: 'e.g., 1 Year',
          items: const ["6 Months", "1 Year", "2 Years", "3 Years", "5 Years"],
          onChanged: vm.updateWarranty,
          value: state.warranty,
        ),
      ],
    );
  }
}
