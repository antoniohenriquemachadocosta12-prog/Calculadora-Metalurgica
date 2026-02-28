import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../data/materiais.dart';
import '../models/material_metal.dart';
import '../models/perfil_metal.dart';
import '../models/projeto.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/calculos.dart';
import '../widgets/profile_diagram.dart';
import 'material_selector_screen.dart';

final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
final _pesoFmt = NumberFormat('#,##0.000', 'pt_BR');

class MeasurementFormScreen extends StatefulWidget {
  final PerfilMetal perfil;
  final ItemProjeto? itemEditando;

  const MeasurementFormScreen({
    super.key,
    required this.perfil,
    this.itemEditando,
  });

  @override
  State<MeasurementFormScreen> createState() => _MeasurementFormScreenState();
}

class _MeasurementFormScreenState extends State<MeasurementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  final _qtdController = TextEditingController(text: '1');

  MaterialMetal _material = materiais.first;
  String _descricao = '';
  bool _calculando = false;

  Map<String, double> get _medidas {
    final m = <String, double>{};
    for (final campo in widget.perfil.campos) {
      m[campo.id] = double.tryParse(
            _controllers[campo.id]?.text.replaceAll(',', '.') ?? '',
          ) ??
          0;
    }
    return m;
  }

  bool get _medidasValidas => _medidas.values.every((v) => v > 0);
  int get _quantidade => int.tryParse(_qtdController.text) ?? 1;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final c in widget.perfil.campos)
        c.id: TextEditingController(
          text: widget.itemEditando?.medidas[c.id]?.toString() ?? '',
        ),
    };
    if (widget.itemEditando != null) {
      _material = widget.itemEditando!.resultado.material;
      _qtdController.text = widget.itemEditando!.quantidade.toString();
    }
    for (final c in _controllers.values) {
      c.addListener(() => setState(() {}));
    }
    _qtdController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    _qtdController.dispose();
    super.dispose();
  }

  Future<void> _selecionarMaterial() async {
    final selecionado = await Navigator.of(context).push<MaterialMetal>(
      MaterialPageRoute(
        builder: (_) => MaterialSelectorScreen(materialAtual: _material),
      ),
    );
    if (selecionado != null) setState(() => _material = selecionado);
  }

  Future<void> _adicionarAoProjeto() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_medidasValidas) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todas as medidas com valores válidos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _calculando = true);
    try {
      final resultado = calcular(
        tipoPerfil: widget.perfil.id,
        medidas: _medidas,
        material: _material,
        quantidade: _quantidade,
      );
      final item = ItemProjeto(
        id: widget.itemEditando?.id ?? const Uuid().v4(),
        tipoPerfil: widget.perfil.id,
        nomePerfil: widget.perfil.nome,
        medidas: _medidas,
        quantidade: _quantidade,
        comprimento: resultado.comprimento,
        resultado: resultado,
        descricao: _descricao.isEmpty ? null : _descricao,
      );
      await _mostrarDialogoSalvar(item);
    } finally {
      if (mounted) setState(() => _calculando = false);
    }
  }

  Future<void> _mostrarDialogoSalvar(ItemProjeto item) async {
    final storage = StorageService();
    final projetos = await storage.carregarProjetos();
    if (!mounted) return;

    final opcao = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _SalvarItemSheet(projetos: projetos),
    );

    if (opcao == null || !mounted) return;

    if (opcao == 'novo') {
      final nomeProjeto = await _pedirNomeProjeto();
      if (nomeProjeto == null || !mounted) return;
      final empresa = await storage.carregarEmpresa();
      final projeto = Projeto(
        id: const Uuid().v4(),
        nome: nomeProjeto,
        dataCriacao: DateTime.now(),
        itens: [item],
        empresa: empresa ?? const EmpresaInfo(nome: ''),
        cliente: const ClienteInfo(),
      );
      await storage.adicionarProjeto(projeto);
    } else {
      final projeto = projetos.firstWhere((p) => p.id == opcao);
      await storage.atualizarProjeto(
        projeto.copyWith(itens: [...projeto.itens, item]),
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item adicionado ao projeto!'),
          backgroundColor: AppColors.teal,
        ),
      );
    }
  }

  Future<String?> _pedirNomeProjeto() async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo Projeto'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nome do Projeto',
            hintText: 'ex: Portão Residencial',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.isEmpty ? 'Projeto' : ctrl.text),
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultado = _medidasValidas
        ? calcular(
            tipoPerfil: widget.perfil.id,
            medidas: _medidas,
            material: _material,
            quantidade: _quantidade,
          )
        : null;

    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 700;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.perfil.nome),
        leading: const BackButton(),
      ),
      body: Form(
        key: _formKey,
        child: isWide
            ? _LayoutWide(
                perfil: widget.perfil,
                controllers: _controllers,
                qtdController: _qtdController,
                material: _material,
                resultado: resultado,
                onSelecionarMaterial: _selecionarMaterial,
                onDescricaoChanged: (v) => _descricao = v,
              )
            : _LayoutMobile(
                perfil: widget.perfil,
                controllers: _controllers,
                qtdController: _qtdController,
                material: _material,
                resultado: resultado,
                onSelecionarMaterial: _selecionarMaterial,
                onDescricaoChanged: (v) => _descricao = v,
              ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _calculando ? null : _adicionarAoProjeto,
            icon: _calculando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.add_circle_outline),
            label: Text(_calculando ? 'Salvando...' : 'Adicionar ao Projeto'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          ),
        ),
      ),
    );
  }
}

// ── Layout Mobile ─────────────────────────────────────────────────────────────

class _LayoutMobile extends StatelessWidget {
  final PerfilMetal perfil;
  final Map<String, TextEditingController> controllers;
  final TextEditingController qtdController;
  final MaterialMetal material;
  final dynamic resultado;
  final VoidCallback onSelecionarMaterial;
  final ValueChanged<String> onDescricaoChanged;

  const _LayoutMobile({
    required this.perfil,
    required this.controllers,
    required this.qtdController,
    required this.material,
    required this.resultado,
    required this.onSelecionarMaterial,
    required this.onDescricaoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProfileDiagram(tipoPerfil: perfil.id, medidas: _medidasMap(controllers, perfil)),
        const SizedBox(height: 20),
        const _SectionTitle(title: 'Dimensões'),
        const SizedBox(height: 12),
        ..._camposFields(perfil, controllers),
        const SizedBox(height: 8),
        _QtdDescricaoRow(qtdController: qtdController, onDescricaoChanged: onDescricaoChanged),
        const SizedBox(height: 20),
        const _SectionTitle(title: 'Material'),
        const SizedBox(height: 12),
        _MaterialButton(material: material, onTap: onSelecionarMaterial),
        if (resultado != null) ...[
          const SizedBox(height: 24),
          _ResultadoCard(resultado: resultado),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

// ── Layout Wide ───────────────────────────────────────────────────────────────

class _LayoutWide extends StatelessWidget {
  final PerfilMetal perfil;
  final Map<String, TextEditingController> controllers;
  final TextEditingController qtdController;
  final MaterialMetal material;
  final dynamic resultado;
  final VoidCallback onSelecionarMaterial;
  final ValueChanged<String> onDescricaoChanged;

  const _LayoutWide({
    required this.perfil,
    required this.controllers,
    required this.qtdController,
    required this.material,
    required this.resultado,
    required this.onSelecionarMaterial,
    required this.onDescricaoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 5,
          child: Container(
            color: AppColors.navy.withValues(alpha: 0.03),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ProfileDiagram(
                  tipoPerfil: perfil.id,
                  medidas: _medidasMap(controllers, perfil),
                ),
                if (resultado != null) ...[
                  const SizedBox(height: 20),
                  _ResultadoCard(resultado: resultado),
                ],
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Flexible(
          flex: 5,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const _SectionTitle(title: 'Dimensões'),
              const SizedBox(height: 14),
              ..._camposFields(perfil, controllers),
              const SizedBox(height: 12),
              _QtdDescricaoRow(
                qtdController: qtdController,
                onDescricaoChanged: onDescricaoChanged,
              ),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Material'),
              const SizedBox(height: 14),
              _MaterialButton(material: material, onTap: onSelecionarMaterial),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Map<String, double> _medidasMap(
  Map<String, TextEditingController> controllers,
  PerfilMetal perfil,
) {
  final m = <String, double>{};
  for (final campo in perfil.campos) {
    m[campo.id] =
        double.tryParse(controllers[campo.id]?.text.replaceAll(',', '.') ?? '') ?? 0;
  }
  return m;
}

List<Widget> _camposFields(
  PerfilMetal perfil,
  Map<String, TextEditingController> controllers,
) {
  return [
    for (final campo in perfil.campos)
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controllers[campo.id],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))],
          decoration: InputDecoration(
            labelText: '${campo.label} (${campo.unidade})',
            hintText: campo.hint,
            suffixText: campo.unidade,
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Campo obrigatório';
            final n = double.tryParse(v.replaceAll(',', '.'));
            if (n == null || n <= 0) return 'Valor inválido';
            return null;
          },
        ),
      ),
  ];
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _QtdDescricaoRow extends StatelessWidget {
  final TextEditingController qtdController;
  final ValueChanged<String> onDescricaoChanged;

  const _QtdDescricaoRow({
    required this.qtdController,
    required this.onDescricaoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: TextFormField(
            controller: qtdController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: const InputDecoration(labelText: 'Qtd', suffixText: 'un'),
            validator: (v) {
              final n = int.tryParse(v ?? '');
              if (n == null || n <= 0) return 'Inválido';
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            onChanged: onDescricaoChanged,
            decoration: const InputDecoration(
              labelText: 'Descrição (opcional)',
              hintText: 'ex: Portão principal',
            ),
          ),
        ),
      ],
    );
  }
}

class _MaterialButton extends StatelessWidget {
  final MaterialMetal material;
  final VoidCallback onTap;

  const _MaterialButton({required this.material, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.hardware_outlined, color: AppColors.teal, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'ρ = ${material.densidade.toStringAsFixed(0)} kg/m³  ·  ${_moeda.format(material.precoKg)}/kg',
                    style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Trocar',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Resultado Card ────────────────────────────────────────────────────────────

class _ResultadoCard extends StatelessWidget {
  final dynamic resultado;

  const _ResultadoCard({required this.resultado});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2845), Color(0xFF243660)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A2845).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calculate_outlined,
                    color: AppColors.orange,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'RESULTADO',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _MetricaTile(
                        label: 'Peso/metro',
                        value: '${_pesoFmt.format(resultado.pesoUnitario)} kg/m',
                        icon: Icons.scale_outlined,
                        cor: Colors.white54,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricaTile(
                        label: 'Peso Total',
                        value: '${_pesoFmt.format(resultado.pesoTotal)} kg',
                        icon: Icons.inventory_2_outlined,
                        cor: AppColors.teal,
                        destaque: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _MetricaTile(
                        label: 'Valor/metro',
                        value: _moeda.format(resultado.valorUnitario),
                        icon: Icons.attach_money,
                        cor: Colors.white54,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricaTile(
                        label: 'VALOR TOTAL',
                        value: _moeda.format(resultado.valorTotal),
                        icon: Icons.payments_outlined,
                        cor: AppColors.orange,
                        destaque: true,
                        grande: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricaTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color cor;
  final bool destaque;
  final bool grande;

  const _MetricaTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.cor,
    this.destaque = false,
    this.grande = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: destaque
            ? cor.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: destaque ? Border.all(color: cor.withValues(alpha: 0.3)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: cor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: destaque ? cor : Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: destaque ? cor : Colors.white,
              fontSize: grande ? 15 : 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Salvar Item Sheet ─────────────────────────────────────────────────────────

class _SalvarItemSheet extends StatelessWidget {
  final List<Projeto> projetos;

  const _SalvarItemSheet({required this.projetos});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Adicionar ao Projeto', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.create_new_folder_outlined, color: AppColors.orange),
            ),
            title: const Text('Novo Projeto'),
            subtitle: const Text('Criar projeto e adicionar este item'),
            onTap: () => Navigator.pop(context, 'novo'),
          ),
          if (projetos.isNotEmpty) ...[
            const Divider(),
            Text(
              'Projetos Existentes',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.darkGray),
            ),
            const SizedBox(height: 8),
            ...projetos.map(
              (p) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.folder_outlined, color: AppColors.teal),
                ),
                title: Text(p.nome),
                subtitle: Text('${p.itens.length} ${p.itens.length == 1 ? 'item' : 'itens'}'),
                onTap: () => Navigator.pop(context, p.id),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
