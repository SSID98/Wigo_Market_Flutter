class EarningsOverview {
  final double today;
  final double thisWeek;
  final double pendingPayout;
  final double totalEarnings;
  final double availableBalance;
  final int totalDeliveries;

  const EarningsOverview({
    required this.today,
    required this.thisWeek,
    required this.pendingPayout,
    required this.totalEarnings,
    required this.availableBalance,
    required this.totalDeliveries,
  });

  factory EarningsOverview.fromJson(Map<String, dynamic> json) {
    return EarningsOverview(
      today: (json['today'] as num).toDouble(),
      thisWeek: (json['thisWeek'] as num).toDouble(),
      pendingPayout: (json['pendingPayout'] as num).toDouble(),
      totalEarnings: (json['totalEarnings'] as num).toDouble(),
      availableBalance: (json['availableBalance'] as num).toDouble(),
      totalDeliveries: (json['totalDeliveries'] as num).toInt(),
    );
  }
}
