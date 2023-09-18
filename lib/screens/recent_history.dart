import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentHistory extends StatefulWidget {
  SharedPreferences _pref;

  RecentHistory(this._pref, {super.key});

  @override
  State<RecentHistory> createState() => _RecentHistoryState();
}

class _RecentHistoryState extends State<RecentHistory> {
  late SharedPreferences _pref;

  @override
  void initState() {
    _pref = widget._pref;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
