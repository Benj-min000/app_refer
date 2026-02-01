import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  final bool isObsecre;
  final bool enabled;

  const CustomTextField(
      {super.key,
      this.controller,
      this.data,
      this.hintText,
      this.isObsecre = true,
      this.enabled = true,
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
            spreadRadius: 2, 
            blurRadius: 5,   
            offset: const Offset(0, 2), 
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        
        enabled: enabled,
        controller: controller,
        obscureText: isObsecre,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(
            data,
            color: Colors.grey,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
