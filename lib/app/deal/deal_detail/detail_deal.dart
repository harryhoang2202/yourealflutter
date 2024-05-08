import 'package:flutter/material.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';

import 'admin_detail_deal.dart';
import 'appraiser_detail_deal.dart';
import 'investor_detail_deal.dart';

class DetailDealArs {
  final Deal deal;

  const DetailDealArs({
    required this.deal,
  });
}

class DetailDeal extends StatefulWidget {
  final Deal deal;

  static const id = "DetailDeal";

  const DetailDeal({
    Key? key,
    required this.deal,
  }) : super(key: key);

  @override
  _DetailDealState createState() => _DetailDealState();
}

class _DetailDealState extends State<DetailDeal> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (checkRole(context, RolesType.SuperAdmin) ||
          checkRole(context, RolesType.Admin)) {
        return AdminDetailDeal(deal: widget.deal);
      } else if (checkRole(context, RolesType.Appraiser)) {
        return AppraiserDetailDeal(deal: widget.deal);
      }
      return InvestorDetailDeal(deal: widget.deal);
    });
  }
}
