import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/form_appraisal/blocs/appraisal_bloc/appraisal_bloc.dart';
import 'package:youreal/app/form_appraisal/widget/license.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';

class AppraisalLegalDocs extends StatelessWidget {
  ///Chứng từ pháp lý
  const AppraisalLegalDocs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appraisalBloc =
        BlocProvider.of<AppraisalBloc>(context, listen: false);
    return BlocSelector<AppraisalBloc, AppraisalState, AppraisalDocType>(
      selector: (state) => state.docType,
      builder: (context, docType) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 8.w),
              alignment: Alignment.centerLeft,
              child: Text(
                "2. Chứng từ pháp lý",
                style: kText18_Light,
              ),
            ),
            SizedBox(
              height: 11.h,
            ),
            LicenseBuild(
              labelText: "Chứng từ pháp lý",
              kindLicense: AppraisalDocType.LegalDocument,
              enable: docType == AppraisalDocType.LegalDocument,
              onTap: () {
                appraisalBloc.add(const AppraisalDocTypeChanged(
                    AppraisalDocType.LegalDocument));
              },
            ),
            SizedBox(
              height: 18.h,
            ),
            LicenseBuild(
              labelText: "Chứng từ nội bộ",
              kindLicense: AppraisalDocType.InternalDocument,
              enable: docType == AppraisalDocType.InternalDocument,
              onTap: () {
                appraisalBloc.add(const AppraisalDocTypeChanged(
                    AppraisalDocType.InternalDocument));
              },
            ),
          ],
        );
      },
    );
  }
}
