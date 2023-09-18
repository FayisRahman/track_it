import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  String title;
  VoidCallback onPressed;
  IconData icon;
  Color color;
  FilterButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.icon,
    this.color = const Color(0xFF38383A),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0),
          backgroundColor: color,
          splashFactory: InkSparkle.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.white60,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(
                  icon,
                  color: (color == const Color(0xFF38383A))
                      ? Colors.white60
                      : Colors.indigoAccent,
                  size: 17,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                    color: (color == const Color(0xFF38383A))
                        ? Colors.white60
                        : Colors.indigoAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
