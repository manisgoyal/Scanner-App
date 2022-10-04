import 'package:flutter/material.dart';

class CheckPointProvider extends ChangeNotifier {
  String checkId = '';
  void changeId(String id) {
    checkId = id;
    notifyListeners();
  }
}
