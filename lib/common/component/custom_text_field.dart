import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;

  final dynamic hintText;
  final dynamic prefixIcon;
  final dynamic suffixIcon;

  const CustomTextField({Key? key, required this.controller, required this.labelText,this.hintText,this.prefixIcon,this.suffixIcon, this.keyboardType, this.obscureText = false, this.validator, this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration:
      decoration ??
          InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
    );
  }
}