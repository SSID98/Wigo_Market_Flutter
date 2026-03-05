enum OrderStage {
  received,
  confirmed,
  preparing,
  ready,
  outForDelivery,
  delivered,
}

class TimelineItem {
  final OrderStage stage;
  final String time;
  final bool isCompleted;

  TimelineItem({
    required this.stage,
    required this.time,
    required this.isCompleted,
  });
}
