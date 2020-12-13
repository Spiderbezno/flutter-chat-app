import 'dart:io';

class Envirotments {
  static String apiURL = Platform.isAndroid ? 'http://10.0.2.2:3000/api' : 'http://127.0.0.1:3000/api';
  static String socketURL = Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://127.0.0.1:3000';
}
