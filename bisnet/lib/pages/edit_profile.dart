import 'dart:io';
import 'package:flutter/material.dart';
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

  File? _selectedPhoto;
  String? _currentPhotoPath;
  bool _uploadingPhoto = false;

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
    _currentPhotoPath = widget.user?['profile_photo'];
  }

  @override
  void dispose() {
    nameController.dispose();
    careerController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() {
      _selectedPhoto = File(picked.path);
      _uploadingPhoto = true;
    });

    try {
      final response = await AuthService.updateProfilePhoto(_selectedPhoto!);
      if (response.containsKey('user')) {
        setState(() {
          _currentPhotoPath = response['user']['profile_photo'];
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Foto actualizada')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'No se pudo subir la foto'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
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

                  // FOTO DE PERFIL
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF488C61),
                              width: 2,
                            ),
                            color: const Color(0xFFEFEFEF),
                          ),
                          child: ClipOval(
                            child: _selectedPhoto != null
                                ? Image.file(_selectedPhoto!, fit: BoxFit.cover)
                                : (_currentPhotoPath != null
                                      ? Image.network(
                                          '${AuthService.storageUrl}/$_currentPhotoPath',
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => const Icon(
                                            Icons.person,
                                            size: 56,
                                            color: Color(0xFF488C61),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 56,
                                          color: Color(0xFF488C61),
                                        )),
                          ),
                        ),
                        if (_uploadingPhoto)
                          const Positioned.fill(
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _uploadingPhoto ? null : _pickAndUploadPhoto,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF488C61),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                      onPressed: () async {
                        try {
                          final response = await AuthService.updateProfile(
                            name: nameController.text,
                            career: careerController.text,
                            description: descriptionController.text,
                          );

                          if (response.containsKey('user')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(t.profileUpdatedSuccessfully),
                              ),
                            );

                            Navigator.pop(context, response['user']);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  response['message'] ?? t.errorUpdatingProfile,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${t.error}: $e')),
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
