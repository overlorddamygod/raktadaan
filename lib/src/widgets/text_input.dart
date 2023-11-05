import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String labelText;
  final Function(String?) onSaved;
  final Function(String?)? onChanged;
  final Function(String?)? validator;
  final String defaultValidationText;
  final bool isRequired;

  const TextInput({
    super.key,
    required this.labelText,
    required this.onSaved,
    this.validator,
    this.onChanged,
    this.isRequired = true,
    this.defaultValidationText = 'Please enter some text',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // validator: ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        labelText: labelText,
      ),
      onSaved: onSaved,
      onChanged: onChanged,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Please enter ${labelText}';
        }
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
    );
  }
}
