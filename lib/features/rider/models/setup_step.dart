import '../presentation/widgets/account_setup_status_widget.dart';

class SetupStep {
  final String id;
  final String title;
  final String description;
  final SetupStatus status;

  SetupStep({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory SetupStep.fromJson(Map<String, dynamic> json) {
    return SetupStep(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: SetupStatus.values.firstWhere(
        (s) => s.name == json['status'],
        // assuming backend sends "pending", "completed"
        orElse: () => SetupStatus.pending,
      ),
    );
  }
}
