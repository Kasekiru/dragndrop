import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class M02Provider with ChangeNotifier {
  String? _image;
  String? get image => _image;
  set image(value) {
    _image = value;
    notifyListeners();
  }

  double _score = 0;
  double get score => _score;
  set score(value) {
    _score = value;
    notifyListeners();
  }

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  set selectedDate(value) {
    _selectedDate = value;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();
  ImagePicker get picker => _picker;

  final TextEditingController _dateController = TextEditingController();
  TextEditingController get dateController => _dateController;

  final String _keyscore = 'score';
  final String _keyImage = 'image';
  final String _keyDateDay = 'date_day';
  final String _keyDateMonth = 'date_month';
  final String _keyDateYear = 'date_year';
  late SharedPreferences prefs;

  void loadData() async {
    prefs = await SharedPreferences.getInstance();
    _score = (prefs.getDouble(_keyscore) ?? 0);
    _image = prefs.getString(_keyImage);
    _selectedDate = DateTime(
        prefs.getInt(_keyDateYear) ?? DateTime.now().year,
        prefs.getInt(_keyDateMonth) ?? DateTime.now().month,
        prefs.getInt(_keyDateDay) ?? DateTime.now().day);
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    notifyListeners();
  }

  Future<void> setScore(double value) async {
    prefs = await SharedPreferences.getInstance();

    prefs.setDouble(_keyscore, value);
    _score = prefs.getDouble(_keyscore) ?? 0;
    notifyListeners();
  }

  Future<void> setImage(String? value) async {
    prefs = await SharedPreferences.getInstance();
    if (value != null) {
      prefs.setString(_keyImage, value);
      _image = prefs.getString(_keyImage);
    }
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2024),
    );
    // save
    prefs = await SharedPreferences.getInstance();
    if (picked != null) {
      _selectedDate = picked;
      prefs.setInt(_keyDateYear, _selectedDate!.year);
      prefs.setInt(_keyDateMonth, _selectedDate!.month);
      prefs.setInt(_keyDateDay, _selectedDate!.day);
      _selectedDate = DateTime(
          prefs.getInt(_keyDateYear) ?? DateTime.now().year,
          prefs.getInt(_keyDateMonth) ?? DateTime.now().month,
          prefs.getInt(_keyDateDay) ?? DateTime.now().day);
      _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
    // text control
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    notifyListeners();
  }
}
