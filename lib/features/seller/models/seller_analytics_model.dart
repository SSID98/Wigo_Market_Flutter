class AnalyticsMetric {
  final num value;
  final num previous;
  final double changePercent;

  const AnalyticsMetric({
    required this.value,
    required this.previous,
    required this.changePercent,
  });

  factory AnalyticsMetric.fromJson(Map<String, dynamic> json) {
    return AnalyticsMetric(
      value: json['value'] as num,
      previous: json['previous'] as num,
      changePercent: (json['changePercent'] as num).toDouble(),
    );
  }
}

class PeriodAnalytics {
  final AnalyticsMetric pendingOrders;
  final AnalyticsMetric pendingOrdersValue;
  final AnalyticsMetric totalSales;
  final AnalyticsMetric grossSales;
  final AnalyticsMetric completedOrders;
  final AnalyticsMetric activeProducts;

  const PeriodAnalytics({
    required this.pendingOrders,
    required this.pendingOrdersValue,
    required this.totalSales,
    required this.grossSales,
    required this.completedOrders,
    required this.activeProducts,
  });

  factory PeriodAnalytics.fromJson(Map<String, dynamic> json) {
    return PeriodAnalytics(
      pendingOrders: AnalyticsMetric.fromJson(
        json['pendingOrders'] as Map<String, dynamic>,
      ),
      pendingOrdersValue: AnalyticsMetric.fromJson(
        json['pendingOrdersValue'] as Map<String, dynamic>,
      ),
      totalSales: AnalyticsMetric.fromJson(
        json['totalSales'] as Map<String, dynamic>,
      ),
      grossSales: AnalyticsMetric.fromJson(
        json['grossSales'] as Map<String, dynamic>,
      ),
      completedOrders: AnalyticsMetric.fromJson(
        json['completedOrders'] as Map<String, dynamic>,
      ),
      activeProducts: AnalyticsMetric.fromJson(
        json['activeProducts'] as Map<String, dynamic>,
      ),
    );
  }
}

class SellerAnalytics {
  final PeriodAnalytics? today;
  final PeriodAnalytics? weekly;
  final PeriodAnalytics? monthly;

  const SellerAnalytics({this.today, this.weekly, this.monthly});

  factory SellerAnalytics.fromJson(Map<String, dynamic> json) {
    final periods = json['periods'] as Map<String, dynamic>? ?? {};
    return SellerAnalytics(
      today: periods.containsKey('today')
          ? PeriodAnalytics.fromJson(periods['today'] as Map<String, dynamic>)
          : null,
      weekly: periods.containsKey('weekly')
          ? PeriodAnalytics.fromJson(periods['weekly'] as Map<String, dynamic>)
          : null,
      monthly: periods.containsKey('monthly')
          ? PeriodAnalytics.fromJson(periods['monthly'] as Map<String, dynamic>)
          : null,
    );
  }

  PeriodAnalytics? forPeriod(String period) {
    switch (period) {
      case 'today':
        return today;
      case 'weekly':
        return weekly;
      case 'monthly':
        return monthly;
      default:
        return today;
    }
  }
}
