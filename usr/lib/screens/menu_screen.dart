import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _opacityAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF2C1810)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background elements
            Positioned(
              top: -50,
              right: -50,
              child: Icon(Icons.local_fire_department, size: 300, color: Colors.orange.withOpacity(0.1)),
            ),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Area
                const Icon(Icons.shield, size: 80, color: Colors.amber),
                const SizedBox(height: 20),
                const Text(
                  "FREE FIRE",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.amber,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(blurRadius: 10, color: Colors.orange, offset: Offset(0, 0)),
                    ],
                  ),
                ),
                const Text(
                  "MINI BATTLEGROUNDS",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    letterSpacing: 5.0,
                  ),
                ),
                
                const SizedBox(height: 150),
                
                // Tap to start
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/lobby');
                  },
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black45,
                      ),
                      child: const Text(
                        "TAP TO BEGIN",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Version info
            const Positioned(
              bottom: 20,
              left: 20,
              child: Text("Ver 1.0.0 (Old Style)", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
