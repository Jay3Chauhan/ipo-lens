import 'package:flutter/material.dart';

class ShareAllocationProvider extends ChangeNotifier {
  bool _showBarView = true;
  int? _hoveredIndex;

  bool get showBarView => _showBarView;
  int? get hoveredIndex => _hoveredIndex;

  void toggleView() {
    _showBarView = !_showBarView;
    notifyListeners();
  }

  void setHoveredIndex(int? index) {
    _hoveredIndex = index;
    notifyListeners();
  }

  void toggleHoveredIndex(int index) {
    _hoveredIndex = _hoveredIndex == index ? null : index;
    notifyListeners();
  }

  void reset() {
    _showBarView = true;
    _hoveredIndex = null;
  }
}
