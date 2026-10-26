import 'package:flutter/material.dart';

class TicklyLogo extends StatelessWidget {
  const TicklyLogo({super.key, this.size = 36});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF8E7BD8), Color(0xFF6550B4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(size * .28),
    ),
    child: Icon(Icons.check_rounded, color: Colors.white, size: size * .72),
  );
}
