import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/projeto.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'empresa_modal.dart';
import 'project_detail_screen.dart';

final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
final _dataFmt = DateFormat('dd/MM/yyyy', 'pt_BR');

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final _storage = StorageService();
  List<Projeto> _projetos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _loading = true);
    final projetos = await _storage.carregarProjetos();
    if (mounted) setState(() {
      _projetos = projetos.reversed.toList();
      _loading = false;
    });
  }

  Future<void> _confirmarExcluir(Projeto projeto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Projeto'),
        content: Text('Deseja excluir "${projeto.nome}"? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _storage.removerProjeto(projeto.id);
      await _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Meus Projetos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.business_outlined),
            tooltip: 'Dados da Empresa',
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const EmpresaModal(),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _projetos.isEmpty
              ? _EmptyState(onNovoProjeto: () => Navigator.of(context).pop())
              : RefreshIndicator(
                  onRefresh: _carregar,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _projetos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final p = _projetos[i];
                      return _ProjetoCard(
                        projeto: p,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProjectDetailScreen(projetoId: p.id),
                            ),
                          );
                          await _carregar();
                        },
                        onExcluir: () => _confirmarExcluir(p),
                      );
                    },
                  ),
                ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _ProjetoCard extends StatelessWidget {
  final Projeto projeto;
  final VoidCallback onTap;
  final VoidCallback onExcluir;

  const _ProjetoCard({
    required this.projeto,
    required this.onTap,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.folder_outlined, color: AppColors.orange, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          projeto.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          _dataFmt.format(projeto.dataCriacao),
                          style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'excluir') onExcluir();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'excluir',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red, size: 18),
                            SizedBox(width: 8),
                            Text('Excluir', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.inventory_2_outlined,
                      label: 'Itens',
                      value: '${projeto.itens.length}',
                      cor: AppColors.teal,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.scale_outlined,
                      label: 'Peso Total',
                      value: '${projeto.totalPeso.toStringAsFixed(2)} kg',
                      cor: AppColors.navy,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.attach_money,
                      label: 'Valor Total',
                      value: _moeda.format(projeto.totalValor),
                      cor: AppColors.orange,
                    ),
                  ),
                ],
              ),
              if (projeto.cliente.nome.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: AppColors.darkGray),
                    const SizedBox(width: 4),
                    Text(
                      projeto.cliente.nome,
                      style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color cor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: cor),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.darkGray)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cor)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onNovoProjeto;

  const _EmptyState({required this.onNovoProjeto});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_open_outlined, size: 80, color: AppColors.navy.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text(
              'Nenhum projeto ainda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.navy),
            ),
            const SizedBox(height: 8),
            const Text(
              'Calcule um perfil e adicione ao seu primeiro projeto',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.darkGray),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onNovoProjeto,
              icon: const Icon(Icons.add),
              label: const Text('Calcular Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
