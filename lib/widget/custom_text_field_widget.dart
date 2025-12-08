


import 'package:ev_charging_app/Utils/CommonStyles.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/extentions.dart';
import 'package:ev_charging_app/widget/TextWithAsterisk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String title;
  final bool isFieldDisabled;
  final String hintText;
  final String? errorText;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final Function(FocusNode)? onFocusField;
  final Function(String)? onChange;
  final TextInputType textInputType;
  final int textFieldLines;
  final int maxCharacterLength;
  final double textFieldContainerHeight;
  final Widget? trailingIcon;
  final bool isFieldReadOnly;
  final Function()? onTapField;
  final TextEditingController textEditingController;
  final bool autoFocus;
  final bool isMaxCharacterHintVisible;
  final String? Function(String?)? validator;
  final bool isRequired;

  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final bool isMandatory;
  final Color fillColor;

  const CustomTextFieldWidget(
      {super.key,
      required this.title,
      this.errorText,
      this.isFieldDisabled = false,
      required this.hintText,
      required this.textEditingController,
      this.leadingIcon,
      this.onFocusField,
      this.onChange,
      this.textFieldLines = 0,
      this.maxCharacterLength = 0,
      this.textFieldContainerHeight = 48,
      this.trailingIcon,
      this.isFieldReadOnly = false,
      this.onTapField,
      this.autoFocus = false,
      this.textInputType = TextInputType.text,
      this.isMaxCharacterHintVisible = true,
      this.inputFormatters,
      this.isRequired = true,
      this.validator,
      this.suffixIcon,
      this.textCapitalization = TextCapitalization.none,
      this.autovalidateMode = AutovalidateMode.always,  this.isMandatory=true,  this.fillColor=CommonColors.white,});

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  final FocusNode _focusNode = FocusNode();
  final BorderSide enableBorder = BorderSide(
    color: CommonColors.background,
    // color: CraftColors.neutral20Color,
    width: 1.0,
  );
  final BorderRadius borderRadius = const BorderRadius.all(
    
    Radius.circular(8),
  );
  final BorderSide focusedBorder = const BorderSide(
     color: CommonColors.blue,
    width: 1.0,
  );

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        if (widget.onFocusField != null) {
          widget.onFocusField!(_focusNode);
        }
      });
    });
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void updateTextValue(String value) {
    setState(() {
      final cursorPosition = widget.textEditingController.selection;
      widget.textEditingController.text = value;
      widget.textEditingController.selection = cursorPosition.copyWith(
        baseOffset: cursorPosition.start,
        extentOffset: cursorPosition.start,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          if (widget.onFocusField != null) {
            widget.onFocusField!(_focusNode);
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _textFieldLabel(),
            8.0.heightBox,
            _textFieldWidget(),
            _getInputTextHintLength(widget.textEditingController.text),
            _errorTextWidget(),
          ],
        ),
      ),
    );
  }

  Widget _textFieldLabel() {
    return  
     TextWithAsterisk(text: widget.title,isAstrick: widget.isMandatory,);

      
  
  }

Widget _textFieldWidget() {
  return TextFormField(
     cursorColor: CommonColors.blue, 
    textCapitalization: widget.textCapitalization,
    autovalidateMode: widget.autovalidateMode,
    controller: widget.textEditingController,
    readOnly: widget.isFieldReadOnly || widget.onTapField != null,
    focusNode: _focusNode,
    enabled: !widget.isFieldDisabled,
    keyboardType: widget.textInputType,
    textInputAction: TextInputAction.done,
    inputFormatters: widget.inputFormatters,
    onEditingComplete: () {
      FocusScope.of(context).unfocus();
    },
    validator: widget.validator,
    showCursor: !widget.isFieldReadOnly && widget.onTapField == null,
    onTap: () async {
      if (widget.onTapField != null) {
        String value = await widget.onTapField!();
        updateTextValue(value);
      }
      _focusNode.requestFocus();
    },
    onChanged: (value) {
      setState(() {
        if (widget.onChange != null) {
          widget.onChange!(value);
        }
      });
    },
    decoration: InputDecoration(
      hintText: widget.hintText,
      hintStyle: CommonStyles.textFieldHint,
      errorStyle: CommonStyles.textFieldHint,
      counterText: "",
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
      focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
      disabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
      errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
      focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
      filled: true,
      fillColor: widget.fillColor,
      prefixIcon: widget.leadingIcon != null
          ? Container(
              margin: const EdgeInsets.only(right: 10, left: 10),
              child: widget.leadingIcon,
            )
          : null,
      prefixIconConstraints: const BoxConstraints(minHeight: 20, minWidth: 20, maxHeight: 40, maxWidth: 90),
      suffixIcon: widget.suffixIcon != null
          ? Container(
              margin: const EdgeInsets.only(right: 10, left: 10),
              child: widget.suffixIcon,
            )
          : null,
      suffixIconConstraints: const BoxConstraints(minHeight: 20, minWidth: 20, maxHeight: 40, maxWidth: 90),
      errorMaxLines: 3,
    ),
    style: CommonStyles.textFieldHeading,
    minLines: widget.textFieldLines == 0 ? 1 : widget.textFieldLines,
    maxLines: widget.textFieldLines == 0 ? 1 : widget.textFieldLines,
    maxLength: widget.maxCharacterLength > 0 ? widget.maxCharacterLength : null,
  );
}


  Widget _errorTextWidget() {
    return
     widget.errorText != null
        ? Container(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.errorText ?? "",
              // style: CraftStyles.tsErrorTextColorRedularS14,
              textAlign: TextAlign.start,
            ),
          )
        : 0.0.heightBox;
  }

  Widget _getInputTextHintLength(String? value) {
    int valueLength = 0;
    if (value != null) {
      valueLength = value.length;
    }
    return (widget.maxCharacterLength > 0 && widget.isMaxCharacterHintVisible)
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              "$valueLength/${widget.maxCharacterLength} characters",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        : 0.0.heightBox;
  }
}
