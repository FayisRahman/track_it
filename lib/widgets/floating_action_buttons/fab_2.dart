import 'package:flutter/material.dart';

class FAB2 extends StatelessWidget {
  final VoidCallback onPressed;
  const FAB2({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Color(0xFF90B2F1),
      onPressed: onPressed,
      child: const Icon(
        Icons.directions,
        color: Colors.black87,
      ),
    );
  }
}
