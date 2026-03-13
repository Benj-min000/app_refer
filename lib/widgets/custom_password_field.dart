import 'package:flutter/material.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:user_app/widgets/custom_error_message.dart';
import 'package:user_app/extensions/extensions_import.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final bool isRequired;
  final bool isConfirmation;

  const CustomPasswordField({
    super.key,
    this.controller,
    this.label,
    this.isRequired = true,
    this.isConfirmation = false,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  late FocusNode _focusNode;
  String? _errorMessage;

  final Set<ValidationRule> _passwordRules = {
    DigitValidationRule(),
    UppercaseValidationRule(),
    LowercaseValidationRule(),
    SpecialCharacterValidationRule(),
    MinCharactersValidationRule(6),
    MaxCharactersValidationRule(12),
  };

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  void _setUIError(String? message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _errorMessage != message) {
        setState(() => _errorMessage = message);
      }
    });
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
          FancyPasswordField(
            validationRules: widget.isConfirmation ? {} : _passwordRules,
            strengthIndicatorBuilder: widget.isConfirmation
                ? (strength) => const SizedBox.shrink()
                : (strength) => _buildStrengthUI(strength, brand),
            validationRuleBuilder: widget.isConfirmation
                ? (rules, value) => const SizedBox.shrink()
                : (rules, value) => _buildRulesUI(rules, value, brand),
            focusNode: _focusNode,
            controller: widget.controller,
            style: const TextStyle(fontSize: 15, color: Color(0xFF21243D)),
            decoration: InputDecoration(
              hintText: widget.label,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Icon(
                widget.isConfirmation ? Icons.lock_reset : Icons.lock_outline,
                size: 20,
                color: _focusNode.hasFocus ? brand.navy : Colors.grey,
              ),
              suffixIconColor: Colors.grey,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Colors.white,
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
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
            ),
            validator: (password) {
              if (widget.isRequired && (password == null || password.isEmpty)) {
                _setUIError(context.l10n.password_is_required);
                return "req";
              }
              if (!widget.isConfirmation) {
                final allRulesMet = _passwordRules
                    .every((rule) => rule.validate(password ?? ''));
                if (!allRulesMet) {
                  _setUIError(context.l10n.password_does_not_meet_requirements);
                  return "inv";
                }
              }
              _setUIError(null);
              return null;
            },
          ),
          CustomErrorMessage(errorMessage: _errorMessage),
        ],
      ),
    );
  }

  Widget _buildStrengthUI(double strength, BrandColors brand) {
    if (strength == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: strength,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            strength < 0.4
                ? Colors.red
                : strength < 0.7
                    ? Colors.orange
                    : brand.accentGreen!,
          ),
          minHeight: 4,
        ),
      ),
    );
  }

  Widget _buildRulesUI(
      Set<ValidationRule> rules, String value, BrandColors brand) {
    if (value.isEmpty || !_focusNode.hasFocus) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...rules.map((rule) {
            final isValid = rule.validate(value);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(
                    isValid ? Icons.check_circle : Icons.circle_outlined,
                    size: 14,
                    color: isValid ? Colors.green : Colors.grey[400],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    rule.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: isValid ? Colors.green[700] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
