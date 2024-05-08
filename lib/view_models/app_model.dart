import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/country.dart' as country_model;
import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/services/hive_service.dart';
import 'package:youreal/services/services_api.dart';

class AppModel with ChangeNotifier {
  static const googleMapApiKey = 'AIzaSyAcJ6CcTB3zm7nRYGco3YkZMJZ4aJ47dm4';
  String locale = kAdvanceConfig['DefaultLanguage'].toString();
  bool darkTheme = false;
  bool isInit = false;
  bool _hideNavBar = false;

  final APIServices _services = APIServices();

  late User _user;

  User get user => _user;

  set user(User value) {
    _user = value;
    notifyListeners();
  }

  bool get hideNavBar => _hideNavBar;

  set hideNavBar(bool value) {
    _hideNavBar = value;
    notifyListeners();
  }

  Map<String, dynamic> appConfig = {};

  AppModel() {
    getConfig();
  }

  Future<bool> getConfig() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      locale = prefs.getString("language") ??
          kAdvanceConfig['DefaultLanguage'].toString();
      darkTheme = prefs.getBool("darkTheme") ?? false;
      isInit = true;
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> changeLanguage(String country, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      locale = country;
      await prefs.setString("language", country);

      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<void> updateTheme(bool theme) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      darkTheme = theme;
      await prefs.setBool("darkTheme", theme);
      notifyListeners();
    } catch (error) {
      printLog('[_getFacebookLink] error: ${error.toString()}');
    }
  }

  Future<List<country_model.Province>> loadProvinces() async {
    List<country_model.Province> provinces = HiveService.cachedProvinces ?? [];
    try {
      if (provinces.isEmpty) {
        final appJson = await _services.getProvinces();
        if (appJson == null) {
          return [];
        }
        final items = List<dynamic>.from(appJson);
        items.sort((a, b) => a["firstLevel"].compareTo(b["firstLevel"]));
        if (items.isNotEmpty) {
          for (var item in items) {
            provinces.add(country_model.Province.fromConfig(item));
          }
        }
        provinces = provinces.toSet().toList();
        await HiveService.cacheProvince(provinces);
      }
      notifyListeners();
    } catch (e, trace) {
      printLog("$e $trace");
      return [];
    }
    return provinces;
  }

  Future<List<country_model.District>> loadDistricts(
      country_model.Province province) async {
    List<country_model.District> districts =
        HiveService.getCachedDistricts(province.id) ?? [];
    try {
      if (districts.isEmpty) {
        final appJson = await _services.getDistrict(province.name);
        if (appJson == null) {
          return [];
        }
        final items = List<dynamic>.from(appJson);
        items.sort((a, b) => a["secondLevel"].compareTo(b["secondLevel"]));
        if (items.isNotEmpty) {
          for (var item in items) {
            districts.add(country_model.District.fromConfig(item));
          }
        }
        districts = districts.toSet().toList();

        await HiveService.cacheDistrict(province.id, districts);
      }
    } catch (e, trace) {
      printLog("$e $trace");
    }

    return districts;
  }

  Future<List<country_model.Ward>> loadWards(
      country_model.Province province, country_model.District district) async {
    List<country_model.Ward> wards =
        HiveService.getCachedWards(province.id, district.id) ?? [];
    try {
      if (wards.isEmpty) {
        final appJson = await _services.getWard(province.name, district.name);
        if (appJson == null) {
          return [];
        }
        final items = List<dynamic>.from(appJson);
        items.sort((a, b) => a["thirdLevel"].compareTo(b["thirdLevel"]));
        if (items.isNotEmpty) {
          for (var item in items) {
            wards.add(country_model.Ward.fromConfig(item));
          }
        }
        wards = wards.toSet().toList();

        await HiveService.cacheWards(province.id, district.id, wards);
      }
    } catch (e, trace) {
      printLog("$e $trace");
    }
    return wards;
  }
}
