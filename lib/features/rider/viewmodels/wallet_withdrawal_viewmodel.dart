import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/features/rider/service/rider_api_service.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/network/network.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../shared/widgets/custom_banner.dart';
import '../../../shared/widgets/custom_loading_overlay.dart';

class WithdrawalState {
  late String? generalError;
  final bool isLoading;
  final String pin;
  final String confirmPin;
  final bool hasSubmitted;
  final String? errorMessage;
  final String code;
  final String? codeError;
  final String? amount;
  final bool showConfirmationCard;

  WithdrawalState({
    this.generalError,
    this.isLoading = false,
    this.pin = '',
    this.confirmPin = '',
    this.hasSubmitted = false,
    this.errorMessage,
    this.code = '',
    this.codeError,
    this.amount,
    this.showConfirmationCard = false,
  });

  WithdrawalState copyWith({
    String? generalError,
    bool? isLoading,
    String? pin,
    String? confirmPin,
    bool? hasSubmitted,
    String? errorMessage,
    String? code,
    String? codeError,
    String? amount,
    bool? showConfirmationCard,
  }) {
    return WithdrawalState(
      generalError: generalError ?? this.generalError,
      isLoading: isLoading ?? this.isLoading,
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      errorMessage: errorMessage,
      code: code ?? this.code,
      codeError: codeError,
      amount: amount ?? this.amount,
      showConfirmationCard: showConfirmationCard ?? this.showConfirmationCard,
    );
  }
}

class WithdrawalViewmodel extends StateNotifier<WithdrawalState> {
  final Reader read;
  final RiderApiService api;
  final TextEditingController pinController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  WithdrawalViewmodel(this.read, {RiderApiService? apiService})
    : api = apiService ?? read(riderApiServiceProvider),
      super(WithdrawalState());

  @override
  void dispose() {
    pinController.dispose();
    confirmPinController.dispose();
    amountController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void updateCode(String value) {
    state = state.copyWith(code: value);
  }

  void updatePin(String value) {
    state = state.copyWith(pin: value);
  }

  void updateConfirmPin(String value) {
    state = state.copyWith(confirmPin: value);
  }

  void updateAmount(String value) {
    state = state.copyWith(amount: value);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void toggleConfirmationCard(bool value) {
    state = state.copyWith(showConfirmationCard: value);
  }

  void validateOnSubmit() {
    final pin = FormValidators.validatePin(state.pin);

    final confirmPinError = FormValidators.validatePin(state.confirmPin);

    final pinMismatch = state.pin != state.confirmPin;

    String? errorMessage;

    if (pin != null || confirmPinError != null || pinMismatch) {
      errorMessage = 'Please fix the Pin error';
    }

    state = state.copyWith(hasSubmitted: true, errorMessage: errorMessage);
  }

  Future<bool> setUserPin({required BuildContext context}) async {
    validateOnSubmit();

    final pin = FormValidators.validatePin(state.pin);
    final confirmPinError = FormValidators.validatePin(state.confirmPin);

    final pinMismatch = state.pin != state.confirmPin;

    if (confirmPinError != null ||
        pin != null ||
        pinMismatch ||
        state.errorMessage != null) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await runWithOverlay<bool>(context, () async {
      try {
        final response = await api.createWalletPin(state.pin);

        state = state.copyWith(isLoading: false);

        if (response.isSuccess && context.mounted) {
          pinController.clear();
          confirmPinController.clear();

          state = state.copyWith(isLoading: false);
          return true;
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: response.errorDescription,
          );

          if (context.mounted) {
            showErrorBanner(state.errorMessage!, context);
          }
          return false;
        }
      } catch (e) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
        if (context.mounted) {
          showErrorBanner(state.errorMessage!, context);
        }
        return false;
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
    return result;
  }

  Future<bool> makeWithdrawal({required BuildContext context}) async {
    final pinError = FormValidators.validatePin(state.pin);

    if (pinError != null) {
      state = state.copyWith(errorMessage: pinError, hasSubmitted: true);
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await runWithOverlay<bool>(context, () async {
      try {
        final payload = {
          "amount": int.tryParse(state.amount ?? ''),
          "pin": state.pin,
        };

        final response = await api.makeWithdrawal(payload);

        state = state.copyWith(isLoading: false);

        if (response.isSuccess && context.mounted) {
          pinController.clear();

          state = state.copyWith(isLoading: false);
          return true;
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: response.errorDescription,
          );

          if (context.mounted) {
            showErrorBanner(state.errorMessage!, context);
          }
          return false;
        }
      } catch (e) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
        if (context.mounted) {
          showErrorBanner(state.errorMessage!, context);
        }
        return false;
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
    return result;
  }
}

final withdrawalViewModelProvider =
    StateNotifierProvider.autoDispose<WithdrawalViewmodel, WithdrawalState>(
      (ref) => WithdrawalViewmodel(ref.read),
    );
