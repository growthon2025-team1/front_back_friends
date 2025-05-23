import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final onboardingData = [
      {
        'textImage': {
          'src': 'assets/images/text1.png',
          'top': h * 0.18,
          'left': (w - w * 0.75) / 2,
          'w': w * 0.75,
          'h': h * 0.07,
        },
        'icons': [
          {'src': 'assets/images/bread.png', 'top': h * 0.36, 'left': w * -0.1, 'w': w * 0.2, 'h': h * 0.08},
          {'src': 'assets/images/icecream.png', 'top': h * 0.35, 'left': w * 0.32, 'w': w * 0.16, 'h': h * 0.13},
          {'src': 'assets/images/sweetpotato.png', 'top': h * 0.38, 'left': w * 0.72, 'w': w * 0.16, 'h': h * 0.08},
          {'src': 'assets/images/ramen.png', 'top': h * 0.60, 'left': w * 0.10, 'w': w * 0.25, 'h': h * 0.07},
          {'src': 'assets/images/pumpkin.png', 'top': h * 0.58, 'left': w * 0.52, 'w': w * 0.18, 'h': h * 0.09},
          {'src': 'assets/images/apple.png', 'top': h * 0.57, 'left': w * 0.87, 'w': w * 0.22, 'h': w * 0.22},
        ],
        'blurs': [
          {'src': 'assets/images/blur1.png', 'top': h * 0.33, 'left': w * -0.1},
          {'src': 'assets/images/blur2.png', 'top': h * 0.33, 'left': w * 0.25},
          {'src': 'assets/images/blur3.png', 'top': h * 0.33, 'left': w * 0.65},
          {'src': 'assets/images/blur4.png', 'top': h * 0.3, 'left': w * -0.8},
          {'src': 'assets/images/blur5.png', 'top': h * 0.55, 'left': w * 0.05},
          {'src': 'assets/images/blur6.png', 'top': h * 0.55, 'left': w * 0.45},
          {'src': 'assets/images/blur7.png', 'top': h * 0.55, 'left': w * 0.75},
        ]
      },
      {
        'textImage': {
          'src': 'assets/images/text2.png',
          'top': h * 0.18,
          'left': (w - w * 0.75) / 2,
          'w': w * 0.75,
          'h': h * 0.07,
        },
        'icons': [
          {
            'src': 'assets/images/Asset12.png',
            'top': h * 0.32,
            'center': true,
            'w': w * 0.7,
            'h': w * 0.7
          }
        ],
        'blurs': []
      },
      {
        'textImage': {
          'src': 'assets/images/text3.png',
          'top': h * 0.18,
          'left': (w - w * 0.75) / 2,
          'w': w * 0.75,
          'h': h * 0.07,
        },
        'icons': [
          {
            'src': 'assets/images/Asset19.png',
            'top': h * 0.34,
            'center': true,
            'w': w * 0.65,
            'h': w * 0.65
          }
        ],
        'blurs': []
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final page = onboardingData[index];

              return Stack(
                children: [
                  Positioned(
                    top: h * 0.18,
                    left: w * -0.1,
                    width: w * 1.2,
                    height: w * 1.2,
                    child: Image.asset('assets/images/Ellipse32.png', fit: BoxFit.contain),
                  ),
                  for (final blur in page['blurs'] as List)
                    Positioned(
                      top: blur['top'],
                      left: blur['left'],
                      width: w * 0.3,
                      height: w * 0.3,
                      child: Image.asset(blur['src'], fit: BoxFit.contain),
                    ),
                  for (final icon in page['icons'] as List)
                    Positioned(
                      top: icon['top'],
                      left: icon['center'] == true ? (w - icon['w']) / 2 : icon['left'],
                      width: icon['w'],
                      height: icon['h'],
                      child: Image.asset(icon['src'], fit: BoxFit.contain),
                    ),
                  Positioned(
                    top: (page['textImage'] as Map)['top'],
                    left: (page['textImage'] as Map)['left'],
                    width: (page['textImage'] as Map)['w'],
                    height: (page['textImage'] as Map)['h'],
                    child: Image.asset((page['textImage'] as Map)['src'] as String, fit: BoxFit.contain),
                  ),
                  if (index == 0) ...[
                    Positioned(
                      top: h * 0.27,
                      left: w * -0.35,
                      width: w * 0.90, 
                      height: w * 0.90, 
                      child: Image.asset('assets/images/Rectangle361.png', fit: BoxFit.contain),
                    ),
                    Positioned(
                      top: h * 0.43,
                      left: w * 0.45,
                      width: w * 0.90, 
                      height: w * 0.90, 
                      child: Image.asset('assets/images/Rectangle360.png', fit: BoxFit.contain),
                    ),
                  ],
                ],
              );
            },
          ),

          Positioned(
            bottom: h * 0.17,
            left: (w - 75) / 2,
            child: Row(
              children: List.generate(onboardingData.length, (index) {
                final isActive = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: isActive ? 30 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF657AE3) : const Color(0xFFE4E9FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
          ),

          Positioned(
            bottom: h * 0.07,
            left: w * 0.065,
            width: w * 0.87,
            height: h * 0.065,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) {
                setState(() => _isPressed = false);
                if (_currentIndex == 2) {
                  Navigator.pushNamed(context, '/login'); 
                } else {
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                }
              },
              child: Image.asset(
                _currentIndex == 2
                    ? 'assets/images/CTA.png'
                    : _isPressed
                        ? 'assets/images/Group2351.png'
                        : 'assets/images/Group235.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          if (_currentIndex < 2)
            Positioned(
              bottom: h * 0.02,
              left: (w - 40) / 2,
              child: GestureDetector(
                onTap: () => _pageController.jumpToPage(2),
                child: const Text("건너뛰기", style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 12)),
              ),
            )
        ],
      ),
    );
  }
}