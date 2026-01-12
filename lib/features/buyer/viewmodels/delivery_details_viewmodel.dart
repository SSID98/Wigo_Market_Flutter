import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryPaymentState {
  final String deliveryOption;
  final bool agreeToTerms;
  final String paymentOption;

  const DeliveryPaymentState({
    this.agreeToTerms = false,
    this.deliveryOption = 'Option2',
    this.paymentOption = 'Option1',
  });

  DeliveryPaymentState copyWith({
    bool? agreeToTerms,
    String? deliveryOption,
    String? paymentOption,
  }) {
    return DeliveryPaymentState(
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      paymentOption: paymentOption ?? this.paymentOption,
    );
  }
}

class DeliveryPaymentNotifier extends StateNotifier<DeliveryPaymentState> {
  DeliveryPaymentNotifier() : super(const DeliveryPaymentState());

  void setSelectedOption(String value) {
    state = state.copyWith(deliveryOption: value);
  }

  void toggleAgreeToTerms(bool? value) {
    state = state.copyWith(agreeToTerms: value ?? false);
  }
}

final deliveryPaymentProvider =
    StateNotifierProvider<DeliveryPaymentNotifier, DeliveryPaymentState>(
      (ref) => DeliveryPaymentNotifier(),
    );
