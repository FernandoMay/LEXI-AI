import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// ── Design System Colors (Dark Palette) ──────────────────────────────────────
const _darkSurfaceDim = Color(0xFF031427);
const _darkSurfaceContainer = Color(0xFF102034);
const _darkSurfaceContainerLow = Color(0xFF0B1C30);
const _darkSurfaceContainerHigh = Color(0xFF1B2B3F);
const _darkSurfaceContainerHighest = Color(0xFF26364A);
const _darkSurfaceBright = Color(0xFF2A3A4F);
const _darkSurfaceDeep = Color(0xFF0B0B13);
const _darkSurfaceDocument = Color(0xFF262B3C);
const _darkGlassBg = Color(0xFF1E222F);
const _darkOnSurface = Color(0xFFD3E4FE);
const _darkOnSurfaceVariant = Color(0xFFC3C6D7);
const _darkPrimary = Color(0xFFB4C5FF);
const _darkPrimaryContainer = Color(0xFF2563EB);
const _darkOutline = Color(0xFF8D90A0);
const _darkOutlineVariant = Color(0xFF434655);
const _darkSuccess = Color(0xFF10B981);
const _darkWarning = Color(0xFFF59E0B);
const _darkAlert = Color(0xFFEF4444);

// ── Design System Colors (Light Palette) ─────────────────────────────────────
const _lightSurfaceDim = Color(0xFFF5F7FA);
const _lightSurfaceContainer = Color(0xFFF0F2F5);
const _lightSurfaceContainerLow = Color(0xFFFFFFFF);
const _lightSurfaceContainerHigh = Color(0xFFE8ECF0);
const _lightSurfaceContainerHighest = Color(0xFFE0E5EA);
const _lightSurfaceBright = Color(0xFFFFFFFF);
const _lightSurfaceDeep = Color(0xFFEAEEF2);
const _lightSurfaceDocument = Color(0xFFF0F4FF);
const _lightGlassBg = Color(0xFFFFFFFF);
const _lightOnSurface = Color(0xFF1A2332);
const _lightOnSurfaceVariant = Color(0xFF5A6B7F);
const _lightPrimary = Color(0xFF2563EB);
const _lightPrimaryContainer = Color(0xFF2563EB);
const _lightOutline = Color(0xFF96A5B8);
const _lightOutlineVariant = Color(0xFFD0D5DD);
const _lightSuccess = Color(0xFF10B981);
const _lightWarning = Color(0xFFF59E0B);
const _lightAlert = Color(0xFFEF4444);

// ── Theme InheritedWidget ─────────────────────────────────────────────────────
class LexiTheme extends InheritedWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const LexiTheme({
    super.key,
    required this.isDark,
    required this.onToggle,
    required super.child,
  });

  static LexiTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LexiTheme>()!;
  }

  @override
  bool updateShouldNotify(LexiTheme old) => old.isDark != isDark;

  // Color accessors
  Color get surfaceDim => isDark ? _darkSurfaceDim : _lightSurfaceDim;
  Color get surfaceContainer => isDark ? _darkSurfaceContainer : _lightSurfaceContainer;
  Color get surfaceContainerLow => isDark ? _darkSurfaceContainerLow : _lightSurfaceContainerLow;
  Color get surfaceContainerHigh => isDark ? _darkSurfaceContainerHigh : _lightSurfaceContainerHigh;
  Color get surfaceContainerHighest => isDark ? _darkSurfaceContainerHighest : _lightSurfaceContainerHighest;
  Color get surfaceBright => isDark ? _darkSurfaceBright : _lightSurfaceBright;
  Color get surfaceDeep => isDark ? _darkSurfaceDeep : _lightSurfaceDeep;
  Color get surfaceDocument => isDark ? _darkSurfaceDocument : _lightSurfaceDocument;
  Color get glassBg => isDark ? _darkGlassBg : _lightGlassBg;
  Color get onSurface => isDark ? _darkOnSurface : _lightOnSurface;
  Color get onSurfaceVariant => isDark ? _darkOnSurfaceVariant : _lightOnSurfaceVariant;
  Color get primary => isDark ? _darkPrimary : _lightPrimary;
  Color get primaryContainer => isDark ? _darkPrimaryContainer : _lightPrimaryContainer;
  Color get outline => isDark ? _darkOutline : _lightOutline;
  Color get outlineVariant => isDark ? _darkOutlineVariant : _lightOutlineVariant;
  Color get success => isDark ? _darkSuccess : _lightSuccess;
  Color get warning => isDark ? _darkWarning : _lightWarning;
  Color get alert => isDark ? _darkAlert : _lightAlert;
}

// ── App Entry ─────────────────────────────────────────────────────────────────
void main() => runApp(const LexiAiApp());

class LexiAiApp extends StatefulWidget {
  const LexiAiApp({super.key});
  @override
  State<LexiAiApp> createState() => _LexiAiAppState();
}

class _LexiAiAppState extends State<LexiAiApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LEXI AI',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: _lightSurfaceDim,
        colorScheme: const ColorScheme.light(
          primary: _lightPrimary,
          secondary: _lightOnSurfaceVariant,
          surface: _lightSurfaceContainer,
          error: _lightAlert,
        ),
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          backgroundColor: _lightSurfaceContainerHigh,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: _lightOnSurface, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3),
          iconTheme: IconThemeData(color: _lightOnSurfaceVariant),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: _lightSurfaceDim,
          selectedItemColor: _lightPrimary,
          unselectedItemColor: _lightOutline,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _darkSurfaceDim,
        colorScheme: const ColorScheme.dark(
          primary: _darkPrimary,
          secondary: _darkOnSurfaceVariant,
          surface: _darkSurfaceContainer,
          error: _darkAlert,
        ),
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          backgroundColor: _darkSurfaceContainerHigh,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: _darkOnSurface, fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3),
          iconTheme: IconThemeData(color: _darkOnSurfaceVariant),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: _darkSurfaceDim,
          selectedItemColor: _darkPrimary,
          unselectedItemColor: _darkOutline,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11),
        ),
      ),
      home: LexiTheme(
        isDark: _themeMode != ThemeMode.light,
        onToggle: _toggleTheme,
        child: const LexiHome(),
      ),
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

// ── Backend Service ──────────────────────────────────────────────────────────

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _executePipeline());
  }

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
    final theme = LexiTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LexiLogo(size: 32),
            const SizedBox(width: 10),
            Flexible(child: Text('LEXI AI  •  LexGuardian Compliance', overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode, color: theme.onSurfaceVariant),
            onPressed: theme.onToggle,
            tooltip: theme.isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
          ),
          if (_useBackend)
            Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: theme.success.withOpacity(0.3)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: theme.success, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text('EN VIVO', style: TextStyle(color: theme.success, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ]),
            ),
          _processing
              ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2, color: _darkPrimary))
              : IconButton(
                  icon: const Icon(Icons.play_circle_outline, color: _darkPrimaryContainer),
                  onPressed: _executePipeline,
                  tooltip: 'Ejecutar Auditoría',
                ),
          PopupMenuButton<String>(
            icon: Icon(Icons.settings, color: theme.outline),
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
      body: _showNgrokInput ? _buildNgrokPanel(theme)
          : _processing ? const Center(child: CircularProgressIndicator(color: _darkPrimaryContainer))
          : _report == null ? _buildEmptyState(theme) : _buildTabContent(theme),
      bottomNavigationBar: _report == null || _showNgrokInput ? null
          : BottomNavigationBar(
              currentIndex: _tabIndex,
              onTap: (i) => setState(() => _tabIndex = i),
              items: List.generate(4, (i) => BottomNavigationBarItem(icon: Icon(_tabIcons[i]), label: _tabs[i])),
            ),
    );
  }

  Widget _buildNgrokPanel(LexiTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _GlassCard(child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(children: [
              Icon(Icons.wifi_tethering, size: 48, color: theme.primaryContainer),
              const SizedBox(height: 16),
              Text('Conexión por Túnel Seguro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: theme.onSurface)),
              const SizedBox(height: 8),
              Text('Ingresa la URL HTTPS de ngrok para conectar\ncon el servidor de auditoría en vivo.', textAlign: TextAlign.center, style: TextStyle(color: theme.onSurfaceVariant, height: 1.4)),
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

  Widget _buildEmptyState(LexiTheme theme) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const LexiLogo(size: 80),
        const SizedBox(height: 20),
        Text('LEXI AI — LexGuardian Compliance', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: theme.onSurface, letterSpacing: 0.3)),
        const SizedBox(height: 8),
        Text('Red de Cumplimiento Inteligente y Contratos Legales\nAuditoría Asistida por IA  •  Blockchain Soroban',
            textAlign: TextAlign.center, style: TextStyle(color: theme.onSurfaceVariant, height: 1.4, fontSize: 14)),
        const SizedBox(height: 28),
        _PrimaryButton(label: 'INICIAR AUDITORÍA', icon: Icons.play_arrow, onPressed: _executePipeline),
      ]),
    );
  }

  Widget _buildTabContent(LexiTheme theme) {
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
    final theme = LexiTheme.of(context);
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
        LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          if (isWide) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 7, child: _commandCenterCard(context, theme, c, meta, status)),
              const SizedBox(width: 20),
              Expanded(flex: 5, child: _complianceCard(theme, context, report)),
            ]);
          }
          return Column(children: [
            _commandCenterCard(context, theme, c, meta, status),
            const SizedBox(height: 16),
            _complianceCard(theme, context, report),
          ]);
        }),
        const SizedBox(height: 24),

        _sectionHeader(context, 'Pipeline de Procesamiento'),
        const SizedBox(height: 8),
        _GlassCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            child: LayoutBuilder(builder: (ctx, constraints) {
              if (constraints.maxWidth > 500) {
                return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _pipelineStep(context, 'IA (NLP)', 'Extracción', Icons.psychology, theme.primary, true),
                  _pipelineStep(context, 'Compliance', 'Validación', Icons.balance, theme.warning, true),
                  _pipelineStep(context, 'Blockchain', 'Inmutabilidad', Icons.verified, theme.success, true),
                  _pipelineStep(context, 'Resguardo', 'Archivado', Icons.inventory_2, theme.outline, false),
                ]);
              }
              return Wrap(spacing: 16, runSpacing: 16, alignment: WrapAlignment.center, children: [
                _pipelineStep(context, 'IA (NLP)', 'Extracción', Icons.psychology, theme.primary, true),
                _pipelineStep(context, 'Compliance', 'Validación', Icons.balance, theme.warning, true),
                _pipelineStep(context, 'Blockchain', 'Inmutabilidad', Icons.verified, theme.success, true),
                _pipelineStep(context, 'Resguardo', 'Archivado', Icons.inventory_2, theme.outline, false),
              ]);
            }),
          ),
        ),
        const SizedBox(height: 24),

        _sectionHeader(context, 'Dictamen de Cumplimiento'),
        const SizedBox(height: 8),
        _GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (status ? theme.success : theme.alert).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(status ? Icons.verified : Icons.warning_amber_rounded, size: 28, color: status ? theme.success : theme.alert),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(status ? 'CUMPLIMIENTO TOTAL' : 'INCUMPLIMIENTO DETECTADO',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: status ? theme.success : theme.alert, letterSpacing: 0.3)),
                const SizedBox(height: 4),
                Text('$rulesCount reglas evaluadas  •  $compliantCount cumplidas  •  ${violations.length} violaciones',
                    style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12)),
              ])),
            ]),
          ),
        ),
        const SizedBox(height: 24),

        _sectionHeader(context, 'Semáforo Legal — Reglas Evaluadas'),
        const SizedBox(height: 8),
        if (rules.isEmpty)
          _GlassCard(child: Padding(padding: const EdgeInsets.all(16), child: Text('No se evaluaron reglas.', style: TextStyle(color: theme.onSurfaceVariant))))
        else
          ...rules.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ruleCard(context, r),
          )),
        const SizedBox(height: 24),

        _sectionHeader(context, 'Contexto de la Operación'),
        const SizedBox(height: 8),
        ...ctx.entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _infoRow(context, _ctxLabel(e.key), '${e.value}', theme.outline),
        )),
        const SizedBox(height: 20),

        _sectionHeader(context, 'Cadena de Auditoría'),
        const SizedBox(height: 8),
        _hashCard('Hash de Auditoría SHA-256', hash, theme.primary, context: context),
        const SizedBox(height: 6),
        _hashCard('Hash del Árbol Sintáctico (AST)', ast, theme.primaryContainer, context: context),
        const SizedBox(height: 6),
        _infoRow(context, 'Reglas Evaluadas', '$rulesCount', theme.outline),
        const SizedBox(height: 6),
        _infoRow(context, 'Marco Regulatorio', meta['regulatory_framework'] as String? ?? '—', theme.outline),
        const SizedBox(height: 6),
        _infoRow(context, 'Fuente', useBackend ? 'Servidor en Vivo' : 'Simulación Local', useBackend ? theme.success : theme.warning),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onRerun,
            icon: const Icon(Icons.refresh),
            label: const Text('RE-EJECUTAR AUDITORÍA'),
            style: _outlinedBtnStyle(context),
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

  Widget _commandCenterCard(BuildContext context, LexiTheme theme, Map<String, dynamic> c, Map<String, dynamic> meta, bool status) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: theme.primaryContainer.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.dashboard, size: 20, color: _darkPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Command Center', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: theme.onSurface)),
              Text('${meta['regulated_entity'] ?? '—'}  |  ${meta['audit_period'] ?? '—'}', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12), overflow: TextOverflow.ellipsis),
            ])),
          ]),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (ctx, constraints) {
            final tileWidth = (constraints.maxWidth - 16) / 3;
            return Row(children: [
              SizedBox(width: tileWidth, child: _statusTile(context, 'Motor NLP', 'Activo (v4.1)', theme.success, Icons.auto_awesome)),
              const SizedBox(width: 8),
              SizedBox(width: tileWidth, child: _statusTile(context, 'Soroban Sync', 'Sincronizado', theme.primary, Icons.sync)),
              const SizedBox(width: 8),
              SizedBox(width: tileWidth, child: _statusTile(context, 'Inmutabilidad', '99.9%', theme.warning, Icons.verified_user)),
            ]);
          }),
        ]),
      ),
    );
  }

  Widget _complianceCard(LexiTheme theme, BuildContext context, AuditReport report) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cumplimiento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: theme.onSurface)),
          const SizedBox(height: 4),
          Text('Valide la integridad de todos los expedientes procesados en el ciclo actual.',
              style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12)),
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
    );
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
    final theme = LexiTheme.of(context);
    final agents = report.agents;
    return ListView(padding: const EdgeInsets.fromLTRB(24, 24, 24, 48), children: [
      _sectionHeader(context, 'Análisis de Inteligencia Artificial (NLP)'),
      const SizedBox(height: 4),
      Text('Tres agentes de IA trabajan en cadena para analizar la ley, evaluar el cumplimiento y registrar el resultado en la blockchain. Cada paso está trazado criptográficamente.',
          style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12, height: 1.4)),
      const SizedBox(height: 16),
      _GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.auto_awesome, size: 16, color: _darkPrimaryContainer),
              const SizedBox(width: 8),
              Text('Pipeline de Agentes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.onSurface)),
            ]),
            const SizedBox(height: 16),
            ...agents.entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _agentDetailCard(context, Map<String, dynamic>.from(e.value)),
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
    final theme = LexiTheme.of(context);
    final sigs = report.signatures;
    return ListView(padding: const EdgeInsets.fromLTRB(24, 24, 24, 48), children: [
      _sectionHeader(context, 'Firmas Co-Partes y Poderes'),
      const SizedBox(height: 4),
      Text('Cada auditoría es firmada de forma independiente por las tres partes. Se requieren al menos 2 firmas válidas para que el registro sea vinculante.',
          style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12, height: 1.4)),
      const SizedBox(height: 16),
      ...sigs.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _partyCard(context, Map<String, dynamic>.from(e.value)),
      )),
      if (report.evidence != null) ...[
        const SizedBox(height: 20),
        _sectionHeader(context, 'Evidencia de Firmas'),
        const SizedBox(height: 8),
        _hashCard('Hash de Recuperación', report.evidence!['recovery_hash'] as String? ?? '—', theme.primaryContainer, context: context),
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
    final theme = LexiTheme.of(context);
    final ct = report.contract;
    final c = report.compliance;
    final hash = c['audit_hash'] as String? ?? '';

    return ListView(padding: const EdgeInsets.fromLTRB(24, 24, 24, 48), children: [
      _sectionHeader(context, 'Sello Digital e Inmutabilidad Blockchain'),
      const SizedBox(height: 4),
      Text('Cada auditoría queda registrada de forma permanente e inmutable en la red descentralizada Stellar (Soroban). Ninguna de las partes puede modificar, borrar o repudiar el resultado.',
          style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12, height: 1.4)),
      const SizedBox(height: 16),

      _hashCardWithTooltip('Hash de Auditoría', hash,
          'Este código es la huella digital matemática única de esta auditoría. Fue inscrita en la red descentralizada Stellar (Soroban) y no puede ser borrada, modificada ni alterada por ninguna de las partes.',
          context: context),
      const SizedBox(height: 16),

      _GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.verified, size: 16, color: _darkPrimaryContainer),
              const SizedBox(width: 8),
              Text('Detalles del Contrato Inteligente', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.onSurface)),
            ]),
            const SizedBox(height: 16),
            _contractRow(context, 'Red', ct['network'] as String? ?? '—', Icons.language),
            _contractRow(context, 'ID del Contrato', ct['contract_id'] as String? ?? '—', Icons.tag),
            _contractRow(context, 'Esquema de Firmas', '2 de 3 (Regulador, Entidad, Auditor)', Icons.group),
            _contractRow(context, 'Hash Compilado', ct['compiled_hash'] as String? ?? '—', Icons.code),
            _contractRow(context, 'Código Fuente', ct['source'] as String? ?? '—', Icons.source),
          ]),
        ),
      ),
      const SizedBox(height: 16),

      _GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.help_outline, size: 16, color: _darkPrimaryContainer),
              const SizedBox(width: 8),
              Text('¿Qué significa esto?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.onSurface)),
            ]),
            const SizedBox(height: 12),
            _explainRow(context, Icons.security, 'Inmutabilidad', 'Una vez registrado, el resultado no puede ser alterado por nadie.'),
            Divider(color: theme.outlineVariant.withOpacity(0.8), height: 24),
            _explainRow(context, Icons.group, 'Multi-Firma', 'Se requieren 2 de 3 firmas independientes (CNBV, Fintech, LEXI) para validar.'),
            Divider(color: theme.outlineVariant.withOpacity(0.8), height: 24),
            _explainRow(context, Icons.public, 'Red Descentralizada', 'Los datos no están en un servidor central, sino en la red pública Stellar.'),
          ]),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGETS — Shared
// ─────────────────────────────────────────────────────────────────────────────

class LexiLogo extends StatelessWidget {
  final double size;
  const LexiLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size, child: CustomPaint(painter: _LexiLogoPainter()));
  }
}

class _LexiLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;
    canvas.scale(s, s);

    final shieldFill = Paint()..color = const Color(0xFF102034);
    final shieldStroke = Paint()
      ..color = const Color(0xFF262B3C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final lShader = const LinearGradient(
      begin: Alignment.bottomLeft, end: Alignment.topRight,
      colors: [Color(0xFF2563EB), Color(0xFF6C5CE7), Color(0xFF10B981)],
    ).createShader(const Rect.fromLTWH(0, 0, 200, 200));

    final lPaintLeft = Paint()..shader = lShader;
    final lPaintRight = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomLeft, end: Alignment.topRight,
        colors: [Color(0xE62563EB), Color(0xE66C5CE7), Color(0xE610B981)],
      ).createShader(const Rect.fromLTWH(0, 0, 200, 200));

    final topFacePaint = Paint()..color = const Color(0xFFB4C5FF).withOpacity(0.3);

    final shadowPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0x00031427), Color(0x99031427)],
      ).createShader(const Rect.fromLTWH(0, 0, 200, 200));

    final oracleFill = Paint()..color = const Color(0xFF031427);
    final oracleStroke = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final oracleCoreFill = Paint()..color = const Color(0xFF10B981);

    // Hexagon shield
    final hex = Path();
    hex.moveTo(100, 25);
    hex.lineTo(165, 62.5);
    hex.lineTo(165, 137.5);
    hex.lineTo(100, 175);
    hex.lineTo(35, 137.5);
    hex.lineTo(35, 62.5);
    hex.close();
    canvas.drawShadow(hex, const Color(0xFF031427), 12, false);
    canvas.drawPath(hex, shieldFill);
    canvas.drawPath(hex, shieldStroke);

    // L front-left
    final lLeft = Path();
    lLeft.moveTo(65, 62.5);
    lLeft.lineTo(100, 82.5);
    lLeft.lineTo(100, 142.5);
    lLeft.lineTo(65, 122.5);
    lLeft.close();
    canvas.drawPath(lLeft, lPaintLeft);

    // L front-right
    final lRight = Path();
    lRight.moveTo(100, 142.5);
    lRight.lineTo(135, 122.5);
    lRight.lineTo(135, 102.5);
    lRight.lineTo(100, 122.5);
    lRight.close();
    canvas.drawPath(lRight, lPaintRight);

    // Top face
    final top = Path();
    top.moveTo(100, 42.5);
    top.lineTo(135, 62.5);
    top.lineTo(100, 82.5);
    top.lineTo(65, 62.5);
    top.close();
    canvas.drawPath(top, topFacePaint);

    // Shadow mask
    final mask = Path();
    mask.moveTo(100, 82.5);
    mask.lineTo(135, 102.5);
    mask.lineTo(100, 122.5);
    mask.lineTo(65, 102.5);
    mask.close();
    canvas.drawPath(mask, shadowPaint);

    // Oracle diamond (translated +15, -5)
    canvas.save();
    canvas.translate(15, -5);
    final oracle = Path();
    oracle.moveTo(120, 80);
    oracle.lineTo(135, 95);
    oracle.lineTo(120, 110);
    oracle.lineTo(105, 95);
    oracle.close();
    canvas.drawPath(oracle, oracleFill);
    canvas.drawPath(oracle, oracleStroke);

    final core = Path();
    core.moveTo(120, 86);
    core.lineTo(129, 95);
    core.lineTo(120, 104);
    core.lineTo(111, 95);
    core.close();
    canvas.drawPath(core, oracleCoreFill);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = LexiTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.glassBg.withOpacity(theme.isDark ? 0.85 : 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.outlineVariant.withOpacity(theme.isDark ? 0.5 : 0.3)),
        boxShadow: theme.isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
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
    final theme = LexiTheme.of(context);
    return TextField(
      controller: controller,
      style: TextStyle(color: theme.onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: theme.outline),
        filled: true,
        fillColor: theme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkPrimaryContainer),
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
        backgroundColor: _darkPrimaryContainer,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

ButtonStyle _outlinedBtnStyle(BuildContext context) {
  final theme = LexiTheme.of(context);
  return OutlinedButton.styleFrom(
    foregroundColor: theme.primaryContainer,
    side: BorderSide(color: theme.primaryContainer),
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

Widget _sectionHeader(BuildContext context, String title) {
  final theme = LexiTheme.of(context);
  return Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.onSurface, letterSpacing: 0.3));
}

Widget _infoRow(BuildContext context, String label, String value, Color color) {
  final theme = LexiTheme.of(context);
  return Container(
    width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: theme.surfaceDocument,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: theme.outlineVariant.withOpacity(0.5)),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 2, child: Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w500))),
      const SizedBox(width: 8),
      Expanded(flex: 3, child: SelectableText(value, style: TextStyle(color: color, fontSize: 12))),
    ]),
  );
}

Widget _hashCard(String label, String value, Color color, {BuildContext? context}) {
  final theme = context != null ? LexiTheme.of(context) : null;
  return Container(
    width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: theme?.surfaceDocument ?? _darkSurfaceDocument,
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
          child: const Icon(Icons.content_copy, size: 14, color: _darkOutline),
        ),
      ]),
    ]),
  );
}

Widget _hashCardWithTooltip(String label, String hash, String tooltip, {BuildContext? context}) {
  final theme = context != null ? LexiTheme.of(context) : null;
  final onSurf = theme?.onSurface ?? _darkOnSurface;
  final surfVariant = theme?.onSurfaceVariant ?? _darkOnSurfaceVariant;
  final primContainer = theme?.primaryContainer ?? _darkPrimaryContainer;
  final prim = theme?.primary ?? _darkPrimary;
  final outline = theme?.outline ?? _darkOutline;
  final surfDim = theme?.surfaceDim ?? _darkSurfaceDim;
  final outlineVar = theme?.outlineVariant ?? _darkOutlineVariant;
  return _GlassCard(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(label, style: TextStyle(color: surfVariant, fontSize: 11, fontWeight: FontWeight.w500))),
          Tooltip(
            message: tooltip,
            triggerMode: TooltipTriggerMode.tap,
            decoration: BoxDecoration(
              color: surfDim,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: outlineVar),
            ),
            textStyle: TextStyle(color: onSurf, fontSize: 12, height: 1.4),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(16),
            preferBelow: false,
            child: Icon(Icons.info_outline, size: 16, color: primContainer.withOpacity(0.6)),
          ),
        ]),
        const SizedBox(height: 6),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: SelectableText(hash, style: TextStyle(color: prim, fontSize: 12, fontFamily: 'monospace', letterSpacing: 0.3))),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: hash));
              if (context != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hash copiado al portapapeles'), duration: Duration(seconds: 1)),
                );
              }
            },
            child: Icon(Icons.content_copy, size: 14, color: outline),
          ),
        ]),
      ]),
    ),
  );
}

Widget _statusTile(BuildContext context, String title, String value, Color dotColor, IconData icon) {
  final theme = LexiTheme.of(context);
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: theme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8),
      border: Border(left: BorderSide(color: dotColor, width: 3)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title.toUpperCase(), style: TextStyle(color: theme.outline, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      const SizedBox(height: 4),
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: dotColor),
        const SizedBox(width: 4),
        Flexible(child: Text(value, style: TextStyle(color: theme.onSurface, fontSize: 11, fontWeight: FontWeight.w600))),
      ]),
    ]),
  );
}

Widget _pipelineStep(BuildContext context, String title, String subtitle, IconData icon, Color color, bool active) {
  final theme = LexiTheme.of(context);
  return Column(mainAxisSize: MainAxisSize.min, children: [
    Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? theme.surfaceContainerHighest : theme.surfaceContainerLow,
        border: Border.all(color: active ? color : theme.outlineVariant, width: 2),
        boxShadow: active ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, spreadRadius: 2)] : null,
      ),
      child: Icon(icon, color: active ? color : theme.outline, size: 20),
    ),
    const SizedBox(height: 8),
    Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? theme.onSurface : theme.outline)),
    Text(subtitle, style: TextStyle(fontSize: 9, color: active ? theme.onSurfaceVariant : theme.outline, letterSpacing: 0.3)),
  ]);
}

Widget _ruleCard(BuildContext context, Map<String, dynamic> rule) {
  final theme = LexiTheme.of(context);
  final compliant = rule['compliant'] as bool? ?? false;
  final type = rule['type'] as String? ?? '';
  final article = rule['article'] as String? ?? '';
  final text = rule['text'] as String? ?? '';
  final desc = rule['description'] as String? ?? '';
  final threshold = rule['threshold_value'];
  final actual = rule['actual_value'];
  final snippet = rule['law_snippet'] as String? ?? '';

  final bool isProhibition = type == 'Prohibition';
  final Color accent = isProhibition ? theme.alert : theme.warning;
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
          Text(article, style: TextStyle(color: theme.outline, fontSize: 11)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (compliant ? theme.success : theme.alert).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(compliant ? 'CUMPLE' : 'INCUMPLE',
                style: TextStyle(color: compliant ? theme.success : theme.alert, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          ),
        ]),
        const SizedBox(height: 10),
        Text(text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: theme.onSurface)),
        const SizedBox(height: 4),
        Text(desc, style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12)),
        const SizedBox(height: 6),
        Row(children: [
          Text('Límite: $threshold  |  Real: $actual', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 11)),
        ]),
        if (snippet.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.surfaceDim,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: theme.outlineVariant.withOpacity(0.5)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.search, size: 12, color: _darkPrimaryContainer),
                const SizedBox(width: 4),
                Text('Trazabilidad — Texto de la Ley', style: TextStyle(color: theme.primaryContainer.withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
              ]),
              const SizedBox(height: 4),
              Text(snippet, style: TextStyle(color: theme.onSurfaceVariant, fontSize: 11, height: 1.4)),
            ]),
          ),
        ],
      ]),
    ),
  );
}

Widget _contractRow(BuildContext context, String label, String value, IconData icon) {
  final theme = LexiTheme.of(context);
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 14, color: theme.primaryContainer),
      const SizedBox(width: 8),
      SizedBox(width: 100, child: Text(label, style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12))),
      Expanded(child: Text(value, style: TextStyle(color: theme.onSurface, fontSize: 12, fontWeight: FontWeight.w500))),
    ]),
  );
}

Widget _explainRow(BuildContext context, IconData icon, String title, String desc) {
  final theme = LexiTheme.of(context);
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, size: 18, color: theme.primaryContainer),
    const SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: theme.onSurface)),
      const SizedBox(height: 2),
      Text(desc, style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12)),
    ])),
  ]);
}

Widget _partyCard(BuildContext context, Map<String, dynamic> party) {
  final theme = LexiTheme.of(context);
  final verified = party['verified'] as bool? ?? false;
  final role = party['role'] as String? ?? '';
  final name = party['party_name'] as String? ?? '';
  final pid = party['party_id'] as String? ?? '';
  final sig = party['signature'] as String? ?? '';
  final Color color = verified ? theme.success : theme.alert;

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
            Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: theme.onSurface)),
            const SizedBox(height: 2),
            Text('$role  •  $pid', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 11)),
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
          decoration: BoxDecoration(color: theme.surfaceDeep, borderRadius: BorderRadius.circular(6), border: Border.all(color: theme.outlineVariant.withOpacity(0.5))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Firma:', style: TextStyle(color: theme.outline, fontSize: 10)),
            const SizedBox(width: 6),
            Expanded(child: SelectableText(sig, style: TextStyle(color: color, fontSize: 10, fontFamily: 'monospace'))),
          ]),
        ),
      ]),
    ),
  );
}

Widget _agentDetailCard(BuildContext context, Map<String, dynamic> agent) {
  final theme = LexiTheme.of(context);
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
      decoration: BoxDecoration(color: theme.primaryContainer.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, color: theme.primaryContainer, size: 18),
    ),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: theme.onSurface))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: theme.outlineVariant.withOpacity(0.3), borderRadius: BorderRadius.circular(4)),
          child: Text('v$version', style: TextStyle(color: theme.outline, fontSize: 10)),
        ),
      ]),
      const SizedBox(height: 2),
      Text(model, style: TextStyle(color: theme.onSurfaceVariant, fontSize: 11)),
      const SizedBox(height: 6),
      ...outputs.entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${_outputLabel(e.key)}: ', style: TextStyle(color: theme.outline, fontSize: 11)),
          Expanded(child: Text(_fmtOutput(e.value), style: TextStyle(color: theme.onSurface, fontSize: 11))),
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
  final theme = LexiTheme.of(context);
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
      backgroundColor: theme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Center(child: Icon(status ? Icons.verified : Icons.warning_amber_rounded, color: status ? theme.success : theme.alert, size: 40)),
            const SizedBox(height: 8),
            Center(child: Text(status ? 'CERTIFICADO DE CUMPLIMIENTO' : 'CERTIFICADO DE INCUMPLIMIENTO',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: status ? theme.success : theme.alert, letterSpacing: 0.5))),
            const SizedBox(height: 16),
            _certLine(context, 'Entidad Regulada', meta['regulated_entity'] as String? ?? '—'),
            _certLine(context, 'Período Auditado', meta['audit_period'] as String? ?? '—'),
            _certLine(context, 'Marco Regulatorio', meta['regulatory_framework'] as String? ?? '—'),
            _certLine(context, 'Resultado', status ? 'CUMPLIMIENTO TOTAL' : 'INCUMPLIMIENTO DETECTADO'),
            _certLine(context, 'Reglas Evaluadas', '$rulesCount'),
            _certLine(context, 'Reglas Cumplidas', '$compliantCount'),
            _certLine(context, 'Fecha de Emisión', '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}'),
            _certLine(context, 'Versión', meta['version'] as String? ?? '—'),
            const SizedBox(height: 12),
            Text('Hash de Certificación:', style: TextStyle(color: theme.outline, fontSize: 9)),
            const SizedBox(height: 2),
            SelectableText(hash, style: TextStyle(color: theme.primary, fontSize: 10, fontFamily: 'monospace')),
            const SizedBox(height: 4),
            Text('Este certificado es una representación digital del resultado de la auditoría. El hash SHA-256 es la evidencia criptográfica vinculada a la red Stellar (Soroban).',
                style: TextStyle(color: theme.outline, fontSize: 9, height: 1.3)),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('CERRAR', style: TextStyle(color: theme.outline))),
      ],
    ),
  );
}

Widget _certLine(BuildContext context, String label, String value) {
  final theme = LexiTheme.of(context);
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 130, child: Text(label, style: TextStyle(color: theme.outline, fontSize: 11))),
      Expanded(child: Text(value, style: TextStyle(color: theme.onSurface, fontSize: 11, fontWeight: FontWeight.w500))),
    ]),
  );
}
