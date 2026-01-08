// import 'package:flutter/material.dart';
// import 'package:klump_mobile/features/checkout/checkout.dart';
// import 'package:provider/provider.dart';

// class StanbicInformation extends StatelessWidget {
//   const StanbicInformation({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         return SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minWidth: constraints.maxWidth,
//               minHeight: constraints.maxHeight,
//             ),
//             child: IntrinsicHeight(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 26),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const YSpace(32.6),
//                     Align(
//                       child: Image.asset(
//                         KAssets.cStanbicLogo,
//                         height: 45,
//                         width: 38.45,
//                       ),
//                     ),
//                     const YSpace(22),
//                     KCHeadline3('Items needed to sign up'),
//                     const YSpace(8),
//                     KCHeadline5(
//                       'These are the requirements needed to sign up with Klump. Please read carefully before you proceed.',
//                       height: 1.6,
//                     ),
//                     const YSpace(22),
//                     const SignupItemTile(
//                       title: 'Bank Account Number',
//                       body:
//                           'The name on the account must match the name on your BVN',
//                       bodyLines: 2,
//                     ),
//                     const SignupItemTile(
//                       title: 'Bank Verification Number (BVN)',
//                       body: 'It must match name on your government ID ',
//                       bodyLines: 1,
//                     ),
//                     const SignupItemTile(
//                       title: 'Valid Government Issued ID',
//                       body:
//                           'International Passport, Driver’s License, National ID Slip.',
//                       bodyLines: 1,
//                     ),
//                     const SignupItemTile(
//                       title: 'Image Upload (JPEG or PNG format)',
//                       body: 'Maximum image upload size: 5MB',
//                       bodyLines: 1,
//                     ),
//                     const SignupItemTile(
//                       title: 'Phone number & Email',
//                       body: 'An active contact information for verification',
//                       bodyLines: 1,
//                       lastItem: true,
//                     ),
//                     const YSpace(25),
//                     const Spacer(),
//                     KCPrimaryButton(
//                       title: 'Create Account',
//                       onTap: () {},
//                     ),
//                     const YSpace(16),
//                     KCSecondaryButton(
//                       title: 'Have an account? Log in',
//                       onTap: () =>
//                           Provider.of<KCChangeNotifier>(context, listen: false)
//                               .nextPage(),
//                     ),
//                     const YSpace(59)
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class SignupItemTile extends StatelessWidget {
//   const SignupItemTile({
//     super.key,
//     required this.title,
//     required this.body,
//     required this.bodyLines,
//     this.lastItem = false,
//   });

//   final String title, body;
//   final int bodyLines;
//   final bool lastItem;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 24 + (bodyLines * 14) + 16,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             children: [
//               Container(
//                 height: 11.34,
//                 width: 11.34,
//                 decoration: BoxDecoration(
//                   color: KCColors.primary,
//                   borderRadius: BorderRadius.circular(30.2483),
//                 ),
//               ),
//               if (!lastItem)
//                 Expanded(
//                   child: Container(
//                     width: 1.5,
//                     color: KCColors.grey1,
//                   ),
//                 )
//             ],
//           ),
//           const XSpace(8.66),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 20,
//                   child: KAutoSizedText(
//                     title,
//                     color: KCColors.black1,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 const YSpace(4),
//                 SizedBox(
//                   height: bodyLines * 14,
//                   child: KAutoSizedText(
//                     body,
//                     fontSize: 14,
//                     color: KCColors.black1,
//                     height: 1.3657,
//                   ),
//                 ),
//                 const YSpace(16),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
