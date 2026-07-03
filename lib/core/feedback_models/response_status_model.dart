enum ResponseStatusEnum { success, failed }

class ResponseStatusModel<T> {
  final ResponseStatusEnum accessStatus;
  final String? errorDescription;
  final T? data;

  const ResponseStatusModel({
    required this.accessStatus,
    this.errorDescription,
    this.data,
  });

  // String get stringData {
  //   if (data is String) return data as String;
  //   return '';
  // }
  //
  // Map<String, dynamic>? get mapData {
  //   if (data is Map<String, dynamic>) return data as Map<String, dynamic>;
  //   return null;
  // }
  //
  // List<dynamic>? get listData {
  //   if (data is List) return data as List<dynamic>;
  //   return null;
  // }

  bool get isSuccess => accessStatus == ResponseStatusEnum.success;
}
