import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonSearchBar extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback iconOnPressed;
  final String title;
  final IconData icon;
  const ButtonSearchBar({
    super.key,
    required this.onPressed,
    required this.iconOnPressed,
    this.title = "Search Here",
    this.icon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Stack(
        children: [
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF34363A).withOpacity(1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 23,
                        width: 23,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            color: (title == "Search Here")
                                ? Colors.grey
                                : Colors.white70,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 17),
            child: IconButton(
                onPressed: iconOnPressed,
                icon: Icon(
                  icon,
                  color: Colors.blueAccent,
                )),
          ),
        ],
      ),
    );
  }
}
