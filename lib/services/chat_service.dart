import 'package:chat/global/envirotments.dart';
import 'package:chat/models/mensaje.dart';
import 'package:chat/models/mensajes_response.dart';
import 'package:chat/models/usurio.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatService with ChangeNotifier {
  Usuario usurioPara;

  Future<List<Mensaje>> getChat(String userID) async {
    try {
      final resp = await http.get('${Envirotments.apiURL}/mensajes/$userID', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      });

      final mensajesResponse = mensajesResponseFromJson(resp.body);
      return mensajesResponse.mensajes;
    } catch (e) {
      return [];
    }
  }
}
