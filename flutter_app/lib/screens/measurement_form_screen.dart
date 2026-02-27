import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/perfil_model.dart';
import '../models/material_model.dart';
import '../models/projeto_model.dart';
import '../data/materiais.dart';
import '../utils/calculos.dart';
import '../widgets/perfil_diagram.dart';
import 'material_selector_screen.dart';

class MeasurementFormScreen extends StatefulWidget {
  final PerfilMetal perfil;
  final List<Projeto> projetos;
  final EmpresaInfo empresa;
  final ClienteInfo cliente;
  final void Function(Projeto) onProjetoAdicionado;

  const MeasurementFormScreen({
    super.key,
    required this.perfil,
    required this.projetos,
    required this.empresa,
    required this.cliente,
    required this.onProjetoAdicionado,
  });

  @override
  State<MeasurementFormScreen> createState() => _MeasurementFormScreenState();
}

class _MeasurementFormScreenState extends State<MeasurementFormScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final _qtdController = TextEditingController(text: '1');
  MaterialMetal? _materialSelecionado;
  Resultado? _resultado;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores para cada campo do perfil
    for (final campo in widget.perfil.campos) {
      _controllers[campo.key] = TextEditingController();
    }
    // Material padrão
    _materialSelecionado = todosMateriais.first;
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _qtdController.dispose();
    super.dispose();
  }

  void _calcular() {
    if (_materialSelecionado == null) return;

    final medidas = <String, double>{};
    bool todosPreenchidos = true;

    for (final campo in widget.perfil.campos) {
      final valor = double.tryParse(
          _controllers[campo.key]?.text.replaceAll(',', '.') ?? '');
      if (valor == null || valor <= 0) {
        todosPreenchidos = false;
        break;
      }
      medidas[campo.key] = valor;
    }

    if (!todosPreenchidos) {
      setState(() => _resultado = null);
      return;
    }

    final quantidade = int.tryParse(_qtdController.text) ?? 1;

    setState(() {
      _resultado = Calculos.calcular(
        perfil: widget.perfil,
        medidas: medidas,
        material: _materialSelecionado!,
        quantidade: quantidade,
      );
    });
  }

  void _adicionarALista() {
    if (_resultado == null || _materialSelecionado == null) return;

    final medidas = <String, double>{};
    for (final campo in widget.perfil.campos) {
      medidas[campo.key] = double.tryParse(
              _controllers[campo.key]?.text.replaceAll(',', '.') ?? '') ??
          0;
    }

    final projeto = Projeto(
      id: DateTime.now().millisecondsSinceEpoch,
      tipoPerfilId: widget.perfil.id,
      nomePerfil: widget.perfil.nome,
      medidas: medidas,
      material: _materialSelecionado!,
      quantidade: int.tryParse(_qtdController.text) ?? 1,
      resultado: _resultado!,
    );

    widget.onProjetoAdicionado(projeto);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.perfil.nome} adicionado à lista!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _selecionarMaterial() async {
    final result = await Navigator.of(context).push<MaterialMetal>(
      MaterialPageRoute(
        builder: (_) => MaterialSelectorScreen(
          materialAtual: _materialSelecionado,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _materialSelecionado = result;
      });
      _calcular();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.perfil.nome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Diagrama técnico do perfil
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.navy, width: 1.5),
              ),
              child: Center(
                child: PerfilDiagram(
                  perfilId: widget.perfil.id,
                  size: 140,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Seletor de material
            Card(
              child: InkWell(
                onTap: _selecionarMaterial,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.layers, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Material',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.medium,
                              ),
                            ),
                            Text(
                              _materialSelecionado?.nome ?? 'Selecionar...',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                            if (_materialSelecionado != null)
                              Text(
                                '${_materialSelecionado!.densidade.toInt()} kg/m³ • R\$ ${_materialSelecionado!.precoKg.toStringAsFixed(2)}/kg',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.medium,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.medium),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Campos de medida
            ...widget.perfil.campos.map((campo) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextField(
                    controller: _controllers[campo.key],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: campo.label,
                      suffixText: campo.unidade,
                    ),
                    onChanged: (_) => _calcular(),
                  ),
                )),

            // Quantidade
            TextField(
              controller: _qtdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                suffixText: 'un.',
              ),
              onChanged: (_) => _calcular(),
            ),

            const SizedBox(height: 20),

            // Resultado
            if (_resultado != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'RESULTADO',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _resultRow(
                        'Peso unitário', Calculos.formatarPeso(_resultado!.pesoUnitario)),
                    _resultRow(
                        'Peso total', Calculos.formatarPeso(_resultado!.pesoTotal)),
                    const Divider(color: AppColors.medium, height: 16),
                    _resultRow(
                        'Valor unitário', Calculos.formatarValor(_resultado!.valorUnitario)),
                    _resultRow(
                        'Valor total', Calculos.formatarValor(_resultado!.valorTotal),
                        destaque: true),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _adicionarALista,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Adicionar à Lista'),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String valor, {bool destaque = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.light,
              fontSize: destaque ? 14 : 12,
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              color: destaque ? AppColors.primary : AppColors.white,
              fontSize: destaque ? 18 : 14,
              fontWeight: destaque ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
