class Customer {
  final String name;
  final String email;
  final String photoURL;
  final String address;
  final String password;
  final String phone;
  final String id;
  final bool isOrphan;
  Customer(this.name, this.email, this.photoURL, this.address, this.password,
      this.phone, this.id, this.isOrphan);

  Map<String, dynamic> toMap({int? nodeId}) {
    return <String, dynamic>{
      'name': name,
      "email": email,
      "phone": phone,
      "isOrphan": isOrphan,
      "photoURL": photoURL,
      "password": password,
      "address": address,
    };
  }
}
