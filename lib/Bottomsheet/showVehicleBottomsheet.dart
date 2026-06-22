import 'package:HyCharge/Utils/commoncolors.dart';

import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/model/VehicleModel.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

void showAddVehicleBottomSheet(
    BuildContext context, VehicleModel selectedVehicle) {
  final controller = TextEditingController();

  // controller.text = selectedVehicle.vehicleName ?? "";
  final formKey = GlobalKey<FormState>();
  String? validateVehicleNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter vehicle number";
    }

    final vehicleNo = value.replaceAll(' ', '').toUpperCase();

    final vehicleRegex = RegExp(
      r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,3}[0-9]{4}$',
    );

    if (!vehicleRegex.hasMatch(vehicleNo)) {
      return "Enter valid vehicle number";
    }

    return null;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Center(
              child: const Text(
                "Enter your Vehicle Number",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFieldWidget(
                    textFieldContainerHeight: 60,
                    isMandatory: false,
                    title: "",
                    // CommonStrings.strVehicle,
                    hintText: CommonStrings.strVehicleNo,
                    textEditingController: controller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                    ],
                    textInputType: TextInputType.text,
                    validator: validateVehicleNumber,
                    onChange: (val) {
                      final upperCaseValue = val.toUpperCase();

                      if (upperCaseValue != controller.text) {
                        controller.value = TextEditingValue(
                          text: upperCaseValue,
                          selection: TextSelection.collapsed(
                            offset: upperCaseValue.length,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  Navigator.pop(context);

                  showSubmittedVehicleBottomSheet(context, selectedVehicle);
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                CommonStrings.strVehicleNote,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    },
  );
}

void showSubmittedVehicleBottomSheet(
    BuildContext context, VehicleModel selectedVehicle) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Center(
              child: const Text(
                "Congratulations !",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: const Text(
                "Vehicle Number successfully added",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Center(
              child: Lottie.asset(
                'assets/lottie/check.json',
                width: 100,
                height: 100,
                repeat: false,
                animate: true,
                fit: BoxFit.contain,
              ),
            ),
            //   Container(
            //   width: 60,
            //   height: 60,
            //   child: Image.asset(CommonImagePath.check),
            // ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    },
  );
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
