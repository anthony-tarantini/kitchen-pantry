import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pantry_ui/items/Image_modal.dart';
import 'package:pantry_ui/networking/api_client.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../app_state.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late AppState appState;
  late String url;
  late File? file;
  late List<String> tags;
  late double _distanceToField;
  late TextfieldTagsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
    url = 'https://d1xih0ax78qrb8.cloudfront.net/images/64e1c18a-3f3d-4406-acf4-ef4df1a9fd31.png';
    file = null;
    tags = [];
  }

  void updateImage(String newUrl) {
    setState(() {
      url = newUrl;
    });
  }

  void addTag(String tag) {
    setState(() {
      tags.add(tag);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<String> uploadImageFromUrl() async {
    return await ApiClient().uploadImageUrl(appState.accessToken, _formKey.currentState?.value['url']);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    appState = context.watch<AppState>();

    // Build a Form widget using the _formKey created above.
    return
    Wrap(
      children: [Card(
        color: theme.colorScheme.primaryContainer,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                Image.network(url),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    Center(
                      child: ElevatedButton(
                        child: const Text('Upload from file'),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (_) =>
                                ImageModal(accessToken: appState.accessToken, type: 'file', callback: updateImage),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        child: const Text('Upload from url'),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (_) =>
                                ImageModal(accessToken: appState.accessToken, type: 'url', callback: updateImage),
                          );
                        },
                      ),
                    ),
                  ],
                    )),
                Center(
                    child: SizedBox(
                        width: 500,
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    floatingLabelStyle: theme.primaryTextTheme.displaySmall,
                                    floatingLabelAlignment: FloatingLabelAlignment.start,
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    label: Text("Name"),
                                    border: OutlineInputBorder()))))),
                Center(
                    child: SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Column(
                        children: [
                          TextFieldTags(
                            textfieldTagsController: _controller,
                            textSeparators: const [' ', ','],
                            letterCase: LetterCase.normal,
                            inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
                              return ((context, sc, tags, onTagDelete) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextField(
                                    controller: tec,
                                    focusNode: fn,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 3.0,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 3.0,
                                        ),
                                      ),
                                      hintText: _controller.hasTags ? '' : "Enter tag...",
                                      errorText: error,
                                      prefixIconConstraints: BoxConstraints(maxWidth: _distanceToField * 0.74),
                                      prefixIcon: tags.isNotEmpty
                                          ? SingleChildScrollView(
                                              controller: sc,
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                  children: tags.map((String tag) {
                                                return Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    ),
                                                  ),
                                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        child: Text(
                                                          tag,
                                                        ),
                                                        onTap: () {
                                                          print("$tag selected");
                                                        },
                                                      ),
                                                      const SizedBox(width: 4.0),
                                                      InkWell(
                                                        child: const Icon(
                                                          Icons.cancel,
                                                          size: 14.0,
                                                        ),
                                                        onTap: () {
                                                          onTagDelete(tag);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList()),
                                            )
                                          : null,
                                    ),
                                    onChanged: onChanged,
                                    onSubmitted: onSubmitted,
                                  ),
                                );
                              });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _controller.clearTags();
                            },
                            child: const Text('Clear Tags'),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                    _formKey.currentState?.saveAndValidate();
                  },
                  child: const Text('Create Item'),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ))
              ])))
    ]);
  }
}
