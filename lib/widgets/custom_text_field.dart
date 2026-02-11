import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFloating = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_onTextChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFloating = _focusNode.hasFocus || (widget.controller?.text.isNotEmpty ?? false);
    });
  }

  void _onTextChange() {
    setState(() {
      _isFloating = _focusNode.hasFocus || (widget.controller?.text.isNotEmpty ?? false);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        focusNode: _focusNode,
        style: TextStyle(
          fontSize: widget.fontSize, 
          color: Colors.black87,
        ),
        textAlignVertical: TextAlignVertical.center,
        enabled: widget.enabled,
        controller: widget.controller,
        obscureText: widget.isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          prefixIcon: widget.data != null ? Icon(
            widget.data,
            color: Colors.grey,
          ) : null,
          focusColor: Theme.of(context).primaryColor,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white,
          ),
          label: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: _isFloating ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ) : null,
            child: Text(
              widget.hintText!,
              style: TextStyle(
                color: _isFloating ? Theme.of(context).primaryColor : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
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
            gapPadding: 0,
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