// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

/**
 *
 * authors @musabisimwa @diri0060
 *
 * navigation screen
 * contains the client main app screen with a map(in nav) and selected contact(s)
 * for more information follow the link below
 * link: https://runtime-terror4001.atlassian.net/wiki/spaces/SA/blog/2022/03/16/753665/UI+UX+Design
 *
 *
 */

/// note to dev: should contain minimal business logic
///

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:safe_app/services/models/contact_model.dart';

import '../../constats.dart';
import '../common/themedHooks.dart';

Widget navigationGroup(
    {String? upperText,
    String? trackText,
    String? distance,
    String? eta,
    String? timeLeft,
    required VoidCallback onSOSButtonpressed,
    required VoidCallback startTimer,
    required VoidCallback stopTimer,
    required Timer? countdownTimer,
    required String sosBtnLabel,
    required Color sosBtnColor,
    required String priorityLabel,
    required double height,
    required double width,
    Priority? priority}) {
  final navigationScreen = Container(
    // search and button ensemble
    height: height,
    width: width,
    decoration: BoxDecoration(
        color: Color.fromARGB(190, 177, 253, 228), //(148, 210, 189, .9)
        borderRadius: BorderRadius.circular(20)),

    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // row here

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  width: 150,
                  height: 110,
                  decoration: BoxDecoration(
                      color:
                          Color.fromARGB(94, 71, 138, 116), //(148, 210, 189, .9)
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Distance',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        distance ?? 'NaN',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  )),
              Container(
                  width: 150,
                  height: 110,
                  decoration: BoxDecoration(
                      color:
                          Color.fromARGB(94, 71, 138, 116), //(148, 210, 189, .9)
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'ETA : ${eta ?? "05:29"}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        'Left : ${timeLeft ?? "01:49"}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  )),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () {
                    if (countdownTimer == null || !countdownTimer.isActive) {
                      stopTimer();
                    }
                  },
                  icon: Icon(Icons.done_all_rounded),
                  label: Text("DONE")),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 50, 10),
                child: SimpleButton(
                  // THE sos button
                  height: 50,
                  width: 120,
                  onPressed: () {
                    onSOSButtonpressed();
                    startTimer();
                  },
                  color: sosBtnColor,
                  label: sosBtnLabel,
                  fontSize: 20,
                ),
              ),
              //row here

              Text(
                priorityLabel,
                style: TextStyle(
                    color: (priority == Priority.HIGH)
                        ? Colors.red
                        : Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  return navigationScreen;
}

Widget ContactNavigationGroup(
    {required VoidCallback onClosePressed,
     required AppContact? assignContact,
    required double height,
    required double width,
    required Duration myDuration,
    String? contactName,
    String? timeLeft}) {
  String strDigits(int n) => n.toString().padLeft(2, '0');
  final hours = strDigits(myDuration.inHours.remainder(24));
  final minutes = strDigits(myDuration.inMinutes.remainder(60));
  final seconds = strDigits(myDuration.inSeconds.remainder(60));
  return Container(
      // search and button ensemble
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Color.fromARGB(190, 177, 253, 228), //(148, 210, 189, .9)
          borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // row here
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Text(
                    assignContact?.name ?? 'Contact database not found',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromARGB(55, 0, 0, 0),
                      ),
                      child: IconButton(
                        //onSettings button pressed
                        onPressed: onClosePressed,
                        icon: Icon(
                          Icons.close,
                          color: Color.fromARGB(255, 231, 41, 7),
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Text(
                timeLeft ?? '$hours:$minutes:$seconds',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ]),
      ));
}
