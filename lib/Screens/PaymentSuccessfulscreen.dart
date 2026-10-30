
// import 'package:flutter/material.dart';
// import 'package:HyCharge/Provider/WalletProvider.dart';
// import 'package:provider/provider.dart';

// class PaymentSuccessfulScreen extends StatelessWidget {
//   const PaymentSuccessfulScreen({super.key});

//   static const Color navy = Color(0xFF142B70);
//   static const Color pageBackground = Color(0xFFF5F7F9);
//   static const Color secondaryText = Color(0xFF667085);
//   static const Color successGreen = Color(0xFF008942);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: pageBackground,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 24,
//             vertical: 20,
//           ),
//           child: Column(
//             children: [
//               const Spacer(flex: 3),

//               // Success icon
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFD7F9DE),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check_rounded,
//                   color: successGreen,
//                   size: 42,
//                 ),
//               ),

//               const SizedBox(height: 22),

//               const Text(
//                 'Credits added',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: -0.5,
//                   color: Color(0xFF111C38),
//                 ),
//               ),

//               const SizedBox(height: 6),

//               const Text(
//                 'Adding to Hycharge wallet',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: secondaryText,
//                 ),
//               ),

//               const SizedBox(height: 28),

//               // Wallet balance card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 18,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: navy.withValues(alpha: 0.07),
//                       blurRadius: 18,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: Consumer<WalletProvider>(
//                   builder: (context, walletProvider, _) {
//                     // Replace this with your actual refreshed balance
//                     // getter if your WalletProvider exposes one.
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Wallet credits',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: secondaryText,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         const Text(
//                           'Updated wallet balance',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: secondaryText,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),

//               const Spacer(flex: 5),

//               // Done button
//               SizedBox(
//                 width: double.infinity,
//                 height: 58,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).popUntil(
//                       (route) => route.isFirst,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: navy,
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(28),
//                     ),
//                   ),
//                   child: const Text(
//                     'Done',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
