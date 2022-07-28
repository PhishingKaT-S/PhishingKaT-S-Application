import 'package:flutter/material.dart';

class SOutlinedButton extends StatelessWidget {
  const SOutlinedButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(
              0xFF0372e0,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          fixedSize: const Size(208, 50)),
    );
  }
}