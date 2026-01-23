import 'package:flutter/material.dart';

/// Animated Parking Marker Widget
/// Creates a pulsing animation to draw attention to parking lots
class AnimatedParkingMarker extends StatefulWidget {
  final Color color;
  final double size;
  final bool isSelected;

  const AnimatedParkingMarker({
    super.key,
    required this.color,
    this.size = 64,
    this.isSelected = false,
  });

  @override
  State<AnimatedParkingMarker> createState() => _AnimatedParkingMarkerState();
}

class _AnimatedParkingMarkerState extends State<AnimatedParkingMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing circles
            if (!widget.isSelected) ...[
              // Outer pulse
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: _pulseAnimation.value),
                  ),
                ),
              ),
              // Middle pulse
              Transform.scale(
                scale: _scaleAnimation.value * 0.7,
                child: Container(
                  width: widget.size * 0.7,
                  height: widget.size * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(
                      alpha: _pulseAnimation.value * 0.5,
                    ),
                  ),
                ),
              ),
            ],
            // Main icon
            Transform.scale(
              scale: widget.isSelected ? 1.15 : 1.0,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_parking,
                  color: widget.color,
                  size: widget.size * 0.6,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

