import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedStrings = {
    'es': {
      'login': 'Iniciar sesión',
      'register': 'Registrarse',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'home': 'Inicio',
      'profile': 'Perfil',
      'posts': 'Publicaciones',
      'delete': 'Eliminar',
      'cancel': 'Cancelar',
      'delete_confirm': '¿Estás seguro?',
      'no_posts': 'No hay publicaciones aún',
      // agrega más según necesites
    },
    'en': {
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'home': 'Home',
      'profile': 'Profile',
      'posts': 'Posts',
      'delete': 'Delete',
      'cancel': 'Cancel',
      'delete_confirm': 'Are you sure?',
      'no_posts': 'No posts yet',
    },
  };

  String translate(String key) {
    return _localizedStrings[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['es', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
