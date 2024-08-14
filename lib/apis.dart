import 'dart:convert';

import "package:http/http.dart" as http;

import 'model.dart';


const base = "https://fantasy.premierleague.com/api";

class Apis {
  Future<BootStrapModel> fetchBootstrapData() async {
    final response = await http.get(Uri.parse('$base/bootstrap-static/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return BootStrapModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch bootstrap data');
    }
  }
}