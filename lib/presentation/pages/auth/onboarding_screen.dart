// lib/presentation/pages/auth/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      titleKey: 'professional_analysis',
      descriptionKey: 'analysis_description',
      icon: Icons.analytics_outlined,
      color: Colors.blue,
    ),
    OnboardingPage(
      titleKey: 'smart_predictions',
      descriptionKey: 'predictions_description',
      icon: Icons.auto_awesome_outlined,
      color: Colors.green,
    ),
    OnboardingPage(
      titleKey: 'cross_platform',
      descriptionKey: 'platform_description',
      icon: Icons.devices_outlined,
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // PageView с адаптивной высотой
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    page: _pages[index],
                    isSmallScreen: isSmallScreen,
                    screenHeight: screenHeight,
                  );
                },
              ),
            ),
            // Нижняя часть с адаптивными отступами
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
                vertical: isSmallScreen ? 16 : 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPageIndicator(isSmallScreen),
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  _buildNavigationButtons(isSmallScreen),
                  if (_currentPage == _pages.length - 1) ...[
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    TextButton(
                      onPressed: () {
                        context.go('/auth');
                      },
                      child: Text(
                        'have_account'.tr(),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return Container(
          width: _currentPage == index
              ? (isSmallScreen ? 20 : 24)
              : (isSmallScreen ? 6 : 8),
          height: isSmallScreen ? 6 : 8,
          margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 3 : 4),
          decoration: BoxDecoration(
            color: _currentPage == index
                ? _pages[index].color
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildNavigationButtons(bool isSmallScreen) {
    return Row(
      children: [
        if (_currentPage != 0)
          Expanded(
            child: SizedBox(
              height: isSmallScreen ? 48 : 56,
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: Text(
                  'back'.tr(),
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                ),
              ),
            ),
          ),
        if (_currentPage != 0) SizedBox(width: isSmallScreen ? 12 : 16),
        Expanded(
          child: SizedBox(
            height: isSmallScreen ? 48 : 56,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == _pages.length - 1) {
                  context.go('/auth');
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              child: Text(
                _currentPage == _pages.length - 1 ? 'start'.tr() : 'next'.tr(),
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingPage {
  final String titleKey;
  final String descriptionKey;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.color,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final bool isSmallScreen;
  final double screenHeight;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    required this.isSmallScreen,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isSmallScreen ? 80.0 : 120.0;
    final titleFontSize = isSmallScreen ? 24.0 : 28.0;
    final descriptionFontSize = isSmallScreen ? 14.0 : 16.0;

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: screenHeight - 200, // Минимальная высота
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 20 : 32,
          vertical: isSmallScreen ? 30 : 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: page.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                page.icon,
                size: iconSize * 0.5, // Адаптивный размер иконки
                color: page.color,
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 40),
            Text(
              page.titleKey.tr(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: page.color,
                    fontSize: titleFontSize,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              page.descriptionKey.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 1.5,
                    fontSize: descriptionFontSize,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
