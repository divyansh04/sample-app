import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/core/models/inventory_model.dart';

import '../../../app/extensions/size_extension.dart';
import '../../../app/size_config.dart';
import 'home_model.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final _textFieldController = TextEditingController();
  String _searchText;
  String _filterAge;

  @override
  void initState() {
    _textFieldController.addListener(
      () {
        setState(() {
          _searchText = _textFieldController.text;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    context.watch<HomeModel>().getItem();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Landing Page'),
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 4.height,
              left: 4.width,
              right: 4.width,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0.height),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      Provider.of<HomeModel>(context, listen: false)
                          .changeSearchString(value);
                    },
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.filter_alt_rounded),
                  onSelected: (item) {
                    Provider.of<HomeModel>(context, listen: false)
                        .changeFilterString(item.toString());
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: "",
                        child: Text('All'),
                      ),
                      PopupMenuItem(
                        value: '50',
                        child: Text('Age > 18'),
                      ),
                      PopupMenuItem(
                        value: '18',
                        child: Text('Age < 18'),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          Consumer<HomeModel>(
            builder: (context, model, child) {
              return Container(
                // height: 90.height,
                child: model.inventoryList.isEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.height,
                          horizontal: 4.width,
                        ),
                        child: Center(
                            child: Text(
                          'Please add some data elements',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.text,
                          ),
                        )),
                      )
                    : ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: model.inventoryList.length,
                        itemBuilder: (context, index) {
                          Inventory inv = model.inventoryList[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 2.height,
                              horizontal: 4.5.width,
                            ),
                            height: 13.height,
                            // width: 50.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 2.width),
                                      width: 16.width,
                                      decoration: BoxDecoration(
                                        color: Colors.green[600],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 3.height,
                                        horizontal: 3.width,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            inv.name,
                                            style: TextStyle(
                                              color: Colors.green[600],
                                              fontWeight: FontWeight.w600,
                                              fontSize: 4.5.text,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1.height,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                inv.age + " years",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 4.text,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8.width,
                                              ),
                                              Text(
                                                inv.description,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 4.text,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.width),
                                  child: PopupMenuButton(
                                    onSelected: (item) {
                                      switch (item) {
                                        case 'update':
                                          nameController.text = inv.name;
                                          descriptionController.text =
                                              inv.description;
                                          ageController.text = inv.age;

                                          inputItemDialog(
                                              context, 'update', index);
                                          break;
                                        case 'delete':
                                          model.deleteItem(index);
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          value: 'update',
                                          child: Text('Update'),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ];
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          inputItemDialog(context, 'add');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 8.width,
        ),
      ),
    );
  }

  inputItemDialog(BuildContext context, String action, [int index]) {
    var inventoryDb = Provider.of<HomeModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 40,
            ),
            height: 50.height,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      action == 'add' ? 'Add Profile' : 'Update Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'name cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Profile name',
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'interest cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Profile interests',
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: ageController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'age cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Age',
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (action == 'add') {
                            await inventoryDb.addItem(Inventory(
                              name: nameController.text,
                              description: descriptionController.text,
                              age: ageController.text,
                            ));
                          } else {
                            await inventoryDb.updateItem(
                                index,
                                Inventory(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  age: ageController.text,
                                ));
                          }

                          nameController.clear();
                          descriptionController.clear();
                          ageController.clear();

                          inventoryDb.getItem();

                          Navigator.pop(context);
                        }
                      },
                      color: Colors.green[600],
                      child: Text(
                        action == 'add' ? 'Add' : 'update',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
