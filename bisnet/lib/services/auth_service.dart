import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AuthService {
  static const String baseUrl =
      'https://e81cc284d899b2.lhr.life/api'; //cambiar cada vez que se inicie el comando ssh -R 80:127.0.0.1:8000 localhost.run

  static String get gameUrl {
    return baseUrl.replaceAll(
      '/api',
      '/juego-phaser_3/juego-phaser/index.html',
    );
  } //Ruta de la página del juego

  //
  // Guarda el token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static String get storageUrl {
    return baseUrl.replaceAll('/api', '/storage');
  }

  // Obtiene el token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Elimina el token (logout)
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String identification,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        'name': name,
        'identification': identification,
        'email': email,
        'password': password,
      }),
    );

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    final data = jsonDecode(response.body);

    // Guarda el token automáticamente
    if (data.containsKey('token')) {
      await saveToken(data['token']);
    }

    return data;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    // Guarda el token automáticamente
    if (data.containsKey('token')) {
      await saveToken(data['token']);
    }

    return data;
  }

  // Actualizar perfil
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? career,
    String? description,
  }) async {
    final token = await getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (career != null) 'career': career,
        if (description != null) 'description': description,
      }),
    );

    return jsonDecode(response.body);
  }

  // Obtener perfil
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    return jsonDecode(response.body);
  }

  // Ver todas las publicaciones
  static Future<List<dynamic>> getPosts() async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    return jsonDecode(response.body);
  }

  // Crear publicación
  static Future<Map<String, dynamic>> createPost({
    required String title,
    required String description,
    File? mediaFile,
  }) async {
    final token = await getToken();

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'));

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'ngrok-skip-browser-warning': 'true',
    });

    request.fields['title'] = title;
    request.fields['description'] = description;

    if (mediaFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('media', mediaFile.path),
      );
    }

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode >= 400) {
      throw Exception(response.body);
    }

    return jsonDecode(response.body);
  }

  // Borrar publicación
  static Future<Map<String, dynamic>> deletePost(int id) async {
    final token = await getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    return jsonDecode(response.body);
  }

  // Toggle like en un post
  static Future<Map<String, dynamic>> toggleLike(int postId) async {
    final token = await getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/like'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    return jsonDecode(response.body);
  }

  // Ver mis publicaciones
  static Future<List<dynamic>> getMyPosts() async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/posts/my'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    return jsonDecode(response.body);
  }

  // Ver todas las estadías
  static Future<List<dynamic>> getEstadias({
    String? search,
    String? carrera,
  }) async {
    final token = await getToken();

    String url = '$baseUrl/estadias';
    if (search != null && search.isNotEmpty) {
      url += '?search=$search';
    } else if (carrera != null && carrera.isNotEmpty) {
      url += '?carrera=$carrera';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    return jsonDecode(response.body);
  }

  // ===== COMUNIDADES =====

  // Ver todas las comunidades
  static Future<List<dynamic>> getCommunities() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/communities'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );
    return jsonDecode(response.body);
  }

  // Crear comunidad
  static Future<Map<String, dynamic>> createCommunity({
    required String name,
    required String description,
    required String type, // 'public' o 'private'
    File? image,
  }) async {
    final token = await getToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/communities'),
    );
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'ngrok-skip-browser-warning': 'true',
    });
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['type'] = type;
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return jsonDecode(response.body);
  }

  // Unirse a comunidad
  static Future<Map<String, dynamic>> joinCommunity(int id) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/communities/$id/join'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );
    return jsonDecode(response.body);
  }

  // Salir de comunidad
  static Future<Map<String, dynamic>> leaveCommunity(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/communities/$id/leave'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );
    return jsonDecode(response.body);
  }

  // Ver miembros
  static Future<List<dynamic>> getCommunityMembers(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/communities/$id/members'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );
    return jsonDecode(response.body);
  }

  // Ver mensajes del chat
  static Future<List<dynamic>> getCommunityMessages(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/communities/$id/messages'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );
    return jsonDecode(response.body);
  }

  // Enviar mensaje
  static Future<Map<String, dynamic>> sendCommunityMessage({
    required int communityId,
    required String message,
  }) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/communities/$communityId/messages'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({'message': message}),
    );
    return jsonDecode(response.body);
  }
}
