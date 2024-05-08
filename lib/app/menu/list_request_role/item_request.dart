import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/menu/role/role_request_appraiser.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/common/tools.dart';

import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/services/services_api.dart';
import 'package:youreal/utils/blocs/lazy_load/lazy_load_bloc.dart';

import 'model/role_requiring.dart';

class ItemRequest extends StatelessWidget {
  final RoleRequiring item;
  const ItemRequest({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var request = await APIServices().getRoleRequiring(requestId: item.id!);
        Object? result;
        switch (item.roleId) {
          case 4:
            result = await Navigator.of(context, rootNavigator: true).pushNamed(
                RoleRequestAppraiser.id,
                arguments:
                    RoleRequestAppraiserArgs(request: request, isAdmin: true));
            break;
          default:
        }
        BlocProvider.of<LazyLoadBloc<RoleRequiring>>(context, listen: false)
            .add(LazyLoadRefreshed());
      },
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: yrColorLight,
          borderRadius: BorderRadius.circular(15.h),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Yêu cầu #${item.id}",
                  style: kText18_Primary,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "Yêu cầu vai trò ",
                            style: kText14Weight400_Primary,
                            children: [
                          TextSpan(
                            text: "${item.role}".toLowerCase(),
                            style: kText14_Primary,
                          )
                        ])),
                    SizedBox(height: 12.h),
                  ],
                ),
                Text(
                  "${item.status}",
                  style: kText14_Primary,
                ),
              ],
            ),
            Text(
              "Được tạo cách đây ${Utils.getDuration(DateTime.parse(item.createdTime!))}",
              style: kText14Weight400_Secondary2,
            ),
          ],
        ),
      ),
    );
  }
}
