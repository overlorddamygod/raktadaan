import 'package:flutter/material.dart';
import 'package:raktadaan/src/constants/app_themes.dart';

class PasswordInput extends StatefulWidget {
  final String labelText;
  final Function(String?) onSaved;
  final Function(String?)? onChanged;
  final Function(String?)? validator;
  const PasswordInput({
    super.key,
    required this.labelText,
    required this.onSaved,
    this.validator,
    this.onChanged,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !visible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        if (widget.validator != null) {
          return widget.validator!(value);
        }

        return null;
      },
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        labelText: widget.labelText,
        prefixIcon: const Icon(Icons.lock),
        prefixIconColor: AppThemes.primaryColor,
        suffixIconColor: Colors.grey,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              visible = !visible;
            });
          },
          child: !visible
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        ),
      ),
    );
  }
}
