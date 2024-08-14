import 'dart:convert';
import 'dart:developer';

import "package:http/http.dart" as http;

import 'model.dart';

const corsProxy = 'https://cors-anywhere.herokuapp.com/';
const base = "https://fantasy.premierleague.com/api";

class Apis {
  Future<BootStrapModel> fetchBootstrapData() async {
    final response = await http.get(Uri.parse('$corsProxy$base/bootstrap-static/'),
      headers: {
        'Content-Type': 'application/json', // Add if necessary
      }
    );
    log(response.toString());
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return BootStrapModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch bootstrap data');
    }
  }
}