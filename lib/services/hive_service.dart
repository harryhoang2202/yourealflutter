import 'package:hive_flutter/hive_flutter.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/country.dart';

class HiveService {
  static Future initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProvinceAdapter());
    Hive.registerAdapter(DistrictAdapter());
    Hive.registerAdapter(WardAdapter());

    cacheBox = await Hive.openBox(kCacheBox);
  }

  static const kProvinceKey = "PROVINCE_KEY";
  static const kProvinceTypeId = 1;
  static const kDistrictKey = "DISTRICT_KEY";
  static const kDistrictTypeId = 2;
  static const kWardKey = "WARD_KEY";
  static const kWardTypeId = 3;
  static late final Box cacheBox;
  static Future cacheProvince(List<Province> provinces) async {
    await cacheBox.put(kProvinceKey, provinces);
  }

  static List<Province>? get cachedProvinces {
    return (cacheBox.get(kProvinceKey) as List?)
        ?.map((e) => e as Province)
        .toList();
  }

  static Future cacheDistrict(
      String provinceId, List<District> districts) async {
    await cacheBox.put("DISTRICT_$provinceId", districts);
  }

  static List<District>? getCachedDistricts(String provinceId) {
    return (cacheBox.get("DISTRICT_$provinceId") as List?)
        ?.map((e) => e as District)
        .toList();
  }

  static Future cacheWards(
      String provinceId, String districtId, List<Ward> wards) async {
    await cacheBox.put("WARD_${provinceId}_$districtId", wards);
  }

  static List<Ward>? getCachedWards(
    String provinceId,
    String districtId,
  ) {
    return (cacheBox.get("WARD_${provinceId}_$districtId") as List?)
        ?.map((e) => e as Ward)
        .toList();
  }
}
