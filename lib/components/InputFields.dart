import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatelessWidget { // Basic Small Input Text Field
  const InputField({
    super.key,
    required this.InputController,
    required this.hint,
    required this.height,
    this.suffix,
    this.searchFocusNode,
    this.onSubmitted,
    this.onChanged,
    this.obscureText = false,
  });

  final TextEditingController InputController;
  final String hint;
  final int height;
  final IconButton? suffix;
  final FocusNode? searchFocusNode;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      focusNode: searchFocusNode,
      maxLines: height,
      minLines: height,
      controller: InputController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Color(0xff1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
        suffixIcon: suffix,
      ),
      onSubmitted: onSubmitted,
      onChanged: onChanged,
    );
  }
}
