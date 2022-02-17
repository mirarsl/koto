import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const mainColor = Color(0xFF1F8281);

const loaderIndicator = CircularProgressIndicator(color: Colors.white);

void launchURL(_url) async {
  await launch(_url);
}
