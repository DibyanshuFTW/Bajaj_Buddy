import 'package:flutter/material.dart';

class BentoShadowPainter extends CustomPainter {
  final Color shadowColor;
  final double borderRadius;

  BentoShadowPainter({required this.shadowColor, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);

    final rect = Rect.fromLTWH(0, 4, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant BentoShadowPainter oldDelegate) {
    return oldDelegate.shadowColor != shadowColor || oldDelegate.borderRadius != borderRadius;
  }
}

class BentoCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double padding;

  const BentoCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.padding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    return CustomPaint(
      painter: BentoShadowPainter(
        shadowColor: theme.shadowColor.withOpacity(0.05),
        borderRadius: 24.0,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
