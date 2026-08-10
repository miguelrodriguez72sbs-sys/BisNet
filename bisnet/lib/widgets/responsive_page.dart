import 'package:flutter/material.dart';

/// En pantallas anchas (web/escritorio) centra el contenido con un ancho
/// máximo para que no se vea estirado como en el emulador.
/// En pantallas pequeñas (móvil) no cambia nada.
class ResponsivePage extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final Color? background;

  const ResponsivePage({
    super.key,
    required this.child,
    this.maxWidth = 820,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 800;
    if (!isWide) return child;
    return Container(
      color: background ?? const Color(0xFFF9F9F4),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
