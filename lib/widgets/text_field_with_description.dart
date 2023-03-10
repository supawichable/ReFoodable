import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/description_text.dart';
import 'package:gdsctokyo/widgets/input_text_field.dart';

class TextFieldWithDescription extends StatelessWidget {
  final String placeHolderText;
  final String descriptionText;
  final void Function(String)? function;

  const TextFieldWithDescription({
    Key? key,
    required this.descriptionText,
    required this.placeHolderText,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DescriptionText(
          text: descriptionText,
        ),
        Container(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          height: 50,
          child: Container(
            padding: const EdgeInsets.only(
              left: 5,
            ),
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 1,
                  color: Colors.grey.shade600.withOpacity(0.5),
                ),
                boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0,2),
                )
              ]),
              child: InputTextField(placeHolderText: placeHolderText, function: function,)),
        ),
      ],
    );
  }
}
