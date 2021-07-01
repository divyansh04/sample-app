import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sample_app/core/models/inventory_model.dart';

class HomeModel with ChangeNotifier {
  String _inventoryBox = 'inventory';
  String _searchString = "";
  String _filterString = "";

  List<Inventory> _inventoryList = [];

  // List get inventoryList => _inventoryList;

  // List<Inventory> get inventoryList => _searchString.isEmpty
  //     ? ((_filterString.isNotEmpty && int.parse(_filterString) > 18)
  //         ? _inventoryList.takeWhile((i) => int.parse(i.age) > 18).toList()
  //         : _inventoryList)
  //     : _inventoryList
  //         .where((element) => element.name.contains(_searchString))
  //         .toList();

  List<Inventory> get inventoryList {
    // return _inventoryList;
    List<Inventory> tempList = _inventoryList;
    List<Inventory> majorList =
        tempList.where((i) => int.parse(i.age) > 18).toList();
    List<Inventory> minorList =
        tempList.where((i) => int.parse(i.age) < 19).toList();

    if (_searchString.isEmpty) {
      if ((_filterString.isNotEmpty && int.parse(_filterString) > 18)) {
        return majorList;
      } else if ((_filterString.isNotEmpty && int.parse(_filterString) < 19)) {
        return minorList;
      } else
        return _inventoryList;
    } else {
      if ((_filterString.isNotEmpty && int.parse(_filterString) > 18)) {
        return majorList
            .where((element) => element.name.contains(_searchString))
            .toList();
      } else if ((_filterString.isNotEmpty && int.parse(_filterString) < 19)) {
        return minorList
            .where((element) => element.name.contains(_searchString))
            .toList();
      } else
        // return _inventoryList;
        return tempList
            .where((element) => element.name.contains(_searchString))
            .toList();
    }
  }

  addItem(Inventory inventory) async {
    var box = await Hive.openBox<Inventory>(_inventoryBox);

    box.add(inventory);

    print('added');

    notifyListeners();
  }

  getItem() async {
    final box = await Hive.openBox<Inventory>(_inventoryBox);

    _inventoryList = box.values.toList();

    notifyListeners();
  }

  updateItem(int index, Inventory inventory) {
    final box = Hive.box<Inventory>(_inventoryBox);

    box.putAt(index, inventory);

    notifyListeners();
  }

  deleteItem(int index) {
    final box = Hive.box<Inventory>(_inventoryBox);

    box.deleteAt(index);

    getItem();

    notifyListeners();
  }

  void changeSearchString(String searchString) {
    _searchString = searchString;
    print(_searchString);
    notifyListeners();
  }

  void changeFilterString(String filterString) {
    _filterString = filterString;
    print(_filterString);
    notifyListeners();
  }
}
