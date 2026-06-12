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

      // Login / Registro
      'enter_details': 'Ingresa tus datos para continuar',
      'name': 'Nombre',
      'id': 'ID',
      'accept_terms': 'Acepto los términos y condiciones',

      // Navegación
      'stays': 'Estancias',
      'plays': 'Actividades',
      'search': 'Buscar',

      // Publicaciones
      'company': 'Empresa',
      'career': 'Carrera',
      'date': 'Fecha',
      'description': 'Descripción',
      'see_details': 'Ver detalles',
      'add_pictures_videos': 'Agregar imágenes y videos',
      'post': 'Publicar',

      // Acciones
      'edit': 'Editar',
      'like': 'Me gusta',

      // Extras que aparecen o seguramente usarás
      'logout': 'Cerrar sesión',
      'terms_conditions': 'Términos y condiciones',
      'loading': 'Cargando...',
      'error': 'Error',
      'success': 'Éxito',
      'save': 'Guardar',
      'close': 'Cerrar',
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
      // Login / Register
      'enter_details': 'Enter your details to continue',
      'name': 'Name',
      'id': 'ID',
      'accept_terms': 'I accept the terms and conditions',

      // Navigation
      'stays': 'Stays',
      'plays': 'Activities',
      'search': 'Search',

      // Posts
      'company': 'Company',
      'career': 'Career',
      'date': 'Date',
      'description': 'Description',
      'see_details': 'See details',
      'add_pictures_videos': 'Add pictures and videos',
      'post': 'Post',

      // Actions
      'edit': 'Edit',
      'like': 'Like',

      // Extras
      'logout': 'Logout',
      'terms_conditions': 'Terms and conditions',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'save': 'Save',
      'close': 'Close',
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
