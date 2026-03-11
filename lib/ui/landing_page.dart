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

  void _showProfileDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFF8B5CF6),
              child: Icon(Icons.person_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Agent Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? Colors.white : Colors.black87)),
                Text('agent@bajaj.com',
                    style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white60 : Colors.black45)),
              ],
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            ListTile(
              leading: Icon(Icons.badge_outlined, color: isDark ? Colors.white70 : Colors.black54),
              title: Text('Agent ID: BAGIC-2024-0417',
                  style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
            ),
            ListTile(
              leading: Icon(Icons.location_on_outlined, color: isDark ? Colors.white70 : Colors.black54),
              title: Text('Region: Mumbai West',
                  style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
            ),
            ListTile(
              leading: Icon(Icons.star_outline_rounded, color: isDark ? Colors.white70 : Colors.black54),
              title: Text('Rating: ⭐ 4.8 / 5.0',
                  style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001B48),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              color: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FC),
              child: Column(
                children: [
                   // Top Header Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.notifications_none_rounded, color: isDark ? Colors.white60 : Colors.black54),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _showProfileDialog(context, isDark),
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFF8B5CF6),
                            child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
                          ),
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
                              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                              border: Border(
                                left: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200),
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
                                          color: isDark ? const Color(0xFF8B5CF6).withOpacity(0.2) : const Color(0xFF8B5CF6).withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.support_agent_rounded, color: Color(0xFF8B5CF6), size: 24),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Buddy AI Chat',
                                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                                              overflow: TextOverflow.ellipsis,
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
                                                  style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
            // Enhanced Dashboard Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF001B48), const Color(0xFF02457A)]
                      : [const Color(0xFF001B48), const Color(0xFF018ABE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF001B48).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Evening, Agent! 👋',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Enterprise Dashboard',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Secure your future with just a few taps.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_rounded, color: Colors.white, size: 40),
                  ),
                ],
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
                        backgroundColor: isDark ? const Color(0xFF1A2744) : const Color(0xFFE3F2FD),
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
                            Text(
                              'Buy Health',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: isDark ? Colors.white : Colors.black87),
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
                        backgroundColor: isDark ? const Color(0xFF2A2210) : const Color(0xFFFFF7E6),
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
                            Text(
                              'Motor Insurance',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: isDark ? Colors.white : Colors.black87),
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
                        backgroundColor: isDark ? const Color(0xFF2A1520) : const Color(0xFFFCE4EC),
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
                            Text(
                              'Compare Policy 📊',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: isDark ? Colors.white : Colors.black87),
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
