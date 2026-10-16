import 'package:bloodline_mobile/core/design_system/theme/bloodline_colors.dart';
import 'package:flutter/material.dart';

class BloodlinePanel extends StatelessWidget {
  const BloodlinePanel({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: BloodlineColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: BloodlineColors.border,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
