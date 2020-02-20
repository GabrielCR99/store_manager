import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData iconData;
  final bool isObscure;
  final Stream<String> stream;
  final Function(String) onChanged;
  InputField({this.hint, this.iconData, this.isObscure, this.stream, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: 5.0, right: 30.0, bottom: 30.0, top: 30.0),
                icon: Icon(
                  iconData,
                  color: Colors.white,
                ),
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
                errorText: snapshot.hasError ? snapshot.error : null),
            style: TextStyle(
              color: Colors.white,
            ),
            obscureText: isObscure,
          );
        });
  }
}
