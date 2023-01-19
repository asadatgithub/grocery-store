import 'dart:convert';

import 'package:alpha_mini_grocery/database/item_db.dart';
import 'package:alpha_mini_grocery/main.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreWidget extends StatelessWidget {
  const StoreWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.address,
    required this.onTap,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final String address;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 15),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: (30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.memory(
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      base64Decode(imagePath),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Wrap(
                direction: Axis.vertical,
                spacing: 8,
                children: [
                  Text("$title",
                      style: GoogleFonts.lato(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Address: $address",
                      style: GoogleFonts.lato(fontSize: 12)),
                ],
              ),
            ),
            InkWell(
              onTap: onTap,
              child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  height: 30,
                  width: 30,
                  child: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                  )),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
