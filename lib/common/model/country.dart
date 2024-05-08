import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:youreal/services/hive_service.dart';

part 'country.g.dart';

@HiveType(typeId: HiveService.kProvinceTypeId)
class Province extends Equatable {
  @HiveField(0)
  final String id;
  // String? code;
  @HiveField(1)
  final String name;
  const Province({required this.id, required this.name});

  factory Province.fromConfig(dynamic parsedJson) {
    String id = "", name = "";
    if (parsedJson is Map) {
      id = parsedJson["id"].toString();
      // code = parsedJson["idProvince"];
      name = parsedJson["firstLevel"];
    }
    if (parsedJson is String) {
      id = parsedJson;
      // code = parsedJson;
      name = parsedJson;
    }
    return Province(id: id, name: name);
  }

  @override
  String toString() {
    return 'Province{id: $id, name: $name}';
  }

  @override
  List<Object?> get props => [name];
}

@HiveType(typeId: HiveService.kDistrictTypeId)
class District extends Equatable {
  @HiveField(0)
  final String id;
  // String? code;
  @HiveField(1)
  final String name;
  const District({required this.id, required this.name});

  factory District.fromConfig(dynamic parsedJson) {
    String id = "", name = "";

    if (parsedJson is Map) {
      id = parsedJson["id"].toString();

      name = parsedJson["secondLevel"];
    }
    if (parsedJson is String) {
      id = parsedJson;

      name = parsedJson;
    }
    return District(id: id, name: name);
  }

  @override
  List<Object?> get props => [name];
}

@HiveType(typeId: HiveService.kWardTypeId)
class Ward extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  const Ward({
    required this.id,
    required this.name,
  });

  factory Ward.fromConfig(dynamic parsedJson) {
    String id = "", name = "";

    if (parsedJson is Map) {
      id = parsedJson["id"].toString();

      name = parsedJson["thirdLevel"];
    }
    if (parsedJson is String) {
      id = parsedJson;

      name = parsedJson;
    }
    return Ward(id: id, name: name);
  }
  @override
  List<Object?> get props => [name];
}
