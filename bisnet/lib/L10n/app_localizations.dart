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
      'accept': 'Acepto',
      'welcome_to': 'Bienvenido a',
      'connect_community':
          'Conecta con tu comunidad y planifica tus próximas estancias',
      'explore_guest': 'Explorar como invitado',
      'translator': 'Traductor',

      // Login / Registro
      'enter_details': 'Ingresa tus datos para continuar',
      'name': 'Nombre',
      'id': 'ID',
      'accept_terms': 'Acepto los términos y condiciones',

      // Navegación
      'stays': 'Estadias',
      'plays': 'Juegos',
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
      'or': 'o',
      'incorrect_credentials': 'Credenciales incorrectas',
      'login_required': 'Debes iniciar sesión para acceder a esta sección',
      'edit_profile': 'Editar perfil',
      'profile_updated_successfully': 'Perfil actualizado correctamente',
      'error_updating_profile': 'Error al actualizar el perfil',
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
      'welcome_to': 'Welcome to',
      'explore_guest': 'Explore as guest',
      'translator': 'Translator',
      // Login / Register
      'enter_details': 'Enter your details to continue',
      'name': 'Name',
      'id': 'ID',
      'accept_terms': 'I accept the terms and conditions',
      'accept': 'I accept',
      'connect_community':
          'Connect with your community and plan your future stays',

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
      'or': 'or',
      'incorrect_credentials': 'Incorrect credentials',
      'login_required': 'You must be logged in to access this section.',
      'edit_profile': 'Edit Profile',
      'profile_updated_successfully': 'Profile updated successfully',
      'error_updating_profile': 'Error updating profile',
    },
  };

  String translate(String key) {
    return _localizedStrings[locale.languageCode]?[key] ?? key;
  }

  // Getters
  String get login => translate('login');
  String get register => translate('register');
  String get email => translate('email');
  String get password => translate('password');
  String get home => translate('home');
  String get profile => translate('profile');
  String get posts => translate('posts');
  String get delete => translate('delete');
  String get cancel => translate('cancel');
  String get deleteConfirm => translate('delete_confirm');
  String get noPosts => translate('no_posts');
  String get welcomeTo => translate('welcome_to');
  String get connectCommunity => translate('connect_community');
  String get exploreGuest => translate('explore_guest');
  String get translator => translate('translator');

  String get enterDetails => translate('enter_details');
  String get name => translate('name');
  String get id => translate('id');
  String get acceptTerms => translate('accept_terms');
  String get accept => translate('accept');

  String get stays => translate('stays');
  String get plays => translate('plays');
  String get search => translate('search');

  String get company => translate('company');
  String get career => translate('career');
  String get date => translate('date');
  String get description => translate('description');
  String get seeDetails => translate('see_details');
  String get addPicturesVideos => translate('add_pictures_videos');
  String get post => translate('post');

  String get edit => translate('edit');
  String get like => translate('like');

  String get logout => translate('logout');
  String get termsConditions => translate('terms_conditions');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get save => translate('save');
  String get close => translate('close');
  String get or => translate('or');
  String get incorrectCredentials => translate('incorrect_credentials');
  String get loginRequired => translate('login_required');
  String get editProfile => translate('edit_profile');
  String get profileUpdatedSuccessfully =>
      translate('profile_updated_successfully');
  String get errorUpdatingProfile => translate('error_updating_profile');
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
