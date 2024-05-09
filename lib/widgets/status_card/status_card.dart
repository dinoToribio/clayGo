import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final bool isOnline;
  const StatusCard({
    super.key,
    required this.isOnline,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(
          7,
        ),
        border: Border.all(color: Colors.white, width: 3)
      ),
      child: Text(
        isOnline ? "ONLINE" : "OFFLINE",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
