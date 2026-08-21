import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/presentation/views/product_management_screen.dart';
import 'package:wigo_flutter/features/seller/viewmodels/single_product_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_banner.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../viewmodels/mulitple_products_viewmodel.dart';
import '../../../viewmodels/seller_product_task_viewmodel.dart';
import '../../../viewmodels/seller_product_text_field_providers.dart';
import '../../../viewmodels/upload_file_viewmodel.dart';
import '../../widgets/step_progress_indicator.dart';

class LaptopsAndDesktopSpecsScreen extends ConsumerWidget {
  final bool showPage2;
  final bool isMultiProduct;

  const LaptopsAndDesktopSpecsScreen({
    super.key,
    this.showPage2 = false,
    this.isMultiProduct = false,
  });

  void _dispatch(
    WidgetRef ref,
    void Function(SingleProductViewModel) single,
    void Function(MultipleProductsViewModel) multi,
  ) {
    if (isMultiProduct) {
      multi(ref.read(multipleProductsProvider.notifier));
    } else {
      single(ref.read(singleProductProvider.notifier));
    }
  }

  ValueNotifier<String?> _notifier(
    WidgetRef ref,
    ValueNotifier<String?> Function(SingleProductViewModel) single,
    ValueNotifier<String?> Function(MultipleProductsViewModel) multi,
  ) => isMultiProduct
      ? multi(ref.read(multipleProductsProvider.notifier))
      : single(ref.read(singleProductProvider.notifier));

  void _validateAndAdvance(BuildContext context, WidgetRef ref) {
    final hasOS = isMultiProduct
        ? ref.read(multipleProductsProvider).oS?.isNotEmpty == true
        : ref.read(singleProductProvider).oS?.isNotEmpty == true;
    final hasRam = isMultiProduct
        ? ref.read(multipleProductsProvider).ramSize?.isNotEmpty == true
        : ref.read(singleProductProvider).ramSize?.isNotEmpty == true;

    if (hasOS && hasRam) {
      ref.read(specsPageProvider.notifier).state = 2;
    } else {
      showErrorBanner("Please fill OS and RAM before continuing", context);
    }
  }

  Future<void> _handlePublish(BuildContext context, WidgetRef ref) async {
    final success = isMultiProduct && context.mounted
        ? await ref.read(multipleProductsProvider.notifier).submit(context, ref)
        : context.mounted
        ? await ref.read(singleProductProvider.notifier).submit(context, ref)
        : false;
    if (success && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProductManagementScreen()),
        (route) => false,
      );
      showSuccessBanner("Product created successfully", context);
      isMultiProduct
          ? ref.invalidate(multipleProductsProvider)
          : ref.invalidate(singleProductProvider);
      ref.invalidate(uploadProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = context.isWeb;
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
                    Navigator.of(context).pop();
                  }
                },
                child: isWeb
                    ? AppAssets.icons.squareArrowBack.svg()
                    : AppAssets.icons.addproductBackArrow.svg(),
              ),
              SizedBox(width: isWeb ? 10 : 20),
              Text(
                isMultiProduct
                    ? "Add Multiple Version Product"
                    : "Add Single Version Product",
                style: GoogleFonts.hind(
                  color: AppColors.textBlackGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _buildBody(isWeb, ref, context, currentPage),
        ],
      ),
    );
  }

  Widget _buildBody(
    bool isWeb,
    WidgetRef ref,
    BuildContext context,
    int currentPage,
  ) {
    final errorMessage = isMultiProduct
        ? ref.watch(multipleProductsProvider).errorMessage
        : ref.watch(singleProductProvider).errorMessage;
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
                    "Computer Specifications",
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
            if (errorMessage != null)
              Container(
                width: double.infinity,
                color: AppColors.accentRed.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.accentRed,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: GoogleFonts.hind(
                          color: AppColors.accentRed,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                    ? () => _handlePublish(context, ref)
                    : () {
                        if (currentPage == 1) {
                          _validateAndAdvance(context, ref);
                        } else {
                          _handlePublish(context, ref);
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
    final controllers = isMultiProduct
        ? ref.watch(multipleProductTextControllersProvider)
        : ref.watch(singleProductTextControllersProvider);
    final currentYear = DateTime.now().year;
    final years = List<String>.generate(
      currentYear - 2012 + 1,
      (index) => (2012 + index).toString(),
    );
    return Column(
      children: [
        CustomTextField(
          key: const ValueKey('os_field'),
          label: 'Operating System',
          hintText: 'e.g., Windows 11, macOS Ventura',
          contentPadding: const EdgeInsets.only(left: 10),
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateOS(val),
            (vm) => vm.updateOS(val),
          ),
          controller: controllers["oS"],
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: 'Processor Type',
          hintText: 'e.g., Intel Core i5, AMD Ryzen 7',
          contentPadding: const EdgeInsets.only(left: 10),
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateProcessorType(val),
            (vm) => vm.updateProcessorType(val),
          ),
          controller: controllers["processorType"],
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          label: 'RAM Size (Memory)',
          hintText: 'e.g., 8GB',
          items: const [
            "2GB",
            "4GB",
            "6GB",
            "8GB",
            "12GB",
            "16GB",
            "32GB",
            "64GB",
          ],
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateRam(val),
            (vm) => vm.updateRam(val),
          ),
          value: _notifier(ref, (vm) => vm.selectedRam, (vm) => vm.selectedRam),
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          label: 'ROM (Internal Storage)',
          hintText: 'e.g., 512GB SSD, 1TB HDD',
          items: const [
            "128GB SSD",
            "256GB SSD",
            "512GB SSD",
            "1TB SSD",
            "2TB SSD",
            "500GB HDD",
            "1TB HDD",
            "2TB HDD",
          ],
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateRom(val),
            (vm) => vm.updateRom(val),
          ),
          value: _notifier(ref, (vm) => vm.selectedRom, (vm) => vm.selectedRom),
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          label: 'Model Year',
          hintText: 'e.g., 2023',
          items: years,
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateModelYear(val),
            (vm) => vm.updateModelYear(val),
          ),
          value: _notifier(
            ref,
            (vm) => vm.selectedModelYear,
            (vm) => vm.selectedModelYear,
          ),
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: 'Graphics Card',
          hintText: 'e.g., NVIDIA GeForce GTX 1650',
          contentPadding: const EdgeInsets.only(left: 10),
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateGraphicsCard(val),
            (vm) => vm.updateGraphicsCard(val),
          ),
          controller: controllers["graphicsCard"],
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: 'Display Resolution',
          hintText: 'e.g., 1920 x 1080 pixels (Full HD)',
          contentPadding: const EdgeInsets.only(left: 10),
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateDisplayResolution(val),
            (vm) => vm.updateDisplayResolution(val),
          ),
          controller: controllers["displayResolution"],
        ),
      ],
    );
  }

  Widget _buildPage2(WidgetRef ref) {
    final controllers = isMultiProduct
        ? ref.watch(multipleProductTextControllersProvider)
        : ref.watch(singleProductTextControllersProvider);
    return Column(
      children: [
        CustomTextField(
          key: const ValueKey('battery_field'),
          label: 'Battery Life (Laptops Only)',
          hintText: 'e.g., Up to 8 hours',
          contentPadding: const EdgeInsets.only(left: 10),
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateBattery(val),
            (vm) => vm.updateBattery(val),
          ),
          controller: controllers["battery"],
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          label: 'USB Ports',
          hintText: 'e.g., 2 x USB 3.0',
          items: const [
            "1 x USB 2.0",
            "2 x USB 2.0",
            "1 x USB 3.0",
            "2 x USB 3.0",
            "3 x USB 3.0",
            "1 x USB-C",
            "2 x USB-C",
            "2 x USB 3.0, 1 x USB-C",
            "2 x USB 3.0, 2 x USB-C",
            "None",
          ],
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateUsbPorts(val),
            (vm) => vm.updateUsbPorts(val),
          ),
          value: _notifier(
            ref,
            (vm) => vm.selectedUSBPort,
            (vm) => vm.selectedUSBPort,
          ),
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          label: 'Connectivity Features',
          hintText: 'e.g., Bluetooth 5.0, WiFi 6',
          items: const [
            "WiFi 5",
            "WiFi 6",
            "WiFi 6E",
            "Bluetooth 4.2",
            "Bluetooth 5.0",
            "Bluetooth 5.3",
            "Bluetooth 5.0, WiFi 6",
            "Bluetooth 5.3, WiFi 6E",
            "Ethernet",
          ],
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateConnectivity(val),
            (vm) => vm.updateConnectivity(val),
          ),
          value: _notifier(
            ref,
            (vm) => vm.selectedConnectivity,
            (vm) => vm.selectedConnectivity,
          ),
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: 'Screen Size (inches)',
          hintText: 'e.g., 15.6',
          contentPadding: const EdgeInsets.only(left: 10),
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateScreenSize(val),
            (vm) => vm.updateScreenSize(val),
          ),
          controller: controllers["screenSize"],
        ),
        const SizedBox(height: 15),
        CustomTextField(
          label: 'Dimensions (L × W × H in mm)',
          hintText: 'e.g., 359 x 234 x 17 mm',
          contentPadding: const EdgeInsets.only(left: 10),
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateDimensions(val),
            (vm) => vm.updateDimensions(val),
          ),
          controller: controllers["dimensions"],
        ),
        const SizedBox(height: 15),
        CustomDropdownField(
          isRichText: true,
          labelRichText: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Warranty Type ",
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
          hintText: 'e.g., Seller Warranty',
          items: const [
            "No Warranty",
            "Seller Warranty",
            "Manufacturer Warranty",
            "International Warranty",
          ],
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateWarrantyType(val),
            (vm) => vm.updateWarrantyType(val),
          ),
          value: _notifier(
            ref,
            (vm) => vm.selectedWarrantyType,
            (vm) => vm.selectedWarrantyType,
          ),
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
          items: const [
            "1 Month",
            "3 Months",
            "6 Months",
            "1 Year",
            "2 Years",
            "3 Years",
            "5 Years",
          ],
          onChanged: (val) => _dispatch(
            ref,
            (vm) => vm.updateWarranty(val),
            (vm) => vm.updateWarranty(val),
          ),
          value: _notifier(
            ref,
            (vm) => vm.selectedWarranty,
            (vm) => vm.selectedWarranty,
          ),
        ),
      ],
    );
  }
}
