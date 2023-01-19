import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({
    Key? key,
    required this.widgetFor,
    required this.customerName,
    required this.customerAddress,
    required this.orderValue,
    required this.orderId,
    required this.orderDateTime,
    required this.orderStatus,
    required this.onTapMarkAsDelivered,
    required this.onTapViewDetails,
  }) : super(key: key);
  final String widgetFor;
  final VoidCallback onTapMarkAsDelivered;
  final VoidCallback onTapViewDetails;
  final String customerName;
  final String customerAddress;
  final double orderValue;
  final String orderId;
  final DateTime orderDateTime;
  final String orderStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 15),
      child: Container(
        height: 180,
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
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Date: " + DateFormat('dd, MMMM y').format(orderDateTime),
                  style: GoogleFonts.lato(),
                ),
              ),
            ),
            Row(children: <Widget>[
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Text(
                  "Details",
                  style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(child: Divider()),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Customer:",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                customerName,
                                style: GoogleFonts.lato(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Address:",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(customerAddress),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: onTapViewDetails,
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.1,
                                    blurRadius: 0.1,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blueAccent)),
                            child: Center(
                              child: Text(
                                "View Details",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Order Value:",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold)),
                              Text(
                                "$orderValue",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Status:",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: 70,
                                child: Center(
                                    child: Text(
                                  orderStatus,
                                  style: GoogleFonts.lato(color: Colors.white),
                                )),
                                decoration: BoxDecoration(
                                    color: (orderStatus == "Pending")
                                        ? Colors.pinkAccent.shade100
                                        : orderStatus == "Cancelled"
                                            ? Colors.red
                                            : Colors.greenAccent,
                                    border: Border.all(
                                      color: (orderStatus == "Pending")
                                          ? Colors.pinkAccent.shade100
                                          : orderStatus == "Cancelled"
                                              ? Colors.red
                                              : Colors.greenAccent,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (orderStatus == "Pending")
                              ? onTapMarkAsDelivered
                              : null,
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  (orderStatus == "Pending")
                                      ? BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0.1,
                                          blurRadius: 0.1,
                                          offset: const Offset(0, 3),
                                        )
                                      : BoxShadow(),
                                ],
                                color: (orderStatus == "Pending")
                                    ? widgetFor == "customer"
                                        ? Colors.red
                                        : Colors.green
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: (orderStatus == "Pending")
                                        ? widgetFor == "customer"
                                            ? Colors.red
                                            : Colors.green
                                        : Colors.grey)),
                            child: Center(
                              child: Text(
                                widgetFor == "customer"
                                    ? "Cancel"
                                    : "Mark as Delivered",
                                style: GoogleFonts.lato(
                                    color: (orderStatus == "Pending")
                                        ? Colors.white
                                        : Colors.grey.shade100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
