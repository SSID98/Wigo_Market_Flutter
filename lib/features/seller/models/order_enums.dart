enum OrderFilter {
  all,
  pending,
  confirmed,
  preparing,
  pickUpReady,
  inTransit,
  delivered,
  cancelled,
}

enum DeliveryType { all, delivery, pickUp }

enum DateFilterType { all, today, custom }

enum OrderCategory { all, pending, ongoing, history }

extension OrderFilterExtension on OrderFilter {
  String get toJsonString => name;

  String get displayName {
    switch (this) {
      case OrderFilter.pickUpReady:
        return 'Pick up Ready';
      case OrderFilter.inTransit:
        return 'In Transit';
      case OrderFilter.pending:
        return 'Pending';
      case OrderFilter.delivered:
        return 'Delivered';
      case OrderFilter.cancelled:
        return 'Cancelled';
      case OrderFilter.confirmed:
        return 'Confirmed';
      case OrderFilter.preparing:
        return 'Preparing';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  static OrderFilter fromString(String status) {
    return OrderFilter.values.firstWhere(
      (e) => e.name.toLowerCase() == status.replaceAll(' ', '').toLowerCase(),
      orElse: () => OrderFilter.pending,
    );
  }
}

extension DeliveryTypeExtension on DeliveryType {
  String get toJsonString => name;

  String get displayName {
    switch (this) {
      case DeliveryType.pickUp:
        return 'Pick up';
      case DeliveryType.delivery:
        return 'Delivery';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  static DeliveryType fromString(String type) {
    return DeliveryType.values.firstWhere(
      (e) => e.name.toLowerCase() == type.replaceAll(' ', '').toLowerCase(),
      orElse: () => DeliveryType.delivery,
    );
  }
}

extension OrderCategoryExtension on OrderCategory {
  String get apiValue => name;

  String get label {
    switch (this) {
      case OrderCategory.all:
        return 'All Orders';
      case OrderCategory.pending:
        return 'Pending';
      case OrderCategory.ongoing:
        return 'Ongoing Orders';
      case OrderCategory.history:
        return 'Order History';
    }
  }

  static OrderCategory fromApiValue(String value) {
    if (value == 'recent') return OrderCategory.all;
    return OrderCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderCategory.all,
    );
  }
}
