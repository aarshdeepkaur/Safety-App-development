// ignore: slash_for_doc_comments
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

/// author @musabisimwa
///
/// widget : iconTextField
/// a simple styled textfield with an icon to it's right
///
///
/// @attributes
///     required controller,
///     fillColor,
///     iconColor,
///     hintColor,
///     textFieldColor,
///     fontWeight,
///     required width,
///     required height,
///     fieldHintText
///
/// state:mutable
///

class IconTextField extends StatefulWidget {
  //controller
  late TextEditingController controller;
  // fill color , icon color , hint color from inputfield
  late Color? fillColor;
  late Color? iconColor; //
  late Color? hintColor;
  late Color? textFieldColor;

  // font weight for both hint text and input text
  FontWeight? fontWeight;
  // size width and height
  late double width, height;

  // input field hint
  late String? fieldHintText;

  //icon data
  late IconData iconData;

  IconTextField({
    Key? key,
    required this.controller,
    this.fillColor,
    this.iconColor,
    this.hintColor,
    this.textFieldColor,
    this.fontWeight,
    required this.width,
    required this.height,
    this.fieldHintText,
    required this.iconData,
  }) : super(key: key);

  @override
  State<IconTextField> createState() => _IconTextFieldState();
}

class _IconTextFieldState extends State<IconTextField> {
  final Color defaultColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Row(
      //alignment
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(widget.iconData, color: widget.iconColor ?? defaultColor),
        Container(
          //size
          width: widget.width,
          height: widget.height,
          //txt feild
          child: TextField(
            textAlignVertical: TextAlignVertical.bottom,
            cursorColor: Colors.black,
            controller: widget.controller,
            style: TextStyle(
              fontWeight: widget.fontWeight ?? FontWeight.bold,
              color: widget.textFieldColor ?? defaultColor,
            ),
            decoration: InputDecoration(
              hintText: widget.fieldHintText ?? '',
              hintStyle: TextStyle(
                color: widget.hintColor ?? defaultColor,
              ),
              filled: true,
              fillColor: widget.fillColor ?? defaultColor.withOpacity(0.3),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50)),
            ),
          ),
        ),
      ],
    );
  }
}
