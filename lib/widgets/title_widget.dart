import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
    required this.name,
    required this.photoURL,
    required this.loginType,
  }) : super(key: key);

  final String name;
  final String photoURL;
  final String loginType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back",
                  style: GoogleFonts.lato(),
                ),
                Text(name,
                    style: GoogleFonts.lato(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              (loginType == "google")
                  ? CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(photoURL),
                    )
                  : (loginType == "normal")
                      ? CircleAvatar(
                          radius: 28,
                          backgroundImage: MemoryImage(base64Decode(photoURL)),
                        )
                      : CircleAvatar(
                          radius: 28,
                          backgroundImage: null,
                        )
            ],
          ),
        ],
      ),
    );
  }
}
