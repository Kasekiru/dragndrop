import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BioData(),
      child: const MyApp(),
    ),
  );
}

class BioData extends ChangeNotifier {
  String? _image;
  double _score = 0;
  DateTime? _selectedDate;

  String? get image => _image;
  double get score => _score;
  DateTime? get selectedDate => _selectedDate;

  void setImage(String? imagePath) {
    _image = imagePath;
    notifyListeners();
  }

  void setScore(double newScore) {
    _score = newScore;
    notifyListeners();
  }

  void setSelectedDate(DateTime? newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MingguKedua(),
    );
  }
}

class MingguKedua extends StatefulWidget {
  const MingguKedua({Key? key}) : super(key: key);

  @override
  State<MingguKedua> createState() => MingguKeduaState();
}

class MingguKeduaState extends State<MingguKedua> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadDataFromPrefs();
  }

  Future<void> _loadDataFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final savedImage = prefs.getString('image_path');
      final savedDate = prefs.getInt('selected_date');

      if (savedImage != null) {
        Provider.of<BioData>(context, listen: false).setImage(savedImage);
        Provider.of<BioData>(context, listen: false).setSelectedDate(
          savedDate != null
              ? DateTime.fromMillisecondsSinceEpoch(savedDate)
              : null,
        );
      }
    } catch (e) {
      print('Error loading data from SharedPreferences: $e');
    }
  }

  Future<void> _saveDataToPrefs(
      String imagePath, DateTime? selectedDate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('image_path', imagePath);

      if (selectedDate != null) {
        await prefs.setInt(
            'selected_date', selectedDate.millisecondsSinceEpoch);
      } else {
        await prefs.remove('selected_date');
      }
    } catch (e) {
      print('Error saving data to SharedPreferences: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Provider.of<BioData>(context, listen: false).setImage(image.path);
      _saveDataToPrefs(image.path,
          Provider.of<BioData>(context, listen: false).selectedDate);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final bioData = Provider.of<BioData>(context, listen: false);
    final currentImage =
        bioData.image ?? ''; // Provide a default empty string if null
    final currentSelectedDate = bioData.selectedDate;

    final DateTime pickedDate = (await showDatePicker(
          context: context,
          initialDate: currentSelectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        )) ??
        DateTime.now();

    if (pickedDate != null && pickedDate != currentSelectedDate) {
      bioData.setSelectedDate(pickedDate);
      _saveDataToPrefs(currentImage, pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bioData = Provider.of<BioData>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Bio")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              if (bioData.image != null)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.red[200],
                  ),
                  child: Image.network(
                    bioData.image!, // Display the chosen image if available
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                )
              else
                PlaceholderImage(),
              if (bioData.selectedDate != null)
                Text(
                  "Selected Date: ${bioData.selectedDate!.toLocal()}"
                      .split(' ')[0],
                  style: TextStyle(fontSize: 16),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: Text("Pick Image"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text("Select Date"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinBox(
                  max: 10.0,
                  min: 0.0,
                  value: bioData.score,
                  decimals: 1,
                  step: 0.1,
                  decoration: InputDecoration(labelText: 'Decimals'),
                  onChanged: (newValue) {
                    Provider.of<BioData>(context, listen: false)
                        .setScore(newValue);
                  },
                ),
              ),
              Text('${bioData.selectedDate}')
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Icon(
        Icons.camera_alt,
        color: Colors.grey[800],
      ),
    );
  }
}