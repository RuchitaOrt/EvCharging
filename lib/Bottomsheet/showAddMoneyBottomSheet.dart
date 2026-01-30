import 'package:ev_charging_app/Provider/WalletProvider.dart';
import 'package:ev_charging_app/Request/AddWalletRequest.dart';
import 'package:ev_charging_app/Utils/AuthStorage.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonstrings.dart';
import 'package:ev_charging_app/widget/TextWithAsterisk.dart';
import 'package:ev_charging_app/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAddMoneyBottomSheet(BuildContext context) {
  final provider = context.read<WalletProvider>();
  final _amountController = TextEditingController();
  final _infoController = TextEditingController();
  String transactionType = "Credit"; // default

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
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Money",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Text(
              "Adding to Ev-Charging wallet",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
            ),
            // Dotted line
    SizedBox(
      height: 20, // spacing
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = 4.0; // width of each dash
          final dashWidth = 4.0; // spacing between dashes
          final dashCount = (constraints.maxWidth / (boxWidth + dashWidth)).floor();
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
            CustomTextFieldWidget(
              isMandatory: false,
              title: CommonStrings.strAmount,
              hintText: CommonStrings.strAmountHint,
              onChange: (val) {},
              textEditingController: _amountController,
              autovalidateMode: AutovalidateMode.disabled,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextWithAsterisk(text: "Transaction Type", isAstrick: false),

            // Row-style radio buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      transactionType = "Credit";
                    },
                    child: Row(
                      children: [
                        Radio<String>(
                          value: "Credit",
                          groupValue: transactionType,
                          activeColor: CommonColors.blue,
                          onChanged: (value) {
                            if (value != null) transactionType = value;
                          },
                        ),
                        const Text("Credit"),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   child: GestureDetector(
                //     onTap: () {
                //       transactionType = "Debit";
                //     },
                //     child: Row(
                //       children: [
                //         Radio<String>(
                //           value: "Debit",
                //            activeColor: CommonColors.blue,
                //           groupValue: transactionType,
                //           onChanged: (value) {
                //             if (value != null) transactionType = value;
                //           },
                //         ),
                //         const Text("Debit"),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 16),
            CustomTextFieldWidget(
              isMandatory: false,
              title: CommonStrings.strAdditionalInfo,
              hintText: CommonStrings.strAdditionalInfoHint,
              onChange: (val) {},
              textEditingController: _infoController,
              autovalidateMode: AutovalidateMode.disabled,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                   print("UserId: ");
                  final amount = double.tryParse(_amountController.text);
                  if (amount == null || amount <= 0) {
                    showToast("Please enter an amount ₹1 or more to proceed");
                  
                    return;
                  }
                  final userId = await AuthStorage.getUserId();
                  print("UserId: $userId");
                  provider.addCredits(
                    context,
                    AddWalletRequest(
                      userId: userId!,
                      amount: amount,
                      transactionType: transactionType,
                      paymentRecId: "razorpay_payment_id",
                      additionalInfo1: _infoController.text,
                    ),
                  );

                  Navigator.pop(ctx);
                },
                child: const Text(
                  "Proceed to Pay",
                  style: TextStyle(color: CommonColors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
