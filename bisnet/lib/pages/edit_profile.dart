import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/L10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController careerController;
  late TextEditingController descriptionController;
  File? _selectedImage;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?['name'] ?? '');
    careerController = TextEditingController(
      text: widget.user?['career'] ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.user?['description'] ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    careerController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => _selectedImage = File(image.path));
  }

  Widget _buildProfilePhoto() {
    final currentPhoto = widget.user?['profile_photo'];

    Widget avatar;
    if (_selectedImage != null) {
      avatar = ClipOval(
        child: Image.file(_selectedImage!, fit: BoxFit.cover, width: 96, height: 96),
      );
    } else if (currentPhoto != null && currentPhoto.toString().isNotEmpty) {
      avatar = ClipOval(
        child: Image.network(
          '${AuthService.storageUrl}/$currentPhoto',
          fit: BoxFit.cover,
          width: 96,
          height: 96,
          errorBuilder: (_, _, _) => const Icon(
            Icons.person,
            size: 48,
            color: Color(0xFF488C61),
          ),
        ),
      );
    } else {
      avatar = const Icon(Icons.person, size: 48, color: Color(0xFF488C61));
    }

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD9D9D9),
              border: Border.all(color: const Color(0xFF488C61), width: 2),
            ),
            child: Center(child: avatar),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF488C61),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0D3C24),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 380,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 248, 248),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LOGO + BISNET
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF488C61),
                            width: 2,
                          ),
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/Lechuzas/Logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'BISNET',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF488C61),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    t.editProfile,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // FOTO DE PERFIL
                  Center(child: _buildProfilePhoto()),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      t.tapToChangePhoto,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // NAME
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: t.name,
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF488C61),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color(0xFF488C61),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color(0xFF488C61),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // CAREER
                  TextField(
                    controller: careerController,
                    decoration: InputDecoration(
                      hintText: t.career,
                      prefixIcon: const Icon(
                        Icons.school_outlined,
                        color: Color(0xFF488C61),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color(0xFF488C61),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color(0xFF488C61),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // DESCRIPTION
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: t.description,
                      prefixIcon: const Icon(
                        Icons.description_outlined,
                        color: Color(0xFF488C61),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF488C61),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF488C61),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // BOTÓN SAVE
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF488C61),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _uploading
                          ? null
                          : () async {
                              setState(() => _uploading = true);
                              try {
                                Map<String, dynamic> updatedUser =
                                    widget.user ?? {};

                                // 1) Subir foto si se eligió una
                                if (_selectedImage != null) {
                                  final photoResponse =
                                      await AuthService.updateProfilePhoto(
                                    _selectedImage!,
                                  );
                                  if (photoResponse.containsKey('user')) {
                                    updatedUser = photoResponse['user'];
                                  }
                                }

                                // 2) Actualizar nombre/carrera/descripción
                                final response = await AuthService.updateProfile(
                                  name: nameController.text,
                                  career: careerController.text,
                                  description: descriptionController.text,
                                );

                                if (response.containsKey('user')) {
                                  updatedUser = response['user'];
                                }

                                if (!mounted) return;
                                setState(() => _uploading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      t.profileUpdatedSuccessfully,
                                    ),
                                  ),
                                );
                                Navigator.pop(context, updatedUser);
                              } catch (e) {
                                if (!mounted) return;
                                setState(() => _uploading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${t.error}: $e'),
                                  ),
                                );
                              }
                            },
                      child: Text(
                        t.save,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
