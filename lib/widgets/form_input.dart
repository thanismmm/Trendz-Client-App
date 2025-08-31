import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FormInput extends StatefulWidget {
  final String inputName;
  final String placeHolder;
  final String inputType;
  final TextEditingController inputController;
  final bool obscureText;
  final bool showPasswordRequirements;
  final String? originalPassword;

  const FormInput(
      {super.key,
      required this.inputName,
      required this.placeHolder,
      required this.inputController,
      required this.inputType,
      this.obscureText = false,
      this.showPasswordRequirements = false,
      this.originalPassword, String? Function(String value)? validator});

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  late bool _isObscured;
  String? _errorText;

  // Password validation states
  bool isUpperCase = false;
  bool isLowerCase = false;
  bool isNumber = false;
  bool isSpecialChar = false;
  bool isMinLength = false;

  bool _showRequirements =
      false; // New flag to control visibility of indicators

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorText = 'This field cannot be empty';
      } else if (widget.originalPassword != null &&
          value != widget.originalPassword) {
        _errorText = 'Passwords do not match';
      } else if (widget.originalPassword == null &&
          value != widget.inputController.text) {
        _errorText = 'Passwords do not match';
      } else {
        _errorText = null;
      }
    });
  }

  // Validate password dynamically
  void _validatePassword(String value) {
    setState(() {
      if (value.isNotEmpty) {
        _showRequirements = true; // Show when typing starts
      } else {
        _showRequirements = false; // Hide if the field is empty
      }

      isUpperCase = value.contains(RegExp(r'[A-Z]'));
      isLowerCase = value.contains(RegExp(r'[a-z]'));
      isNumber = value.contains(RegExp(r'[0-9]'));
      isSpecialChar = value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
      isMinLength = value.length >= 8;

      // If all conditions are met, clear the error
      if (isUpperCase &&
          isLowerCase &&
          isNumber &&
          isSpecialChar &&
          isMinLength) {
        _errorText = null;
      } else {
        _errorText = "Password does not meet all requirements";
      }
    });
  }

  // General input validation
  String? _validateInput(String value) {
    if (widget.inputType == 'password') {
      _validatePassword(value);
    }

    if (widget.inputType == 'confirmPassword') {
      _validateConfirmPassword(value);
    }

    if (widget.inputType == 'email') {
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email';
      }
    }

    if (value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  // Password rule widget
  Widget _passwordRequirement(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: isValid ? Colors.green : Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            obscureText: _isObscured,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.inputType == 'email'
                ? TextInputType.emailAddress
                : TextInputType.text,
            controller: widget.inputController,
            autofocus: true,
            style: Theme.of(context).textTheme.bodySmall,
            decoration: InputDecoration(
              suffixIcon: widget.inputType == "password" ||
                      widget.inputType == "confirmPassword"
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : null,
              labelText: widget.inputName,
              hintText: widget.placeHolder,
              hintStyle: Theme.of(context).textTheme.bodySmall,
              labelStyle: Theme.of(context).textTheme.bodySmall,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              errorText: _errorText,
            ),
            onChanged: (value) {
              _validateInput(value);
            },
          ),
          const SizedBox(height: 10),
          if (widget.inputType == 'password' &&
              widget.showPasswordRequirements &&
              _showRequirements) ...[
            _passwordRequirement("At least 8 characters", isMinLength),
            _passwordRequirement("Contains uppercase letter", isUpperCase),
            _passwordRequirement("Contains lowercase letter", isLowerCase),
            _passwordRequirement("Contains number", isNumber),
            _passwordRequirement("Contains special character", isSpecialChar),
          ],
        ],
      ),
    );
  }
}
