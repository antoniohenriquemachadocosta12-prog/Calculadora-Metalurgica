import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../models/projeto.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/pdf_generator.dart';
import 'empresa_modal.dart';

final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
final _pesoFmt = NumberFormat('#,##0.000', 'pt_BR');

class ProjectDetailScreen extends StatefulWidget {
  final String projetoId;

  const ProjectDetailScreen({super.key, required this.projetoId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final _storage = StorageService();
  Projeto? _projeto;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _loading = true);
    final projetos = await _storage.carregarProjetos();
    final projeto = projetos.firstWhere((p) => p.id == widget.projetoId);
    if (mounted) setState(() {
      _projeto = projeto;
      _loading = false;
    });
  }

  Future<void> _editarCliente() async {
    if (_projeto == null) return;

    final nomeCtrl = TextEditingController(text: _projeto!.cliente.nome);
    final telCtrl = TextEditingController(text: _projeto!.cliente.telefone);
    final obsCtrl = TextEditingController(text: _projeto!.cliente.observacoes);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
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
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Dados do Cliente', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome do Cliente')),
            const SizedBox(height: 12),
            TextField(controller: telCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Telefone')),
            const SizedBox(height: 12),
            TextField(controller: obsCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Observações')),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final updated = _projeto!.copyWith(
                    cliente: ClienteInfo(
                      nome: nomeCtrl.text,
                      telefone: telCtrl.text,
                      observacoes: obsCtrl.text,
                    ),
                  );
                  await _storage.atualizarProjeto(updated);
                  if (ctx.mounted) Navigator.pop(ctx);
                  await _carregar();
                },
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removerItem(ItemProjeto item) async {
    if (_projeto == null) return;
    final itens = _projeto!.itens.where((i) => i.id != item.id).toList();
    final updated = _projeto!.copyWith(itens: itens);
    await _storage.atualizarProjeto(updated);
    await _carregar();
  }

  Future<void> _gerarPdf() async {
    if (_projeto == null) return;

    // Verificar empresa
    final empresa = await _storage.carregarEmpresa();
    if (empresa == null || empresa.nome.isEmpty) {
      if (!mounted) return;
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => const EmpresaModal(),
      );
    }

    if (!mounted) return;
    setState(() => _loading = true);

    try {
      final empresaAtualizada = await _storage.carregarEmpresa();
      final projetoComEmpresa = _projeto!.copyWith(
        empresa: empresaAtualizada ?? const EmpresaInfo(nome: 'MetalCalc Pro'),
      );

      final pdfBytes = await gerarPdfProjeto(projetoComEmpresa);

      if (!mounted) return;
      await Printing.layoutPdf(
        onLayout: (_) => pdfBytes,
        name: '${_projeto!.nome} - Orçamento',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao gerar PDF: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final projeto = _projeto!;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(projeto.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Cliente',
            onPressed: _editarCliente,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Gerar PDF',
            onPressed: _gerarPdf,
          ),
        ],
      ),
      body: projeto.itens.isEmpty
          ? const Center(
              child: Text('Nenhum item neste projeto.', style: TextStyle(color: AppColors.darkGray)),
            )
          : CustomScrollView(
              slivers: [
                // Resumo do projeto
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (projeto.cliente.nome.isNotEmpty)
                          _InfoBanner(
                            icon: Icons.person_outline,
                            text: 'Cliente: ${projeto.cliente.nome}',
                          ),
                        _ResumoCard(projeto: projeto),
                        const SizedBox(height: 4),
                        Text(
                          'Itens do Projeto',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.navy),
                        ),
                      ],
                    ),
                  ),
                ),

                // Lista de itens
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final item = projeto.itens[i];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: _ItemCard(
                          item: item,
                          numero: i + 1,
                          onRemover: () => _removerItem(item),
                        ),
                      );
                    },
                    childCount: projeto.itens.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _loading ? null : _gerarPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Gerar Orçamento PDF'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          ),
        ),
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBanner({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.teal.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.teal),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, color: AppColors.teal, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ResumoCard extends StatelessWidget {
  final Projeto projeto;

  const _ResumoCard({required this.projeto});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ResumoItem(
              label: 'Itens',
              value: '${projeto.itens.length}',
              icon: Icons.inventory_2_outlined,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(
            child: _ResumoItem(
              label: 'Peso Total',
              value: '${_pesoFmt.format(projeto.totalPeso)} kg',
              icon: Icons.scale_outlined,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(
            child: _ResumoItem(
              label: 'Valor Total',
              value: _moeda.format(projeto.totalValor),
              icon: Icons.attach_money,
              destaque: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool destaque;

  const _ResumoItem({
    required this.label,
    required this.value,
    required this.icon,
    this.destaque = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white54, size: 18),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: destaque ? AppColors.orange : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ItemProjeto item;
  final int numero;
  final VoidCallback onRemover;

  const _ItemCard({
    required this.item,
    required this.numero,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    final r = item.resultado;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(
                      '$numero',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nomePerfil,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.navy),
                      ),
                      Text(
                        r.material.nome,
                        style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: onRemover,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _DetalheItem(label: 'Qtd', value: '${item.quantidade} un')),
                Expanded(child: _DetalheItem(label: 'Comp.', value: item.comprimento == 1 ? '-' : '${item.comprimento} m')),
                Expanded(child: _DetalheItem(label: 'Peso/m', value: '${_pesoFmt.format(r.pesoUnitario)} kg')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _DetalheItem(
                    label: 'Peso Total',
                    value: '${_pesoFmt.format(r.pesoTotal)} kg',
                    destaque: false,
                  ),
                ),
                Expanded(
                  child: _DetalheItem(
                    label: 'Valor Total',
                    value: _moeda.format(r.valorTotal),
                    destaque: true,
                  ),
                ),
              ],
            ),
            if (item.descricao != null && item.descricao!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                item.descricao!,
                style: const TextStyle(fontSize: 12, color: AppColors.darkGray, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetalheItem extends StatelessWidget {
  final String label;
  final String value;
  final bool destaque;

  const _DetalheItem({required this.label, required this.value, this.destaque = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.darkGray)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: destaque ? AppColors.orange : AppColors.navy,
          ),
        ),
      ],
    );
  }
}
