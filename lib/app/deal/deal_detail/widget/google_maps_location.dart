import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/general.dart';

import 'map_widget.dart';

class GoogleMapsLocation extends StatelessWidget {
  const GoogleMapsLocation({
    Key? key,
    required this.deal,
  }) : super(key: key);
  final Deal deal;

  @override
  Widget build(BuildContext context) {
    final position = deal.realEstate?.position?.content?.split(",");
    late LatLng latLng;
    if (position?.isEmpty == true || position == null) {
      latLng = MapWidget.kGooglePosition.target;
      printLog("Detail deal location error: Position not found");
    } else {
      final lat = double.parse(position.first);
      final lng = double.parse(position.last);
      latLng = LatLng(lat, lng);
    }
    return Column(
      children: [
        Container(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "Vị trí",
            style: kText18_Light,
          ),
        ),
        Container(
          height: 177.h,
          width: screenWidth,
          margin: EdgeInsets.only(top: 5.h),
          child: MapWidget(
            onMapCreated: (controller) {},
            location: latLng,
          ),
        ),
      ],
    );
  }
}
