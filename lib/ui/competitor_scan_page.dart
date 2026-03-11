import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import '../services/demo_data.dart';
import '../services/chat_service.dart';
import 'bento_widgets/bento_card.dart';

class CompetitorScanPage extends ConsumerStatefulWidget {
  const CompetitorScanPage({super.key});

  @override
  ConsumerState<CompetitorScanPage> createState() => _CompetitorScanPageState();
}

class _CompetitorScanPageState extends ConsumerState<CompetitorScanPage> {
  bool _isDemoMode = true; // Use demo data
  bool _isScanning = false;
  String? _analysisResult;
  Uint8List? _imageBytes;

  Future<void> _pickAndAnalyzeImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile == null) return;

    final bytes = await xFile.readAsBytes();
    if (!mounted) return;
    setState(() {
      _imageBytes = bytes;
      _isScanning = true;
      _analysisResult = null;
    });

    if (_isDemoMode) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      setState(() {
        _analysisResult = DemoData.competitorComparisonJson['recommendedTag'];
        _isScanning = false;
      });
    } else {
      final result = await ref.read(chatServiceProvider).analyzeCompetitorPolicy(bytes);

      if (!mounted) return;
      setState(() {
        _analysisResult = result;
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Navy Mesh Gradient Background
          Positioned.fill(
            child: AnimatedMeshGradient(
              colors: const [
                Color(0xFF001B48), // Deep Navy Blue
                Color(0xFF02457A), // Mid Blue
                Color(0xFF018ABE), // Lighter Blue
                Color(0xFF001B48),
              ],
              options: AnimatedMeshGradientOptions(
                speed: 2.0,
                grain: 0.1,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Top Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_rounded, color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      const Text(
                        'Insurance Buddy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600, // Lexend Semi-bold
                        ),
                      ),
                      const Spacer(),
                      // AI Avatar and dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.support_agent_rounded, size: 16, color: Color(0xFF02457A)),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Hi! How can I assist you?',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0).copyWith(bottom: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Compare Health Insurance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Find the best plan for you',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Central White Card
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                )
                              ],
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                    if (_imageBytes == null)
                                      BentoCard(
                                        onTap: _pickAndAnalyzeImage,
                                        backgroundColor: Colors.blue.withOpacity(0.05),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.document_scanner_rounded, size: 64, color: Colors.blueAccent),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Upload a Competitor Policy to compare',
                                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    
                                    if (_imageBytes != null && _isScanning)
                                      Column(
                                        children: [
                                          LottieBuilder.network(
                                            'https://assets2.lottiefiles.com/packages/lf20_t2v9xub9.json', // Scanning animation
                                            height: 150,
                                            errorBuilder: (context, error, stackTrace) => const CircularProgressIndicator(),
                                          ),
                                          const SizedBox(height: 16),
                                          Text('Buddy is scanning...', style: theme.textTheme.titleMedium),
                                        ],
                                      ),

                                    if (_analysisResult != null && !_isScanning) ...[
                                      const ComparisonTableWidget(),
                                    ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Demo Switch in corner
          Positioned(
            bottom: 16, right: 16,
            child: Row(
              children: [
                const Text('Demo Mode', style: TextStyle(color: Colors.white54, fontSize: 10)),
                Switch(
                  value: _isDemoMode,
                  onChanged: (val) {
                    setState(() {
                      _isDemoMode = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ComparisonTableWidget extends StatefulWidget {
  const ComparisonTableWidget({super.key});

  @override
  State<ComparisonTableWidget> createState() => _ComparisonTableWidgetState();
}

class _ComparisonTableWidgetState extends State<ComparisonTableWidget> {
  int _selectedTabIndex = 1; // Default to 'Network Hospitals'

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final companies = DemoData.competitorComparisonJson['companies'] as List<dynamic>;

    return Column(
      children: [
        // Tabs Header
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              _buildTab(0, 'Company', isFirst: true),
              _buildTab(1, 'Network Hospitals'),
              _buildTab(2, 'Claim Settlement'),
              _buildTab(3, 'Unique Feature', isLast: true),
            ],
          ),
        ),
        
        // Table Body
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.grey.withOpacity(0.2)),
              right: BorderSide(color: Colors.grey.withOpacity(0.2)),
              bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          child: Column(
            children: [
              ...List.generate(companies.length, (index) {
                final company = companies[index];
                final isBajaj = company['company'].toString().contains('Bajaj');
                
                return Column(
                  children: [
                    if (isBajaj)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF02457A),
                        ),
                        child: const Text(
                          'Recommended',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        ),
                      ),
                      
                    Container(
                      color: isBajaj ? const Color(0xFF018ABE).withOpacity(0.1) : Colors.transparent,
                      child: Row(
                        children: [
                          // Company Column
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Logo Placeholder (would typically be Image.asset)
                                  Icon(
                                    isBajaj ? Icons.shield_rounded : Icons.business_rounded, 
                                    color: isBajaj ? const Color(0xFF02457A) : Colors.redAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      company['company'],
                                      style: TextStyle(
                                        fontWeight: isBajaj ? FontWeight.bold : FontWeight.normal,
                                        color: isBajaj ? const Color(0xFF02457A) : Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Network Hospitals
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: isBajaj ? const Color(0xFF02457A) : Colors.transparent,
                              padding: const EdgeInsets.all(16.0),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    company['networkHospitals'],
                                    style: TextStyle(
                                      fontWeight: isBajaj ? FontWeight.bold : FontWeight.w500,
                                      color: isBajaj ? Colors.white : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (isBajaj)
                                     Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.check, color: Color(0xFF02457A), size: 10),
                                            Text(' Largest Network', style: TextStyle(color: Color(0xFF02457A), fontSize: 9, fontWeight: FontWeight.bold)),
                                          ]
                                        ),
                                     )
                                ],
                              ),
                            ),
                          ),
                          
                          // Claim Settlement
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: isBajaj ? const Color(0xFF018ABE) : Colors.transparent,
                              padding: const EdgeInsets.all(16.0),
                              alignment: Alignment.center,
                              child: Text(
                                company['claimSettlementRatio'],
                                style: TextStyle(
                                  fontWeight: isBajaj ? FontWeight.bold : FontWeight.w500,
                                  color: isBajaj ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          
                          // Unique Feature
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: isBajaj ? const Color(0xFF018ABE).withOpacity(0.8) : Colors.transparent,
                              padding: const EdgeInsets.all(16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                company['uniqueFeature'],
                                style: TextStyle(
                                  color: isBajaj ? Colors.white : Colors.black87,
                                  fontSize: 13,
                                  fontWeight: isBajaj ? FontWeight.w500 : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < companies.length - 1 && !isBajaj && !companies[index+1]['company'].toString().contains('Bajaj'))
                      const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                  ],
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Recommend badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'Bajaj has the largest network & highest claim ratio!',
                style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        
        // Bottom Action Pills
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionPill(context, Icons.directions_car_rounded, 'Compare Motor Plans'),
              _buildActionPill(context, Icons.health_and_safety_rounded, 'Explain Health Cover'),
              _buildActionPill(context, Icons.campaign_rounded, 'Sales Pitch Generator', isPrimary: true),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTab(int index, String title, {bool isFirst = false, bool isLast = false}) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      flex: index == 0 ? 2 : (index == 3 ? 3 : 2),
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF02457A) : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: isFirst ? const Radius.circular(16) : Radius.zero,
              right: isLast ? const Radius.circular(16) : Radius.zero,
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF02457A),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionPill(BuildContext context, IconData icon, String label, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF02457A)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF02457A),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          if (isPrimary) ...[
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF02457A)),
          ]
        ],
      ),
    );
  }
}
