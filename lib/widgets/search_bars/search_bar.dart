import 'package:flutter/material.dart';
import 'dart:io';

class Searchbar extends StatelessWidget {
  Searchbar(
      {super.key,
      required this.onChanged,
      required this.onSubmitted,
      required this.clearTextButton,
      required this.controller});

  Function(String) onChanged;
  Function(String) onSubmitted;
  final VoidCallback clearTextButton;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: TextField(
            controller: controller,
            autofocus: true,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
              decorationThickness: 0.0,
            ),
            decoration: InputDecoration(
              hintText: "Search here",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              prefixIcon: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Platform.isAndroid
                    ? const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white38,
                      )
                    : const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white38,
                      ),
              ),
              suffixIcon: IconButton(
                splashRadius: 3,
                onPressed: clearTextButton,
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white38,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFF35363A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
