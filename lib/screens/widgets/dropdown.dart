import 'package:flutter/material.dart';
import 'package:hushh_proto/screens/widgets/colors.dart';

customDropDown(
  context,
  bool lightMode,
  String selectedValue,
  Function(String?)? onChanged,
  List<String> list,
  title,
) {
  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: lightMode
                ? Pallet.black.withOpacity(0.5)
                : Pallet.white.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<String>(
          dropdownColor: Pallet.black2,
          menuMaxHeight: 250,
          underline: const SizedBox(),
          icon: Icon(
            Icons.arrow_drop_down,
            color: lightMode ? Pallet.black : Pallet.white,
          ),
          value: selectedValue,
          onChanged: onChanged,
          isExpanded: true,
          style: const TextStyle(color: Pallet.white, fontSize: 16),
          items: list
              .map((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
        ),
      ),
      Positioned(
        left: 10,
        top: 0,
        child: Container(
          color: lightMode ? Pallet.white : Pallet.black,
          padding: const EdgeInsets.all(2),
          child: Text(
            title,
            style: TextStyle(
              color: lightMode ? Pallet.black : Pallet.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ],
  );
}
