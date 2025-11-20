import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class SplashWelcomeScreen extends StatefulWidget {
  @override
  _SplashWelcomeScreenState createState() => _SplashWelcomeScreenState();
}

class _SplashWelcomeScreenState extends State<SplashWelcomeScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Timer? _timer;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Selamat datang\ndi Petify!',
      subtitle: 'Aplikasi yang dibuat untuk mengadopsi\ndan juga merawat hewan peliharaan',
    ),
    OnboardingPage(
      title: 'Rawat Hewan\nKesayangan Anda!',
      subtitle: 'Pantau kesehatan dan kebutuhan\nhewan peliharaan dengan mudah',
    ),
    OnboardingPage(
      title: 'Adopsi Hewan\nPeliharaan!',
      subtitle: 'Temukan hewan peliharaan yang tepat\nuntuk keluarga Anda',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Auto slide every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5E9), // Cream/beige color
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index 
                          ? Color(0xFFF07B3F) // Orange
                          : Color(0xFFF07B3F).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to login or create account screen
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF07B3F), // Orange
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'Mulai',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo/Icon with paw
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Color(0xFFF07B3F), // Orange
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Icon(
                Icons.pets,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          
          SizedBox(height: 80),
          
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.2,
            ),
          ),
          
          SizedBox(height: 24),
          
          // Subtitle
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;

  OnboardingPage({
    required this.title,
    required this.subtitle,
  });
}
