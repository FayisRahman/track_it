import 'package:flutter/material.dart';

class TxtButton extends StatelessWidget {
  String? title;
  void Function() onPressed;
  bool? isChecked;

  TxtButton(
      {required this.onPressed,
      required this.title,
      this.isChecked = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 70,
          vertical: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor:
            isChecked! ? const Color(0xFF4153EF) : const Color(0xFF656FCB),
      ),
      child: Text(
        title!,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
