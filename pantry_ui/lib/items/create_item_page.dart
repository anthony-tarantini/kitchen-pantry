import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pantry_ui/items/item_form.dart';

class CreateItemPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ItemForm(),
    );
  }
}
