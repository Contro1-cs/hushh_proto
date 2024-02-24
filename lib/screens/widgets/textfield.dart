import 'package:flutter/material.dart';

customTextField(
  context,
  String title,
  TextEditingController controller,
  Color fontColor,
) {
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      cursorColor: fontColor,
      style: TextStyle(
        color: fontColor,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: fontColor.withOpacity(0.7),
        ),
        label: Text(title),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: fontColor, width: 2),
        ),
      ),
    ),
  );
}

customTextField2(
  context,
  TextEditingController controller,
  Color fontColor,
) {
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      cursorColor: fontColor,
      style: TextStyle(
        color: fontColor,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: fontColor, width: 2),
        ),
      ),
    ),
  );
}
