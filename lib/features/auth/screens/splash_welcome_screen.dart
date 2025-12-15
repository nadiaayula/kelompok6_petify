import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashWelcomeScreen extends StatefulWidget {
  @override
  _SplashWelcomeScreenState createState() => _SplashWelcomeScreenState();
}

class _SplashWelcomeScreenState extends State<SplashWelcomeScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Selamat datang\ndi Petify!',
      subtitle: 'Aplikasi yang dibuat untuk mengadopsi\ndan juga merawat hewan peliharaan',
      hasBackground: false,
    ),
    OnboardingPage(
      title: 'Rawat Hewan\nKesayangan Anda!',
      subtitle: 'Pantau kesehatan dan kebutuhan\nhewan peliharaan dengan mudah',
      hasBackground: true,
      backgroundImage: 'assets/images/chewy.png',
    ),
    OnboardingPage(
      title: 'Adopsi Hewan\nPeliharaan!',
      subtitle: 'Temukan hewan peliharaan yang tepat\nuntuk keluarga Anda',
      hasBackground: true,
      backgroundImage: 'assets/images/flouffy.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Tidak perlu auto-slide lagi, user control dengan button
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleButtonPress() {
    if (_currentPage < _pages.length - 1) {
      // Masih ada halaman berikutnya, pindah ke halaman selanjutnya
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Sudah halaman terakhir, pindah ke login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentPage == 0 ? Color(0xFFFFF5E9) : Colors.white, // Cream untuk halaman 1, Putih untuk halaman 2-3
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
              padding: EdgeInsets.symmetric(vertical: 12), // Kurangi dari 24 jadi 12
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
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16), // Kurangi dari 32 jadi 16
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  return SizedBox(
                    width: double.infinity,
                    height: screenWidth > 600 ? 60 : 56,
                    child: ElevatedButton(
                      onPressed: _handleButtonPress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage == 0 
                            ? Color(0xFFF07B3F) // Orange untuk halaman 1
                            : Color(0xFFFFA500), // Kuning untuk halaman 2-3
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        _currentPage == 0 ? 'Mulai' : 'Lanjut',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: screenWidth > 600 ? 18 : 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Halaman 1: Background cream dengan icon
    if (!page.hasBackground) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon with paw - responsive size
                Container(
                  width: screenWidth > 600 ? 140 : screenWidth * 0.3,
                  height: screenWidth > 600 ? 140 : screenWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Color(0xFFF07B3F), // Orange
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.pets,
                      size: screenWidth > 600 ? 70 : screenWidth * 0.16,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.08),
                
                // Title - responsive font
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: screenWidth > 600 ? 36 : screenWidth * 0.08,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Subtitle - responsive font
                Text(
                  page.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: screenWidth > 600 ? 16 : 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    
    // Halaman 2-3: Background dengan foto + popup putih
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Background Image - Full screen
            Positioned.fill(
              child: Image.asset(
                page.backgroundImage!,
                fit: BoxFit.cover,
              ),
            ),
            
            // White popup card di bawah - minimal height
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 35, 
                  bottom: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.1,
                      ),
                    ),
                    
                    SizedBox(height: 9),
                    
                    // Subtitle
                    Text(
                      page.subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                    
                    SizedBox(height: 40), 
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final bool hasBackground;
  final String? backgroundImage;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    this.hasBackground = false,
    this.backgroundImage,
  });
}
