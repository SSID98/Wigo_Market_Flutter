enum ResponseStatusEnum { success, failed }

class ResponseStatusModel<T> {
  final ResponseStatusEnum accessStatus;
  final String? errorDescription;
  final List<String>? errors;
  final T? data;

  const ResponseStatusModel({
    required this.accessStatus,
    this.errorDescription,
    this.data,
    this.errors,
  });

  bool get isSuccess => accessStatus == ResponseStatusEnum.success;
}
