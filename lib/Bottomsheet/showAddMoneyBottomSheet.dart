import 'package:HyCharge/Provider/PaymentProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Request/AddWalletRequest.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/widget/TextWithAsterisk.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAddMoneyBottomSheet(BuildContext context,String currentBalance) {
  final provider = context.read<WalletProvider>();
  final _amountController = TextEditingController();
  final _infoController = TextEditingController();
  String transactionType = "Credit"; // default
  int? selectedAmount;
  showModalBottomSheet(
    context: context,
    backgroundColor: CommonColors.white,
    isScrollControlled: true, // keyboard won't cover
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Credits header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Credits",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.currency_rupee, size: 14),
                    ),
                  ],
                ),
                const Text(
                  "1 Credit = 1 INR",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                )
              ],
            ),

            const SizedBox(height: 4),
            const Text(
              "Adding to Statiq wallet",
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),

            const SizedBox(height: 8),
            SizedBox(
              height: 20, // spacing
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final boxWidth = 4.0; // width of each dash
                  final dashWidth = 4.0; // spacing between dashes
                  final dashCount =
                      (constraints.maxWidth / (boxWidth + dashWidth)).floor();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(dashCount, (_) {
                      return Container(
                        width: boxWidth,
                        height: 1,
                        color: Colors.grey, // dotted color
                      );
                    }),
                  );
                },
              ),
            ),

            CustomTextFieldWidget(
              textFieldContainerHeight: 40,
              isMandatory: false,
              title: CommonStrings.strAmount,
              hintText: CommonStrings.strAmountHint,
              onChange: (val) {},
              textEditingController: _amountController,
              autovalidateMode: AutovalidateMode.disabled,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: 8),

         

            StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [500, 1000, 1500].map((amt) {
                    final isSelected = selectedAmount == amt;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAmount = amt;
                            _amountController.text = amt.toString();
                          });
                        },
                        child: Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                //  isSelected
                                //     ? Colors.blue.shade50
                                //     :
                                Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? CommonColors.blue
                                  : Colors.transparent,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            "+$amt",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: isSelected
                                  ? CommonColors.blue
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 16),
            SizedBox(
              height: 20, // spacing
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final boxWidth = 4.0; // width of each dash
                  final dashWidth = 4.0; // spacing between dashes
                  final dashCount =
                      (constraints.maxWidth / (boxWidth + dashWidth)).floor();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(dashCount, (_) {
                      return Container(
                        width: boxWidth,
                        height: 1,
                        color: Colors.grey, // dotted color
                      );
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            /// Apply coupon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CommonColors.neutral50,
                borderRadius: BorderRadius.circular(10),
                //  border: Border.all(color: CommonColors.neutral200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_offer, color: Colors.orange, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Apply Coupon",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      // open coupons
                    },
                    child: DottedUnderlineText(
                      text: "View Coupons",
                      dotColor: CommonColors.blue,
                      style: const TextStyle(
                        fontSize: 10,
                        color: CommonColors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Wallet credits summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  "Wallet credits",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  "₹ ${currentBalance}",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Proceed button
            /// 
          Consumer<PaymentProvider>(
  builder: (context, paymentProvider, _) {
                return SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      //   final amount = double.tryParse(_amountController.text);
                      //   if (amount == null || amount <= 0) {
                      //     showToast("Please enter an amount ₹1 or more");
                      //     return;
                      //   }
                      final amount = int.tryParse(_amountController.text);
                      final userId = await AuthStorage.getUserId();
                       print("Proceed to pay");
                      //  Navigator.pop(ctx);
                
                      if (amount == null || amount <= 0) {
                        showToast("Please enter an amount ₹1 or more");
                        return;
                      }
                
                     
                
                     
                        final key = context.read<PaymentProvider>().razorpayKey;
                        print("RAZORPAY");
                print(key);
                if (key != null && key.isNotEmpty) {
                  // final response = context.read<PaymentProvider>().createRazorpayOrder(context, amount: amount);
                  //  provider.razorpayHelper.openPaymentGateway(amount: amount,key: key);
                
                
                   final paymentProvider = context.read<PaymentProvider>();
                
                final response = await paymentProvider.createRazorpayOrder(
                  context,
                  amount: amount,
                );
                  Navigator.pop(ctx); // close bottom sheet first
                  print("Proceed to pay ${response}");
                if (response?.success == true) {
                  print("Proceed to pay ${response!.data!.id}");
                  final orderId = response!.data!.id;
                 provider.razorpayHelper.openPaymentGateway(amount: amount,key: key,currency: "INR",orderID: orderId!);
                  // razorpay.open({
                  //   "key": razorpayKey,
                  //   "order_id": orderId,
                  //   "amount": response.data!.amount,
                  //   "currency": response.data!.currency,
                  // });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response?.message ?? "Order failed")),
                  );
                }
                
                }
                
                  
                    },
                    child:  paymentProvider.loading? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ): Text(
                     "Proceed to Pay",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

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


//
    // builder: (ctx) {
    //   return Padding(
    //     padding: EdgeInsets.only(
    //       bottom: MediaQuery.of(ctx).viewInsets.bottom,
    //       top: 20,
    //       left: 20,
    //       right: 20,
    //     ),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const Text(
    //           "Add Money",
    //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    //         ),
    //         const Text(
    //           "Adding to Ev-Charging wallet",
    //           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
    //         ),
    //         // Dotted line
    // SizedBox(
    //   height: 20, // spacing
    //   child: LayoutBuilder(
    //     builder: (context, constraints) {
    //       final boxWidth = 4.0; // width of each dash
    //       final dashWidth = 4.0; // spacing between dashes
    //       final dashCount = (constraints.maxWidth / (boxWidth + dashWidth)).floor();
    //       return Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: List.generate(dashCount, (_) {
    //           return Container(
    //             width: boxWidth,
    //             height: 1,
    //             color: Colors.grey, // dotted color
    //           );
    //         }),
    //       );
    //     },
    //   ),
    // ),
             
    //         const SizedBox(height: 16),
    //         CustomTextFieldWidget(
    //           isMandatory: false,
    //           title: CommonStrings.strAmount,
    //           hintText: CommonStrings.strAmountHint,
    //           onChange: (val) {},
    //           textEditingController: _amountController,
    //           autovalidateMode: AutovalidateMode.disabled,
    //           textInputType: TextInputType.number,
    //         ),
    //         const SizedBox(height: 16),
    //         TextWithAsterisk(text: "Transaction Type", isAstrick: false),

    //         // Row-style radio buttons
    //         Row(
    //           children: [
    //             Expanded(
    //               child: GestureDetector(
    //                 onTap: () {
    //                   transactionType = "Credit";
    //                 },
    //                 child: Row(
    //                   children: [
    //                     Radio<String>(
    //                       value: "Credit",
    //                       groupValue: transactionType,
    //                       activeColor: CommonColors.blue,
    //                       onChanged: (value) {
    //                         if (value != null) transactionType = value;
    //                       },
    //                     ),
    //                     const Text("Credit"),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             // Expanded(
    //             //   child: GestureDetector(
    //             //     onTap: () {
    //             //       transactionType = "Debit";
    //             //     },
    //             //     child: Row(
    //             //       children: [
    //             //         Radio<String>(
    //             //           value: "Debit",
    //             //            activeColor: CommonColors.blue,
    //             //           groupValue: transactionType,
    //             //           onChanged: (value) {
    //             //             if (value != null) transactionType = value;
    //             //           },
    //             //         ),
    //             //         const Text("Debit"),
    //             //       ],
    //             //     ),
    //             //   ),
    //             // ),
    //           ],
    //         ),

    //         const SizedBox(height: 16),
    //         CustomTextFieldWidget(
    //           isMandatory: false,
    //           title: CommonStrings.strAdditionalInfo,
    //           hintText: CommonStrings.strAdditionalInfoHint,
    //           onChange: (val) {},
    //           textEditingController: _infoController,
    //           autovalidateMode: AutovalidateMode.disabled,
    //           textInputType: TextInputType.text,
    //         ),
    //         const SizedBox(height: 20),
    //         SizedBox(
    //           width: double.infinity,
    //           child: ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor: CommonColors.blue,
    //               padding: const EdgeInsets.symmetric(vertical: 12),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //             ),
    //             onPressed: () async {
    //                print("UserId: ");
    //               final amount = double.tryParse(_amountController.text);
    //               if (amount == null || amount <= 0) {
    //                 showToast("Please enter an amount ₹1 or more to proceed");
                  
    //                 return;
    //               }
    //               final userId = await AuthStorage.getUserId();
    //               print("UserId: $userId");
    //               provider.addCredits(
    //                 context,
    //                 AddWalletRequest(
    //                   userId: userId!,
    //                   amount: amount,
    //                   transactionType: transactionType,
    //                   paymentRecId: "razorpay_payment_id",
    //                   additionalInfo1: _infoController.text,
    //                 ),
    //               );

    //               Navigator.pop(ctx);
    //             },
    //             child: const Text(
    //               "Proceed to Pay",
    //               style: TextStyle(color: CommonColors.white),
    //             ),
    //           ),
    //         ),
    //         const SizedBox(height: 20),
    //       ],
    //     ),
    //   );
    // },