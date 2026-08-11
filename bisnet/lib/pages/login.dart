import 'package:flutter/material.dart';
import 'package:bisnet/pages/email.dart';
import 'package:bisnet/pages/register.dart';
import 'package:bisnet/pages/home.dart';
import 'package:bisnet/L10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0D3C24),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),

              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
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
                    // -----------------------------
                    // WELCOME
                    // -----------------------------
                    Text(
                      t.welcomeTo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      'BISNET',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF488C61),
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // -----------------------------
                    // DESCRIPTION
                    // -----------------------------
                    Text(
                      t.connectCommunity,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // -----------------------------
                    // CHARACTER
                    // -----------------------------
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final imageHeight = constraints.maxWidth < 350
                            ? 210.0
                            : 260.0;

                        return Image.asset(
                          'assets/Lechuzas/Lechuza_3.png',
                          height: imageHeight,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.error_outline,
                              size: 120,
                              color: Colors.red,
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // -----------------------------
                    // LOGIN
                    // -----------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginFormScreen(),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF488C61),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),

                          elevation: 0,
                        ),

                        child: Text(
                          t.login,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // -----------------------------
                    // REGISTER
                    // -----------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterFormScreen(),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF488C61),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),

                          elevation: 0,
                        ),

                        child: Text(
                          t.register,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // -----------------------------
                    // EXPLORE AS GUEST
                    // -----------------------------
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomeScreen(isGuest: true),
                          ),
                        );
                      },

                      child: Text(
                        t.exploreGuest,
                        style: const TextStyle(
                          color: Color(0xFF488C61),
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 2),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
