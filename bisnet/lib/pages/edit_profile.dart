import 'package:flutter/material.dart';
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
