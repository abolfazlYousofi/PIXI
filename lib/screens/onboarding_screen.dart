import 'package:flutter/material.dart';
import '../utils/strings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<Map<String, String>> data = [
    {
      'image': 'assets/images/ai_photo1.png',
      'titleKey': 'welcomeTitle',
      'descKey': 'welcomeDesc',
    },
    {
      'image': 'assets/images/ai_photo2.png',
      'titleKey': 'welcomeTitle',
      'descKey': 'welcomeDesc',
    },
    {
      'image': 'assets/images/ai_photo3.png',
      'titleKey': 'welcomeTitle',
      'descKey': 'welcomeDesc',
    },
  ];

  void _next() {
    if (_page == data.length - 1) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF7B2FF7);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: data.length,
                itemBuilder: (context, i) {
                  final item = data[i];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(item['image']!, height: 300),
                        const SizedBox(height: 30),
                        Text(
                          t(context, item['titleKey']!),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t(context, item['descKey']!),
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(data.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: _page == i ? 28 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _page == i ? accent : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _page == data.length - 1
                            ? t(context, 'start')
                            : t(context, 'next'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
