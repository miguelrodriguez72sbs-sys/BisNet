import 'package:flutter/material.dart';
// NUEVA PANTALLA: TÉRMINOS Y CONDICIONES

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3C24),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 320,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F4),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Imagen del Búho desde carpeta assets
                  Image.asset(
                    'assets/Lechuzas/Lechuza_2.png',
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 120,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Título
                  const Text(
                    'Terms and conditions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Texto descriptivo
                  const Text(
                    '''
TERMS AND CONDITIONS OF USE

Welcome to Bisnet. By accessing, registering for, or using the platform, you agree to comply with these Terms and Conditions of Use. Please read them carefully before using the application.

1. PURPOSE OF THE PLATFORM

The platform provides a university-focused digital space where users can:

• Share academic projects.
• Publish images and videos related to student activities.
• Interact through reactions ("likes").
• Access information about internships and professional opportunities.
• Promote collaboration and interaction among students.

2. USER REGISTRATION

To access certain features, users must register with valid and up-to-date information.

Users are responsible for:

• Maintaining the confidentiality of their account and password.
• All activities performed through their account.

The administration reserves the right to suspend accounts that contain false information, exhibit suspicious activity, or violate these Terms and Conditions.

3. PUBLISHED CONTENT

Users may share images, videos, academic projects, and other university-related content.

By publishing content, users confirm that:

• They own the content or have permission to publish it.
• The content does not violate copyright laws.
• The content does not infringe upon the rights of third parties.

4. USER CONDUCT

The following activities are strictly prohibited:

• Publishing offensive, discriminatory, violent, sexual, or defamatory content.
• Posting content unrelated to the academic environment.
• Impersonating another person.
• Manipulating information.
• Attempting to compromise platform security.
• Using the platform for illegal purposes.

5. INTERACTIONS

Users may interact with posts through reactions ("likes").

The platform does not guarantee that any publication will receive a specific level of visibility, reach, or engagement.

6. INTERNSHIPS AND PROFESSIONAL OPPORTUNITIES

This section provides information about companies, job openings, internships, and professional opportunities.

The platform does not guarantee:

• Employment opportunities.
• Acceptance into internships.
• Continuous availability of posted vacancies.

Users are responsible for verifying the authenticity and validity of the information provided.

7. PRIVACY AND PERSONAL DATA

User information is collected solely for the operation of the platform.

Personal and academic data will:

• Be treated confidentially.
• Not be shared with third parties without authorization.
• Be disclosed only when required by applicable law.

8. INTELLECTUAL PROPERTY

The platform's design, logo, structure, and visual elements are protected under applicable intellectual property laws.

Users retain ownership rights to the content they publish.

9. ACCOUNT SUSPENSION OR TERMINATION

The administration may suspend or remove accounts and content that violate these Terms and Conditions or compromise the security and proper functioning of the platform.

10. MODIFICATIONS

The platform may update these Terms and Conditions at any time to improve its functionality, security, and services.

Changes become effective once published within the application.

11. ACCEPTANCE

By registering for and using the platform, you acknowledge that you have read, understood, and accepted these Terms and Conditions of Use.
''',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1C1B1F),
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botón Accept
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Al presionar aceptar, cierra esta pantalla y regresa al Login
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF488C61),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
