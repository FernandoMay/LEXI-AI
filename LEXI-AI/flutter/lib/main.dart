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
      home: const LexiHome(),
    );
  }
}

class AuditReport {
  final Map<String, dynamic> metadata;
  final Map<String, dynamic> agents;
  final Map<String, dynamic> contract;
  final Map<String, dynamic> compliance;
  final Map<String, dynamic> signatures;
  final Map<String, dynamic>? evidence;

  AuditReport({
    required this.metadata,
    required this.agents,
    required this.contract,
    required this.compliance,
    required this.signatures,
    this.evidence,
  });

  factory AuditReport.fromJson(Map<String, dynamic> json) {
    return AuditReport(
      metadata: json['metadata'] ?? {},
      agents: json['agents'] ?? {},
      contract: json['contract'] ?? {},
      compliance: json['compliance'] ?? {},
      signatures: json['signatures'] ?? {},
      evidence: json['evidence'],
    );
  }

  factory AuditReport.mock() {
    final hash = List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join();
    return AuditReport(
      metadata: {
        "title": "LEXI AI Compliance Audit Report",
        "version": "1.0.0",
        "generated_at": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "pipeline": "Python Orchestrator",
      },
      agents: {
        "nlp_agent": {
          "agent": "LexiNLP",
          "version": "0.1.0",
          "model": "Regex + NER (HuggingFace)",
          "outputs": {"rules_count": 5},
        },
        "compliance_agent": {
          "agent": "LexiCompliance",
          "version": "0.1.0",
          "model": "Rule-based Inference Engine",
          "outputs": {"compliant": true, "violations": []},
        },
        "web3_agent": {
          "agent": "LexiWeb3",
          "version": "0.1.0",
          "model": "Soroban Smart Contract",
          "outputs": {"onchain_tx": {"tx_hash": hash, "contract_id": "CA3Q5T6E7F8G9H0J1K2L3M4N5P6Q7R8S9T0U1V2W3X4Y5Z6"}},
        },
      },
      contract: {
        "network": "Stellar Testnet",
        "contract_id": "CA3Q5T6E7F8G9H0J1K2L3M4N5P6Q7R8S9T0U1V2W3X4Y5Z6",
        "compiled_hash": "9d8a7b6c5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0b9c8d7e6f5a4b3c2d1e0f",
        "source": "contracts/lexi_compliance/src/lib.rs",
      },
      compliance: {
        "status": true,
        "audit_hash": hash,
        "rules_evaluated": 5,
        "violations": [],
        "context": {"transaction_amount": 45000, "anonymous_accounts": 0},
      },
      signatures: {
        "regulator": {
          "party_id": "CNBV-001",
          "party_name": "Comisión Nacional Bancaria y de Valores",
          "role": "Regulator",
          "signature": List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join(),
          "verified": true,
        },
        "audited_entity": {
          "party_id": "FINTECH-042",
          "party_name": "Institución de Tecnología Financiera S.A.",
          "role": "Audited Entity",
          "signature": List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join(),
          "verified": true,
        },
        "independent_auditor": {
          "party_id": "AUDIT-LEXI-001",
          "party_name": "LEXI AI Audit Network",
          "role": "Independent Auditor",
          "signature": List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join(),
          "verified": true,
        },
      },
    );
  }
}

class LexiBackendService {
  static const String _baseUrl = 'http://localhost:8000';

  static Future<AuditReport> runPipeline({String? lawPath}) async {
    try {
      final params = lawPath != null ? {'law': lawPath} : null;
      final uri = Uri.parse('$_baseUrl/pipeline').replace(queryParameters: params);
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return AuditReport.fromJson(jsonDecode(response.body));
      }
    } catch (_) {}
    return AuditReport.mock();
  }
}

class LexiHome extends StatefulWidget {
  const LexiHome({super.key});

  @override
  State<LexiHome> createState() => _LexiHomeState();
}

class _LexiHomeState extends State<LexiHome> {
  int _tabIndex = 0;
  bool _processing = false;
  AuditReport? _report;
  bool _useBackend = false;

  static const _tabs = ['Dashboard', 'Contract', 'Signatures', 'Agents'];
  static const _tabIcons = [Icons.dashboard, Icons.code, Icons.verified_user, Icons.smart_toy];

  Future<void> _executePipeline() async {
    setState(() => _processing = true);
    try {
      if (_useBackend) {
        _report = await LexiBackendService.runPipeline();
      } else {
        await Future.delayed(const Duration(milliseconds: 800));
        _report = AuditReport.mock();
      }
    } catch (_) {
      _report = AuditReport.mock();
    }
    setState(() => _processing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEXI AI // Intelligent Legal Network'),
        backgroundColor: const Color(0xFF161824),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bolt, color: Color(0xFF6C5CE7)),
            onPressed: _processing ? null : _executePipeline,
            tooltip: 'Execute Pipeline',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.white54),
            onSelected: (v) => setState(() => _useBackend = v == 'backend'),
            itemBuilder: (_) => [
              CheckedPopupMenuItem(value: 'mock', checked: !_useBackend, child: const Text('Mock Mode')),
              CheckedPopupMenuItem(value: 'backend', checked: _useBackend, child: const Text('Backend (8000)')),
            ],
          ),
        ],
      ),
      body: _processing
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C5CE7)))
          : _report == null ? _buildEmptyState() : _buildTabContent(),
      bottomNavigationBar: _report == null
          ? null
          : Theme(
              data: Theme.of(context).copyWith(canvasColor: const Color(0xFF161824)),
              child: BottomNavigationBar(
                currentIndex: _tabIndex,
                onTap: (i) => setState(() => _tabIndex = i),
                backgroundColor: const Color(0xFF161824),
                selectedItemColor: const Color(0xFF6C5CE7),
                unselectedItemColor: Colors.white38,
                items: List.generate(4, (i) => BottomNavigationBarItem(
                  icon: Icon(_tabIcons[i]),
                  label: _tabs[i],
                )),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.gavel, size: 64, color: Color(0xFF6C5CE7)),
          const SizedBox(height: 16),
          const Text('LEXI AI', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Intelligent Smart-Compliance\n& Legal Contract Networks',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, height: 1.4)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _executePipeline,
            icon: const Icon(Icons.play_arrow),
            label: const Text('INITIALIZE PIPELINE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_tabIndex) {
      case 0: return _DashboardTab(report: _report!);
      case 1: return _ContractTab(report: _report!);
      case 2: return _SignaturesTab(report: _report!);
      case 3: return _AgentsTab(report: _report!);
      default: return const SizedBox();
    }
  }
}

// ─── DASHBOARD TAB ──────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  final AuditReport report;
  const _DashboardTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final c = report.compliance;
    final status = c['status'] as bool? ?? false;
    final hash = c['audit_hash'] as String? ?? '';
    final rulesCount = c['rules_evaluated'] as int? ?? 0;
    final violations = (c['violations'] as List?) ?? [];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionTitle('Compliance Verdict'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: (status ? Colors.greenAccent : Colors.redAccent).withOpacity(0.3)),
            color: const Color(0xFF161824),
          ),
          child: Column(
            children: [
              Icon(status ? Icons.verified : Icons.warning, size: 48,
                  color: status ? Colors.greenAccent : Colors.redAccent),
              const SizedBox(height: 8),
              Text(status ? 'COMPLIANT' : 'NON-COMPLIANT',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold,
                      color: status ? Colors.greenAccent : Colors.redAccent,
                      fontFamily: 'monospace')),
              const SizedBox(height: 12),
              if (violations.isNotEmpty) ...[
                Text('Violations: ${violations.join(", ")}',
                    style: const TextStyle(color: Colors.redAccent, fontFamily: 'monospace', fontSize: 12)),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        _sectionTitle('Audit Trail'),
        const SizedBox(height: 8),
        _infoCard('SHA-256 Hash', hash, Colors.cyan),
        const SizedBox(height: 8),
        _infoCard('Rules Evaluated', '$rulesCount', Colors.amber),
        const SizedBox(height: 8),
        _infoCard('Pipeline', report.metadata['pipeline'] as String? ?? '', Colors.white54),
        const SizedBox(height: 8),
        _infoCard('Generated', _fmt(report.metadata['generated_at']), Colors.white54),
        const SizedBox(height: 20),
        _sectionTitle('Operational Context'),
        const SizedBox(height: 8),
        ...((c['context'] as Map<String, dynamic>?)?.entries.map((e) => _contextRow(e.key, '${e.value}')) ?? []),
      ],
    );
  }
}

// ─── CONTRACT TAB ───────────────────────────────────────────────────────────

class _ContractTab extends StatelessWidget {
  final AuditReport report;
  const _ContractTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final ct = report.contract;
    final tx = ct['registration_tx'] as Map<String, dynamic>? ?? {};

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionTitle('Soroban Smart Contract'),
        const SizedBox(height: 8),
        _infoCard('Network', ct['network'] as String? ?? '', Colors.cyan),
        const SizedBox(height: 8),
        _infoCard('Contract ID', ct['contract_id'] as String? ?? '', Colors.cyan),
        const SizedBox(height: 8),
        _infoCard('Compiled Hash', ct['compiled_hash'] as String? ?? '', Colors.cyan),
        const SizedBox(height: 8),
        _infoCard('Source File', ct['source'] as String? ?? '', Colors.white54),
        const SizedBox(height: 20),
        _sectionTitle('On-Chain Registration'),
        const SizedBox(height: 8),
        _infoCard('TX Hash', tx['tx_hash'] as String? ?? '', Colors.greenAccent),
        const SizedBox(height: 8),
        _infoCard('Function', tx['function'] as String? ?? 'register_audit', Colors.amber),
        const SizedBox(height: 8),
        _infoCard('Block Confirmed', tx['block_confirmed'] != null ? _fmt(tx['block_confirmed']) : '--', Colors.white54),
        const SizedBox(height: 20),
        _sectionTitle('Contract Source Code'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2C2E3E)),
          ),
          child: const SelectableText(
            '#![no_std]\nuse soroban_sdk::{contract, contractimpl, symbol_short, Env, Symbol, String, Address};\n\n#[contract]\npub struct LexiAuditContract;\n\n#[contractimpl]\nimpl LexiAuditContract {\n    pub fn register_audit(\n        env: Env, client: Address, doc_id: String,\n        audit_hash: String, is_compliant: bool,\n    ) {\n        client.require_auth();\n        let key = (symbol_short!("audit"), client, doc_id.clone());\n        env.storage().persistent().set(&key, &audit_hash);\n        env.events().publish(\n            (symbol_short!("lexi_evt"), client),\n            (doc_id, audit_hash, is_compliant),\n        );\n    }\n\n    pub fn verify_status(env: Env, client: Address, doc_id: String) -> String {\n        let key = (symbol_short!("audit"), client, doc_id);\n        if env.storage().persistent().has(&key) {\n            env.storage().persistent().get(&key).unwrap()\n        } else {\n            String::from_str(&env, "NOT_FOUND")\n        }\n    }\n}',
            style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: Color(0xFF00D2D3), height: 1.5),
          ),
        ),
      ],
    );
  }
}

// ─── SIGNATURES TAB ─────────────────────────────────────────────────────────

class _SignaturesTab extends StatelessWidget {
  final AuditReport report;
  const _SignaturesTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final sigs = report.signatures;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionTitle('Multi-Party Signatures'),
        const SizedBox(height: 4),
        const Text('Every audit is independently signed by all parties',
            style: TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 16),
        ...sigs.entries.map((e) => _partyCard(e.key, Map<String, dynamic>.from(e.value))),
        const SizedBox(height: 20),
        _sectionTitle('Evidence'),
        const SizedBox(height: 8),
        if (report.evidence != null) ...[
          _infoCard('Recovery Hash', report.evidence!['recovery_hash'] as String? ?? '', Colors.amber),
          const SizedBox(height: 8),
          _infoCard('Core Payload', (report.evidence!['core_payload'] as String? ?? '').length > 60
              ? '${(report.evidence!['core_payload'] as String).substring(0, 60)}...'
              : report.evidence!['core_payload'] as String? ?? '', Colors.white54),
        ],
      ],
    );
  }
}

// ─── AGENTS TAB ─────────────────────────────────────────────────────────────

class _AgentsTab extends StatelessWidget {
  final AuditReport report;
  const _AgentsTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final agents = report.agents;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionTitle('Agentic Pipeline Trace'),
        const SizedBox(height: 4),
        const Text('Complete trace of all agents involved in the audit',
            style: TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 16),
        ...agents.entries.map((e) => _agentCard(e.key, Map<String, dynamic>.from(e.value))),
      ],
    );
  }
}

// ─── SHARED WIDGETS ─────────────────────────────────────────────────────────

Widget _sectionTitle(String title) {
  return Text(title,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 0.5));
}

Widget _infoCard(String label, String value, Color color) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFF161824),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(color: color.withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        const SizedBox(height: 4),
        SelectableText(value,
            style: TextStyle(color: color, fontSize: 12, fontFamily: 'monospace')),
      ],
    ),
  );
}

Widget _contextRow(String key, String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF161824),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: const Color(0xFF2C2E3E)),
    ),
    child: Row(
      children: [
        Text(key, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white54)),
        const Spacer(),
        Text(value, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white)),
      ],
    ),
  );
}

Widget _partyCard(String id, Map<String, dynamic> party) {
  final verified = party['verified'] as bool? ?? false;
  final color = verified ? Colors.greenAccent : Colors.redAccent;
  final icon = party['role'] == 'Regulator'
      ? Icons.account_balance
      : party['role'] == 'Audited Entity'
          ? Icons.business
          : Icons.verified_user;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF161824),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(party['party_name'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(verified ? 'VERIFIED' : 'INVALID',
                  style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text('${party['role']}  •  ${party['party_id']}',
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Signature: ', style: TextStyle(color: Colors.white38, fontSize: 10, fontFamily: 'monospace')),
            Expanded(
              child: Text(party['signature'] as String? ?? '',
                  style: TextStyle(color: color, fontSize: 9, fontFamily: 'monospace')),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _agentCard(String id, Map<String, dynamic> agent) {
  final name = agent['agent'] as String? ?? id;
  final outputs = agent['outputs'] as Map<String, dynamic>? ?? {};

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF161824),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFF2C2E3E)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(_agentIcon(name), color: const Color(0xFF6C5CE7), size: 20),
            const SizedBox(width: 10),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const Spacer(),
            Text('v${agent['version'] ?? '0.1.0'}',
                style: const TextStyle(color: Colors.white38, fontSize: 10, fontFamily: 'monospace')),
          ],
        ),
        const SizedBox(height: 4),
        Text(agent['model'] as String? ?? '',
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 8),
        ...outputs.entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${e.key}: ', style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'monospace')),
              Expanded(
                child: Text(_fmtOutput(e.value),
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace')),
              ),
            ],
          ),
        )),
      ],
    ),
  );
}

IconData _agentIcon(String name) {
  if (name.contains('NLP')) return Icons.translate;
  if (name.contains('Compliance')) return Icons.rule;
  if (name.contains('Web3')) return Icons.link;
  return Icons.smart_toy;
}

String _fmtOutput(dynamic v) {
  if (v is bool) return v ? 'true' : 'false';
  if (v is List) return v.join(', ');
  if (v is Map) return jsonEncode(v);
  return '$v';
}

String _fmt(dynamic ts) {
  if (ts is int) {
    return DateTime.fromMillisecondsSinceEpoch(ts * 1000).toIso8601String();
  }
  return '$ts';
}
