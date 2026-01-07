import 'dart:convert';
import 'package:flutter/services.dart';
import '../../data/models/form_field_model.dart';

class JsonParser {
  static Future<List<FormFieldModel>> loadForm(String assetPath) async {
    try {
      final String response = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> steps = data['steps'];

      return steps.map((e) => FormFieldModel.fromJson(e)).toList();
    } catch (e) {
      print("Error parsing JSON: $e");
      return [];
    }
  }
}