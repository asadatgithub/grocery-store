import 'dart:convert';
import 'dart:io';

import 'package:alpha_mini_grocery/database/item_db.dart';
import 'package:alpha_mini_grocery/models/items.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key, required this.user});
  final user;
  @override
  State<ItemPage> createState() => ItemPageState(user);
}

class ItemPageState extends State<ItemPage> {
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemBrandController = TextEditingController();
  final user;
  File? _image;
  final picker = ImagePicker();
  var cateogries = ["Bakery", "Beverage", "Deli", "Prepared Foods"];
  String categoryValue = "Bakery";

  ItemPageState(this.user);

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 200, maxWidth: 200);

    setState(() {
      _image = File(pickedFile!.path);
      print("here");
      print(_image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text("ADD NEW ITEM",
                    style: GoogleFonts.lato(
                        fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                    controller: itemNameController,
                    style: GoogleFonts.lato(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Enter Item Name",
                        hintText: "Item Name",
                        border: OutlineInputBorder())),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                    keyboardType: TextInputType.number,
                    controller: itemPriceController,
                    style: GoogleFonts.lato(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Enter Item Price",
                        hintText: "Item Price",
                        border: OutlineInputBorder())),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                    keyboardType: TextInputType.number,
                    controller: itemQuantityController,
                    style: GoogleFonts.lato(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Enter Item Quantity",
                        hintText: "Item Quantity",
                        border: OutlineInputBorder())),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Select Category",
                    border: OutlineInputBorder(),
                  ),
                  value: categoryValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: cateogries.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      categoryValue = newValue!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                    keyboardType: TextInputType.name,
                    controller: itemBrandController,
                    style: GoogleFonts.lato(),
                    decoration: InputDecoration(
                        labelText: "Enter Item Brand",
                        hintText: "Enter Item Brand",
                        border: OutlineInputBorder())),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: InkWell(
                  onTap: getImage,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: (_image != null)
                        ? Image.file(_image!)
                        : Center(
                            child: Text(
                            "Pick an Image",
                            style: GoogleFonts.lato(fontSize: 16),
                          )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await addItem();
        },
        tooltip: "Add Item",
        icon: Container(
          child: const Icon(Icons.add_circle),
        ),
        elevation: 1.0,
        label: Text("Add Item"),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        //color of the BottomAppBar
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                iconSize: 27.0,
                icon: Icon(Icons.home,
                    //darken the icon if it is selected or else give it a different color
                    color: Colors.blue.shade900),
              ),

              //to leave space in between the bottom app bar items and below the FAB
              const SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addItem() async {
    String name = itemNameController.text;
    String brand = itemBrandController.text;
    double price = double.parse(itemPriceController.text);
    String category = categoryValue;
    int quantity = int.parse(itemQuantityController.text);
    String imageBytes = base64Encode(_image!.readAsBytesSync());
    var item =
        Item(name, quantity, price, category, brand, imageBytes, user['email']);
    await ItemDatabase.insert(item).then((value) => {Navigator.pop(context)});
  }
}
