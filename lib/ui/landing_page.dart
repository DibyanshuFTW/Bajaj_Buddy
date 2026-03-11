import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/theme_provider.dart';
import 'bento_widgets/bento_card.dart';

import 'package:lottie/lottie.dart';
import 'chat_screen.dart';
import 'bento_widgets/calculator_widget.dart';
import 'competitor_scan_page.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final isDark = themeMode == ThemeMode.dark;

    // Check if we are on a large screen (desktop/web)
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: Row(
        children: [
          // Navy Blue Navigation Rail (Left Side)
          NavigationRail(
            backgroundColor: const Color(0xFF001B48), // Deep Navy Blue
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.none,
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedIconTheme: IconThemeData(color: Colors.white.withOpacity(0.5)),
            leading: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shield_outlined, color: Color(0xFF001B48), size: 28),
                ),
                const SizedBox(height: 8),
                const Text(
                  'BASIC\nBuddy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
            trailing: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: Colors.white),
                    onPressed: () {
                      ref.read(themeModeProvider.notifier).state =
                          isDark ? ThemeMode.light : ThemeMode.dark;
                    },
                  ),
                  const SizedBox(height: 16),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person_outline_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_filled),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shield_outlined),
                selectedIcon: Icon(Icons.shield),
                label: Text('Scanner'),
              ),
               NavigationRailDestination(
                icon: Icon(Icons.description_outlined),
                selectedIcon: Icon(Icons.description),
                label: Text('Policies'),
              ),
            ],
          ),

          // Main Content Area
          Expanded(
            child: Container(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Column(
                children: [
                   // Top Header Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.notifications_none_rounded, color: Colors.black.withOpacity(0.6)),
                        const SizedBox(width: 16),
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF8B5CF6),
                          child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        // Left Column: Main View (Dashboard)
                        Expanded(
                          flex: 3,
                          child: _buildMainContent(context, isDark, theme),
                        ),

                        // Right Column: Fixed AI Chat Sidebar
                        if (isDesktop)
                          Container(
                            width: 380,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(color: Colors.grey.withOpacity(0.1)),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Chat Header
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF8B5CF6).withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.support_agent_rounded, color: Color(0xFF8B5CF6), size: 24),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Buddy AI Chat',
                                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Online',
                                                style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                const Expanded(
                                  child: ChatScreen(isEmbedded: true),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isDark, ThemeData theme) {
    if (_selectedIndex == 1) {
      return const CompetitorScanPage();
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enterprise Dashboard 👤',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF02457A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Secure your future with just a few taps.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.black.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 48),

            // Bento Grid Layout
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    // Buy Health
                    SizedBox(
                      width: (constraints.maxWidth - 24) / 2,
                      height: 240,
                      child: BentoCard(
                        backgroundColor: const Color(0xFFE3F2FD),
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2196F3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite_outline_rounded, color: Colors.white, size: 32),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Buy Health',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Motor Insurance
                    SizedBox(
                      width: (constraints.maxWidth - 24) / 2,
                      height: 240,
                      child: BentoCard(
                        backgroundColor: const Color(0xFFFFF7E6),
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF57C00),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.directions_car_outlined, color: Colors.white, size: 32),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Motor Insurance',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Compare Policy
                    SizedBox(
                      width: (constraints.maxWidth - 24) / 2,
                      height: 240,
                      child: BentoCard(
                        backgroundColor: const Color(0xFFFCE4EC),
                        onTap: () {
                          setState(() => _selectedIndex = 1);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE91E63),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.description_outlined, color: Colors.white, size: 32),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Compare Policy 📊',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // NCB Premium Calculator
                    SizedBox(
                      width: (constraints.maxWidth - 24) / 2,
                      height: 240,
                      child: const CalculatorWidget(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
