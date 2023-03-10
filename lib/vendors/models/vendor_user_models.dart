class VendorUserModel {
  final bool approved;
  final String bussinessName;
  final String cityValue;
  final String countryValue;
  final String email;
  final String phoneNumber;
  final String stateValue;
  final String storeImage;
  final String taxNumber;
  final String taxRegistered;

  VendorUserModel({
    required this.approved,
    required this.bussinessName,
    required this.cityValue,
    required this.countryValue,
    required this.email,
    required this.phoneNumber,
    required this.stateValue,
    required this.storeImage,
    required this.taxNumber,
    required this.taxRegistered,
  });

  VendorUserModel.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved']! as bool,
          bussinessName: json['bussinessName'] != null
              ? json['bussinessName']! as String
              : '',
          cityValue:
              json['cityValue'] != null ? json['cityValue']! as String : '',
          countryValue: json['countryValue'] != null
              ? json['countryValue']! as String
              : '',
          email: json['email'] != null ? json['email']! as String : '',
          phoneNumber:
              json['phoneNumber'] != null ? json['phoneNumber']! as String : '',
          stateValue:
              json['stateValue'] != null ? json['stateValue']! as String : '',
          storeImage:
              json['storeImage'] != null ? json['storeImage']! as String : '',
          taxNumber:
              json['taxNumber'] != null ? json['taxNumber']! as String : '',
          taxRegistered: json['taxRegistered'] != null
              ? json['taxRegistered']! as String
              : '',
        );

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'bussinessName': bussinessName,
      'cityValue': cityValue,
      'countryValue': countryValue,
      'email': email,
      'phoneNumber': phoneNumber,
      'stateValue': stateValue,
      'storeImage': storeImage,
      'taxNumber': taxNumber,
      'taxRegistered': taxRegistered,
    };
  }
}
