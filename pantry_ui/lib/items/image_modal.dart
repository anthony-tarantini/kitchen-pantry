import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../networking/api_client.dart';

class ImageModal extends StatefulWidget {
  final String accessToken;
  final String type;
  final ValueSetter<String> callback;

  const ImageModal({super.key, required this.type, required this.accessToken, required this.callback});

  @override
  State<ImageModal> createState() => _ImageModalState();
}

class _ImageModalState extends State<ImageModal> {
  File? file;
  String? url;

  Future<void> selectFile() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'png'],
    );
    XFile? chosenFile = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    if (chosenFile != null) {
      setState(() {
        file = File(chosenFile.path);
      });
    }
  }

  void updateUrl(String url) {
    setState(() {
      this.url = url;
    });
  }

  Future<void> upload() async {
    if (widget.type == 'file' && file != null) {
      widget.callback(await ApiClient().uploadImage(widget.accessToken, file!));
    } else if (widget.type == 'url' && url != null) {
      widget.callback(await ApiClient().uploadImageUrl(widget.accessToken, url!));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      height: 400,
      color: theme.colorScheme.inversePrimary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.type == 'file' && file != null)
              Image.network(file!.path, width: 250, height: 250)
            else if (widget.type == 'url' && url != null)
              Image.network(url!, width: 250, height: 250)
            else
              SizedBox(
                height: 250,
                width: 250,
              ),
            if (widget.type == 'file')
              Padding(
                padding: EdgeInsets.all(15),
                child: ElevatedButton(child: const Text('Select File'), onPressed: () => selectFile()),
              ),
            if (widget.type == 'url')
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                  child: TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.add_link, color: theme.iconTheme.color),
                          floatingLabelStyle: theme.primaryTextTheme.labelSmall,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder()),
                      onChanged: (text) => updateUrl(text))),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.all(15),
                  child: ElevatedButton(
                    child: const Text('Upload'),
                    onPressed: () {
                      upload().then((value) => Navigator.pop(context));
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: ElevatedButton(
                    child: const Text('Close'),
                    onPressed: () => Navigator.pop(context),
                  ))
            ]),
          ],
        ),
      ),
    );
  }
}
