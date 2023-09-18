import 'package:flutter/material.dart';

class TxtField extends StatelessWidget {
  String title;
  bool hideText;
  bool isError;
  void Function(String?) onChanged;

  TxtField({
    super.key,
    required this.title,
    required this.onChanged,
    this.hideText = false,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        onChanged: onChanged,
        obscureText: hideText,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          errorText: isError ? "Incorrect or username already in use" : null,
          labelText: title,
          labelStyle: const TextStyle(
            height: 0.1,
            fontSize: 15,
            letterSpacing: 1,
            fontWeight: FontWeight.w400,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
    );
  }
}
