import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit;

  SocketService(){
    this._initConfig();
  }

  void _initConfig() {

    // Dart client
    this._socket = IO.io('http://192.168.1.125:3000', {
      'transports': ['websocket'],
      'autoconnect': true
    });
    this._socket.onConnect((_) {
     print('connect');
     this._serverStatus = ServerStatus.Online;
     notifyListeners();
    });
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    // socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo-mensaje: ');
    //   print('nombre:' + payload['nombre']);
    //   print('nombre:' + payload['mensaje']);
    //   print(payload.containsKey('mensaje2') ? payload['mensaje2']: 'nohay');
    // });
    // socket.off('nuevo-mensaje');
  }
}