import 'dart:async';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:youreal/app/deal/common/address_search_provider.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/model/address.dart';
import 'package:youreal/common/tools.dart';

class AddressAutoComplete extends StatefulWidget {
  const AddressAutoComplete({
    Key? key,
    required TextEditingController addressDetail,
    required this.address,
    required this.onLocationChanged,
  })  : _addressDetail = addressDetail,
        super(key: key);

  final TextEditingController _addressDetail;
  final Address address;
  final void Function(LatLng newLocation) onLocationChanged;

  @override
  _AddressAutoCompleteState createState() => _AddressAutoCompleteState();
}

class _AddressAutoCompleteState extends State<AddressAutoComplete>
    with SingleTickerProviderStateMixin {
  FocusNode textFieldFocusNode = FocusNode();
  AnimationController? animationController;
  Animation<double>? animation;
  AddressSearchProvider? providerNoListen;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    providerNoListen ??=
        Provider.of<AddressSearchProvider>(context, listen: false);

    providerNoListen!.currentAddress = widget.address;
    providerNoListen!.animationController = animationController;
    if (providerNoListen!.enableAutoComplete) {
      textFieldFocusNode.addListener(_onFocusChanged);
    }
  }

  void _onFocusChanged() async {
    if (textFieldFocusNode.hasFocus) {
      providerNoListen!.isSearching = textFieldFocusNode.hasFocus;
      await providerNoListen!.showSuggestion();
    } else {
      await providerNoListen!.hideSuggestion();
      providerNoListen!.isSearching = textFieldFocusNode.hasFocus;
    }
  }

  @override
  void dispose() {
    textFieldFocusNode.removeListener(_onFocusChanged);
    textFieldFocusNode.dispose();
    super.dispose();
  }

  List<Widget> buildSuggestion(List<String> address, BuildContext context) {
    if (address.isEmpty && widget._addressDetail.text.isNotEmpty) {
      return [
        Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Text(
            "Không tìm thấy kết quả nào",
            style: kText14Weight400_Hint,
          ),
        )
      ];
    } else if (address.isEmpty && widget._addressDetail.text.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Text(
            "Nhập địa chỉ chi tiết...",
            style: kText14Weight400_Hint,
          ),
        )
      ];
    }
    if (Provider.of<AddressSearchProvider>(context).isFetching) {
      return [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        )
      ];
    }

    while (address.length > 3) {
      address.removeLast();
    }

    return address
        .map((e) => ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(e),
            onTap: () async {
              providerNoListen!.onAddressSelected(e, widget.onLocationChanged);
              widget._addressDetail.text = e;
              await providerNoListen!.hideSuggestion();

              Utils.hideKeyboard(context);
            }))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    providerNoListen!.currentAddress = widget.address;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            focusNode: textFieldFocusNode,
            controller: widget._addressDetail,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.streetAddress,
            onFieldSubmitted: (val) {
              providerNoListen!
                  .onAddressSelected(val, widget.onLocationChanged);
            },
            maxLines: 1,
            onChanged: (value) async {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 1000), () {
                providerNoListen!
                    .onAddressSelected(value, widget.onLocationChanged);
                providerNoListen!.getPredictions(value);
              });
            },
            style: kText14Weight400_Dark,
            decoration: InputDecoration(
              isDense: true,
              labelStyle: kText14Weight400_Dark,
              fillColor: yrColorLight,
              filled: true,
              border: InputBorder.none,
              isCollapsed: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            ).allBorder(
              OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.w),
              ),
            ),
          ),
          Visibility(
            visible: Provider.of<AddressSearchProvider>(context).isSearching &&
                providerNoListen!.enableAutoComplete,
            child: CircularRevealAnimation(
              centerAlignment: Alignment.topCenter,
              animation: animation!,
              child: Container(
                margin: EdgeInsets.only(top: 10.h),
                constraints: BoxConstraints(minHeight: 60.h),
                color: yrColorLight,
                width: screenWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      buildSuggestion(providerNoListen!.suggestions!, context),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
