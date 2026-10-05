import 'order_enums.dart';

class AllowedAction {
  final OrderFilter status;
  final String label;

  const AllowedAction({required this.status, required this.label});

  factory AllowedAction.fromJson(Map<String, dynamic> json) {
    return AllowedAction(
      status: OrderFilterExtension.fromString(json['status'] as String? ?? ''),
      label: json['label'] as String? ?? '',
    );
  }
}
