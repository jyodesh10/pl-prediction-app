


import 'package:flutter/material.dart';

showSnackbar (context, String label) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
}