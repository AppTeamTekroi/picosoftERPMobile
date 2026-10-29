import 'package:flutter/material.dart';
import 'package:mobile_erp/constants/sized_box_utils.dart';

class OptionsButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function() onTap;

  const OptionsButton(
      {super.key,
      required this.label,
      required this.onTap,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.16),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.blueAccent,
              size: 17,
            ),
            SizedBoxUtils.width3,
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
