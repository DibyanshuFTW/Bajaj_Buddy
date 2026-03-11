import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'view_models/theme_provider.dart';
import 'ui/landing_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: InsuranceBuddyApp(),
    ),
  );
}

class InsuranceBuddyApp extends ConsumerWidget {
  const InsuranceBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Insurance Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const LandingPage(),
    );
  }
}
