import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:user_app/widgets/custom_error_message.dart';

class CustomPhoneField extends StatefulWidget {
  final PhoneController? controller;
  final String? label;
  
  const CustomPhoneField({
    super.key,
    this.controller,
    this.label
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  late FocusNode _focusNode;
  bool _isFloating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_onTextChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFloatingState();
    });
  }

  void _updateFloatingState() {
    final hasContent = widget.controller?.value.nsn.isNotEmpty ?? false;
    final newFloating = _focusNode.hasFocus || hasContent;
    
    if (_isFloating != newFloating) {
      setState(() {
        _isFloating = newFloating;
      });
    }
  }

  void _onFocusChange() {
    _updateFloatingState();
  }

  void _onTextChange() {
    _updateFloatingState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller?.removeListener(_onTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhoneFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            countrySelectorNavigator: const CountrySelectorNavigator.dialog(
              width: 400,
              showDialCode: true,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              focusColor: Theme.of(context).primaryColor,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              floatingLabelStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.white,
              ),
              errorStyle: TextStyle(
                fontSize: 0,
                height: 0,
              ),
              errorBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: _isFloating ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ) : null,
                child: Text(
                  widget.label ?? "Phone Number",
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
            validator: (phoneNumber) {
              final validators = PhoneValidator.compose([
                PhoneValidator.required(context),
                PhoneValidator.validMobile(context),
              ]);
              
              final error = validators(phoneNumber);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _errorMessage != error) {
                  setState(() => _errorMessage = error);
                }
              });
              return error;
            },
          ),
          CustomErrorMessage(errorMessage: _errorMessage),
        ],
      ),
    );
  }
}