import 'dart:async';
import 'dart:convert';
import 'dart:io';


class Config {
  final File configFile = new File('config.json');

  Config();

  Future<Map<String, Symbol>> load() async {
    String fileString;
    Map json;
    try {
      fileString = await configFile.readAsString();
      json = JSON.decode(fileString);
    } on FileSystemException catch (e) {
      print("IO error: ${e.message}");
    } on FormatException catch (e) {
      print('IO error: ${e.message}');
    }
    return json;
  }
}