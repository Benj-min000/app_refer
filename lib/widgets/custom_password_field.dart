import 'package:flutter/material.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:user_app/widgets/custom_error_message.dart';

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
  bool _isFloating = false;
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
    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_onTextChange);
  }

  void _updateFloatingState() {
    final hasContent = widget.controller?.text.isNotEmpty ?? false;
    final newFloating = _focusNode.hasFocus || hasContent;
    
    if (_isFloating != newFloating) {
      setState(() {
        _isFloating = newFloating;
      });
    }
  }

  void _onFocusChange() =>  _updateFloatingState();

  void _onTextChange() =>  _updateFloatingState();

  String _getStrengthLabel(double strength) {
    if (strength < 0.3) return 'Weak';
    if (strength < 0.7) return 'Medium';
    return 'Strong';
  }

  Color _getStrengthColor(double strength) {
    if (strength < 0.3) return Colors.red;
    if (strength < 0.7) return Colors.orange;
    return Colors.green;
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
            FancyPasswordField(
              validationRules: widget.isConfirmation ? {} : _passwordRules,
              strengthIndicatorBuilder: widget.isConfirmation 
                ? (strength) => const SizedBox.shrink() 
                : (strength) => _buildStrengthUI(strength),

              validationRuleBuilder: widget.isConfirmation 
                ? (rules, value) => const SizedBox.shrink() 
                : (rules, value) => _buildRulesUI(rules, value),
              focusNode: _focusNode,
              controller: widget.controller,
              decoration: InputDecoration(
                prefixIcon: widget.isConfirmation ? Icon(
                  Icons.lock_reset,
                  size: 30,
                  color: Colors.grey,
                ) : Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.all(20),
                focusColor: Theme.of(context).primaryColor,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.white,
                ),
                errorStyle: const TextStyle(
                  fontSize: 0,
                  height: 0,
                ),
                errorBorder: OutlineInputBorder(
                  gapPadding: 0,
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  gapPadding: 0,
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
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
                    widget.label ?? "Password",
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
              validator: (password) {               
                if (widget.isRequired && (password == null || password.isEmpty)) {
                  _setUIError("Password is required");
                  return "required";
                }
                
                if (!widget.isConfirmation) {
                  final allRulesMet = _passwordRules.every((rule) => rule.validate(password ?? ''));
                  if (!allRulesMet) {
                    _setUIError("Please meet all requirements");
                    return "invalid";
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

  Widget _buildStrengthUI(double strength) {
    if (strength == 0) strength += 0.1;     
      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Password Strength: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  _getStrengthLabel(strength),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _getStrengthColor(strength),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: strength,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getStrengthColor(strength),
                ),
                minHeight: 6,
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildRulesUI(Set<ValidationRule> rules, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Password Requirements:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ...rules.map(
              (rule) {
                final isValid = rule.validate(value);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isValid ? Colors.green : Colors.red.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isValid ? Colors.green : Colors.red,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          isValid ? Icons.check : Icons.close,
                          color: isValid ? Colors.white : Colors.red,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          rule.name,
                          style: TextStyle(
                            color: isValid ? Colors.green.shade700 : Colors.red.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
  }

}