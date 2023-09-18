import 'package:flutter/material.dart';

class FilteredItem extends StatelessWidget {
  final String searchedItem;
  final VoidCallback onPressed;
  const FilteredItem(
      {super.key, required this.searchedItem, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        child: Stack(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white10,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white60,
                    size: 18,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      searchedItem,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "NIT,Calicut",
                      style: TextStyle(
                        color: Colors.white38,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: 1,
                      color: Colors.white38,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
