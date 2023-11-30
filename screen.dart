import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m10/camera.dart';
import 'package:m10/contactscreen.dart';
import 'package:permission_handler/permission_handler.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _pickedImage;

  // Fungsi contact
  void contact() async {
    if (await Permission.contacts.status.isGranted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ContactScreen()));
    } else {
      var status = await Permission.contacts.request();
      handlePermissionStatus(status);
    }
  }

  // Fungsi camera
  void camera() async {
    if (await Permission.camera.status.isGranted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CameraScreen()));
    } else {
      var status = await Permission.camera.request();
      handlePermissionStatus(status);
    }
  }

  // Fungsi pick image
  void pickImage() async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      final pickedFile =
          await _imagePicker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Do something with the picked image
        print("Image picked: ${pickedFile.path}");
        setState(() {
          _pickedImage = File(pickedFile.path!);
        });
      }
    } else {
      handlePermissionStatus(status);
    }
  }

  // Handle permission status
  void handlePermissionStatus(PermissionStatus status) {
    if (status == PermissionStatus.granted) {
      // Permission granted, you can proceed
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Screen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: contact, child: Text("Contact")),
            ElevatedButton(onPressed: camera, child: Text("Camera")),
            ElevatedButton(onPressed: pickImage, child: Text("Pick Image")),
            SizedBox(height: 20),
            _pickedImage != null ? Image.file(_pickedImage!) : Text(""),
          ],
        ),
      ),
    );
  }
}
