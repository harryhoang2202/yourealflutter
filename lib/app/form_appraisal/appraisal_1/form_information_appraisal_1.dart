import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';
import 'package:youreal/app/deal/create_deal/blocs/create_deal_bloc.dart';

import 'package:youreal/app/form_appraisal/widget/appraisal_app_bar.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/model/status_state.dart';

import 'upload_file_appraisal.dart';
import 'widgets/appraisal_general_info.dart';

class FormInformationAppraisal_1 extends StatefulWidget {
  static const id = "FormInformationAppraisal_1";

  const FormInformationAppraisal_1({Key? key}) : super(key: key);

  @override
  _FormInformationAppraisal_1State createState() =>
      _FormInformationAppraisal_1State();
}

class _FormInformationAppraisal_1State
    extends State<FormInformationAppraisal_1> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateDealBloc, CreateDealState, StatusState>(
      selector: (state) => state.status,
      builder: (context, status) {
        return ModalProgressHUD(
          inAsyncCall: status is LoadingState,
          child: Scaffold(
            backgroundColor: yrColorPrimary,
            appBar: const AppraisalAppBar(),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 21.h,
                      ),

                      ///Các thông tin chung
                      const AppraisalGeneralInfo(),

                      SizedBox(
                        height: 16.h,
                      ),
                      const UploadFileAppraisal(),
                      SizedBox(
                        height: 16.h,
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: 50.h, left: 24.w, right: 24.w),
              child: PrimaryButton(
                text: 'Thêm file thẩm định',
                onTap: () {
                  Navigator.pop(context);
                },
                textColor: yrColorPrimary,
                backgroundColor: yrColorLight,
                verticalPadding: 20.h,
              ),
            ),
          ),
        );
      },
    );
  }
}
