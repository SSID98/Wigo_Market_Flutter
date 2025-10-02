class BankDetails {
  final String id;
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final bool isDefault;
  final String phoneNumber;
  final bool isEmpty;

  const BankDetails({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.isDefault,
    required this.phoneNumber,
    this.isEmpty = false,
  });

  // Factory constructor for a default/empty state
  factory BankDetails.empty(String id) {
    return BankDetails(
      id: id,
      bankName: 'Add a Bank',
      accountNumber: '**** ****',
      accountHolderName: '',
      isDefault: false,
      phoneNumber: '',
      isEmpty: true,
    );
  }

  BankDetails copyWith({
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    bool? isDefault,
    String? phoneNumber,
    bool? isEmpty,
  }) {
    return BankDetails(
      id: id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      isDefault: isDefault ?? this.isDefault,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}
