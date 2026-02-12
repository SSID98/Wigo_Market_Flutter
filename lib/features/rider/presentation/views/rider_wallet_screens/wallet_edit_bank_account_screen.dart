import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/rider/viewmodels/edit_bank_account_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/contact_text_field.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_checkbox_widget.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../../../core/utils/validation_utils.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../models/bank_details.dart';
import '../../../models/wallet_state.dart';

class EditBankAccountScreen extends ConsumerStatefulWidget {
  const EditBankAccountScreen({
    super.key,
    required this.bankDetails,
    this.returnToState,
    this.openedViaNavigator = false,
  });

  final BankDetails bankDetails;
  final WalletScreenState? returnToState;
  final bool openedViaNavigator;

  @override
  ConsumerState<EditBankAccountScreen> createState() =>
      _EditBankAccountScreenState();
}

class _EditBankAccountScreenState extends ConsumerState<EditBankAccountScreen> {
  late TextEditingController _accountNumberController;
  late TextEditingController _accountNameController;
  late TextEditingController _phoneNumberController;
  late bool _isDefault;
  late bool _isAddingNew;
  String? _selectedBankName;
  String? _accountHasError;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final accountKey = GlobalKey<FormFieldState<String>>();

  bool get isBankEmpty =>
      _selectedBankName == null || _selectedBankName!.isEmpty;

  @override
  void initState() {
    super.initState();
    final bank = widget.bankDetails;
    _isAddingNew = bank.isEmpty;

    _accountNumberController = TextEditingController(
      text: bank.isEmpty ? '' : bank.accountNumber,
    );

    _selectedBankName = bank.isEmpty ? '' : bank.bankName;

    _accountNameController = TextEditingController(
      text: bank.isEmpty ? '' : bank.accountHolderName,
    );
    _phoneNumberController = TextEditingController(
      text: bank.isEmpty ? '' : bank.phoneNumber,
    );

    _isDefault = bank.isEmpty ? false : bank.isDefault || _isAddingNew;
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _navigateBackToList() {
    if (widget.openedViaNavigator) {
      Navigator.of(context).pop();
    } else {
      ref.read(editBankAccountProvider.notifier).cancelEditBankAccount();
    }
  }

  void _saveChanges() {
    final notifier = ref.read(editBankAccountProvider.notifier);

    FocusManager.instance.primaryFocus?.unfocus();
    final validationResult = FormValidators.validateAccountNo(
      _accountNumberController.text,
    );
    setState(() {
      _accountHasError = validationResult;

      _autoValidateMode = AutovalidateMode.always;
    });

    if (_accountNumberController.text.isEmpty ||
        isBankEmpty ||
        _accountNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields must be filled.")),
      );
      return;
    }

    if (validationResult != null) {
      return;
    }

    notifier.updateBankDetails(
      bankId: widget.bankDetails.id,
      newBankName: _selectedBankName ?? '',
      newAccountNumber: _accountNumberController.text,
      newAccountHolderName: _accountNameController.text,
      newIsDefault: _isDefault,
      newPhoneNumber: _phoneNumberController.text,
    );

    if (widget.openedViaNavigator) {
      Future.delayed(const Duration(milliseconds: 200), () {});
      Navigator.of(context).pop(true);
    } else {
      widget.returnToState;
    }
  }

  final List<String> _banks = const [
    'Zenith Bank',
    'Gt Bank',
    'Access Bank',
    'UBA Bank',
  ];

  @override
  Widget build(BuildContext context) {
    return widget.openedViaNavigator
        ? Scaffold(body: _buildBody())
        : Expanded(child: _buildBody());
  }

  Widget _buildBody() {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isWeb ? 40 : 15.0,
        isWeb ? 20 : 0,
        isWeb ? 300 : 15.0,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isWeb && widget.openedViaNavigator) const SizedBox(height: 20),
          if (isWeb || widget.openedViaNavigator)
            Row(
              children: [
                InkWell(
                  onTap:
                      widget.openedViaNavigator
                          ? () => Navigator.of(context).pop()
                          : _navigateBackToList,
                  child: AppAssets.icons.arrowLeft.svg(),
                ),
                const SizedBox(width: 5),
                Text(
                  'Back',
                  style: GoogleFonts.hind(
                    fontWeight: isWeb ? FontWeight.w600 : FontWeight.w400,
                    fontSize: isWeb ? 24 : 18,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ],
            ),
          if (!isWeb && widget.openedViaNavigator)
            Divider(color: AppColors.dividerColor.withValues(alpha: 0.2)),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                elevation: 0,
                margin: EdgeInsets.only(top: 20),
                color: AppColors.backgroundWhite,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'We need your bank details to send you earnings from completed deliveries.',
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackGrey,
                          fontSize: isWeb ? 20 : 16,
                        ),
                      ),
                      SizedBox(height: isWeb ? 20 : 10),
                      Text(
                        'Payment Details',
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackGrey,
                          fontSize: isWeb ? 20 : 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'This is the Account you would receive payments',
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlackGrey,
                          fontSize: isWeb ? 15 : 12,
                        ),
                      ),
                      GridView.builder(
                        padding: EdgeInsets.only(top: isWeb ? 20 : 15),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWeb ? 2 : 1,
                          crossAxisSpacing: isWeb ? 13 : 0,
                          mainAxisSpacing: isWeb ? 30 : 0,
                          mainAxisExtent:
                              isWeb
                                  ? 85
                                  : _accountHasError != null
                                  ? 82
                                  : 75,
                        ),
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return CustomTextField(
                                label: 'Account Number',
                                fontSize: isWeb ? 18 : 12,
                                labelFontSize: isWeb ? 20 : 14,
                                hintFontSize: isWeb ? 18 : 12,
                                labelFontWeight: FontWeight.w600,
                                hintText: 'Enter 10-digit account number',
                                controller: _accountNumberController,
                                hasError: _accountHasError != null,
                                errorMessage: _accountHasError,
                                autoValidateMode: _autoValidateMode,
                                validator: (value) => null,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                onChanged: (v) {},
                                height: isWeb ? 52 : 40,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                focusedBorderColor: AppColors.borderColor,
                                enabledBorderColor: AppColors.borderColor,
                              );
                            case 1:
                              return CustomTextField(
                                label: 'Account Name',
                                hintText: 'Account Name',
                                fontSize: isWeb ? 18 : 12,
                                labelFontSize: isWeb ? 20 : 14,
                                hintFontSize: isWeb ? 18 : 12,
                                labelFontWeight: FontWeight.w600,
                                controller: _accountNameController,
                                onChanged: (v) {},
                                height: isWeb ? 52 : 40,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                focusedBorderColor: AppColors.borderColor,
                                enabledBorderColor: AppColors.borderColor,
                              );
                            case 2:
                              return CustomDropdownField(
                                label: 'Bank Name',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBankName = value;
                                  });
                                },
                                labelTextColor: AppColors.textBlack,
                                padding: EdgeInsets.zero,
                                itemsFontSize: isWeb ? 18 : 12,
                                enabledBorderColor: AppColors.borderColor,
                                focusedBorderColor: AppColors.borderColor,
                                labelFontSize: isWeb ? 20 : 14,
                                hintFontSize: isWeb ? 18 : 12,
                                labelFontWeight: FontWeight.w600,
                                hintText: 'Select Bank Name',
                                iconWidth: isWeb ? 32 : 16,
                                iconHeight: isWeb ? 32 : 16,
                                validatorText: 'Please select a bank name',
                                value:
                                    _banks.contains(_selectedBankName)
                                        ? _selectedBankName
                                        : null,
                                sizeBoxHeight: isWeb ? 52 : 40,
                                items: _banks,
                              );
                            case 3:
                              return CustomPhoneNumberField(
                                padding: EdgeInsets.only(left: 17, top: 1),
                                label: 'Phone Number',
                                labelFontSize: isWeb ? 20 : 14,
                                labelFontWeight: FontWeight.w600,
                                controller: _phoneNumberController,
                                hintText: '',
                                height: isWeb ? 52 : 40,
                                borderColor: AppColors.borderColor,
                                inputFontSize: isWeb ? 18 : 12,
                                hintTextFontSize: isWeb ? 18 : 12,
                                dialCodeFontSize: isWeb ? 18 : 12,
                                inputColor: AppColors.textBlack,
                                contentPadding: EdgeInsets.only(
                                  bottom: isWeb ? 4.5 : 0,
                                ),
                              );
                            default:
                              return const SizedBox.shrink();
                          }
                        },
                      ),
                      SizedBox(height: isWeb ? 15 : 5),
                      Row(
                        children: [
                          CustomCheckBox(
                            sizedBoxHeight: isWeb ? 20 : 11,
                            value: _isDefault,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _isDefault = newValue ?? false;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Make Default Payment Method',
                            style: GoogleFonts.hind(
                              fontSize: isWeb ? 14 : 12,
                              color: AppColors.textVidaLocaGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment:
                            isWeb
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: isWeb ? 0 : 1,
                            child: CustomButton(
                              onPressed:
                                  widget.openedViaNavigator
                                      ? () => Navigator.of(context).pop()
                                      : _navigateBackToList,
                              text: 'Cancel',
                              fontSize: isWeb ? 18 : 16,
                              fontWeight: FontWeight.w500,
                              textColor: AppColors.textDarkDarkerGreen,
                              buttonColor: AppColors.buttonLighterGreen,
                              height: isWeb ? 48 : 45,
                              width: isWeb ? 300 : 150.0,
                            ),
                          ),
                          SizedBox(width: isWeb ? 50 : 20),
                          Expanded(
                            flex: isWeb ? 0 : 1,
                            child: CustomButton(
                              onPressed: _saveChanges,
                              text: 'Save',
                              fontSize: isWeb ? 18 : 16,
                              fontWeight: FontWeight.w500,
                              height: isWeb ? 48 : 45,
                              width: isWeb ? 300 : 150.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
