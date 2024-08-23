import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedShoppingCart extends StatefulWidget {
  final bool isSelectedCarShopingModule;

  const AnimatedShoppingCart({super.key, required this.isSelectedCarShopingModule});

  @override
  AnimatedShoppingCartState createState() => AnimatedShoppingCartState();
}

class AnimatedShoppingCartState extends State<AnimatedShoppingCart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animationOffset;
  bool isGoldColor = false; // To track if the color should be gold

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _animationController = AnimationController(
      duration: const Duration(seconds: 1), // Duration for one cycle of movement
      vsync: this, // Use `this` as TickerProvider
    );

    // Create an animation for moving the image
    _animationOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.2, 0), // Move slightly to the right
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Repeatedly start the animation every 5 seconds
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _animateCart();
    });
  }

  // Method to animate the cart
  void _animateCart() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    // Change color to gold or revert to normal
    setState(() {
      isGoldColor = !isGoldColor;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap and update parent state
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/car-shop',
          (Route<dynamic> route) => false,
          arguments: 0,
        );
      },
      child: SlideTransition(
        position: _animationOffset,
        child: Image.asset(
          'lib/assets/carrito@2x.png',
          width: 50,
          color: isGoldColor
              ? const Color(0xFFFFD700)
              : (widget.isSelectedCarShopingModule ? const Color(0xFF053452) : Colors.grey),
        ),
      ),
    );
  }
}
