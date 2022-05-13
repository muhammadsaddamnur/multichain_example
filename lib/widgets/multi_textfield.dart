import 'package:flutter/material.dart';

class MultiTextField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  const MultiTextField({Key? key, this.controller, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: '0.0',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            //  when the TextFormField in focused
          ),
        ),
      ),
    );
  }
}
