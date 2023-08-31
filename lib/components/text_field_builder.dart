import 'package:flutter/material.dart';

class TextFieldBuilder extends StatelessWidget {
  const TextFieldBuilder({super.key, required this.hintText, required this.onChanged, this.decoration});

  final String hintText;
  final Function(String value) onChanged;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: decoration ??
          InputDecoration(
            hintStyle: const TextStyle(color: Colors.grey),
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
    );
  }
}
