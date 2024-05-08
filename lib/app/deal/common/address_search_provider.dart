import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/address.dart';

import 'package:youreal/services/services_api.dart';

class AddressSearchProvider extends ChangeNotifier {
  bool _isSearching = false;

  bool get isSearching => _isSearching;

  final bool enableAutoComplete;

  AddressSearchProvider({required this.enableAutoComplete});

  set isSearching(val) {
    _isSearching = val;
    notifyListeners();
  }

  Address currentAddress = Address("", "", "", "");
  GoogleMapController? controller;
  LatLng selectedLocation = const LatLng(10.8468936, 106.6408852);
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  set isFetching(val) {
    _isFetching = val;
    notifyListeners();
  }

  AnimationController? animationController;
  final APIServices _services = APIServices();
  List<String>? suggestions = [];

  Future onAddressSelected(
      String address, void Function(LatLng latlng) onLocationChanged,
      {bool animate = true}) async {
    List<double>? latLng = await _services.geoCoding(
        "$address ${currentAddress.ward} ${currentAddress.district} ${currentAddress.province}");
    if (latLng != null) {
      onLocationChanged(LatLng(latLng[0], latLng[1]));
      printLog("Create deal address latLng: ${latLng[0]} ${latLng[1]}");

      selectedLocation = LatLng(latLng[0], latLng[1]);
      if (animate) {
        controller!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                  latLng[0],
                  latLng[1],
                ),
                tilt: 0,
                zoom: 14.5),
          ),
        );
        notifyListeners();
      }
    } else {
      printLog("Create deal address latLng not found");
    }
  }

  Future getPredictions(String input) async {
    if (input.isEmpty) {
      suggestions!.clear();
      notifyListeners();
      return;
    }
    isFetching = true;
    final findKeyword =
        "$input ${currentAddress.ward} ${currentAddress.district} ${currentAddress.province}";
    suggestions = await _services.fetchPredictions(findKeyword);

    suggestions ??= [];
    isFetching = false;
  }

  Future showSuggestion() async {
    await animationController!.forward();
  }

  Future hideSuggestion() async {
    await animationController!.reverse();
  }
}
