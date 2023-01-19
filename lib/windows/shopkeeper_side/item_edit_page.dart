import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../database/item_db.dart';
import '../../models/items.dart';

class ItemEditPage extends StatefulWidget {
  const ItemEditPage(
      {super.key,
      required this.user,
      required this.id,
      required this.name,
      required this.quantity,
      required this.price,
      required this.category,
      required this.brand,
      required this.imageBytes});
  final user;
  final Object id;
  final String name;
  final int quantity;
  final double price;
  final String category;
  final String brand;
  final String imageBytes;
  @override
  State<ItemEditPage> createState() => ItemEditPageState(
      id, name, quantity, price, category, brand, imageBytes, user);
}

class ItemEditPageState extends State<ItemEditPage> {
  final Object id;
  final user;
  final String name;
  final int quantity;
  final double price;
  String categoryValue;
  final String brand;
  final String imageBytes;
  ItemEditPageState(this.id, this.name, this.quantity, this.price,
      this.categoryValue, this.brand, this.imageBytes, this.user);
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemBrandController = TextEditingController();
  @override
  void initState() {
    super.initState();
    itemPriceController.text = "$price";
    itemNameController.text = name;
    itemQuantityController.text = "$quantity";
    itemBrandController.text = brand;
  }

  File? _image;
  final picker = ImagePicker();
  var cateogries = ["Bakery", "Beverage", "Deli", "Prepared Foods"];

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

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
                child: Text("EDIT ITEM",
                    style: GoogleFonts.lato(
                        fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                    controller: itemNameController,
                    style: GoogleFonts.lato(),
                    decoration: const InputDecoration(
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
                    decoration: const InputDecoration(
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
                    decoration: const InputDecoration(
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
                    decoration: const InputDecoration(
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
                        : Image.memory(
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            base64Decode(imageBytes),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          editItem();
        },
        tooltip: "Edit",
        elevation: 4.0,
        child: Container(
          margin: const EdgeInsets.all(15.0),
          child: const Icon(Icons.save_rounded),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        //color of the BottomAppBar
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                iconSize: 27.0,
                icon: Icon(Icons.home, color: Colors.blue.shade900),
              ),
              const SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editItem() async {
    String name = itemNameController.text;
    String brand = itemBrandController.text;
    double price = double.parse(itemPriceController.text);
    String category = categoryValue;
    int quantity = int.parse(itemQuantityController.text);
    String imageData = imageBytes;
    if (_image != null) imageData = base64Encode(_image!.readAsBytesSync());

    var item =
        Item(name, quantity, price, category, brand, imageData, user['email']);

    await ItemDatabase.update(id, item);
    Navigator.pop(context);
  }
}
