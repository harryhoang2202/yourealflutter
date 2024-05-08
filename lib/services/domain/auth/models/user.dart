import 'package:intl/intl.dart';
import 'package:youreal/common/constants/general.dart';

class User {
  String? userId;
  List<Roles>? roles;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? phoneNumber;
  UserAddress? userAddress;
  @override
  String toString() {
    return 'User{userId: $userId, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, picture: $picture}';
  }

  String? picture;
  String get fullName => "$firstName $lastName";

  String getDob() {
    if (dateOfBirth == null) return "";
    final dateFm = DateFormat("dd/MM/yyyy");
    return dateFm.format(DateTime.parse(dateOfBirth!).toLocal());
  }

  User.fromJson(Map<String, dynamic> json) {
    try {
      userId = json["userId"];
      if (json['roles'] != null) {
        roles = <Roles>[];
        json['roles'].forEach((v) {
          roles!.add(Roles.fromJson(v));
        });
      }
      firstName = json['firstName'];
      lastName = json['lastName'];
      dateOfBirth = json['dateOfBirth'];
      picture = json['picture'];
      phoneNumber = json['phoneNumber'];
      userAddress = json['userAddress'] != null
          ? UserAddress.fromJson(json['userAddress'])
          : null;
    } catch (e, trace) {
      printLog("$e $trace");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['dateOfBirth'] = dateOfBirth;
    data['picture'] = picture;
    data['phoneNumber'] = phoneNumber;
    if (userAddress != null) {
      data['userAddress'] = userAddress!.toJson();
    }
    return data;
  }

  User(
      {this.userId,
      this.roles,
      this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.phoneNumber,
      this.picture,
      this.userAddress});

  User copyWith(
      {String? userId,
      List<Roles>? roles,
      String? firstName,
      String? lastName,
      String? dateOfBirth,
      String? phoneNumber,
      String? picture,
      UserAddress? userAddress}) {
    return User(
      userId: userId ?? this.userId,
      roles: roles ?? this.roles,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      picture: picture ?? this.picture,
      userAddress: userAddress ?? this.userAddress,
    );
  }
}

class Account {
  late int id;
  late String userId;
  String? name;

  Account({required this.id, required this.userId, this.name});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    return data;
  }
}

class UserAddress {
  int? id;
  String? userId;
  int? addressTypeId;
  int? subdivisionId;
  String? address;
  Subdivision? subdivision;

  UserAddress(
      {this.id,
      this.userId,
      this.addressTypeId,
      this.subdivisionId,
      this.address,
      this.subdivision});

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    addressTypeId = json['addressTypeId'];
    subdivisionId = json['subdivisionId'];
    address = json['address'];
    subdivision = json['subdivision'] != null
        ? Subdivision.fromJson(json['subdivision'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['addressTypeId'] = addressTypeId;
    data['subdivisionId'] = subdivisionId;
    data['address'] = address;
    if (subdivision != null) {
      data['subdivision'] = subdivision!.toJson();
    }
    return data;
  }
}

class Subdivision {
  int? id;
  String? firstLevel;
  String? secondLevel;
  String? thirdLevel;

  Subdivision({this.id, this.firstLevel, this.secondLevel, this.thirdLevel});

  Subdivision.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstLevel = json['firstLevel'];
    secondLevel = json['secondLevel'];
    thirdLevel = json['thirdLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstLevel'] = firstLevel;
    data['secondLevel'] = secondLevel;
    data['thirdLevel'] = thirdLevel;
    return data;
  }
}

class Roles {
  int? id;
  String? name;

  Roles({this.id, this.name});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
