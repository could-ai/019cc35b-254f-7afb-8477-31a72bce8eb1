import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Game State
  Offset playerPos = const Offset(0, 0);
  double playerAngle = 0;
  List<Enemy> enemies = [];
  List<Bullet> bullets = [];
  int score = 0;
  bool isGameOver = false;
  int health = 100;
  
  // Controls
  Offset joystickDelta = Offset.zero;
  bool isFiring = false;
  
  // Loop
  Timer? gameLoop;
  final Random rng = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        playerPos = Offset(size.width / 2, size.height / 2);
      });
      startGame();
    });
  }

  void startGame() {
    gameLoop = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (isGameOver) {
        timer.cancel();
        return;
      }
      updateGame();
    });
    
    // Spawn enemies periodically
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (isGameOver) {
        timer.cancel();
        return;
      }
      spawnEnemy();
    });
  }

  void spawnEnemy() {
    final size = MediaQuery.of(context).size;
    // Spawn at random edge
    double x, y;
    if (rng.nextBool()) {
      x = rng.nextBool() ? -20 : size.width + 20;
      y = rng.nextDouble() * size.height;
    } else {
      x = rng.nextDouble() * size.width;
      y = rng.nextBool() ? -20 : size.height + 20;
    }
    
    setState(() {
      enemies.add(Enemy(position: Offset(x, y), speed: 2.0 + (score * 0.1)));
    });
  }

  void updateGame() {
    final size = MediaQuery.of(context).size;

    setState(() {
      // Move Player
      if (joystickDelta != Offset.zero) {
        playerPos += joystickDelta * 4.0;
        // Clamp to screen
        playerPos = Offset(
          playerPos.dx.clamp(0, size.width),
          playerPos.dy.clamp(0, size.height),
        );
        
        // Update angle based on movement
        playerAngle = joystickDelta.direction;
      }

      // Move Bullets
      for (var bullet in bullets) {
        bullet.position += Offset(cos(bullet.angle), sin(bullet.angle)) * 10.0;
      }
      // Remove off-screen bullets
      bullets.removeWhere((b) => 
        b.position.dx < 0 || b.position.dx > size.width ||
        b.position.dy < 0 || b.position.dy > size.height
      );

      // Move Enemies
      for (var enemy in enemies) {
        final angle = (playerPos - enemy.position).direction;
        enemy.position += Offset(cos(angle), sin(angle)) * enemy.speed;
      }

      // Collision Detection
      checkCollisions();
    });
  }

  void checkCollisions() {
    // Bullet hits Enemy
    for (var bullet in List.of(bullets)) {
      for (var enemy in List.of(enemies)) {
        if ((bullet.position - enemy.position).distance < 20) {
          bullets.remove(bullet);
          enemies.remove(enemy);
          score++;
          break;
        }
      }
    }

    // Enemy hits Player
    for (var enemy in List.of(enemies)) {
      if ((enemy.position - playerPos).distance < 20) {
        enemies.remove(enemy);
        health -= 10;
        if (health <= 0) {
          isGameOver = true;
          showGameOverDialog();
        }
      }
    }
  }

  void fireBullet() {
    setState(() {
      bullets.add(Bullet(position: playerPos, angle: playerAngle));
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("ELIMINATED", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text("You survived with $score kills.", style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Back to lobby
            },
            child: const Text("RETURN TO LOBBY"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game World (Grass)
          Container(color: const Color(0xFF2E7D32)),
          
          // Grid lines for "ground" feel
          CustomPaint(
            painter: GridPainter(),
            size: Size.infinite,
          ),

          // Bullets
          ...bullets.map((b) => Positioned(
            left: b.position.dx - 5,
            top: b.position.dy - 5,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
            ),
          )),

          // Enemies
          ...enemies.map((e) => Positioned(
            left: e.position.dx - 15,
            top: e.position.dy - 15,
            child: const Icon(Icons.person, color: Colors.red, size: 30),
          )),

          // Player
          Positioned(
            left: playerPos.dx - 20,
            top: playerPos.dy - 20,
            child: Transform.rotate(
              angle: playerAngle + pi / 2, // Adjust for icon orientation
              child: const Icon(Icons.navigation, color: Colors.white, size: 40),
            ),
          ),

          // UI Layer
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.black54,
                        child: Text("ALIVE: ${enemies.length + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.black54,
                        child: Text("KILLS: $score", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                
                // Controls
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Joystick (Simple implementation)
                      GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            joystickDelta = Offset(
                              details.localPosition.dx - 75,
                              details.localPosition.dy - 75,
                            ) / 75;
                            if (joystickDelta.distance > 1) {
                              joystickDelta = joystickDelta / joystickDelta.distance;
                            }
                          });
                        },
                        onPanEnd: (_) {
                          setState(() {
                            joystickDelta = Offset.zero;
                          });
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white54, width: 2),
                          ),
                          child: Center(
                            child: Transform.translate(
                              offset: joystickDelta * 40,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Fire Button
                      GestureDetector(
                        onTapDown: (_) => fireBullet(),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.redAccent, width: 2),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.my_location, color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Health Bar
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 200,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: health / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: health > 30 ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Enemy {
  Offset position;
  double speed;
  Enemy({required this.position, required this.speed});
}

class Bullet {
  Offset position;
  double angle;
  Bullet({required this.position, required this.angle});
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
