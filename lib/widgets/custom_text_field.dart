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
      this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5), 
            spreadRadius: 1, 
            blurRadius: 4,   
            offset: const Offset(0, 2), 
          ),
        ],
      ),
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.all(6),
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
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12),
          prefixIcon: data != null ? Icon(
            data,
            color: Colors.grey,
          ) : null,
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: fontSize - 1,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          )
        ),
      ),
    );
  }
}
