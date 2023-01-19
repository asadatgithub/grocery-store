class Member {
  final String name;
  final String email;
  final String photoURL;
  final String storeName;
  final String storeAddress;
  final String password;
  final String storeImage;
  final String phone;
  final String id;
  Member(this.name, this.email, this.photoURL, this.storeName,
      this.storeAddress, this.id, this.phone, this.storeImage, this.password);

  Map<String, dynamic> toMap({int? nodeId}) {
    return <String, dynamic>{
      'name': name,
      "email": email,
      "phone": phone,
      "photoURL": photoURL,
      "password": password,
      "storeName": storeName,
      "storeAddress": storeAddress,
      "storeImage": storeImage,
      "exists": "yes"
    };
  }
}
