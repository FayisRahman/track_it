import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../database/data_transferer.dart';

class HistoryItem extends StatelessWidget {
  final String searchedItem;
  final IconData icon;
  final VoidCallback onIconPressed;
  final String onPressedFunctionInput;
  final VoidCallback onPressed;
  final List<String> searchedItems;
  HistoryItem({
    super.key,
    required this.icon,
    required this.searchedItem,
    required this.onIconPressed,
    required this.onPressed,
    required this.onPressedFunctionInput,
    required this.searchedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TransferData>(
      builder: (context, transferData, child) {
        return TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
          ),
          onPressed: () async {
            await transferData.prefs
                .setStringList('searchedItems', searchedItems);
            if (context.mounted) {
              transferData.changeGetDirection(true);
              transferData.createSelectedMarker(onPressedFunctionInput);
              transferData.changeButtonSearchBar(onPressedFunctionInput);
              transferData.changeSearchBarDisplayText(onPressedFunctionInput);
              transferData.roadsApi({});
              transferData.changeShowDistance(false);
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Stack(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white10,
                      child: Icon(
                        icon,
                        color: Colors.white70,
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
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: IconButton(
                        splashRadius: 15,
                        onPressed: onIconPressed,
                        icon: const Icon(
                          Icons.north_west,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
