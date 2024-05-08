import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';

class PopupDoc extends StatefulWidget {
  final Function(DealDocumentType) onSelect;
  final DealDocumentType initialType;
  final DealDocumentCategory category;

  const PopupDoc(
      {Key? key,
      required this.onSelect,
      required this.initialType,
      required this.category})
      : super(key: key);

  @override
  _PopupDocState createState() => _PopupDocState();
}

class _PopupDocState extends State<PopupDoc> {
  late List<Item> listSelect;

  @override
  void initState() {
    super.initState();
    if (widget.category == DealDocumentCategory.RealEstate) {
      listSelect = [
        Item(
            DealDocumentType.SoDo, widget.initialType == DealDocumentType.SoDo),
        Item(DealDocumentType.HopDongMuaBan,
            widget.initialType == DealDocumentType.HopDongMuaBan),
        Item(DealDocumentType.HopDongGopVon,
            widget.initialType == DealDocumentType.HopDongGopVon),
        Item(DealDocumentType.QuyetDinhPheDuyet,
            widget.initialType == DealDocumentType.QuyetDinhPheDuyet),
        // Item(DealImageType.SoHong, widget.initialType == DealImageType.SoHong),
        // Item(DealImageType.GiayChungNhan,
        //     widget.initialType == DealImageType.GiayChungNhan),
        Item(DealDocumentType.BanTKCT,
            widget.initialType == DealDocumentType.BanTKCT),
        Item(
            DealDocumentType.GPXD, widget.initialType == DealDocumentType.GPXD),

        Item(DealDocumentType.ChungTuKhac,
            widget.initialType == DealDocumentType.ChungTuKhac),
        // Item(DealImageType.GiaySDDat,
        //     widget.initialType == DealImageType.GiaySDDat),
      ];
    } else {
      listSelect = [
        Item(
            DealDocumentType.CMND, widget.initialType == DealDocumentType.CMND),
        Item(DealDocumentType.CanCuocCD,
            widget.initialType == DealDocumentType.CanCuocCD),
        Item(DealDocumentType.SoHoKhau,
            widget.initialType == DealDocumentType.SoHoKhau),
        Item(DealDocumentType.Passport,
            widget.initialType == DealDocumentType.Passport),
        Item(
            DealDocumentType.BHYT, widget.initialType == DealDocumentType.BHYT),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.h),
          topLeft: Radius.circular(15.h),
        ),
        color: yrColorLight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 6.h,
            width: 148.w,
            margin: EdgeInsets.only(top: 14.h),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(15.h)),
            ),
          ),
          SizedBox(height: 16.h),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listSelect.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    for (var i in listSelect) {
                      i.isSelected = false;
                    }
                    setState(() {
                      listSelect[index].isSelected = true;
                    });
                    widget.onSelect(listSelect[index].type);
                  },
                  child: Container(
                    height: 50.h,
                    color: listSelect[index].isSelected
                        ? yrColorPrimary
                        : yrColorLight,
                    padding: EdgeInsets.only(left: 16.w),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      listSelect[index].type.name,
                      style: listSelect[index].isSelected
                          ? kText14_Light
                          : kText14_Primary,
                    ),
                  ),
                );
              }),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }
}

class Item {
  late DealDocumentType type;
  late bool isSelected;

  Item(this.type, this.isSelected);
}
