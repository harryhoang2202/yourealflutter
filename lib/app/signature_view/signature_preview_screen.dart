// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
//
// import 'package:youreal/common/config/color_config.dart';

// class SignaturePreviewScreen extends StatelessWidget {
//   static const id = "SignaturePreviewScreen";
//   final Uint8List signature;

//   const SignaturePreviewScreen({
//     Key? key,
//     required this.signature,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         backgroundColor: yrColorPrimary,
//         appBar: AppBar(
//           leading: const CloseButton(),
//           title: const Text('Store Signature'),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.done),
//               onPressed: () => storeSignature(context),
//             ),
//             SizedBox(width: 8.w),
//           ],
//         ),
//         body: Center(
//           child: Image.memory(signature, width: double.infinity),
//         ),
//       );

//   Future storeSignature(BuildContext context) async {
//     final file = File.fromRawPath(signature);
//   }
// }
