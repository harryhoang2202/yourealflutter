import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/blocs/deal_document/deal_document_bloc.dart';
import 'package:youreal/app/deal/create_deal/widget/file_grid_view.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/widgets_common/yr_back_button.dart';

import '../deal_document/widgets/appraisal_documents.dart';
import '../deal_document/widgets/deal_document_by_category.dart';

class DealDocumentScreen extends StatelessWidget {
  static const id = "DealDocument";

  const DealDocumentScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yrColorPrimary,
      appBar: AppBar(
        backgroundColor: yrColorPrimary,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Các giấy tờ liên quan",
          style: kText28_Light,
        ),
        leading: const YrBackButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: BlocBuilder<DealDocumentBloc, DealDocumentState>(
                  builder: (context, state) {
                    final children = <Widget>[];
                    final list = state.docImages.entries;
                    for (var element in list) {
                      if (element.value.imagePathOrUrls.isEmpty &&
                          element.value.filePathOrUrls.isEmpty) {
                        continue;
                      }
                      final items = element.value;
                      //items.addAll([...items, ...items]);
                      children.addAll(
                        [
                          Text(
                            element.key.name.replaceFirst("*", ""),
                            style: kText18_Light,
                          ),
                          8.verSp,
                          if (element.value.imagePathOrUrls.isNotEmpty)
                            DealDocumentByCategory(
                                items: items.imagePathOrUrls),
                          8.verSp,
                          if (items.filePathOrUrls.isNotEmpty)
                            FileGridView(
                              docFiles: items.filePathOrUrls,
                              width: 0.9.sw,
                              shortFor: 37,
                              readOnly: true,
                            ),
                          24.verSp,
                        ],
                      );
                    }

                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      children: children,
                    );
                  },
                ),
              ),
            ),
            BlocSelector<DealDocumentBloc, DealDocumentState, List<String>>(
              selector: (state) => state.appraisalFiles,
              builder: (context, appraisalFiles) {
                return AppraisalDocuments(
                  appraisalFiles: appraisalFiles,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
