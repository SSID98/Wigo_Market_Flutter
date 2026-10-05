enum ResponseStatusEnum { success, failed }

class ResponseStatusModel<T> {
  final ResponseStatusEnum accessStatus;
  final String? errorDescription;
  final List<String>? errors;
  final T? data;
  final int? statusCode;


  const ResponseStatusModel({
    required this.accessStatus,
    this.errorDescription,
    this.data,
    this.errors,
    this.statusCode,
  });

  bool get isSuccess => accessStatus == ResponseStatusEnum.success;
}
