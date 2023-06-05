import 'dart:convert';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';

Widget dynamicDropdownWidgetV(
    {DropdownEditingController<Map<String, dynamic>>? dropdownEditingName,
    final String? labelTextValue,
    required String displayItemFnValue,
    required List<Map<String, dynamic>> itemsCollection,
    required String selectedFnValue,
    required String filterFnValue,
    String? titleValue,
    String? subtitleValue,
    dynamic defaultItemValue}) {
  return DropdownFormField<Map<String, dynamic>>(
      controller: dropdownEditingName,
      onEmptyActionPressed: () async {},
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.arrow_drop_down),
          labelText: labelTextValue),
      onSaved: (dynamic str) {},
      onChanged: (dynamic str) {},
      /* validator: (value) {
        if (Jso(value) == null || value.isEmpty) {
          return 'Example Is Required';
        }
        return null;
      },
 validator: (dynamic str) {},
      */
      validator: (dynamic str) {
        if (selectedFnValue == null || selectedFnValue.isEmpty) {
          return 'Example Is Required';
        }
        return null;
      },
      /*validator: (value) {
        if (value == null || value.isEmpty) {
          return labelTextValue;
        }
        return null;
      },*/
      //validator: (value) => value == null || value.isEmpty ? 'required' : null,
      displayItemFn: (dynamic item) => Text(
            ((item ?? defaultItemValue) ?? {})[displayItemFnValue] ?? '',
            style: const TextStyle(fontSize: 16),
          ),
/*
displayItemFn: (dynamic item) => Text(
            (item ?? {})[displayItemFnValue] ?? '',
            style: const TextStyle(fontSize: 16),
          ),
*/

      //defaultItemValue
      findFn: (dynamic str) async => itemsCollection,
      selectedFn: (dynamic item1, dynamic item2) {
        if (item1 != null && item2 != null) {
          return item1[selectedFnValue] == item2[selectedFnValue];
        }
        return false;
      },
      filterFn: (dynamic item, str) =>
          item[filterFnValue].toLowerCase().indexOf(str.toLowerCase()) >= 0,
      dropdownItemFn: (dynamic item, int position, bool focused, bool selected,
              Function() onTap) =>
          ListTile(
            title: Text(item[titleValue]),
            subtitle: Text(
              item[subtitleValue] ?? '',
            ),
            tileColor: focused
                ? const Color.fromARGB(20, 0, 0, 0)
                : Colors.transparent,
            onTap: onTap,
          ));
}
