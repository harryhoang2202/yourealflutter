import 'package:flutter/material.dart';
import 'package:youreal/common/constants/extensions.dart';

import 'role_req_text_field.dart';

class RoleReqGeneralInfo extends StatelessWidget {
  const RoleReqGeneralInfo({
    Key? key,
    required this.nameController,
    required this.ageController,
    required this.emailController,
    required this.addressController,
    required this.phoneController,
  }) : super(key: key);
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Họ tên
        RoleReqTextField(
          controller: nameController,
          readOnly: true,
          title: "Họ và tên:",
          inputType: TextInputType.name,
        ),
        8.verSp,

        //Tuổi
        RoleReqTextField(
          controller: ageController,
          readOnly: true,
          title: 'Tuổi:',
          inputType: const TextInputType.numberWithOptions(),
        ),
        8.verSp,

        ///Số điện thoại
        RoleReqTextField(
          controller: phoneController,
          readOnly: true,
          title: "Số điện thoại:",
          inputType: const TextInputType.numberWithOptions(),
        ),
        8.verSp,

        ///Email
        RoleReqTextField(
          controller: emailController,
          title: "Email:",
          inputType: TextInputType.emailAddress,
        ),
        8.verSp,

        /// Địa chỉ
        RoleReqTextField(
          controller: addressController,
          title: "Địa chỉ:",
          inputType: TextInputType.streetAddress,
          maxLine: null,
        ),
        8.verSp,
      ],
    );
  }
}
