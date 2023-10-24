import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pantry_ui/widgets/item_form.dart';

class CreateItemPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ItemForm(),
    );
  }

}
