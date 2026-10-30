import 'package:HyCharge/Provider/PaymentProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void showAddMoneyBottomSheet(
  BuildContext context,
  String currentBalance,
) {
  final provider = context.read<WalletProvider>();
  final _amountController = TextEditingController();
  final _infoController = TextEditingController();

  String transactionType = "Credit";
  int? selectedAmount;

  const navy = Color(0xFF142B70);
  const lightBlue = Color(0xFFEAF0FC);
  const borderColor = Color(0xFFD9E1EF);
  const secondaryText = Color(0xFF667085);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(28),
      ),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 12,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDE2EA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Credits",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF111C38),
                                letterSpacing: -0.4,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Adding to Hycharge wallet",
                              style: TextStyle(
                                fontSize: 13,
                                color: secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "1 Credit = 1 INR",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: navy,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // Amount label
                  const Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: secondaryText,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Amount input
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: borderColor,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 18),
                        const Icon(
                          Icons.currency_rupee_rounded,
                          color: secondaryText,
                          size: 23,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: navy,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Enter amount",
                              hintStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF969EAA),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (_) {
                              setState(() {
                                selectedAmount = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Preset amounts
                  Row(
                    children: [500, 1000, 1500].map((amount) {
                      final isSelected = selectedAmount == amount;

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: amount == 1500 ? 0 : 8,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAmount = amount;
                                _amountController.text =
                                    amount.toString();
                              });
                            },
                            child: Container(
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? lightBlue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? navy
                                      : borderColor,
                                  width: 1.1,
                                ),
                              ),
                              child: Text(
                                "+$amount",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? navy : const Color(0xFF111C38),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 28),

                  // Wallet balance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Wallet credits",
                        style: TextStyle(
                          fontSize: 13,
                          color: secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "₹ $currentBalance",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111C38),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Proceed to pay
                  Consumer<PaymentProvider>(
                    builder: (context, paymentProvider, _) {
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: paymentProvider.loading
                              ? null
                              : () async {
                                  final amount = int.tryParse(
                                    _amountController.text,
                                  );

                                  final userId =
                                      await AuthStorage.getUserId();

                                  print("Proceed to pay");

                                  if (amount == null || amount <= 0) {
                                    FocusScope.of(context).unfocus();
                                    showToast(
                                      "Please enter an amount ₹1 or more",
                                    );
                                    return;
                                  }

                                  final key = context
                                      .read<PaymentProvider>()
                                      .razorpayKey;

                                  print("RAZORPAY");
                                  print("key");
                                  print(key);

                                  if (key != null && key.isNotEmpty) {
                                    final paymentProvider =
                                        context.read<PaymentProvider>();

                                    final response =
                                        await paymentProvider
                                            .createRazorpayOrder(
                                      context,
                                      amount: amount,
                                    );

                                    Navigator.pop(ctx);

                                    print("Proceed to pay $response");

                                    if (response?.success == true) {
                                      print(
                                        "Proceed to pay ${response!.data!.id}",
                                      );

                                      final orderId = response.data!.id;

                                      provider.razorpayHelper
                                          .openPaymentGateway(
                                        amount: amount,
                                        key: key,
                                        currency: "INR",
                                        orderID: orderId!,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            response?.message ??
                                                "Order failed",
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    print("Razorpay key error: ");
                                  }
                                },
                          child: paymentProvider.loading
                              ? const SizedBox(
                                  height: 21,
                                  width: 21,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Proceed to Pay",
                                  style: TextStyle(
                                     fontFamily: 'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
// void showAddMoneyBottomSheet(BuildContext context,String currentBalance) {
//   final provider = context.read<WalletProvider>();
//   final _amountController = TextEditingController();
//   final _infoController = TextEditingController();
//   String transactionType = "Credit"; // default
//   int? selectedAmount;
//   showModalBottomSheet(
//     context: context,
//     backgroundColor: CommonColors.white,
//     isScrollControlled: true, // keyboard won't cover
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (ctx) {
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(ctx).viewInsets.bottom,
//           left: 20,
//           right: 20,
//           top: 16,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Drag handle
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             /// Credits header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     const Text(
//                       "Credits",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.currency_rupee, size: 14),
//                     ),
//                   ],
//                 ),
//                 const Text(
//                   "1 Credit = 1 INR",
//                   style: TextStyle(fontSize: 12, color: Colors.black54),
//                 )
//               ],
//             ),

//             const SizedBox(height: 4),
//             const Text(
//               "Adding to Hycharge wallet",
//               style: TextStyle(fontSize: 10, color: Colors.black54),
//             ),

//             const SizedBox(height: 8),
//             SizedBox(
//               height: 20, // spacing
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   final boxWidth = 4.0; // width of each dash
//                   final dashWidth = 4.0; // spacing between dashes
//                   final dashCount =
//                       (constraints.maxWidth / (boxWidth + dashWidth)).floor();
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: List.generate(dashCount, (_) {
//                       return Container(
//                         width: boxWidth,
//                         height: 1,
//                         color: Colors.grey, // dotted color
//                       );
//                     }),
//                   );
//                 },
//               ),
//             ),

//             CustomTextFieldWidget(
//               textFieldContainerHeight: 40,
//               isMandatory: false,
//               title: CommonStrings.strAmount,
//               hintText: CommonStrings.strAmountHint,
//               onChange: (val) {},
//               textEditingController: _amountController,
//               autovalidateMode: AutovalidateMode.disabled,
//               textInputType: TextInputType.number,
//             ),
//             const SizedBox(height: 8),

         

//             StatefulBuilder(
//               builder: (context, setState) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [500, 1000, 1500].map((amt) {
//                     final isSelected = selectedAmount == amt;

//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 3),
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedAmount = amt;
//                             _amountController.text = amt.toString();
//                           });
//                         },
//                         child: Container(
//                           width: 60,
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color:
//                                 //  isSelected
//                                 //     ? Colors.blue.shade50
//                                 //     :
//                                 Colors.grey.shade100,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: isSelected
//                                   ? CommonColors.blue
//                                   : Colors.transparent,
//                               width: 1.2,
//                             ),
//                           ),
//                           child: Text(
//                             "+$amt",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 12,
//                               color: isSelected
//                                   ? CommonColors.blue
//                                   : Colors.black87,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),

//             const SizedBox(height: 16),
//             SizedBox(
//               height: 20, // spacing
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   final boxWidth = 4.0; // width of each dash
//                   final dashWidth = 4.0; // spacing between dashes
//                   final dashCount =
//                       (constraints.maxWidth / (boxWidth + dashWidth)).floor();
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: List.generate(dashCount, (_) {
//                       return Container(
//                         width: boxWidth,
//                         height: 1,
//                         color: Colors.grey, // dotted color
//                       );
//                     }),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),

//             /// Apply coupon
//             // Container(
//             //   padding: const EdgeInsets.all(14),
//             //   decoration: BoxDecoration(
//             //     color: CommonColors.neutral50,
//             //     borderRadius: BorderRadius.circular(10),
//             //     //  border: Border.all(color: CommonColors.neutral200),
//             //   ),
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Row(
//             //         children: [
//             //           Icon(Icons.local_offer, color: Colors.orange, size: 18),
//             //           SizedBox(width: 8),
//             //           Text(
//             //             "Apply Coupon",
//             //             style: TextStyle(
//             //                 fontWeight: FontWeight.w400, fontSize: 12),
//             //           ),
//             //         ],
//             //       ),
//             //       InkWell(
//             //         onTap: () {
//             //           // open coupons
//             //         },
//             //         child: DottedUnderlineText(
//             //           text: "View Coupons",
//             //           dotColor: CommonColors.blue,
//             //           style: const TextStyle(
//             //             fontSize: 10,
//             //             color: CommonColors.blue,
//             //             fontWeight: FontWeight.w400,
//             //           ),
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),

//             const SizedBox(height: 20),

//             /// Wallet credits summary
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children:  [
//                 Text(
//                   "Wallet credits",
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 Text(
//                   "₹ ${currentBalance}",
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             /// Proceed button
//             /// 
//           Consumer<PaymentProvider>(
//   builder: (context, paymentProvider, _) {
//                 return SizedBox(
//                   width: double.infinity,
//                   height: 38,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: CommonColors.blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () async {
                     
//                       final amount = int.tryParse(_amountController.text);
//                       final userId = await AuthStorage.getUserId();
//                        print("Proceed to pay");
                     
                
//                       if (amount == null || amount <= 0) {
//                         FocusScope.of(context).unfocus();
                        
//                         showToast("Please enter an amount ₹1 or more");
//                         return;
//                       }
                
                     
                
                     
//                         final key = context.read<PaymentProvider>().razorpayKey;
//                         print("RAZORPAY");
//                         print("key");
//                 print(key);
//                 if (key != null && key.isNotEmpty) {
//                   // final response = context.read<PaymentProvider>().createRazorpayOrder(context, amount: amount);
//                   //  provider.razorpayHelper.openPaymentGateway(amount: amount,key: key);
                
                
//                    final paymentProvider = context.read<PaymentProvider>();
                
//                 final response = await paymentProvider.createRazorpayOrder(
//                   context,
//                   amount: amount,
//                 );
//                   Navigator.pop(ctx); // close bottom sheet first
//                   print("Proceed to pay ${response}");
//                 if (response?.success == true) {
//                   print("Proceed to pay ${response!.data!.id}");
//                   final orderId = response!.data!.id;
//                  provider.razorpayHelper.openPaymentGateway(amount: amount,key: key,currency: "INR",orderID: orderId!);
//                   // razorpay.open({
//                   //   "key": razorpayKey,
//                   //   "order_id": orderId,
//                   //   "amount": response.data!.amount,
//                   //   "currency": response.data!.currency,
//                   // });
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(response?.message ?? "Order failed")),
//                   );
//                 }
                
//                 }else
//                 {
//                    print("Razorpay key error: ");
//                 }
                
                  
//                     },
//                     child:  paymentProvider.loading? SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           ): Text(
//                      "Proceed to Pay",
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 );
//               }
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       );
//     },
//   );
// }

class DottedUnderlineText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color dotColor;

  const DottedUnderlineText({
    super.key,
    required this.text,
    required this.style,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width + 4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: style),
        const SizedBox(height: 2),
        SizedBox(
          width: textWidth,
          height: 1,
          child: CustomPaint(
            painter: _DottedLinePainter(dotColor),
          ),
        ),
      ],
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;

  _DottedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const dashWidth = 3;
    const dashSpace = 3;

    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + dashWidth, 0),
        paint,
      );
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

