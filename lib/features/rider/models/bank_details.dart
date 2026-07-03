import '../../../shared/models/bank_model.dart';

class BankDetails {
  final String id;
  final Bank? selectedBank;
  final String accountNumber;
  final String accountHolderName;
  final bool isDefault;
  final String phoneNumber;
  final bool isEmpty;

  const BankDetails({
    required this.id,
    this.selectedBank,
    this.phoneNumber = '',
    this.accountNumber = '',
    this.accountHolderName = '',
    required this.isDefault,
    this.isEmpty = false,
  });

  factory BankDetails.empty(String id) {
    return BankDetails(
      id: id,
      selectedBank: Bank(id: 0, code: '', name: 'Add a Bank'),
      accountNumber: '**** ****',
      accountHolderName: '',
      isDefault: false,
      phoneNumber: '',
      isEmpty: true,
    );
  }

  BankDetails copyWith({
    Bank? selectedBank,
    String? accountNumber,
    String? accountHolderName,
    bool? isDefault,
    String? phoneNumber,
    bool? isEmpty,
  }) {
    return BankDetails(
      id: id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedBank: selectedBank ?? this.selectedBank,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      isDefault: isDefault ?? this.isDefault,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}
