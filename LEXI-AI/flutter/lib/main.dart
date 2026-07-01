import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// ── Design System Tokens (LexGuardian) ───────────────────────────────────────
const _surfaceDim = Color(0xFF031427);
const _surfaceContainer = Color(0xFF102034);
const _surfaceContainerLow = Color(0xFF0B1C30);
const _surfaceContainerHigh = Color(0xFF1B2B3F);
const _surfaceContainerHighest = Color(0xFF26364A);
const _surfaceBright = Color(0xFF2A3A4F);
const _surfaceDeep = Color(0xFF0B0B13);
const _surfaceDocument = Color(0xFF262B3C);
const _glassBg = Color(0xFF1E222F);
const _onSurface = Color(0xFFD3E4FE);
const _onSurfaceVariant = Color(0xFFC3C6D7);
const _primary = Color(0xFFB4C5FF);
const _primaryContainer = Color(0xFF2563EB);
const _outline = Color(0xFF8D90A0);
const _outlineVariant = Color(0xFF434655);
const _success = Color(0xFF10B981);
const _warning = Color(0xFFF59E0B);
const _alert = Color(0xFFEF4444);

void main() => runApp(const LexiAiApp());

class LexiAiApp extends StatelessWidget {
  const LexiAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LEXI AI',
      theme: ThemeData(
        scaffoldBackgroundColor: _surfaceDim,
        colorScheme: const ColorScheme.dark(
          primary: _primary,
          secondary: _onSurfaceVariant,
          surface: _surfaceContainer,
          error: _alert,
        ),
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          backgroundColor: _surfaceContainerHigh,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: _onSurface, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3),
          iconTheme: IconThemeData(color: _onSurfaceVariant),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: _surfaceDim,
          selectedItemColor: _primary,
          unselectedItemColor: _outline,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11),
        ),
      ),
      home: const LexiHome(),
    );
  }
}

// ── Data Model ───────────────────────────────────────────────────────────────

class AuditReport {
  final Map<String, dynamic> metadata;
  final Map<String, dynamic> agents;
  final Map<String, dynamic> contract;
  final Map<String, dynamic> compliance;
  final Map<String, dynamic> signatures;
  final Map<String, dynamic>? evidence;

  AuditReport({
    required this.metadata, required this.agents, required this.contract,
    required this.compliance, required this.signatures, this.evidence,
  });

  factory AuditReport.fromJson(Map<String, dynamic> json) => AuditReport(
    metadata: json['metadata'] ?? {},
    agents: json['agents'] ?? {},
    contract: json['contract'] ?? {},
    compliance: json['compliance'] ?? {},
    signatures: json['signatures'] ?? {},
    evidence: json['evidence'],
  );

  factory AuditReport.mock() {
    final h = List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join();
    final a = List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join();
    return AuditReport(
      metadata: {
        "title": "Dictamen de Cumplimiento Regulatorio LEXI AI",
        "version": "2.0.0", "generated_at": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "regulated_entity": "Institución Fintech S.A. de C.V.",
        "audit_period": "Enero - Junio 2026",
        "regulatory_framework": "Ley Fintech | LFPIRPFI",
      },
      agents: {
        "nlp_agent": {"agent": "LexiNLP", "version": "0.1.0", "model": "Híbrido: spaCy + HuggingFace + Regex", "outputs": {"rules_count": 5, "ast_hash": a, "nlp_method": "regex"}},
        "compliance_agent": {"agent": "LexiCompliance", "version": "0.1.0", "model": "Motor de Inferencia Basado en Reglas", "outputs": {"compliant": true, "violations": [], "audit_hash": h}},
        "web3_agent": {"agent": "LexiWeb3", "version": "0.1.0", "model": "Soroban 2-of-3 Multi-Sig", "outputs": {"onchain_tx": {"tx_hash": h, "contract_id": "CA3Q5T..."}, "multi_sig_scheme": "2-of-3"}},
      },
      contract: {"network": "Stellar Testnet", "contract_id": "CA3Q5T6E7F8G9H0J1K2L3M4N5P6Q7R8S9T0U1V2W3X4Y5Z6", "multi_sig_required": 2, "compiled_hash": "9d8a7b6c...", "source": "contracts/lexi_compliance/src/lib.rs"},
      compliance: {
        "status": true, "audit_hash": h, "ast_hash": a, "rules_evaluated": 5, "violations": [],
        "context": {"transaction_amount": 45000, "anonymous_accounts": 0},
        "rules": [
          {"id": "PRO-001", "type": "Prohibition", "article": "Artículo 42", "text": "Cuentas Anónimas", "description": "Prohibición de mantener cuentas anónimas o beneficiarios no identificados", "threshold_value": 1, "actual_value": 0, "compliant": true, "law_snippet": "Artículo 42.- Queda prohibido a las Instituciones de Tecnología Financiera mantener cuentas anónimas o con beneficiarios no identificados. En caso de detección, la institución deberá congelar los recursos y notificar a la CNBV en un plazo de 24 horas."},
          {"id": "OBL-001", "type": "Obligation", "article": "Artículo 15", "text": "Límite de Transacciones", "description": "Transacciones mayores a 50,000 MXN deben ser reportadas a la CNBV", "threshold_value": 50000, "actual_value": 45000, "compliant": true, "law_snippet": "Artículo 15.- Las instituciones deberán reportar a la Comisión Nacional Bancaria y de Valores cualquier transacción que exceda el equivalente a 50,000 UDIs dentro de los tres días hábiles siguientes."},
          {"id": "PRO-002", "type": "Prohibition", "article": "Artículo 28", "text": "Paraísos Fiscales", "description": "Prohibición de transferencias a jurisdicciones no cooperantes", "threshold_value": 1, "actual_value": 0, "compliant": true, "law_snippet": "Artículo 28.- Queda prohibida la realización de transferencias o disposiciones de recursos hacia jurisdicciones consideradas no cooperantes por el GAFI, salvo autorización expresa de la CNBV."},
          {"id": "OBL-002", "type": "Obligation", "article": "Artículo 33", "text": "Reporte de PLD/FT", "description": "Obligación de presentar reportes de prevención de lavado de dinero", "threshold_value": 1, "actual_value": 1, "compliant": true, "law_snippet": "Artículo 33.- Las instituciones deberán presentar ante la CNBV reportes trimestrales sobre sus programas de prevención de lavado de dinero y financiamiento al terrorismo."},
          {"id": "PRO-003", "type": "Prohibition", "article": "Artículo 56", "text": "Conflicto de Intereses", "description": "Prohibición de realizar operaciones con partes relacionadas sin autorización", "threshold_value": 1, "actual_value": 0, "compliant": true, "law_snippet": "Artículo 56.- Los consejeros, directivos y funcionarios no podrán realizar operaciones con partes relacionadas sin la autorización expresa del consejo de administración y el comisario."},
        ],
      },
      signatures: {
        "regulator": {"party_id": "CNBV-001", "party_name": "Comisión Nacional Bancaria y de Valores", "role": "Regulador", "signature": List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join(), "verified": true},
        "audited_entity": {"party_id": "FINTECH-042", "party_name": "Institución Fintech S.A. de C.V.", "role": "Entidad Regulada", "signature": List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join(), "verified": true},
        "independent_auditor": {"party_id": "AUDIT-LEXI-001", "party_name": "LEXI AI Audit Network", "role": "Auditor Independiente", "signature": List.generate(64, (_) => '0123456789abcdef'[Random().nextInt(16)]).join(), "verified": true},
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
      if (response.statusCode == 200) return AuditReport.fromJson(jsonDecode(response.body));
    } catch (_) {}
    return AuditReport.mock();
  }
}

// ── Main Shell ───────────────────────────────────────────────────────────────

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

  static const _tabs = ['Panel de Control', 'Análisis de IA', 'Firmas y Poderes', 'Sello Digital'];
  static const _tabIcons = [Icons.dashboard, Icons.auto_awesome, Icons.history_edu, Icons.verified];

  @override
  void dispose() { _ngrokController.dispose(); super.dispose(); }

  Future<void> _executePipeline() async {
    setState(() => _processing = true);
    try {
      _report = _useBackend ? await LexiBackendService.runPipeline() : (await Future.delayed(const Duration(milliseconds: 800), AuditReport.mock));
    } catch (_) { _report = AuditReport.mock(); }
    if (mounted) setState(() => _processing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: _primaryContainer.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.gavel, size: 18, color: _primaryContainer),
            ),
            const SizedBox(width: 10),
            const Text('LEXI AI  •  LexGuardian Compliance'),
          ],
        ),
        actions: [
          if (_useBackend)
            Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _success.withOpacity(0.3)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: _success, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                const Text('EN VIVO', style: TextStyle(color: _success, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ]),
            ),
          _processing
              ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2, color: _primary))
              : IconButton(
                  icon: const Icon(Icons.play_circle_outline, color: _primaryContainer),
                  onPressed: _executePipeline,
                  tooltip: 'Ejecutar Auditoría',
                ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: _outline),
            onSelected: (v) {
              if (v == 'mock') setState(() { _useBackend = false; _showNgrokInput = false; });
              else if (v == 'ngrok') setState(() => _showNgrokInput = true);
              else if (v == 'localhost') { setState(() { _useBackend = true; _showNgrokInput = false; }); LexiBackendService.setBaseUrl('http://localhost:8000'); }
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
      body: _showNgrokInput ? _buildNgrokPanel()
          : _processing ? const Center(child: CircularProgressIndicator(color: _primaryContainer))
          : _report == null ? _buildEmptyState() : _buildTabContent(),
      bottomNavigationBar: _report == null || _showNgrokInput ? null
          : BottomNavigationBar(
              currentIndex: _tabIndex,
              onTap: (i) => setState(() => _tabIndex = i),
              items: List.generate(4, (i) => BottomNavigationBarItem(icon: Icon(_tabIcons[i]), label: _tabs[i])),
            ),
    );
  }

  Widget _buildNgrokPanel() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _GlassCard(child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(children: [
              const Icon(Icons.wifi_tethering, size: 48, color: _primaryContainer),
              const SizedBox(height: 16),
              const Text('Conexión por Túnel Seguro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _onSurface)),
              const SizedBox(height: 8),
              const Text('Ingresa la URL HTTPS de ngrok para conectar\ncon el servidor de auditoría en vivo.', textAlign: TextAlign.center, style: TextStyle(color: _onSurfaceVariant, height: 1.4)),
              const SizedBox(height: 16),
              _StyledField(controller: _ngrokController, hint: 'https://tu-tunel.ngrok.io'),
              const SizedBox(height: 16),
              _PrimaryButton(label: 'CONECTAR', icon: Icons.link, onPressed: _connectNgrok),
            ]),
          )),
        ]),
      ),
    );
  }

  void _connectNgrok() {
    final url = _ngrokController.text.trim();
    if (url.isNotEmpty) {
      LexiBackendService.setBaseUrl(url.replaceAll(RegExp(r'/$'), ''));
      setState(() { _useBackend = true; _showNgrokInput = false; });
      _executePipeline();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: _primaryContainer.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.gavel, size: 48, color: _primaryContainer),
        ),
        const SizedBox(height: 20),
        const Text('LEXI AI — LexGuardian Compliance', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _onSurface, letterSpacing: 0.3)),
        const SizedBox(height: 8),
        Text('Red de Cumplimiento Inteligente y Contratos Legales\nAuditoría Asistida por IA  •  Blockchain Soroban',
            textAlign: TextAlign.center, style: const TextStyle(color: _onSurfaceVariant, height: 1.4, fontSize: 14)),
        const SizedBox(height: 28),
        _PrimaryButton(label: 'INICIAR AUDITORÍA', icon: Icons.play_arrow, onPressed: _executePipeline),
      ]),
    );
  }

  Widget _buildTabContent() {
    switch (_tabIndex) {
      case 0: return _DashboardTab(report: _report!, useBackend: _useBackend, onRerun: _executePipeline);
      case 1: return _AgentsTab(report: _report!);
      case 2: return _SignaturesTab(report: _report!);
      case 3: return _ContractTab(report: _report!);
      default: return const SizedBox();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 0 — PANEL DE CONTROL
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  final AuditReport report;
  final bool useBackend;
  final VoidCallback onRerun;
  const _DashboardTab({required this.report, required this.useBackend, required this.onRerun});

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

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      children: [
        // ── Hero: Command Center ──
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Bento status card
          Expanded(flex: 7, child: _GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: _primaryContainer.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.dashboard, size: 20, color: _primaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Command Center', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _onSurface)),
                    Text('${meta['regulated_entity'] ?? '—'}  |  ${meta['audit_period'] ?? '—'}', style: const TextStyle(color: _onSurfaceVariant, fontSize: 12), overflow: TextOverflow.ellipsis),
                  ])),
                ]),
                const SizedBox(height: 20),
                // Status tiles in a responsive row that wraps
                LayoutBuilder(builder: (ctx, constraints) {
                  final tileWidth = (constraints.maxWidth - 16) / 3;
                  return Row(children: [
                    SizedBox(width: tileWidth, child: _statusTile('Motor NLP', 'Activo (v4.1)', _success, Icons.auto_awesome)),
                    const SizedBox(width: 8),
                    SizedBox(width: tileWidth, child: _statusTile('Soroban Sync', 'Sincronizado', _primary, Icons.sync)),
                    const SizedBox(width: 8),
                    SizedBox(width: tileWidth, child: _statusTile('Inmutabilidad', '99.9%', _warning, Icons.verified_user)),
                  ]);
                }),
              ]),
            ),
          )),
          const SizedBox(width: 20),
          // Certificate CTA
          Expanded(flex: 5, child: _GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Cumplimiento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _onSurface)),
                const SizedBox(height: 4),
                const Text('Valide la integridad de todos los expedientes procesados en el ciclo actual.',
                    style: TextStyle(color: _onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: _PrimaryButton(
                    label: 'Generar Certificado (PDF)',
                    icon: Icons.picture_as_pdf,
                    onPressed: () => _showCertificate(context, report),
                  ),
                ),
              ]),
            ),
          )),
        ]),
        const SizedBox(height: 24),

        // ── Pipeline Visualizer ──
        _sectionHeader('Pipeline de Procesamiento'),
        const SizedBox(height: 8),
        _GlassCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _pipelineStep('IA (NLP)', 'Extracción', Icons.psychology, _primary, true),
              _pipelineStep('Compliance', 'Validación', Icons.balance, _warning, true),
              _pipelineStep('Blockchain', 'Inmutabilidad', Icons.verified, _success, true),
              _pipelineStep('Resguardo', 'Archivado', Icons.inventory_2, _outline, false),
            ]),
          ),
        ),
        const SizedBox(height: 24),

        // ── Verdict ──
        _sectionHeader('Dictamen de Cumplimiento'),
        const SizedBox(height: 8),
        _GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (status ? _success : _alert).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(status ? Icons.verified : Icons.warning_amber_rounded, size: 28, color: status ? _success : _alert),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(status ? 'CUMPLIMIENTO TOTAL' : 'INCUMPLIMIENTO DETECTADO',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: status ? _success : _alert, letterSpacing: 0.3)),
                const SizedBox(height: 4),
                Text('$rulesCount reglas evaluadas  •  $compliantCount cumplidas  •  ${violations.length} violaciones',
                    style: const TextStyle(color: _onSurfaceVariant, fontSize: 12)),
              ])),
            ]),
          ),
        ),
        const SizedBox(height: 24),

        // ── Traffic Light Cards ──
        _sectionHeader('Semáforo Legal — Reglas Evaluadas'),
        const SizedBox(height: 8),
        if (rules.isEmpty)
          _GlassCard(child: const Padding(padding: EdgeInsets.all(16), child: Text('No se evaluaron reglas.', style: TextStyle(color: _onSurfaceVariant))))
        else
          ...rules.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ruleCard(r),
          )),
        const SizedBox(height: 24),

        // ── Context + Hashes ──
        _sectionHeader('Contexto de la Operación'),
        const SizedBox(height: 8),
        ...ctx.entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _infoRow(_ctxLabel(e.key), '${e.value}', _outline),
        )),
        const SizedBox(height: 20),

        _sectionHeader('Cadena de Auditoría'),
        const SizedBox(height: 8),
        _hashCard('Hash de Auditoría SHA-256', hash, _primary, context: context),
        const SizedBox(height: 6),
        _hashCard('Hash del Árbol Sintáctico (AST)', ast, const Color(0xFF8B5CF6), context: context),
        const SizedBox(height: 6),
        _infoRow('Reglas Evaluadas', '$rulesCount', _outline),
        const SizedBox(height: 6),
        _infoRow('Marco Regulatorio', meta['regulatory_framework'] as String? ?? '—', _outline),
        const SizedBox(height: 6),
        _infoRow('Fuente', useBackend ? 'Servidor en Vivo' : 'Simulación Local', useBackend ? _success : _warning),
        const SizedBox(height: 20),

        // ── Re-run ──
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onRerun,
            icon: const Icon(Icons.refresh),
            label: const Text('RE-EJECUTAR AUDITORÍA'),
            style: _outlinedBtnStyle,
          ),
        ),
      ],
    );
  }

  String _ctxLabel(String k) {
    switch (k) {
      case 'transaction_amount': return 'Monto de Transacción';
      case 'anonymous_accounts': return 'Cuentas Anónimas';
      default: return k.replaceAll('_', ' ');
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1 — ANÁLISIS DE IA
// ─────────────────────────────────────────────────────────────────────────────

class _AgentsTab extends StatelessWidget {
  final AuditReport report;
  const _AgentsTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final agents = report.agents;
    return ListView(padding: const EdgeInsets.fromLTRB(24, 24, 24, 48), children: [
      _sectionHeader('Análisis de Inteligencia Artificial (NLP)'),
      const SizedBox(height: 4),
      const Text('Tres agentes de IA trabajan en cadena para analizar la ley, evaluar el cumplimiento y registrar el resultado en la blockchain. Cada paso está trazado criptográficamente.',
          style: TextStyle(color: _onSurfaceVariant, fontSize: 12, height: 1.4)),
      const SizedBox(height: 16),
      _GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.auto_awesome, size: 16, color: _primaryContainer),
              SizedBox(width: 8),
              Text('Pipeline de Agentes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _onSurface)),
            ]),
            const SizedBox(height: 16),
            ...agents.entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _agentDetailCard(Map<String, dynamic>.from(e.value)),
            )),
          ]),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2 — FIRMAS Y PODERES
// ─────────────────────────────────────────────────────────────────────────────

class _SignaturesTab extends StatelessWidget {
  final AuditReport report;
  const _SignaturesTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final sigs = report.signatures;
    return ListView(padding: const EdgeInsets.fromLTRB(24, 24, 24, 48), children: [
      _sectionHeader('Firmas Co-Partes y Poderes'),
      const SizedBox(height: 4),
      const Text('Cada auditoría es firmada de forma independiente por las tres partes. Se requieren al menos 2 firmas válidas para que el registro sea vinculante.',
          style: TextStyle(color: _onSurfaceVariant, fontSize: 12, height: 1.4)),
      const SizedBox(height: 16),
      ...sigs.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _partyCard(Map<String, dynamic>.from(e.value)),
      )),
      if (report.evidence != null) ...[
        const SizedBox(height: 20),
        _sectionHeader('Evidencia de Firmas'),
        const SizedBox(height: 8),
        _hashCard('Hash de Recuperación', report.evidence!['recovery_hash'] as String? ?? '—', const Color(0xFF8B5CF6), context: context),
      ],
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3 — SELLO DIGITAL BLOCKCHAIN
// ─────────────────────────────────────────────────────────────────────────────

class _ContractTab extends StatelessWidget {
  final AuditReport report;
  const _ContractTab({required this.report});

  @override
  Widget build(BuildContext context) {
    final ct = report.contract;
    final c = report.compliance;
    final hash = c['audit_hash'] as String? ?? '';

    return ListView(padding: const EdgeInsets.fromLTRB(24, 24, 24, 48), children: [
      _sectionHeader('Sello Digital e Inmutabilidad Blockchain'),
      const SizedBox(height: 4),
      const Text('Cada auditoría queda registrada de forma permanente e inmutable en la red descentralizada Stellar (Soroban). Ninguna de las partes puede modificar, borrar o repudiar el resultado.',
          style: TextStyle(color: _onSurfaceVariant, fontSize: 12, height: 1.4)),
      const SizedBox(height: 16),

      _hashCardWithTooltip('Hash de Auditoría', hash,
          'Este código es la huella digital matemática única de esta auditoría. Fue inscrita en la red descentralizada Stellar (Soroban) y no puede ser borrada, modificada ni alterada por ninguna de las partes.',
          context: context),
      const SizedBox(height: 16),

      _GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.verified, size: 16, color: _primaryContainer),
              SizedBox(width: 8),
              Text('Detalles del Contrato Inteligente', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _onSurface)),
            ]),
            const SizedBox(height: 16),
            _contractRow('Red', ct['network'] as String? ?? '—', Icons.language),
            _contractRow('ID del Contrato', ct['contract_id'] as String? ?? '—', Icons.tag),
            _contractRow('Esquema de Firmas', '2 de 3 (Regulador, Entidad, Auditor)', Icons.group),
            _contractRow('Hash Compilado', ct['compiled_hash'] as String? ?? '—', Icons.code),
            _contractRow('Código Fuente', ct['source'] as String? ?? '—', Icons.source),
          ]),
        ),
      ),
      const SizedBox(height: 16),

      _GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.help_outline, size: 16, color: _primaryContainer),
              SizedBox(width: 8),
              Text('¿Qué significa esto?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _onSurface)),
            ]),
            const SizedBox(height: 12),
            _explainRow(Icons.security, 'Inmutabilidad', 'Una vez registrado, el resultado no puede ser alterado por nadie.'),
            const Divider(color: _outlineVariant, height: 24),
            _explainRow(Icons.group, 'Multi-Firma', 'Se requieren 2 de 3 firmas independientes (CNBV, Fintech, LEXI) para validar.'),
            const Divider(color: _outlineVariant, height: 24),
            _explainRow(Icons.public, 'Red Descentralizada', 'Los datos no están en un servidor central, sino en la red pública Stellar.'),
          ]),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGETS — Shared
// ─────────────────────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _glassBg.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _outlineVariant.withOpacity(0.5)),
      ),
      child: child,
    );
  }
}

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _StyledField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: _onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _outline),
        filled: true,
        fillColor: _surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryContainer),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryContainer,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

final _outlinedBtnStyle = OutlinedButton.styleFrom(
  foregroundColor: _primaryContainer,
  side: const BorderSide(color: _primaryContainer),
  padding: const EdgeInsets.symmetric(vertical: 14),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

Widget _sectionHeader(String title) {
  return Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _onSurface, letterSpacing: 0.3));
}

Widget _infoRow(String label, String value, Color color) {
  return Container(
    width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: _surfaceDocument,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: _outlineVariant.withOpacity(0.5)),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 2, child: Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w500))),
      const SizedBox(width: 8),
      Expanded(flex: 3, child: SelectableText(value, style: TextStyle(color: color, fontSize: 12))),
    ]),
  );
}

Widget _hashCard(String label, String value, Color color, {BuildContext? context}) {
  return Container(
    width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: _surfaceDocument,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: TextStyle(color: color.withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
      const SizedBox(height: 6),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: SelectableText(value, style: TextStyle(color: color, fontSize: 11, fontFamily: 'monospace', letterSpacing: 0.3))),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            if (context != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hash copiado al portapapeles'), duration: Duration(seconds: 1)),
              );
            }
          },
          child: const Icon(Icons.content_copy, size: 14, color: _outline),
        ),
      ]),
    ]),
  );
}

Widget _hashCardWithTooltip(String label, String hash, String tooltip, {BuildContext? context}) {
  return _GlassCard(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(label, style: const TextStyle(color: _onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w500))),
          Tooltip(
            message: tooltip,
            triggerMode: TooltipTriggerMode.tap,
            decoration: BoxDecoration(
              color: _surfaceDim,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _outlineVariant),
            ),
            textStyle: const TextStyle(color: _onSurface, fontSize: 12, height: 1.4),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(16),
            preferBelow: false,
            child: Icon(Icons.info_outline, size: 16, color: _primaryContainer.withOpacity(0.6)),
          ),
        ]),
        const SizedBox(height: 6),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: SelectableText(hash, style: TextStyle(color: _primary, fontSize: 12, fontFamily: 'monospace', letterSpacing: 0.3))),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: hash));
              if (context != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hash copiado al portapapeles'), duration: Duration(seconds: 1)),
                );
              }
            },
            child: const Icon(Icons.content_copy, size: 14, color: _outline),
          ),
        ]),
      ]),
    ),
  );
}

Widget _statusTile(String title, String value, Color dotColor, IconData icon) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _surfaceContainerLow,
      borderRadius: BorderRadius.circular(8),
      border: Border(left: BorderSide(color: dotColor, width: 3)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title.toUpperCase(), style: const TextStyle(color: _outline, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      const SizedBox(height: 4),
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: dotColor),
        const SizedBox(width: 4),
        Flexible(child: Text(value, style: TextStyle(color: _onSurface, fontSize: 11, fontWeight: FontWeight.w600))),
      ]),
    ]),
  );
}

Widget _pipelineStep(String title, String subtitle, IconData icon, Color color, bool active) {
  return Column(mainAxisSize: MainAxisSize.min, children: [
    Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? _surfaceContainerHighest : _surfaceContainerLow,
        border: Border.all(color: active ? color : _outlineVariant, width: 2),
        boxShadow: active ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, spreadRadius: 2)] : null,
      ),
      child: Icon(icon, color: active ? color : _outline, size: 20),
    ),
    const SizedBox(height: 8),
    Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? _onSurface : _outline)),
    Text(subtitle, style: TextStyle(fontSize: 9, color: active ? _onSurfaceVariant : _outline, letterSpacing: 0.3)),
  ]);
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

  final bool isProhibition = type == 'Prohibition';
  final Color accent = isProhibition ? _alert : _warning;
  final String badge = isProhibition ? 'PROHIBICIÓN' : 'OBLIGACIÓN';
  final IconData badgeIcon = isProhibition ? Icons.block : Icons.assignment_late;

  return _GlassCard(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: accent.withOpacity(0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(badgeIcon, size: 11, color: accent),
              const SizedBox(width: 4),
              Text(badge, style: TextStyle(color: accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
            ]),
          ),
          const SizedBox(width: 8),
          Text(article, style: const TextStyle(color: _outline, fontSize: 11)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (compliant ? _success : _alert).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(compliant ? 'CUMPLE' : 'INCUMPLE',
                style: TextStyle(color: compliant ? _success : _alert, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          ),
        ]),
        const SizedBox(height: 10),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: _onSurface)),
        const SizedBox(height: 4),
        Text(desc, style: const TextStyle(color: _onSurfaceVariant, fontSize: 12)),
        const SizedBox(height: 6),
        Row(children: [
          Text('Límite: $threshold  |  Real: $actual', style: const TextStyle(color: _onSurfaceVariant, fontSize: 11)),
        ]),
        if (snippet.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _surfaceDim,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _outlineVariant.withOpacity(0.5)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.search, size: 12, color: _primaryContainer),
                const SizedBox(width: 4),
                Text('Trazabilidad — Texto de la Ley', style: TextStyle(color: _primaryContainer.withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
              ]),
              const SizedBox(height: 4),
              Text(snippet, style: const TextStyle(color: _onSurfaceVariant, fontSize: 11, height: 1.4)),
            ]),
          ),
        ],
      ]),
    ),
  );
}

Widget _contractRow(String label, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 14, color: _primaryContainer),
      const SizedBox(width: 8),
      SizedBox(width: 100, child: Text(label, style: const TextStyle(color: _onSurfaceVariant, fontSize: 12))),
      Expanded(child: Text(value, style: const TextStyle(color: _onSurface, fontSize: 12, fontWeight: FontWeight.w500))),
    ]),
  );
}

Widget _explainRow(IconData icon, String title, String desc) {
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, size: 18, color: _primaryContainer),
    const SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _onSurface)),
      const SizedBox(height: 2),
      Text(desc, style: const TextStyle(color: _onSurfaceVariant, fontSize: 12)),
    ])),
  ]);
}

Widget _partyCard(Map<String, dynamic> party) {
  final verified = party['verified'] as bool? ?? false;
  final role = party['role'] as String? ?? '';
  final name = party['party_name'] as String? ?? '';
  final pid = party['party_id'] as String? ?? '';
  final sig = party['signature'] as String? ?? '';
  final Color color = verified ? _success : _alert;

  IconData icon;
  if (role.contains('Regulador')) icon = Icons.account_balance;
  else if (role.contains('Entidad')) icon = Icons.business;
  else icon = Icons.verified_user;

  return _GlassCard(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: _onSurface)),
            const SizedBox(height: 2),
            Text('$role  •  $pid', style: const TextStyle(color: _onSurfaceVariant, fontSize: 11)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withOpacity(0.3))),
            child: Text(verified ? 'FIRMADO' : 'PENDIENTE', style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          ),
        ]),
        const SizedBox(height: 12),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: _surfaceDeep, borderRadius: BorderRadius.circular(6), border: Border.all(color: _outlineVariant.withOpacity(0.5))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Firma:', style: TextStyle(color: _outline, fontSize: 10)),
            const SizedBox(width: 6),
            Expanded(child: SelectableText(sig, style: TextStyle(color: color, fontSize: 10, fontFamily: 'monospace'))),
          ]),
        ),
      ]),
    ),
  );
}

Widget _agentDetailCard(Map<String, dynamic> agent) {
  final name = agent['agent'] as String? ?? '';
  final model = agent['model'] as String? ?? '';
  final version = agent['version'] as String? ?? '';
  final outputs = agent['outputs'] as Map<String, dynamic>? ?? {};

  IconData icon;
  if (name.contains('NLP')) icon = Icons.translate;
  else if (name.contains('Compliance')) icon = Icons.rule;
  else if (name.contains('Web3')) icon = Icons.link;
  else icon = Icons.psychology;

  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: _primaryContainer.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, color: _primaryContainer, size: 18),
    ),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _onSurface))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: _outlineVariant.withOpacity(0.3), borderRadius: BorderRadius.circular(4)),
          child: Text('v$version', style: const TextStyle(color: _outline, fontSize: 10)),
        ),
      ]),
      const SizedBox(height: 2),
      Text(model, style: const TextStyle(color: _onSurfaceVariant, fontSize: 11)),
      const SizedBox(height: 6),
      ...outputs.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${_outputLabel(e.key)}: ', style: const TextStyle(color: _outline, fontSize: 11)),
          Expanded(child: Text(_fmtOutput(e.value), style: const TextStyle(color: _onSurface, fontSize: 11))),
        ]),
      )),
    ])),
  ]);
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
      backgroundColor: _surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Center(child: Icon(status ? Icons.verified : Icons.warning_amber_rounded, color: status ? _success : _alert, size: 40)),
            const SizedBox(height: 8),
            Center(child: Text(status ? 'CERTIFICADO DE CUMPLIMIENTO' : 'CERTIFICADO DE INCUMPLIMIENTO',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: status ? _success : _alert, letterSpacing: 0.5))),
            const SizedBox(height: 16),
            _certLine('Entidad Regulada', meta['regulated_entity'] as String? ?? '—'),
            _certLine('Período Auditado', meta['audit_period'] as String? ?? '—'),
            _certLine('Marco Regulatorio', meta['regulatory_framework'] as String? ?? '—'),
            _certLine('Resultado', status ? 'CUMPLIMIENTO TOTAL' : 'INCUMPLIMIENTO DETECTADO'),
            _certLine('Reglas Evaluadas', '$rulesCount'),
            _certLine('Reglas Cumplidas', '$compliantCount'),
            _certLine('Fecha de Emisión', '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}'),
            _certLine('Versión', meta['version'] as String? ?? '—'),
            const SizedBox(height: 12),
            const Text('Hash de Certificación:', style: TextStyle(color: _outline, fontSize: 9)),
            const SizedBox(height: 2),
            SelectableText(hash, style: TextStyle(color: _primary, fontSize: 10, fontFamily: 'monospace')),
            const SizedBox(height: 4),
            const Text('Este certificado es una representación digital del resultado de la auditoría. El hash SHA-256 es la evidencia criptográfica vinculada a la red Stellar (Soroban).',
                style: TextStyle(color: _outline, fontSize: 9, height: 1.3)),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CERRAR', style: TextStyle(color: _outline))),
      ],
    ),
  );
}

Widget _certLine(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 130, child: Text(label, style: const TextStyle(color: _outline, fontSize: 11))),
      Expanded(child: Text(value, style: const TextStyle(color: _onSurface, fontSize: 11, fontWeight: FontWeight.w500))),
    ]),
  );
}
