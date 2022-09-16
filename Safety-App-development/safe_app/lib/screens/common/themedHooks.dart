// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

/**
 * themed hooks
 * 
 * contains custom hooks that dont need to be their own classes
 * 
 * 
 * 
 * author @musabisimwa @diri0060
 * 
 */

import 'dart:typed_data';

import 'package:flutter/material.dart';

InputDecoration textInputDecoration = InputDecoration(
  fillColor: Color.fromARGB(51, 44, 130, 156),
  filled: true,
  contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
  hintStyle: TextStyle(
    color: Color.fromARGB(230, 52, 129, 165),
    fontWeight: FontWeight.bold,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      width: 0,
      style: BorderStyle.none,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      width: 0,
      style: BorderStyle.none,
    ),
  ),
);

///white horizontal divider hook with opacity
Widget HorizontalDivider({double? opacity}) {
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Divider(
        thickness: 1.0,
        color: Color.fromRGBO(255, 255, 255, opacity ?? 1),
        indent: 30,
        endIndent: 30,
      ));
}

//
//circular picture button
Widget CircularPictureButton(
    {required VoidCallback onTap, required String name, Color? bgcolor}) {
  return SingleChildScrollView(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgcolor ?? Colors.white.withOpacity(0.3)),
        width: 70,
        height: 50,
        child: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Icon(Icons.person),
              InkWell(
                onTap: onTap,
              )
            ],
          ),
        ),
      ),
      Center(
        child: Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
        ),
      )
    ]),
  );
}

// simple button
// can be resized and has 1 onpress event
Widget SimpleButton({
  required double height, //50,70
  required double width,
  required VoidCallback onPressed,
  Color? color,
  Color? textColor,
  String? label,
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextButton(
      
      onPressed: onPressed,
      child: Text(
        label ?? '',
        style: TextStyle(
          fontSize: fontSize ?? 17,
          fontWeight: fontWeight ?? FontWeight.bold,
          color: textColor ?? Colors.white,
        ),
      ),
    ),
  );
}

Widget ThemedTextInput({
  required double width,
  required double height,
  required TextEditingController controller,
  FontWeight? fontWeight,
  Color? textFieldColor,
  String? fieldHintText,
  Color? hintColor,
  Color? fillColor,
  bool? obscureText,
}) {
  const Color defaultColor = Colors.white;

  return Container(
    //size
    width: width,
    height: height,
    //txt feild
    child: TextField(
      obscureText: obscureText ?? false,
      textAlignVertical: TextAlignVertical.bottom,
      cursorColor: Colors.black,
      controller: controller,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.bold,
        color: textFieldColor ?? defaultColor,
      ),
      decoration: InputDecoration(
        hintText: fieldHintText ?? '',
        hintStyle: TextStyle(
          color: hintColor ?? defaultColor,
        ),
        filled: true,
        fillColor: fillColor ?? defaultColor.withOpacity(0.3),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

Widget SettingsTile({required double height,required double width,Color?color,
required VoidCallback onTap,required String label,FontWeight?fontweight,double?fontSize}) {
  return Container(
    height:height, //MediaQuery.of(context).size.height * 0.1,
    width:width, //MediaQuery.of(context).size.width * 0.9,
    decoration: BoxDecoration(
      color: color??Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: InkWell(
      onTap: onTap,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontWeight: fontweight??FontWeight.bold,
            fontSize: fontSize??20,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
