import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';

import 'file_item.dart';

class FileStorage extends StatefulWidget {
  const FileStorage({
    Key? key,
    required this.fileUrls,
  }) : super(key: key);
  final List<String> fileUrls;

  @override
  State<FileStorage> createState() => _FileStorageState();
}

class _FileStorageState extends State<FileStorage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user =
        (context.read<AuthBloc>().state as AuthStateAuthenticated).user;

    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return FileItem(
            url: widget.fileUrls[index],
            username: user.fullName,
          );
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 8.h,
            ),
        itemCount: widget.fileUrls.length);
  }

  @override
  bool get wantKeepAlive => true;
}
