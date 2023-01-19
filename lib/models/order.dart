class Order {
  final String customerName;
  final String phone;
  final String address;
  final DateTime orderDateTime;
  final double orderValue;
  final bool isCustomerOrphan;
  final String orderStatus;
  final String storeOwnerEmail;
  final List<dynamic> orderItems;
  Order(
      this.customerName,
      this.phone,
      this.address,
      this.orderDateTime,
      this.orderValue,
      this.isCustomerOrphan,
      this.orderStatus,
      this.storeOwnerEmail,
      this.orderItems);

  Map<String, dynamic> toMap({int? nodeId}) {
    return <String, dynamic>{
      'customerName': customerName,
      "phone": phone,
      "address": address,
      "orderDateTime": orderDateTime,
      "orderValue": orderValue,
      "isCustomerOrphan": isCustomerOrphan,
      "orderStatus": orderStatus,
      "storeOwnerEmail": storeOwnerEmail,
      "orderItems": orderItems
    };
  }
}
