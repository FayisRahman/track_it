import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_it/widgets/search_bars/search_bar.dart';
import 'package:track_it/widgets/historyList.dart';
import 'package:track_it/database/marker_data.dart';
import 'package:provider/provider.dart';
import 'package:track_it/database/data_transferer.dart';

class SearchScreen extends StatefulWidget {
  static const String id = "SearchScreen";
  final SharedPreferences _prefs;

  const SearchScreen(this._prefs, {Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  MarkerData markerData = MarkerData();
  SharedPreferences? _prefs;
  String searchItem = "";
  late Iterable<HistoryItem> reverseOrder;
  List<String> searchedItems = [];
  List<Widget> recentItems = [];
  List<String> filterList = [];
  List<Widget> filteredList = [];
  bool searchBarIsEmpty = true;
  String checkItem = "";
  final TextEditingController _controller = TextEditingController();

  void displayText(String buttonText) {
    _controller.text = buttonText;

    // Move the cursor to the end of the text field
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  void createRecentHistory(List<String> searchedItems) {
    recentItems.clear();
    for (int i = searchedItems.length - 1;
        i > ((searchedItems.length > 7) ? searchedItems.length - 7 : 0);
        i--) {
      recentItems.add(
        HistoryItem(
          icon: Icons.access_time_rounded,
          searchedItem: searchedItems[i],
          onPressedFunctionInput: searchedItems[i],
          searchedItems: searchedItems,
          onPressed: () {
            searchedItems =
                List.from(_prefs?.getStringList('searchedItems') ?? []);
            searchedItems.add(searchedItems[i]);
          },
          onIconPressed: () {
            displayText(searchedItems[i]);
          },
        ),
      );
    }
    if (searchedItems.length > 7) {
      recentItems.add(
        TextButton(
          onPressed: () {},
          child: const Text(
            "More from recent history",
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
        ),
      );
    }
    setState(() {
      recentItems;
    });
  }

  void updateTextState() {
    setState(() {
      searchBarIsEmpty = searchItem.isEmpty;
    });
  }

  void listFilter(value) {
    filteredList.clear();
    filterList = markerData.markerTitle
        .where((element) => element
            .toString()
            .toLowerCase()
            .contains(value.toString().toLowerCase()))
        .toList();
    for (String text in filterList) {
      filteredList.add(
        HistoryItem(
          icon: searchedItems.contains(text)
              ? Icons.access_time_outlined
              : Icons.location_on_outlined,
          searchedItem: text,
          onPressedFunctionInput: text,
          searchedItems: searchedItems,
          onPressed: () {
            searchedItems =
                List.from(_prefs?.getStringList('searchedItems') ?? []);
            print(searchedItems);
            searchedItems.add(text);
          },
          onIconPressed: () {
            displayText(text);
          },
        ),
      );
    }
    setState(() {
      filterList;
      filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    _prefs = widget._prefs;
    checkItem = Provider.of<TransferData>(context, listen: false).searchItem;
    print(checkItem);
    if (checkItem != "") {
      displayText(checkItem);
    }
    searchedItems = List.from(_prefs?.getStringList('searchedItems') ?? []);
    print(searchedItems);
    createRecentHistory(searchedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            Center(
              child: Searchbar(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    //changes the search field text and check if its empty or not
                    searchItem = _controller.text;
                    searchBarIsEmpty = searchItem.isEmpty;
                  });
                  listFilter(searchItem);
                },
                onSubmitted: (value) async {
                  //if not empty gets the previously searched list from cache using shared pref and add an extra searched item
                  if (_controller.text.isNotEmpty) {
                    searchItem = _controller.text;
                    searchedItems =
                        List.from(_prefs?.getStringList('searchedItems') ?? []);
                    searchedItems.add(searchItem);
                    await _prefs?.setStringList('searchedItems', searchedItems);
                    createRecentHistory(
                        _prefs!.getStringList('searchedItems')!);
                  }
                },
                clearTextButton: () {
                  _controller.clear();
                  Provider.of<TransferData>(context, listen: false).searchItem =
                      "";
                  Provider.of<TransferData>(context, listen: false)
                      .revertSearchBar();
                  setState(() {
                    searchItem = _controller.text;
                    searchBarIsEmpty = searchItem.isEmpty;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: double.infinity,
              height: 10,
              color: Colors.black87,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Recent",
                    textAlign: TextAlign.left,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    //removes the recent search history
                    await _prefs?.setStringList('searchedItems', []);
                    setState(() {
                      recentItems = [];
                    });
                  },
                  icon: const Icon(
                    Icons.disabled_by_default,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: searchBarIsEmpty ? recentItems : filteredList,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
