import 'package:flutter/material.dart';

void main() => runApp(const LexiAiApp());

class LexiAiApp extends StatelessWidget {
  const LexiAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LEXI AI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0E15),
        primaryColor: const Color(0xFF6C5CE7),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C5CE7),
          secondary: Color(0xFF00D2D3),
          surface: Color(0xFF161824),
        ),
      ),
      home: const LexiDashboard(),
    );
  }
}

class LexiDashboard extends StatefulWidget {
  const LexiDashboard({super.key});

  @override
  State<LexiDashboard> createState() => _LexiDashboardState();
}

class _LexiDashboardState extends State<LexiDashboard> {
  bool _processing = false;
  String _auditHash = '0x0000000000000000000000000000000000000000';
  String _status = 'AWAITING PIPELINE EXECUTION';
  bool _compliant = false;
  int _rulesCount = 0;

  final List<Map<String, dynamic>> _lawQueue = [
    {'name': 'Ley Fintech Mexicana', 'loaded': true},
    {'name': 'Ley General Títulos y Crédito', 'loaded': false},
    {'name': 'L Federal Prevención Lavado', 'loaded': false},
  ];

  void _executePipeline() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _processing = false;
      _compliant = true;
      _rulesCount = 5;
      _auditHash = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
      _status = 'COMPLIANT - ALL RULES VALIDATED';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEXI AI // Intelligent Legal Network'),
        backgroundColor: const Color(0xFF161824),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildSectionTitle('Legal Document Ingest'),
            const SizedBox(height: 8),
            ..._lawQueue.map((law) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161824),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF2C2E3E)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        law['loaded'] ? Icons.check_circle : Icons.pending,
                        color: law['loaded'] ? Colors.greenAccent : Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(law['name'], style: const TextStyle(fontFamily: 'RobotoMono', fontSize: 13)),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _processing ? null : _executePipeline,
                icon: _processing
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.bolt),
                label: Text(_processing ? 'EXECUTING...' : 'EXECUTE COGNITIVE PIPELINE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Divider(color: Color(0xFF2C2E3E)),
            const SizedBox(height: 12),
            _buildSectionTitle('Immutable Audit Monitor'),
            const SizedBox(height: 12),
            _buildStatusCard(theme),
            const SizedBox(height: 12),
            _buildHashCard(),
            const SizedBox(height: 16),
            _buildStatsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161824),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _compliant ? Colors.greenAccent.withOpacity(0.3) : Colors.amber.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12, height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _compliant ? Colors.greenAccent : Colors.amber,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _status,
              style: TextStyle(
                color: _compliant ? Colors.greenAccent : Colors.amber,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHashCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2C2E3E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SOROBAN CRYPTOGRAPHIC HASH',
              style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 8),
          SelectableText(
            _auditHash,
            style: const TextStyle(
              fontFamily: 'RobotoMono',
              color: Color(0xFF00D2D3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatBadge('RULES', '$_rulesCount', Icons.rule),
        const SizedBox(width: 12),
        _buildStatBadge('STATUS', _compliant ? 'PASS' : '--', Icons.verified),
        const SizedBox(width: 12),
        _buildStatBadge('NETWORK', 'SOROBAN', Icons.link),
      ],
    );
  }

  Widget _buildStatBadge(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161824),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2C2E3E)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF6C5CE7), size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'RobotoMono')),
            Text(label,
                style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
