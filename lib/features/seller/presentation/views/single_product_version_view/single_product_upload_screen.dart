import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/presentation/views/single_product_version_view/laptops_desktop_specs_screen.dart';
import 'package:wigo_flutter/features/seller/presentation/views/single_product_version_view/mobile_specs_screen.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../viewmodels/single_product_viewmodel.dart';
import '../../../viewmodels/upload_file_viewmodel.dart';
import '../../widgets/step_progress_indicator.dart';
import '../../widgets/upload_box2.dart';
import '../product_management_screen.dart';

class SingleProductUploadScreen extends ConsumerWidget {
  const SingleProductUploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child:
                    isWeb
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
          _buildBody(isWeb, ref, context),
        ],
      ),
    );
  }

  Widget _buildBody(bool isWeb, WidgetRef ref, BuildContext context) {
    final mainImage = ref.watch(uploadProvider('cover_image'));
    final mainImageNotifier = ref.read(uploadProvider('cover_image').notifier);
    final vm = ref.read(singleProductProvider.notifier);
    Future.microtask(() {
      mainImageNotifier.init(1); // Only 1 box for this identity
      return null;
    });

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
                    "Product Image & Visual",
                    style: GoogleFonts.hind(
                      color: AppColors.textVidaLocaGreen,
                      fontWeight: isWeb ? FontWeight.w700 : FontWeight.w600,
                      fontSize: isWeb ? 20 : 16,
                    ),
                  ),
                  StepProgressIndicator(
                    currentStep: 2,
                    totalSteps:
                        vm.needsComputerSpecsScreen || vm.needsMobileSpecsScreen
                            ? 3
                            : 2,
                    isWeb: isWeb,
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  top: 8,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add high-quality visuals that show your product clearly. Great images increase your chances of selling!",
                      style: GoogleFonts.hind(
                        color:
                            isWeb
                                ? AppColors.textBodyText
                                : AppColors.textBlackGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: isWeb ? 18 : 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    UploadBox2(
                      file: mainImage.isNotEmpty ? mainImage[0] : null,
                      type: UploadType.image,
                      height: 280,
                      isMainProduct: true,
                      width: isWeb ? 300 : double.infinity,
                      onPick: () => mainImageNotifier.pickImage(0),
                      onRemove: () => mainImageNotifier.removeFile(0),
                    ),
                    const SizedBox(height: 5),
                    isWeb
                        ? _buildWebUploadLayout(isWeb, ref)
                        : _buildMobileUploadLayout(isWeb, ref),
                    const SizedBox(height: 20),
                    _buildInstructionCard(isWeb),
                    const SizedBox(height: 20),
                    _buildMovieUploadSection(isWeb, ref),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 50),
              child: CustomButton(
                text:
                    vm.needsComputerSpecsScreen || vm.needsMobileSpecsScreen
                        ? "Next"
                        : "Publish Product",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 48,
                width: double.infinity,
                onPressed: () {
                  if (vm.needsMobileSpecsScreen) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MobileSpecsScreen()),
                    );
                  } else if (vm.needsComputerSpecsScreen) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LaptopsAndDesktopSpecsScreen(),
                      ),
                    );
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
                suffixIcon: AppAssets.icons.arrowRight.svg(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileUploadLayout(bool isWeb, WidgetRef ref) {
    return Column(children: [_buildGridView(isWeb, ref)]);
  }

  Widget _buildWebUploadLayout(bool isWeb, WidgetRef ref) {
    return Row(children: [_buildGridView(isWeb, ref)]);
  }

  Widget _buildGridView(bool isWeb, WidgetRef ref) {
    final imageFiles = ref.watch(uploadProvider('extra_images'));
    final imageNotifier = ref.read(uploadProvider('extra_images').notifier);
    // Initialize once
    Future.microtask(() {
      imageNotifier.init(4);
      return null;
    });

    return GridView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imageFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent:
            imageFiles.any((file) => file?.error != null) ? 190 : 150,
      ),
      itemBuilder: (_, index) {
        return Center(
          child: UploadBox2(
            iconHeight: 36.14,
            iconWidth: 36.15,
            fontSize: 10,
            height: isWeb ? 132 : 140,
            width: isWeb ? 210 : 155,
            file: imageFiles[index],
            type: UploadType.image,
            onPick: () => imageNotifier.pickImage(index),
            onRemove: () => imageNotifier.removeFile(index),
          ),
        );
      },
    );
  }

  Widget _buildInstructionCard(bool isWeb) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.backgroundLight,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isWeb)
              Row(
                children: [
                  _buildTextOutline(
                    isWeb: isWeb,
                    text: "Upload (2–5 Product images)",
                  ),
                  const SizedBox(width: 20),
                  _buildTextOutline(
                    isWeb: isWeb,
                    text: "Accepted file types: JPG, PNG (Max size: 5MB each)",
                  ),
                ],
              ),
            if (!isWeb) ...[
              _buildTextOutline(
                isWeb: isWeb,
                text: "Upload (2–5 Product images)",
              ),
              const SizedBox(height: 10),
              _buildTextOutline(
                isWeb: isWeb,
                text: "Accepted file types: JPG, PNG (Max size: 5MB each)",
              ),
            ],
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "Start with your main product image. Add other angles, packaging, or use-case shots to help buyers understand what they’re getting. ",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      fontSize: isWeb ? 16 : 14,
                      color: AppColors.textBodyText,
                    ),
                  ),
                  TextSpan(
                    text:
                        "The first image will be used as the default display image on your storefront ",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w500,
                      fontSize: isWeb ? 16 : 14,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextOutline({required bool isWeb, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.9),
          child: AppAssets.icons.orangeCircleBullet.svg(),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.hind(
              fontSize: isWeb ? 16 : 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlackGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieUploadSection(bool isWeb, WidgetRef ref) {
    final videoFiles = ref.watch(uploadProvider('product_video'));
    final videoNotifier = ref.read(uploadProvider('product_video').notifier);

    Future.microtask(() {
      videoNotifier.init(1);
      return null;
    });

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderColor, width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.only(bottom: 16),
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Product Video ",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w600,
                      fontSize: isWeb ? 20 : 16,
                      color: AppColors.textBlueishBlack,
                    ),
                  ),
                  TextSpan(
                    text: "(Optional)",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w700,
                      fontSize: isWeb ? 16 : 14,
                      color: AppColors.textBodyText,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Show your product in action! A short video helps build trust and shows real-life use.",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w500,
                fontSize: isWeb ? 16 : 14,
                color: AppColors.textBodyText,
              ),
            ),
            const SizedBox(height: 20),
            UploadBox2(
              file: videoFiles.isNotEmpty ? videoFiles[0] : null,
              type: UploadType.video,
              height: 168,
              width: isWeb ? 518 : double.infinity,
              onPick: () => videoNotifier.pickVideo(0),
              onRemove: () => videoNotifier.removeFile(0),
            ),
            const SizedBox(height: 10),
            _buildTextOutline(
              isWeb: isWeb,
              text:
                  "Accepted file type: MP4 (Max duration: 60 sec, Max size: 20MB)",
            ),
          ],
        ),
      ),
    );
  }
}
