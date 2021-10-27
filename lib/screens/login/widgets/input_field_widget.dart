import 'package:flutter/material.dart';

class InputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;
  final bool isObscure;
  final TextInputType keyBoardType;
  final FormFieldValidator<String> validator;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmit;
  final int maxLength;

  const InputFieldWidget({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.isObscure,
    required this.keyBoardType,
    required this.validator,
    required this.maxLength,
    this.onEditingComplete,
    this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  bool obscureCtrl = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        counterText: '',
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isObscure
            ? IconButton(
                icon: obscureCtrl
                    ? const Icon(Icons.visibility_rounded)
                    : const Icon(Icons.visibility_off_rounded),
                onPressed: () {
                  setState(() {
                    obscureCtrl = !obscureCtrl;
                  });
                },
              )
            : null,
        isDense: true,
      ),
      obscureText: widget.isObscure ? obscureCtrl : false,
      keyboardType: widget.keyBoardType,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onSubmit,
      validator: widget.validator,
      maxLength: widget.maxLength,
    );
  }
}
