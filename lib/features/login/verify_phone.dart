import 'package:flutter/material.dart';
import './phone_login_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  
  @override
  State<PhoneScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<PhoneScreen> {

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;

    final headlineSize = w < 420 ? 40.0 : 44.0;
    final buttonHeight = 56.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1520975958225-1c74f5a4b2de?auto=format&fit=crop&w=1200&q=80",
            fit: BoxFit.cover,
          ),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                  Colors.black87,
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    children: [
                      Icon(Icons.baby_changing_station, color: const Color(0xFFFF00BF), size: 28),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.language, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'English',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 6),                          
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "Let’s get",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: headlineSize,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),
                  Text(
                    "you there",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: headlineSize,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneLoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B48FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: const Text(
                        'Get started',
                        style: TextStyle(
                          color: Color(0xFFEAEAEA),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Ready to earn? Open the driver app.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}