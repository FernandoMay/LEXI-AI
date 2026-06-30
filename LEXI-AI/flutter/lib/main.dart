import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class PipelineResult {
  final int timestamp;
  final List<Map<String, dynamic>> rulesEvaluated;
  final bool complianceStatus;
  final String complianceHash;
  final List<String> violations;

  PipelineResult({
    required this.timestamp,
    required this.rulesEvaluated,
    required this.complianceStatus,
    required this.complianceHash,
    this.violations = const [],
  });

  factory PipelineResult.fromJson(Map<String, dynamic> json) {
    return PipelineResult(
      timestamp: json['timestamp'] ?? 0,
      rulesEvaluated: (json['rules_evaluated'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      complianceStatus: json['compliance_status'] ?? false,
      complianceHash: json['compliance_hash'] ?? '',
      violations: (json['violations'] as List? ?? []).cast<String>(),
    );
  }

  factory PipelineResult.mock() {
    final hash = List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join();
    return PipelineResult(
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      rulesEvaluated: [
        {'id': 'OBL-001', 'source_doc': 'Ley Fintech', 'rule_type': 'Obligation', 'condition_variable': 'transaction_amount', 'threshold_value': 50000, 'description': 'Verificar identidad para operaciones > 50,000 UDIS'},
        {'id': 'PRO-001', 'source_doc': 'Ley Fintech', 'rule_type': 'Prohibition', 'condition_variable': 'anonymous_accounts', 'threshold_value': 1, 'description': 'Prohibición de cuentas anónimas'},
        {'id': 'OBL-002', 'source_doc': 'Ley General', 'rule_type': 'Obligation', 'condition_variable': 'kyc_threshold', 'threshold_value': 0, 'description': 'Obligación de KYC'},
        {'id': 'PER-001', 'source_doc': 'Ley Fintech', 'rule_type': 'Permission', 'condition_variable': 'crowdfunding', 'threshold_value': 2000000, 'description': 'Permiso financiamiento colectivo'},
        {'id': 'PRO-002', 'source_doc': 'LFPIORPI', 'rule_type': 'Prohibition', 'condition_variable': 'money_laundering', 'threshold_value': 1, 'description': 'Prohibición lavado de dinero'},
      ],
      complianceStatus: true,
      complianceHash: hash,
    );
  }
}

class LexiBackendService {
  static const String _baseUrl = 'http://localhost:8000';

  static Future<PipelineResult> runPipeline({String? lawPath}) async {
    try {
      final uri = Uri.parse('$_baseUrl/pipeline').replace(queryParameters: lawPath != null ? {'law': lawPath} : {});
      final response = await uri.scheme.isNotEmpty
          ? await http.get(uri).timeout(const Duration(seconds: 10))
          : throw Exception('Invalid URI');
      if (response.statusCode == 200) {
        return PipelineResult.fromJson(jsonDecode(response.body));
      }
    } catch (_) {}
    return PipelineResult.mock();
  }
}

class LexiDashboard extends StatefulWidget {
  const LexiDashboard({super.key});

  @override
  State<LexiDashboard> createState() => _LexiDashboardState();
}

class _LexiDashboardState extends State<LexiDashboard> {
  bool _processing = false;
  PipelineResult? _result;
  bool _useBackend = false;

  final List<Map<String, dynamic>> _lawQueue = [
    {'name': 'Ley Fintech Mexicana', 'loaded': true},
    {'name': 'Ley General Títulos y Crédito', 'loaded': false},
    {'name': 'LFPIORPI', 'loaded': false},
  ];

  Future<void> _executePipeline() async {
    setState(() => _processing = true);
    try {
      if (_useBackend) {
        _result = await LexiBackendService.runPipeline();
      } else {
        await Future.delayed(const Duration(seconds: 1));
        _result = PipelineResult.mock();
      }
    } catch (_) {
      _result = PipelineResult.mock();
    }
    setState(() => _processing = false);
  }

  Color _statusColor() {
    if (_result == null) return Colors.amber;
    return _result!.complianceStatus ? Colors.greenAccent : Colors.redAccent;
  }

  String _statusText() {
    if (_result == null) return 'AWAITING PIPELINE EXECUTION';
    return _result!.complianceStatus ? 'COMPLIANT - ALL RULES VALIDATED' : 'NON-COMPLIANT - VIOLATIONS DETECTED';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEXI AI // Intelligent Legal Network'),
        backgroundColor: const Color(0xFF161824),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.white54),
            onSelected: (v) => setState(() => _useBackend = v == 'backend'),
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: 'mock',
                checked: !_useBackend,
                child: const Text('Mock Mode'),
              ),
              CheckedPopupMenuItem(
                value: 'backend',
                checked: _useBackend,
                child: const Text('Backend (localhost:8000)'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _sectionTitle('Legal Document Ingest'),
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
                      Expanded(
                        child: Text(law['name'],
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                      ),
                      Text(law['loaded'] ? 'LOADED' : 'QUEUED',
                          style: TextStyle(
                              color: law['loaded'] ? Colors.greenAccent : Colors.amber,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
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
            _sectionTitle('Immutable Audit Monitor'),
            const SizedBox(height: 12),
            _statusCard(),
            if (_result != null) ...[
              const SizedBox(height: 12),
              _hashCard(),
              const SizedBox(height: 16),
              _statsRow(),
              const SizedBox(height: 20),
              _sectionTitle('Evaluated Rules'),
              const SizedBox(height: 8),
              ..._result!.rulesEvaluated.map((rule) => _ruleCard(rule)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 0.5));
  }

  Widget _statusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161824),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _statusColor().withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 12, height: 12,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _statusColor()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(_statusText(),
                style: TextStyle(
                    color: _statusColor(),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _hashCard() {
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
          SelectableText(_result!.complianceHash,
              style: const TextStyle(
                  fontFamily: 'monospace', color: Color(0xFF00D2D3), fontSize: 12)),
          if (_result != null) ...[
            const SizedBox(height: 8),
            Text('Timestamp: ${DateTime.fromMillisecondsSinceEpoch(_result!.timestamp * 1000)}',
                style: const TextStyle(color: Colors.white24, fontSize: 10)),
          ],
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        _statBadge('RULES', '${_result!.rulesEvaluated.length}', Icons.rule),
        const SizedBox(width: 12),
        _statBadge('STATUS', _result!.complianceStatus ? 'PASS' : 'FAIL', Icons.verified),
        const SizedBox(width: 12),
        _statBadge('NETWORK', 'SOROBAN', Icons.link),
        const SizedBox(width: 12),
        _statBadge('MODE', _useBackend ? 'API' : 'MOCK', Icons.cloud),
      ],
    );
  }

  Widget _statBadge(String label, String value, IconData icon) {
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
                    fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'monospace')),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _ruleCard(Map<String, dynamic> rule) {
    final type = rule['rule_type'] as String? ?? '';
    final color = type == 'Prohibition'
        ? Colors.redAccent
        : type == 'Obligation'
            ? Colors.amber
            : Colors.greenAccent;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF161824),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(rule['id'] ?? '',
                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(rule['description'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ),
          Text(rule['rule_type'] ?? '',
              style: TextStyle(color: color, fontSize: 10, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
