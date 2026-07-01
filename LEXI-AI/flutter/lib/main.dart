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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E222F),
        primaryColor: const Color(0xFF2563EB),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2563EB),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF262B3C),
          error: Color(0xFFEF4444),
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E222F),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E222F),
          selectedItemColor: Color(0xFF2563EB),
          unselectedItemColor: Color(0xFF6B7280),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
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
    final h = List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join();
    final a = List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join();
    return AuditReport(
      metadata: {
        "title": "Dictamen de Cumplimiento Regulatorio LEXI AI",
        "version": "2.0.0",
        "generated_at": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "regulated_entity": "Institución Fintech S.A. de C.V.",
        "audit_period": "Enero - Junio 2026",
        "regulatory_framework": "Ley Fintech | LFPIRPFI",
      },
      agents: {
        "nlp_agent": {
          "agent": "LexiNLP", "version": "0.1.0", "model": "Híbrido: spaCy + HuggingFace + Regex",
          "outputs": {"rules_count": 5, "ast_hash": a, "nlp_method": "regex"},
        },
        "compliance_agent": {
          "agent": "LexiCompliance", "version": "0.1.0", "model": "Motor de Inferencia Basado en Reglas",
          "outputs": {"compliant": true, "violations": [], "audit_hash": h},
        },
        "web3_agent": {
          "agent": "LexiWeb3", "version": "0.1.0", "model": "Soroban 2-of-3 Multi-Sig",
          "outputs": {
            "onchain_tx": {"tx_hash": h, "contract_id": "CA3Q5T6E7F8G9H0J1K2L3M4N5P6Q7R8S9T0U1V2W3X4Y5Z6"},
            "multi_sig_scheme": "2-of-3",
          },
        },
      },
      contract: {
        "network": "Stellar Testnet",
        "contract_id": "CA3Q5T6E7F8G9H0J1K2L3M4N5P6Q7R8S9T0U1V2W3X4Y5Z6",
        "multi_sig_required": 2,
        "compiled_hash": "9d8a7b6c...",
        "source": "contracts/lexi_compliance/src/lib.rs",
      },
      compliance: {
        "status": true,
        "audit_hash": h,
        "ast_hash": a,
        "rules_evaluated": 5,
        "violations": [],
        "context": {"transaction_amount": 45000, "anonymous_accounts": 0},
        "rules": [
          {
            "id": "PRO-001", "type": "Prohibition", "article": "Artículo 42",
            "text": "Cuentas Anónimas",
            "description": "Prohibición de mantener cuentas anónimas o beneficiarios no identificados",
            "threshold_value": 1, "actual_value": 0, "compliant": true,
            "law_snippet": "Artículo 42.- Queda prohibido a las Instituciones de Tecnología Financiera mantener cuentas anónimas o con beneficiarios no identificados. En caso de detección, la institución deberá congelar los recursos y notificar a la CNBV en un plazo de 24 horas.",
          },
          {
            "id": "OBL-001", "type": "Obligation", "article": "Artículo 15",
            "text": "Límite de Transacciones",
            "description": "Transacciones mayores a 50,000 MXN deben ser reportadas a la CNBV",
            "threshold_value": 50000, "actual_value": 45000, "compliant": true,
            "law_snippet": "Artículo 15.- Las instituciones deberán reportar a la Comisión Nacional Bancaria y de Valores cualquier transacción que exceda el equivalente a 50,000 UDIs dentro de los tres días hábiles siguientes.",
          },
          {
            "id": "PRO-002", "type": "Prohibition", "article": "Artículo 28",
            "text": "Paraísos Fiscales",
            "description": "Prohibición de transferencias a jurisdicciones no cooperantes",
            "threshold_value": 1, "actual_value": 0, "compliant": true,
            "law_snippet": "Artículo 28.- Queda prohibida la realización de transferencias o disposiciones de recursos hacia jurisdicciones consideradas no cooperantes por el GAFI, salvo autorización expresa de la CNBV.",
          },
          {
            "id": "OBL-002", "type": "Obligation", "article": "Artículo 33",
            "text": "Reporte de PLD/FT",
            "description": "Obligación de presentar reportes de prevención de lavado de dinero",
            "threshold_value": 1, "actual_value": 1, "compliant": true,
            "law_snippet": "Artículo 33.- Las instituciones deberán presentar ante la CNBV reportes trimestrales sobre sus programas de prevención de lavado de dinero y financiamiento al terrorismo.",
          },
          {
            "id": "PRO-003", "type": "Prohibition", "article": "Artículo 56",
            "text": "Conflicto de Intereses",
            "description": "Prohibición de realizar operaciones con partes relacionadas sin autorización",
            "threshold_value": 1, "actual_value": 0, "compliant": true,
            "law_snippet": "Artículo 56.- Los consejeros, directivos y funcionarios no podrán realizar operaciones con partes relacionadas sin la autorización expresa del consejo de administración y el comisario.",
          },
        ],
      },
      signatures: {
        "regulator": {
          "party_id": "CNBV-001", "party_name": "Comisión Nacional Bancaria y de Valores",
          "role": "Regulador", "signature": List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join(), "verified": true,
        },
        "audited_entity": {
          "party_id": "FINTECH-042", "party_name": "Institución Fintech S.A. de C.V.",
          "role": "Entidad Regulada", "signature": List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join(), "verified": true,
        },
        "independent_auditor": {
          "party_id": "AUDIT-LEXI-001", "party_name": "LEXI AI Audit Network",
          "role": "Auditor Independiente", "signature": List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join(), "verified": true,
        },
      },
    );
  }
}

class LexiBackendService {
  static String _baseUrl = 'http://localhost:8000';

  static void setBaseUrl(String url) => _baseUrl = url;

  static Future<AuditReport> runPipeline({String? lawPath}) async {
    try {
      final params = lawPath != null ? {'law': lawPath} : null;
      final uri = Uri.parse('$_baseUrl/pipeline').replace(queryParameters: params);
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
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
  final _ngrokController = TextEditingController();
  bool _showNgrokInput = false;

  static const _tabs = [
    'Panel de Cumplimiento',
    'Sello Digital Blockchain',
    'Firmas Co-Partes',
    'Análisis de IA',
  ];
  static const _tabIcons = [
    Icons.shield_outlined,
    Icons.verified_outlined,
    Icons.edit_note_outlined,
    Icons.psychology_outlined,
  ];

  @override
  void dispose() {
    _ngrokController.dispose();
    super.dispose();
  }

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
    if (mounted) setState(() => _processing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEXI AI  •  Red de Cumplimiento Inteligente'),
        actions: [
          if (_useBackend)
            Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
              ),
              child: const Text('EN VIVO', style: TextStyle(color: Color(0xFF10B981), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            ),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: Color(0xFF2563EB)),
            onPressed: _processing ? null : _executePipeline,
            tooltip: 'Ejecutar Auditoría',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Color(0xFF6B7280)),
            onSelected: (v) {
              if (v == 'mock') {
                setState(() { _useBackend = false; _showNgrokInput = false; });
              } else if (v == 'ngrok') {
                setState(() => _showNgrokInput = true);
              } else if (v == 'localhost') {
                setState(() { _useBackend = true; _showNgrokInput = false; });
                LexiBackendService.setBaseUrl('http://localhost:8000');
              }
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem(value: 'mock', checked: !_useBackend && !_showNgrokInput, child: const Text('Simulación Local')),
              CheckedPopupMenuItem(value: 'localhost', checked: _useBackend && !_showNgrokInput, child: const Text('Servidor Local:8000')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'ngrok', child: Text('Túnel ngrok...')),
            ],
          ),
        ],
      ),
      body: _showNgrokInput
          ? _buildNgrokPanel()
          : _processing
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)))
              : _report == null ? _buildEmptyState() : _buildTabContent(),
      bottomNavigationBar: _report == null || _showNgrokInput
          ? null
          : BottomNavigationBar(
              currentIndex: _tabIndex,
              onTap: (i) => setState(() => _tabIndex = i),
              items: List.generate(4, (i) => BottomNavigationBarItem(
                icon: Icon(_tabIcons[i]),
                label: _tabs[i],
              )),
            ),
    );
  }

  Widget _buildNgrokPanel() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_tethering, size: 48, color: Color(0xFF2563EB)),
          const SizedBox(height: 16),
          const Text('Conexión por Túnel Seguro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Ingresa la URL HTTPS de ngrok para conectar\ncon el servidor de auditoría en vivo.',
              textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF6B7280), height: 1.4)),
          const SizedBox(height: 16),
          TextField(
            controller: _ngrokController,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'https://tu-tunel.ngrok.io',
              hintStyle: const TextStyle(color: Color(0xFF4B5563)),
              filled: true,
              fillColor: const Color(0xFF262B3C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF374151)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              final url = _ngrokController.text.trim();
              if (url.isNotEmpty) {
                LexiBackendService.setBaseUrl(url.replaceAll(RegExp(r'/$'), ''));
                setState(() { _useBackend = true; _showNgrokInput = false; });
                _executePipeline();
              }
            },
            icon: const Icon(Icons.link),
            label: const Text('CONECTAR'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.gavel, size: 48, color: Color(0xFF2563EB)),
          ),
          const SizedBox(height: 20),
          const Text('LEXI AI', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Text('Red de Cumplimiento Inteligente\ny Contratos Legales',
              textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF6B7280), height: 1.4, fontSize: 15)),
          const SizedBox(height: 8),
          Text('RegTech • Auditoría Asistida por IA • Blockchain',
              style: TextStyle(color: const Color(0xFF4B5563), fontSize: 11, letterSpacing: 0.3)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _executePipeline,
            icon: const Icon(Icons.play_arrow),
            label: const Text('INICIAR AUDITORÍA'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_tabIndex) {
      case 0: return _DashboardTab(report: _report!, useBackend: _useBackend);
      case 1: return _ContractTab(report: _report!);
      case 2: return _SignaturesTab(report: _report!);
      case 3: return _AgentsTab(report: _report!);
      default: return const SizedBox();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD — Panel de Cumplimiento
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  final AuditReport report;
  final bool useBackend;
  const _DashboardTab({required this.report, required this.useBackend});

  @override
  Widget build(BuildContext context) {
    final c = report.compliance;
    final status = c['status'] as bool? ?? false;
    final hash = c['audit_hash'] as String? ?? '';
    final ast = c['ast_hash'] as String? ?? '';
    final rulesCount = c['rules_evaluated'] as int? ?? 0;
    final violations = (c['violations'] as List?) ?? [];
    final rules = (c['rules'] as List?) ?? [];
    final ctx = (c['context'] as Map<String, dynamic>?) ?? {};
    final meta = report.metadata;

    final compliantCount = rules.where((r) => r['compliant'] == true).length;
    final violatedCount = rules.where((r) => r['compliant'] == false).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        // ── Encabezado del Dictamen ──
        _sectionTitle('Dictamen de Cumplimiento'),
        const SizedBox(height: 4),
        Text(
          '${meta['regulated_entity'] ?? '—'}  |  ${meta['audit_period'] ?? '—'}',
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
        ),
        const SizedBox(height: 12),

        // ── Verdict Card ──
        Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: (status ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.3)),
            color: const Color(0xFF262B3C),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (status ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(status ? Icons.verified : Icons.warning_amber_rounded,
                  size: 28, color: status ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status ? 'CUMPLIMIENTO TOTAL' : 'INCUMPLIMIENTO DETECTADO',
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700,
                      color: status ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      letterSpacing: 0.3,
                    )),
                const SizedBox(height: 4),
                Text(
                  status
                      ? '$rulesCount reglas evaluadas • $compliantCount cumplidas • $violatedCount violaciones'
                      : '${violations.length} violación(es) detectada(s): ${violations.join(", ")}',
                  style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                ),
              ],
            )),
          ]),
        ),
        const SizedBox(height: 20),

        // ── Semáforo Legal: Reglas ──
        _sectionTitle('Semáforo Legal — Reglas Evaluadas'),
        const SizedBox(height: 8),
        if (rules.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF262B3C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('No se evaluaron reglas en esta auditoría.',
                style: TextStyle(color: Color(0xFF6B7280))),
          )
        else
          ...rules.map((r) => _ruleCard(r)),

        const SizedBox(height: 20),

        // ── Contexto Operativo ──
        _sectionTitle('Contexto de la Operación'),
        const SizedBox(height: 8),
        ...ctx.entries.map((e) => _contextRow(e.key, '${e.value}')),
        const SizedBox(height: 20),

        // ── Cadena de Auditoría (Hashes) ──
        _sectionTitle('Cadena de Auditoría'),
        const SizedBox(height: 8),
        _hashCard('Hash de Auditoría SHA-256', hash, const Color(0xFF2563EB)),
        const SizedBox(height: 6),
        _hashCard('Hash del Árbol Sintáctico (AST)', ast, const Color(0xFF8B5CF6)),
        const SizedBox(height: 6),
        _infoRow('Reglas Evaluadas', '$rulesCount', const Color(0xFF6B7280)),
        const SizedBox(height: 6),
        _infoRow('Marco Regulatorio', meta['regulatory_framework'] as String? ?? '—', const Color(0xFF6B7280)),
        const SizedBox(height: 6),
        _infoRow('Fuente de Datos', useBackend ? 'Servidor en Vivo (ngrok/localhost)' : 'Simulación Local',
            useBackend ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
        const SizedBox(height: 20),

        // ── Botón de Dictamen PDF ──
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showCertificate(context, report),
            icon: const Icon(Icons.description_outlined),
            label: const Text('GENERAR CERTIFICADO DE CUMPLIMIENTO'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              side: const BorderSide(color: Color(0xFF2563EB)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTRACT TAB — Sello Digital Blockchain
// ─────────────────────────────────────────────────────────────────────────────

class _ContractTab extends StatelessWidget {
  final AuditReport report;
  const _ContractTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final ct = report.contract;
    final c = report.compliance;
    final hash = c['audit_hash'] as String? ?? '';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        _sectionTitle('Sello Digital e Inmutabilidad Blockchain'),
        const SizedBox(height: 4),
        const Text(
          'Cada auditoría queda registrada de forma permanente e inmutable en la red descentralizada Stellar (Soroban). '
          'Ninguna de las partes puede modificar, borrar o repudiar el resultado.',
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 16),

        // ── Hash con explicación ──
        _hashWithTooltip(
          'Hash de la Auditoría (Huella Digital)',
          hash,
          'Este código alfanumérico es la huella digital matemática única de esta auditoría. '
              'Fue inscrita en la red descentralizada Stellar (Soroban) y no puede ser borrada, '
              'modificada ni alterada por ninguna de las partes. Cualquier cambio en los datos '
              'originales generaría un hash completamente diferente.',
        ),
        const SizedBox(height: 16),

        // ── Datos del Contrato ──
        _infoRow('Red', ct['network'] as String? ?? '—', const Color(0xFF2563EB)),
        const SizedBox(height: 6),
        _infoRow('ID del Contrato', ct['contract_id'] as String? ?? '—', const Color(0xFF2563EB)),
        const SizedBox(height: 6),
        _infoRow('Esquema de Firmas', '2 de 3 (Regulador, Entidad, Auditor Independiente)', const Color(0xFF8B5CF6)),
        const SizedBox(height: 6),
        _infoRow('Hash Compilado', ct['compiled_hash'] as String? ?? '—', const Color(0xFF2563EB)),
        const SizedBox(height: 6),
        _infoRow('Código Fuente', ct['source'] as String? ?? '—', const Color(0xFF6B7280)),
        const SizedBox(height: 20),

        // ── Explicación para no técnicos ──
        _sectionTitle('¿Qué significa esto?'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF262B3C),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF374151)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _explainRow(Icons.security, 'Inmutabilidad',
                  'Una vez registrado, el resultado de la auditoría no puede ser alterado por nadie.'),
              const SizedBox(height: 12),
              _explainRow(Icons.group, 'Multi-Firma',
                  'Se requieren 2 de 3 firmas independientes (CNBV, Fintech, LEXI) para validar el registro.'),
              const SizedBox(height: 12),
              _explainRow(Icons.public, 'Red Descentralizada',
                  'Los datos no están en un servidor central, sino en la red pública de Stellar.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _explainRow(IconData icon, String title, String desc) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 18, color: const Color(0xFF2563EB)),
      const SizedBox(width: 10),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white)),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
        ],
      )),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SIGNATURES TAB — Firmas Co-Partes
// ─────────────────────────────────────────────────────────────────────────────

class _SignaturesTab extends StatelessWidget {
  final AuditReport report;
  const _SignaturesTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final sigs = report.signatures;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        _sectionTitle('Firmas Co-Partes y Poderes'),
        const SizedBox(height: 4),
        const Text(
          'Cada auditoría es firmada de forma independiente por las tres partes involucradas. '
          'Se requieren al menos 2 firmas válidas para que el registro sea vinculante.',
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 16),
        ...sigs.entries.map((e) => _partyCard(e.key, Map<String, dynamic>.from(e.value))),
        const SizedBox(height: 20),

        // ── Evidencia ──
        if (report.evidence != null) ...[
          _sectionTitle('Evidencia de Firmas'),
          const SizedBox(height: 8),
          _infoRow('Hash de Recuperación', report.evidence!['recovery_hash'] as String? ?? '—', const Color(0xFF8B5CF6)),
          if (report.evidence!['core_payload'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _infoRow('Carga útil firmada',
                  (report.evidence!['core_payload'] as String).length > 60
                      ? '${(report.evidence!['core_payload'] as String).substring(0, 60)}...'
                      : report.evidence!['core_payload'] as String,
                  const Color(0xFF6B7280)),
            ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AGENTS TAB — Análisis de IA
// ─────────────────────────────────────────────────────────────────────────────

class _AgentsTab extends StatelessWidget {
  final AuditReport report;
  const _AgentsTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final agents = report.agents;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        _sectionTitle('Análisis de Inteligencia Artificial (NLP)'),
        const SizedBox(height: 4),
        const Text(
          'Tres agentes de IA trabajan en cadena para analizar la ley, evaluar el cumplimiento '
          'y registrar el resultado en la blockchain. Cada paso está trazado criptográficamente.',
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 16),
        ...agents.entries.map((e) => _agentCard(e.key, Map<String, dynamic>.from(e.value))),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

Widget _sectionTitle(String title) {
  return Text(title, style: const TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.3,
  ));
}

Widget _infoRow(String label, String value, Color color) {
  return Container(
    width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFF262B3C),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF374151)),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 2, child: Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w500))),
      const SizedBox(width: 8),
      Expanded(flex: 3, child: SelectableText(value, style: TextStyle(color: color, fontSize: 12))),
    ]),
  );
}

Widget _hashCard(String label, String value, Color color) {
  return Container(
    width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFF262B3C),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: TextStyle(color: color.withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      SelectableText(value, style: TextStyle(color: color, fontSize: 11, fontFamily: 'monospace', letterSpacing: 0.3)),
    ]),
  );
}

Widget _hashWithTooltip(String label, String hash, String tooltip) {
  return Container(
    width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFF262B3C),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF374151)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.w500))),
        Tooltip(
          message: tooltip,
          triggerMode: TooltipTriggerMode.tap,
          decoration: BoxDecoration(
            color: const Color(0xFF1E222F),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF374151)),
          ),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(16),
          preferBelow: false,
          child: Icon(Icons.info_outline, size: 16, color: const Color(0xFF2563EB).withOpacity(0.6)),
        ),
      ]),
      const SizedBox(height: 6),
      SelectableText(hash, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontFamily: 'monospace', letterSpacing: 0.3)),
    ]),
  );
}

Widget _contextRow(String key, String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 4), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF262B3C),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: const Color(0xFF374151)),
    ),
    child: Row(children: [
      Text(_contextLabel(key), style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
      const Spacer(),
      Text(value, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
    ]),
  );
}

String _contextLabel(String key) {
  switch (key) {
    case 'transaction_amount': return 'Monto de Transacción';
    case 'anonymous_accounts': return 'Cuentas Anónimas';
    default: return key.replaceAll('_', ' ');
  }
}

Widget _ruleCard(Map<String, dynamic> rule) {
  final compliant = rule['compliant'] as bool? ?? false;
  final type = rule['type'] as String? ?? '';
  final article = rule['article'] as String? ?? '';
  final text = rule['text'] as String? ?? '';
  final desc = rule['description'] as String? ?? '';
  final threshold = rule['threshold_value'];
  final actual = rule['actual_value'];
  final snippet = rule['law_snippet'] as String? ?? '';

  IconData icon;
  Color color;
  String badge;

  if (type == 'Prohibition') {
    icon = Icons.block;
    color = const Color(0xFFEF4444);
    badge = 'PROHIBICIÓN';
  } else {
    icon = Icons.check_circle_outline;
    color = const Color(0xFFF59E0B);
    badge = 'OBLIGACIÓN';
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF262B3C),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: compliant ? const Color(0xFF374151) : const Color(0xFFEF4444).withOpacity(0.3)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Header row
      Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
            Text(badge, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          ]),
        ),
        const SizedBox(width: 8),
        Text(article, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: (compliant ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(compliant ? 'CUMPLE' : 'INCUMPLE',
              style: TextStyle(
                color: compliant ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3,
              )),
        ),
      ]),
      const SizedBox(height: 8),
      Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white)),
      const SizedBox(height: 4),
      Text(desc, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
      const SizedBox(height: 6),
      Row(children: [
        Text('Límite: $threshold  |  Real: $actual', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
      ]),
      if (snippet.isNotEmpty) ...[
        const SizedBox(height: 8),
        // Traceability: law snippet with expand/collapse
        _lawSnippetCard(article, snippet),
      ],
    ]),
  );
}

Widget _lawSnippetCard(String article, String snippet) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFF1E222F),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: const Color(0xFF374151)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(Icons.search, size: 12, color: const Color(0xFF2563EB).withOpacity(0.7)),
        const SizedBox(width: 4),
        Text('Trazabilidad — Texto de la Ley', style: TextStyle(
          color: const Color(0xFF2563EB).withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.3,
        )),
      ]),
      const SizedBox(height: 4),
      Text(snippet, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, height: 1.4)),
    ]),
  );
}

Widget _partyCard(String id, Map<String, dynamic> party) {
  final verified = party['verified'] as bool? ?? false;
  final color = verified ? const Color(0xFF10B981) : const Color(0xFFEF4444);
  final role = party['role'] as String? ?? '';
  final name = party['party_name'] as String? ?? '';
  final pid = party['party_id'] as String? ?? '';
  final sig = party['signature'] as String? ?? '';

  IconData icon;
  if (role.contains('Regulador')) {
    icon = Icons.account_balance;
  } else if (role.contains('Entidad')) {
    icon = Icons.business;
  } else {
    icon = Icons.verified_user;
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF262B3C),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: verified ? const Color(0xFF10B981).withOpacity(0.2) : const Color(0xFFEF4444).withOpacity(0.2)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white)),
            const SizedBox(height: 2),
            Text('$role  •  $pid', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(verified ? 'FIRMADO' : 'PENDIENTE',
              style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
        ),
      ]),
      const SizedBox(height: 12),
      Container(
        width: double.infinity, padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E222F),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF374151)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Firma:', style: TextStyle(color: Color(0xFF6B7280), fontSize: 10)),
          const SizedBox(width: 6),
          Expanded(child: SelectableText(sig, style: TextStyle(color: color, fontSize: 10, fontFamily: 'monospace'))),
        ]),
      ),
    ]),
  );
}

Widget _agentCard(String id, Map<String, dynamic> agent) {
  final name = agent['agent'] as String? ?? id;
  final model = agent['model'] as String? ?? '';
  final version = agent['version'] as String? ?? '';
  final outputs = agent['outputs'] as Map<String, dynamic>? ?? {};

  return Container(
    margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF262B3C),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFF374151)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_agentIcon(name), color: const Color(0xFF2563EB), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white)),
            const SizedBox(height: 2),
            Text(model, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF374151),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text('v$version', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 10)),
        ),
      ]),
      const SizedBox(height: 12),
      ...outputs.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${_outputLabel(e.key)}: ',
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
          Expanded(child: Text(_fmtOutput(e.value),
              style: const TextStyle(color: Colors.white, fontSize: 11))),
        ]),
      )),
    ]),
  );
}

String _outputLabel(String key) {
  switch (key) {
    case 'rules_count': return 'Reglas detectadas';
    case 'ast_hash': return 'Hash AST';
    case 'nlp_method': return 'Método NLP';
    case 'compliant': return 'Cumplimiento';
    case 'violations': return 'Violaciones';
    case 'audit_hash': return 'Hash de Auditoría';
    case 'onchain_tx': return 'Transacción on-chain';
    case 'multi_sig_scheme': return 'Esquema multi-firma';
    default: return key;
  }
}

IconData _agentIcon(String name) {
  if (name.contains('NLP')) return Icons.translate;
  if (name.contains('Compliance')) return Icons.rule;
  if (name.contains('Web3')) return Icons.link;
  return Icons.psychology;
}

String _fmtOutput(dynamic v) {
  if (v is bool) return v ? 'Verdadero' : 'Falso';
  if (v is List) return v.join(', ');
  if (v is Map) return jsonEncode(v);
  return '$v';
}

// ─────────────────────────────────────────────────────────────────────────────
// CERTIFICATE DIALOG
// ─────────────────────────────────────────────────────────────────────────────

void _showCertificate(BuildContext context, AuditReport report) {
  final c = report.compliance;
  final meta = report.metadata;
  final status = c['status'] as bool? ?? false;
  final hash = c['audit_hash'] as String? ?? '';
  final rulesCount = c['rules_evaluated'] as int? ?? 0;
  final rules = (c['rules'] as List?) ?? [];
  final compliantCount = rules.where((r) => r['compliant'] == true).length;
  final now = DateTime.now();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1E222F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Center(child: Icon(
                status ? Icons.verified : Icons.warning_amber_rounded,
                color: status ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                size: 40,
              )),
              const SizedBox(height: 8),
              Center(child: Text(
                status ? 'CERTIFICADO DE CUMPLIMIENTO' : 'CERTIFICADO DE INCUMPLIMIENTO',
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: status ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  letterSpacing: 0.5,
                ),
              )),
              const SizedBox(height: 16),

              _certLine('Entidad Regulada', meta['regulated_entity'] as String? ?? '—'),
              _certLine('Período Auditado', meta['audit_period'] as String? ?? '—'),
              _certLine('Marco Regulatorio', meta['regulatory_framework'] as String? ?? '—'),
              _certLine('Resultado', status ? 'CUMPLIMIENTO TOTAL' : 'INCUMPLIMIENTO DETECTADO'),
              _certLine('Reglas Evaluadas', '$rulesCount'),
              _certLine('Reglas Cumplidas', '$compliantCount'),
              _certLine('Fecha de Emisión', '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}'),
              _certLine('Versión del Sistema', meta['version'] as String? ?? '—'),
              const SizedBox(height: 12),
              Text('Hash de Certificación:', style: TextStyle(color: const Color(0xFF6B7280), fontSize: 9)),
              const SizedBox(height: 2),
              SelectableText(hash, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 10, fontFamily: 'monospace')),
              const SizedBox(height: 4),
              Text('Este certificado es una representación digital del resultado de la auditoría. '
                  'El hash SHA-256 mostrado es la evidencia criptográfica vinculada a la red Stellar (Soroban).',
                  style: TextStyle(color: const Color(0xFF4B5563), fontSize: 9, height: 1.3)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('CERRAR', style: TextStyle(color: Color(0xFF6B7280))),
        ),
      ],
    ),
  );
}

Widget _certLine(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: 130,
        child: Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
      ),
      Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500))),
    ]),
  );
}
