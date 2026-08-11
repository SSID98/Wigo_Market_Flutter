enum NotificationLoadStatus { initial, loading, loaded, notFound, error }

class NotificationState {
  final bool pushNotify;
  final bool smsNotify;
  final bool emailNotify;
  final bool isEditMode;
  final bool hasData;
  final NotificationLoadStatus loadStatus;
  final bool isLoading;
  final String? errorMessage;
  final bool success;

  const NotificationState({
    this.pushNotify = false,
    this.smsNotify = false,
    this.emailNotify = false,
    this.isEditMode = true,
    this.hasData = false,
    this.loadStatus = NotificationLoadStatus.initial,
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
  });

  NotificationState copyWith({
    bool? pushNotify,
    bool? smsNotify,
    bool? emailNotify,
    bool? isEditMode,
    bool? hasData,
    NotificationLoadStatus? loadStatus,
    bool? isLoading,
    String? errorMessage,
    bool? success,
  }) {
    return NotificationState(
      pushNotify: pushNotify ?? this.pushNotify,
      smsNotify: smsNotify ?? this.smsNotify,
      emailNotify: emailNotify ?? this.emailNotify,
      isEditMode: isEditMode ?? this.isEditMode,
      hasData: hasData ?? this.hasData,
      loadStatus: loadStatus ?? this.loadStatus,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }

  /// Helper to serialize state to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'pushNotifications': {'enabled': pushNotify},
      'smsNotifications': {'enabled': smsNotify},
      'emailNotifications': {'enabled': emailNotify},
    };
  }
}
