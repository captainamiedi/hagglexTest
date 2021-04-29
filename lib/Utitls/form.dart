import 'package:flutter/material.dart';

class FormFieldInput extends StatelessWidget {
  FormFieldInput(
      {Key key,
      this.validate,
      this.label,
      this.onchangedFunction,
      this.errorText,
      this.secureText})
      : super(key: key);
  Function validate;
  String label;
  Function onchangedFunction;
  String errorText;
  bool secureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 11.0,
            color: Colors.white,
          ),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusColor: Colors.white,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          )),
      obscureText: secureText,
      validator: (value) => value.isEmpty ? errorText : validate(value),
      onChanged: (value) {
        onchangedFunction(value);
      },
      onSaved: (value) {
        onchangedFunction(value);
      },
    );
  }
}
