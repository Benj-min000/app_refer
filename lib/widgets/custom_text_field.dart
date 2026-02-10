import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  final bool isObsecure;
  final bool enabled;
  final double fontSize;

  const CustomTextField(
      {super.key,
      this.controller,
      this.data,
      this.hintText,
      this.isObsecure = true,
      this.enabled = true,
      this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: TextFormField(
        style: TextStyle(
          fontSize: fontSize, 
          color: Colors.black87,
        ),
        textAlignVertical: TextAlignVertical.center,
        enabled: enabled,
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          prefixIcon: data != null ? Icon(
            data,
            color: Colors.grey,
          ) : null,
          focusColor: Theme.of(context).primaryColor,
          labelText: hintText,
          labelStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
