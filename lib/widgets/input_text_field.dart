import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  final String placeHolderText;
  final void Function(String)? function;

  const InputTextField({
    Key? key,
    required this.placeHolderText,
    required this.function,
  }) : super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        fontSize: 12,
      ),
      controller: _textController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.placeHolderText,
        // contentPadding: EdgeInsets.symmetric(
        //   vertical: 15,
        // )
        // suffixIcon: IconButton(
        //   onPressed: () {
        //     _textController.clear();
        //   },
        //   icon: const Icon(Icons.clear),
        // ),
      ),
      onChanged: widget.function,
    );
  }
}
