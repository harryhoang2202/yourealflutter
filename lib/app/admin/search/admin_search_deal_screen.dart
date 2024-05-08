import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/widget/sliver_header.dart';

import 'package:youreal/widgets_common/search_bar.dart';
import 'package:youreal/widgets_common/yr_back_button.dart';

import '../common/widgets/card_deal_approved.dart';
import 'bloc/admin_search_deal_cubit.dart';

class AdminSearchDealScreen extends StatefulWidget {
  const AdminSearchDealScreen({Key? key}) : super(key: key);
  static const id = "SearchDealScreen";
  static const searchBarHeroTag = "SearchDealScreen_SearchBar";

  @override
  State<AdminSearchDealScreen> createState() => _AdminSearchDealScreenState();
}

class _AdminSearchDealScreenState extends State<AdminSearchDealScreen> {
  final _key = GlobalKey<ScaffoldState>();

  final searchBarFocusNode = FocusNode();
  final searchController = TextEditingController();
  late AdminSearchDealCubit _cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 400));
      searchBarFocusNode.requestFocus();
    });
    _cubit = context.read<AdminSearchDealCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      appBar: _buildAppbar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: SliverPersistentHeaderCustomDelegate(
                minHeight: 0,
                maxHeight: 70.h,
                child: Hero(
                  tag: AdminSearchDealScreen.searchBarHeroTag,
                  child: SearchBar(
                    hintText: "Nhập từ khóa",
                    focusNode: searchBarFocusNode,
                    onSubmit: (val) async {
                      _cubit.onSearched(val);
                    },
                    controller: searchController,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h).toSliver(),
            BlocConsumer<AdminSearchDealCubit, AdminSearchDealState>(
              listener: (context, state) {},
              builder: (context, state) {
                return state.maybeWhen(
                  success: (result) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: CardDealApproved(
                            item: result[index],
                            showStatus: true,
                          ),
                        );
                      }, childCount: result.length),
                    );
                  },
                  empty: () {
                    return Container(
                      height: 0.5.sh,
                      alignment: Alignment.center,
                      child: Text(
                        "Không tìm thấy deal",
                        style: kText14Weight400_Light,
                      ),
                    ).toSliver();
                  },
                  initial: () {
                    return Container(
                      height: 0.5.sh,
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Vui lòng nhập từ khóa để bắt đầu tìm kiếm",
                        style: kText14Weight400_Light,
                      ),
                    ).toSliver();
                  },
                  orElse: () {
                    return const SizedBox.shrink().toSliver();
                  },
                );
              },
            ),
            SizedBox(height: 50.h).toSliver(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: yrColorPrimary,
      elevation: 0,
      centerTitle: true,
      leading: const YrBackButton(),
      title: Text(
        "Tìm kiếm deal",
        style: kText28_Light,
      ),
    );
  }
}
