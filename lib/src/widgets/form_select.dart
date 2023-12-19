import 'package:flutter/material.dart';

class BloodTypeFormSelect extends StatelessWidget {
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;

  const BloodTypeFormSelect(
      {super.key, this.initialValue, this.onSaved, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: initialValue ?? 'A+',
      validator: (value) {
        // print("SAD ${value}");
        if (value == null || value.isEmpty) {
          return 'Please select blood group';
        }
        return null;
      },
      onSaved: onSaved,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            labelText: 'Blood Group',
          ),
          isEmpty: false,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: state.value,
              isDense: true,
              onChanged: (String? newValue) {
                state.didChange(newValue);
                // formData.bloodGroup = newValue!;
                if (onChanged != null) {
                  onChanged!(newValue);
                }
              },
              items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class CityFormSelect extends StatelessWidget {
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;

  const CityFormSelect(
      {super.key, this.initialValue, this.onSaved, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: initialValue ?? "Lalitpur",
      validator: (value) {
        // print("SAD ${value}");
        if (value == null || value.isEmpty) {
          return 'Please select your city';
        }
        return null;
      },
      onSaved: onSaved,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            labelText: 'City',
          ),
          isEmpty: false,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: state.value,
              isDense: true,
              onChanged: (String? newValue) {
                state.didChange(newValue);
                if (onChanged != null) {
                  onChanged!(newValue);
                }
              },
              items: <String>['Kathmandu', 'Lalitpur', 'Bhaktapur', 'Pokhara']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
