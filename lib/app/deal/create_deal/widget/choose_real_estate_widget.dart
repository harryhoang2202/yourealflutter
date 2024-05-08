import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youreal/app/deal/create_deal/blocs/create_deal_bloc.dart';

import 'package:youreal/app/deal/create_deal/widget/item_kind_of_real.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';

class ChooseRealEstateWidget extends StatelessWidget {
  const ChooseRealEstateWidget({
    Key? key,
    required this.createDealBloc,
  }) : super(key: key);

  final CreateDealBloc createDealBloc;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateDealBloc, CreateDealState, RealEstateType>(
      selector: (state) => state.realEstateType,
      builder: (context, realEstateType) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final type in RealEstateType.values)
                if (type != RealEstateType.other &&
                    type != RealEstateType.initial)
                  ItemKindOfReal(
                    name: type.name,
                    icon: type.image,
                    type: type,
                    value: realEstateType,
                    onTap: () {
                      createDealBloc.add(
                        CreateDealRealEstateTypeChanged(type),
                      );
                    },
                  ),
            ],
          ),
        );
      },
    );
  }
}
