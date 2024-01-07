import 'package:flutter/material.dart';

class BloodTypeFormSelect extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;

  const BloodTypeFormSelect({
    Key? key,
    this.controller,
    this.onSaved,
    this.onChanged,
    this.initialValue = 'A+',
  }) : super(key: key);

  @override
  _BloodTypeFormSelectState createState() => _BloodTypeFormSelectState();
}

class _BloodTypeFormSelectState extends State<BloodTypeFormSelect> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _controller.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select blood group';
        }
        return null;
      },
      onSaved: (value) {
        // // Handle saving the value if needed
        // _controller.text = value!;
        if (widget.onSaved != null) {
          widget.onSaved!(value);
        }
      },
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
              value: _controller.text,
              isDense: true,
              onChanged: (String? newValue) {
                state.didChange(newValue);
                print("CHANGE $newValue");
                _controller.text = newValue ?? '';
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue);
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

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }
}

class CityFormSelect extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;

  const CityFormSelect({
    Key? key,
    this.controller,
    this.onSaved,
    this.onChanged,
    this.initialValue = 'Lalitpur',
  }) : super(key: key);

  @override
  _CityFormSelectState createState() => _CityFormSelectState();
}

class _CityFormSelectState extends State<CityFormSelect> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }

    // // Add a listener to the controller to update the UI when the text changes
    // _controller.addListener(() {
    //   if (widget.onChanged != null) {
    //     widget.onChanged!(_controller.text);
    //   }
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _controller.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your city';
        }
        return null;
      },
      onSaved: (value) {
        // Handle saving the value if needed
        _controller.text = value!;
        if (widget.onSaved != null) {
          widget.onSaved!(value);
        }
      },
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
              value: _controller.text,
              isDense: true,
              onChanged: (String? newValue) {
                state.didChange(newValue);
                _controller.text = newValue ?? '';
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue);
                }
              },
              items: <String>[
                'Kathmandu',
                'Lalitpur',
                'Bhaktapur',
                'Pokhara',
                'None'
              ].map<DropdownMenuItem<String>>((String value) {
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

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }
}
