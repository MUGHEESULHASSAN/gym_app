
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;

  const PrimaryButton({super.key, required this.label, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      child: loading ? const SizedBox(height:24,width:24,child:CircularProgressIndicator(strokeWidth:2)) : Text(label),
    );
  }
}
