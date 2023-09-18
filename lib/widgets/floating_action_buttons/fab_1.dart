import 'package:flutter/material.dart';

class FAB1 extends StatelessWidget {
  final VoidCallback onPressed;

  const FAB1({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: const Color(0xFF38383A),
      onPressed: onPressed,
      child: const Icon(
        Icons.my_location,
        color: Colors.white70,
      ),
    );
  }
}
