import 'package:flutter/material.dart';

class ButtonNavigator extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool fullWidth;

  const ButtonNavigator({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black.withOpacity(0.08),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Color(0xFF6A0DAD), size: 28),
              const SizedBox(height: 10),
              Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF888780),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}