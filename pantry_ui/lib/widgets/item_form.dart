import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  late String url;

  void updateImage(String newUrl) {
    setState(() {
      url = newUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    url = 'https://d1xih0ax78qrb8.cloudfront.net/images/64e1c18a-3f3d-4406-acf4-ef4df1a9fd31.png';
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<AppState>();
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
                FormBuilderTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                  name: 'url',
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    _formKey.currentState?.saveAndValidate();
                    uploadImageUrl(appState.accessToken, _formKey.currentState?.value['url'])
                        .then((value) => updateImage(value));
                  },
                  child: const Text('Submit'),
                )
              ],
            ),
        ))]);
  }
}
