import 'dart:async';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;
import 'package:somics_os/utils/app_constants.dart';
import 'package:somics_os/utils/local_storage.dart';
import 'package:somics_os/utils/logger_helper.dart';
import 'package:somics_os/utils/shared_key.dart';

class SocketIoService extends GetxService {
  socket_io_client.Socket? _socket;

  final Rx<SocketIoConnectionState> connectionState = SocketIoConnectionState.disconnected.obs;

  bool get isConnected =>
      _socket != null && _socket!.connected && connectionState.value == SocketIoConnectionState.connected;

  String? _lastServerUri;

  static String resolveSocketServerUri(String? staffRole) {
    final uri = '${AppConstants.baseUrl}/user/noti';

    return uri;
  }

  Map<String, dynamic> _authPayload() {
    final token = LocalStorage.getString(SharedKey.token) ?? '';

    return {'token': token};
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }

  Future<void> connect({String? staffRole}) async {
    final serverUri = resolveSocketServerUri(staffRole);

    if (isConnected && _lastServerUri == serverUri) {
      return;
    }

    if (_socket != null) {
      if (_lastServerUri == serverUri) {
        try {
          _socket!.auth = _authPayload();
          _socket!.connect();
          return;
        } catch (_) {
          disconnect();
        }
      } else {
        disconnect();
      }
    }

    connectionState.value = SocketIoConnectionState.connecting;
    loggerHelper.log('Connecting to Socket.IO… $serverUri', name: 'SocketIoService');

    _lastServerUri = serverUri;
    _socket = socket_io_client.io(
      serverUri,
      socket_io_client.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setAuth(_authPayload())
          .setPath('/socket.io')
          .enableForceNew()
          .enableAutoConnect()
          .enableReconnection()
          .build(),
    );

    _socket!.on('connect_error', (data) {
      connectionState.value = SocketIoConnectionState.error;
      loggerHelper.log('[WS CONNECT_ERROR] ${data?.toString()}', name: 'SocketIoService - CONNECT_ERROR');
    });

    _socket!.on('connect_failed', (data) {
      connectionState.value = SocketIoConnectionState.error;
      loggerHelper.log('[WS CONNECT_FAILED] ${data?.toString()}', name: 'SocketIoService - CONNECT_FAILED');
    });

    _socket!.onConnect((_) {
      connectionState.value = SocketIoConnectionState.connected;
      loggerHelper.log('[WS CONNECTED] id=${_socket?.id}', name: 'SocketIoService - CONNECTED');
    });

    _socket!.onDisconnect((reason) {
      connectionState.value = SocketIoConnectionState.disconnected;
      loggerHelper.log('[WS DISCONNECTED] reason=$reason', name: 'SocketIoService - DISCONNECTED');
    });

    _socket!.onError((err) {
      connectionState.value = SocketIoConnectionState.error;
      loggerHelper.log('[WS ERROR] ${err?.toString()}');
    });

    _socket!.connect();
  }

  void disconnect() {
    if (_socket == null) return;
    try {
      _socket!.disconnect();
      _socket!.dispose();
    } catch (_) {}
    _socket = null;
    _lastServerUri = null;
    connectionState.value = SocketIoConnectionState.disconnected;
    loggerHelper.log('Socket.IO disconnected');
  }
}

enum SocketIoConnectionState { disconnected, connecting, connected, error }
