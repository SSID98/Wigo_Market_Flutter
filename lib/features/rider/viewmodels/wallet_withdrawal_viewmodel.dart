import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WithdrawalState {
  late String? generalError;
  final bool isLoading;

  WithdrawalState({this.generalError, this.isLoading = false});

  WithdrawalState copyWith({String? generalError, bool? isLoading}) {
    return WithdrawalState(
      generalError: generalError ?? this.generalError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WithdrawalViewmodel extends StateNotifier<WithdrawalState> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  WithdrawalViewmodel() : super(WithdrawalState());

  @override
  void dispose() {
    pinController.dispose();
    confirmPinController.dispose();
    amountController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}

final withdrawalViewModelProvider =
    StateNotifierProvider.autoDispose<WithdrawalViewmodel, WithdrawalState>((
      ref,
    ) {
      return WithdrawalViewmodel();
    });
