class Address {
  String? district;
  String? ward;
  String? province;
  String? fullAddress;
  Address(this.province, this.district, this.ward, this.fullAddress);

  factory Address.empty() => Address("", "", "", "");
}
