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
    if (selecionado != null) {
      setState(() => _material = selecionado);
    }
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
      final atualizado = projeto.copyWith(itens: [...projeto.itens, item]);
      await storage.atualizarProjeto(atualizado);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.perfil.nome),
        leading: const BackButton(),
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Diagrama técnico
                    ProfileDiagram(
                      tipoPerfil: widget.perfil.id,
                      medidas: _medidas,
                    ),
                    const SizedBox(height: 20),

                    // Campos de medida
                    Text(
                      'Dimensões',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...widget.perfil.campos.map((campo) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TextFormField(
                            controller: _controllers[campo.id],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                            ],
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
                        )),

                    const SizedBox(height: 4),

                    // Quantidade
                    TextFormField(
                      controller: _qtdController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                        suffixText: 'un',
                      ),
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null || n <= 0) return 'Quantidade inválida';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Descrição opcional
                    TextFormField(
                      onChanged: (v) => _descricao = v,
                      decoration: const InputDecoration(
                        labelText: 'Descrição (opcional)',
                        hintText: 'ex: Portão principal',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Material
                    Text(
                      'Material',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _selecionarMaterial,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderGray),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.category_outlined, color: AppColors.teal),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _material.nome,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  Text(
                                    'ρ = ${_material.densidade.toStringAsFixed(0)} kg/m³  •  ${_moeda.format(_material.precoKg)}/kg',
                                    style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.darkGray),
                          ],
                        ),
                      ),
                    ),

                    // Resultado em tempo real
                    if (resultado != null) ...[
                      const SizedBox(height: 24),
                      _ResultadoCard(resultado: resultado),
                    ],

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
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
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _ResultadoCard extends StatelessWidget {
  final dynamic resultado;

  const _ResultadoCard({required this.resultado});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resultado',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ResultItem(
                  label: 'Peso Unitário',
                  value: '${_pesoFmt.format(resultado.pesoUnitario)} kg/m',
                ),
              ),
              Expanded(
                child: _ResultItem(
                  label: 'Peso Total',
                  value: '${_pesoFmt.format(resultado.pesoTotal)} kg',
                  highlight: true,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 20),
          Row(
            children: [
              Expanded(
                child: _ResultItem(
                  label: 'Valor Unitário',
                  value: _moeda.format(resultado.valorUnitario),
                ),
              ),
              Expanded(
                child: _ResultItem(
                  label: 'Valor Total',
                  value: _moeda.format(resultado.valorTotal),
                  highlight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _ResultItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.orange : Colors.white,
            fontSize: highlight ? 15 : 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

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
          Text(
            'Adicionar ao Projeto',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.1),
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
            Text('Projetos Existentes',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.darkGray)),
            const SizedBox(height: 8),
            ...projetos.map(
              (p) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.1),
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
