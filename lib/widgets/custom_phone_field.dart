import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:user_app/widgets/custom_error_message.dart';
import 'package:user_app/extensions/brand_color_ext.dart';

class CustomPhoneField extends StatefulWidget {
  final PhoneController? controller;
  final String? label;

  const CustomPhoneField({
    super.key,
    this.controller,
    this.label,
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  late FocusNode _focusNode;
  String? _errorMessage;

  final Color textDark = const Color(0xFF21243D);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandColors>()!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(
                color: Colors.grey,
                size: 20,
              ),
              textTheme: Theme.of(context).textTheme.copyWith(
                    bodyMedium: TextStyle(color: textDark, fontSize: 15),
                  ),
            ),
            child: PhoneFormField(
              focusNode: _focusNode,
              controller: widget.controller,
              style: TextStyle(fontSize: 15, color: textDark),
              cursorColor: textDark,
              countrySelectorNavigator: const CountrySelectorNavigator.dialog(
                width: 400,
                showDialCode: true,
              ),
              decoration: InputDecoration(
                prefixIconColor: Colors.grey,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                filled: true,
                fillColor: Colors.white,
                hintText: widget.label,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                errorStyle: const TextStyle(fontSize: 0, height: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: brand.navy!, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                ),
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
          ),
          CustomErrorMessage(errorMessage: _errorMessage),
        ],
      ),
    );
  }
}