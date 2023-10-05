import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m02/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBio extends StatefulWidget {
  const MyBio({Key? key}) : super(key: key);

  @override
  State<MyBio> createState() => _MyBioState();
}

class _MyBioState extends State<MyBio> {
  @override
  Widget build(BuildContext context) {
    // Provider
    var loadProvider = Provider.of<M02Provider>(context);

    // load Data to Provider
    loadProvider.loadData();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bio')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(color: Colors.red),
                child: (loadProvider.image != null)
                    ? Image.file(
                        File(loadProvider.image!),
                        width: 200,
                        height: 200,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 198, 198, 198)),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    XFile? image = await loadProvider.picker
                        .pickImage(source: ImageSource.gallery);
                    loadProvider.setImage(image?.path);
                  },
                  child: const Text('Take Image'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SpinBox(
                  max: 10,
                  min: 0,
                  value: loadProvider.score,
                  decimals: 1,
                  step: 0.1,
                  decoration: const InputDecoration(labelText: 'Decimals'),
                  onChanged: (value) {
                    loadProvider.setScore(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: loadProvider.dateController,
                  decoration: InputDecoration(
                    labelText: 'Select a Date',
                    suffixIcon: IconButton(
                      onPressed: () => loadProvider.selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                  onTap: () {
                    loadProvider.selectDate(
                        context); // Open the date picker when the text field is tapped
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
