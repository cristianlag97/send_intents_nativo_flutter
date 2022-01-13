import 'package:flutter/services.dart';

class SendDataConnector {
  static const sendDataConnector = MethodChannel("com.example.send_data_intents/sendData");

  static final SendDataConnector _singleton = SendDataConnector._internal();

  factory SendDataConnector() {
    return _singleton;
  }

  SendDataConnector._internal();

  Future<void> sendAllData(String? merchantCode, String tipoTarjeta, String valorDeTarjeta, String valor, String packageName, email, password) async {
    try{
      var data = {
        "tipoTarjeta": tipoTarjeta,
        "valorDeTarjeta": valorDeTarjeta,
        "valor": valor,
        "packageName": packageName,
        "email": email,
        "password": password
      };

      if(merchantCode != null) {
        data['merchantCode'] = merchantCode;
      }
      sendDataConnector.invokeMethod("sendDataEvent", data);

    } on PlatformException catch (e) {
      print('error enviando evento');
      print(e);
    }
  }
}

