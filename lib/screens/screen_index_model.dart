import 'package:flutter/cupertino.dart';

class ScreenIndexModel extends ChangeNotifier {
  int index = 0;
  PageController pageController = PageController();
  void updateIndex(index) {
    this.index = index;
    pageController.jumpToPage(
      this.index,
    );
    notifyListeners();
  }
}
