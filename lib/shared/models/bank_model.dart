class Bank {
  final int id;
  final String code;
  final String name;

  Bank({required this.id, required this.code, required this.name});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(id: json['id'], code: json['code'], name: json['name']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bank && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

class BankState {
  final List<Bank> banks;
  final bool isLoading;
  final Bank? selectedBank;
  final String phoneNumber;
  final String accountNumber;
  final String accountName;
  final String? errorMessage;
  final bool hasSubmitted;

  BankState({
    this.banks = const [],
    this.isLoading = false,
    this.selectedBank,
    this.phoneNumber = '',
    this.accountNumber = '',
    this.accountName = '',
    this.errorMessage,
    this.hasSubmitted = false,
  });

  BankState copyWith({
    List<Bank>? banks,
    bool? isLoading,
    String? errorMessage,
    Bank? selectedBank,
    String? phoneNumber,
    String? accountNumber,
    String? accountName,
    bool? hasSubmitted,
  }) {
    return BankState(
      banks: banks ?? this.banks,
      isLoading: isLoading ?? this.isLoading,
      accountNumber: accountNumber ?? this.accountNumber,
      selectedBank: selectedBank ?? this.selectedBank,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accountName: accountName ?? this.accountName,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }
}
