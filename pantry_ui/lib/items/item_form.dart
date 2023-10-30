import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pantry_ui/items/Image_modal.dart';
import 'package:pantry_ui/networking/api_client.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();

    url = 'https://d1xih0ax78qrb8.cloudfront.net/images/64e1c18a-3f3d-4406-acf4-ef4df1a9fd31.png';
    file = null;
  }

  void updateImage(String newUrl) {
    setState(() {
      url = newUrl;
    });
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
                Center(child: Image.network(url)),
                Row(
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
                ),
                ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState?.saveAndValidate();
                    var imageUrl = await uploadImageFromUrl();
                    updateImage(imageUrl);
                  },
                  child: const Text('Create Item'),
                )
              ],
            ),
        ))]);
  }
}
