import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:laravel_reverb/laravel_reverb.dart';
import 'package:bisnet/services/auth_service.dart';

/// Cliente de tiempo real (Laravel Reverb).
///
/// Mantiene una única instancia de [Reverb] conectada al servidor de
/// WebSockets del backend (puerto 8080 por defecto) usando el protocolo
/// Pusher. Los canales privados se autorizan contra
/// `/api/broadcasting/auth` con el token Sanctum.
class RealtimeService {
  RealtimeService._();

  static final RealtimeService instance = RealtimeService._();

  static const String appKey =
      'MxI4LXRox4AX6rjeXrTCGLJ7rn4iehBGE82uWQEp2vk=';

  /// URL del servidor Reverb (host + puerto donde corre
  /// `php artisan reverb:start --port=8080`).
  ///
  /// - Con cloudflared: `https://<tunel-reverb>.trycloudflare.com` (cambiar
  ///   cada vez que se inicie un túnel apuntando al puerto 8080).
  /// - Local: `http://localhost:8080` (en el emulador Android se normaliza
  ///   automáticamente a `10.0.2.2`).
  static const String reverbUrl =
      'https://fence-molecular-humanities-reef.trycloudflare.com';

  static Uri get _reverbUri {
    final uri = Uri.parse(reverbUrl);
    final isLocal = uri.host == 'localhost';
    final host = (Platform.isAndroid && isLocal) ? '10.0.2.2' : uri.host;
    return uri.replace(host: host);
  }

  Reverb? _reverb;

  /// La instancia activa de [Reverb], o `null` si aún no se ha conectado.
  Reverb? get reverb => _reverb;

  /// Conecta al servidor de WebSockets si aún no está conectado.
  ///
  /// Devuelve la instancia de [Reverb] lista para suscribirse a canales.
  Future<Reverb> ensureConnected() async {
    final existing = _reverb;
    if (existing != null) {
      final state = existing.state;
      if (state == ReverbState.connected ||
          state == ReverbState.connecting ||
          state == ReverbState.reconnecting) {
        return existing;
      }
      await existing.connect();
      return existing;
    }

    final token = await AuthService.getToken();
    final uri = _reverbUri;

    final client = Reverb(
      host: uri.host,
      port: uri.port,
      appKey: appKey,
      useTls: uri.scheme == 'https',
      authEndpoint: '${AuthService.baseUrl}/broadcasting/auth',
      authHeaders: () async => {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      onError: (error, stackTrace) =>
          debugPrint('Realtime error: $error $stackTrace'),
      onLog: (message) => debugPrint('Realtime: $message'),
    );

    _reverb = client;
    await client.connect();
    return client;
  }

  /// Cierra la conexión y descarta todos los canales al cerrar sesión.
  Future<void> disconnectForLogout() async {
    final client = _reverb;
    _reverb = null;
    if (client != null) {
      await client.disconnect(forget: true);
    }
  }
}
