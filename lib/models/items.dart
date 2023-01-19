class Item {
  final String name;
  final int quantity;
  final double price;
  final String category;
  final String brand;
  final String imageBytes;
  final String memberEmail;
  Item(this.name, this.quantity, this.price, this.category, this.brand,
      this.imageBytes, this.memberEmail);

  Map<String, dynamic> toMap({int? nodeId}) {
    return <String, dynamic>{
      'name': name,
      "quantity": quantity,
      "price": price,
      "category": category,
      "brand": brand,
      "imageBytes": imageBytes,
      "memberEmail": memberEmail,
    };
  }
}
