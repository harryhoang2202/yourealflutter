import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:youreal/app/chats/blocs/chat_input_bloc/chat_input_bloc.dart';
import 'package:youreal/app/deal/deal_detail/widget/map_widget.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';

class LocationView extends StatelessWidget {
  LocationView({Key? key}) : super(key: key);

  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Row(
            children: [
              Flexible(
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (val) {},
                  maxLines: 1,
                  onChanged: (value) async {},
                  style: kText14Weight400_Dark,
                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: yrColorLight,
                    filled: true,
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintStyle: kText18Weight400_Hint,
                    hintText: "Tìm địa điểm",
                    contentPadding: EdgeInsets.all(8.w),
                    suffixIcon: SvgPicture.asset(
                      "assets/icons/ic_search.svg",
                      color: yrColorPrimary,
                      fit: BoxFit.fitHeight,
                    ),
                    suffixIconConstraints: BoxConstraints.tightFor(
                      height: 20.w,
                      width: 28.w,
                    ),
                  ).allBorder(
                    OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: yrColorLight,
                ),
                child: Text(
                  "Xong",
                  style: kText18Weight400_Light,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Flexible(
          child: BlocSelector<ChatInputBloc, ChatInputState, SlidingPanelState>(
            selector: (state) => state.panelState,
            builder: (context, panelState) {
              double height = 177.h;
              if (panelState == SlidingPanelState.Opened) {
                height = 1.sh;
              }

              return SizedBox(
                height: height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    onTap: (LatLng latLng) async {},
                    markers: const <Marker>{},
                    initialCameraPosition: MapWidget.kGooglePosition,
                    onMapCreated: (GoogleMapController controller) {},
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
