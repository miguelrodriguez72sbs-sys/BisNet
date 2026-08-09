import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:bisnet/services/auth_service.dart';

/// Envuelve pusher_channels_flutter para manejar la conexión en tiempo real
/// de notificaciones y chat. Se inicializa una sola vez por sesión (por
/// ejemplo, justo después del login o al abrir el Home).
class PusherService {
  PusherService._();
  static final PusherService instance = PusherService._();

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    await _pusher.init(
      apiKey: AuthService.pusherKey,
      cluster: AuthService.pusherCluster,
      onAuthorizer: _authorizer,
      onConnectionStateChange: (currentState, previousState) {},
      onError: (message, code, e) {},
      onEvent: (event) {},
    );

    await _pusher.connect();
    _initialized = true;
  }

  // Autoriza la suscripción a canales privados usando el token Sanctum
  // (en vez de la cookie de sesión que usaría un navegador normal).
  Future<dynamic> _authorizer(
    String channelName,
    String socketId,
    dynamic options,
  ) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse(AuthService.broadcastAuthUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
      body: {'socket_id': socketId, 'channel_name': channelName},
    );

    return jsonDecode(response.body);
  }

  // Suscribe al canal privado de notificaciones del usuario actual
  Future<void> subscribeToNotifications({
    required int userId,
    required void Function(Map<String, dynamic> data) onNotification,
  }) async {
    await init();
    await _pusher.subscribe(
      channelName: 'private-notifications.$userId',
      onEvent: (event) {
        if (event.eventName == 'notification.created' && event.data != null) {
          onNotification(jsonDecode(event.data!));
        }
      },
    );
  }

  Future<void> unsubscribeFromNotifications(int userId) async {
    await _pusher.unsubscribe(channelName: 'private-notifications.$userId');
  }

  // Suscribe al canal privado de chat entre dos usuarios
  Future<void> subscribeToChat({
    required int myId,
    required int otherId,
    required void Function(Map<String, dynamic> data) onMessage,
  }) async {
    await init();
    final ids = [myId, otherId]..sort();
    await _pusher.subscribe(
      channelName: 'private-chat.${ids[0]}.${ids[1]}',
      onEvent: (event) {
        if (event.eventName == 'message.sent' && event.data != null) {
          onMessage(jsonDecode(event.data!));
        }
      },
    );
  }

  Future<void> unsubscribeFromChat({
    required int myId,
    required int otherId,
  }) async {
    final ids = [myId, otherId]..sort();
    await _pusher.unsubscribe(channelName: 'private-chat.${ids[0]}.${ids[1]}');
  }
}
