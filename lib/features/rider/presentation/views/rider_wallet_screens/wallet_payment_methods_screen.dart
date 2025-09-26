import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../models/delivery_task_state.dart';
import '../../../viewmodels/delivery_task_viewmodel.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  const PaymentMethodScreen({super.key, required this.isWeb});

  final bool isWeb;

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(deliveryTaskProvider);
    final notifier = ref.read(deliveryTaskProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Expanded(
      child: SingleChildScrollView(
        child: Card(
          elevation: 0,
          color: AppColors.backgroundWhite,
          margin: EdgeInsets.only(
            top: 20,
            right: isWeb ? 740 : 15,
            left: isWeb ? 40 : 15,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: isWeb ? 310 : 86,
                    ),
                    color: AppColors.buttonLighterGreen,
                    child: Text(
                      "Setting Up withdrawal Pin",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: widget.isWeb ? 16 : 14,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Secure your earnings with a 4-digit PIN. You can reset your PIN anytime in Settings. Make sure to choose a PIN you'll remember.",
                  style: GoogleFonts.hind(
                    fontSize: widget.isWeb ? 14 : 12,
                    color: AppColors.textBlackGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  label: 'Create Pin',
                  labelFontWeight: FontWeight.w600,
                  hintText: 'Enter PIN',
                  prefixIcon: AppAssets.icons.lock.path,
                  hintTextColor: AppColors.textBlackGrey,
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                  hintFontSize: isWeb ? 16 : 14,
                  controller: _pinController,
                  isPassword: true,
                  height: isWeb ? 48 : 35,
                  contentPadding: EdgeInsets.only(top: isWeb ? 0 : 10),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Confirm Pin',
                  labelFontWeight: FontWeight.w600,
                  hintText: 'Confirm PIN',
                  prefixIcon: AppAssets.icons.lock.path,
                  hintTextColor: AppColors.textBlackGrey,
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                  hintFontSize: isWeb ? 16 : 14,
                  controller: _pinController,
                  isPassword: true,
                  height: isWeb ? 48 : 35,
                  contentPadding: EdgeInsets.only(top: isWeb ? 0 : 10),
                ),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: () {
                          if (_pinController.text.length == 4) {
                            notifier.setWalletScreenState(
                              WalletScreenState.pinSuccess,
                            );
                          } else {
                            // You can add your own validation logic here
                            // e.g., show an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("PIN must be 4 digits long."),
                              ),
                            );
                          }
                        },
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.textDarkDarkerGreen,
                        height: isWeb ? 48 : 40,
                        buttonColor: AppColors.buttonLighterGreen,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: CustomButton(
                        text: 'Continue',
                        onPressed: () async {
                          if (_pinController.text.length == 4) {
                            notifier.setWalletScreenState(
                              WalletScreenState.pinSuccess,
                            );
                            await _buildSuccessOverlay(context, isWeb);
                          } else {
                            // You can add your own validation logic here
                            // e.g., show an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("PIN must be 4 digits long."),
                              ),
                            );
                          }
                        },
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.w500,
                        height: isWeb ? 48 : 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _buildSuccessOverlay(BuildContext context, bool isWeb) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // prevent closing by tapping outside
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          titlePadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              IconButton(
                padding: EdgeInsets.only(right: isWeb ? 0 : 25),
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 45.0 : 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppAssets.icons.doubleTickSuccessful.svg(),
                const SizedBox(height: 12),
                Text(
                  "New Pin Successfully Created",
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: isWeb ? 20 : 14,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "This is the Pin will protect your funds and ensures only you can request a payout.",
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 16 : 12,
                    color: AppColors.textBodyText,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Continue',
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref
                        .read(deliveryTaskProvider.notifier)
                        .setWalletScreenState(WalletScreenState.paymentMethods);
                  },
                  fontSize: isWeb ? 18 : 12,
                  height: isWeb ? 48 : 45,
                  fontWeight: FontWeight.w500,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
