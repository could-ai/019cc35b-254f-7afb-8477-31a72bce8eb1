import 'package:flutter/material.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://placeholder.com/wp-content/uploads/2018/10/placeholder.com-logo1.jpg'), // Fallback or solid color if fails
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Color(0xFF222222), Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Survivor_01", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text("Lvl 55", style: TextStyle(color: Colors.amber, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.diamond, color: Colors.cyan, size: 16),
                          SizedBox(width: 5),
                          Text("9999", style: TextStyle(color: Colors.white)),
                          SizedBox(width: 15),
                          Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                          SizedBox(width: 5),
                          Text("5000", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Character Preview (Placeholder)
              SizedBox(
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Aura effect
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 50, spreadRadius: 10),
                        ],
                      ),
                    ),
                    // Character
                    Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png', // Just a placeholder sprite (Charizard) to look cool, or use Icon
                      height: 250,
                      errorBuilder: (c, o, s) => const Icon(Icons.accessibility_new, size: 200, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Mode Selector
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.map, color: Colors.white70),
                    SizedBox(width: 10),
                    Text("BERMUDA - CLASSIC", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Start Button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0, left: 40, right: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/game');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 10,
                    ),
                    child: const Text(
                      "START",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
