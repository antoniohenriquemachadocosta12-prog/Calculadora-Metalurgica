import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/projeto_model.dart';
import '../utils/calculos.dart';
import '../utils/pdf_generator.dart';
import 'empresa_modal.dart';

class ProjectListScreen extends StatefulWidget {
  final List<Projeto> projetos;
  final EmpresaInfo empresa;
  final ClienteInfo cliente;
  final void Function(int index) onRemover;
  final VoidCallback onLimpar;

  const ProjectListScreen({
    super.key,
    required this.projetos,
    required this.empresa,
    required this.cliente,
    required this.onRemover,
    required this.onLimpar,
  });

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  double get _pesoTotal =>
      widget.projetos.fold(0, (sum, p) => sum + p.resultado.pesoTotal);

  double get _valorTotal =>
      widget.projetos.fold(0, (sum, p) => sum + p.resultado.valorTotal);

  void _gerarPdf() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => EmpresaModal(
        empresa: widget.empresa,
        cliente: widget.cliente,
      ),
    );

    if (result == true && mounted) {
      await PdfGenerator.gerarECompartilhar(
        projetos: widget.projetos,
        empresa: widget.empresa,
        cliente: widget.cliente,
        context: context,
      );
    }
  }

  void _confirmarLimpar() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar lista'),
        content: const Text('Tem certeza que deseja remover todos os itens?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onLimpar();
              setState(() {});
            },
            child: const Text(
              'Limpar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Materiais'),
        actions: [
          if (widget.projetos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _confirmarLimpar,
            ),
        ],
      ),
      body: widget.projetos.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 64, color: AppColors.light),
                  SizedBox(height: 16),
                  Text(
                    'Lista vazia',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.medium,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Adicione perfis a partir do menu principal',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.light,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Resumo
                Container(
                  color: AppColors.navy,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PESO TOTAL',
                              style: TextStyle(
                                color: AppColors.light,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              Calculos.formatarPeso(_pesoTotal),
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'VALOR TOTAL',
                              style: TextStyle(
                                color: AppColors.light,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              Calculos.formatarValor(_valorTotal),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Lista
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: widget.projetos.length,
                    itemBuilder: (context, index) {
                      final p = widget.projetos[index];
                      return Dismissible(
                        key: Key('${p.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: AppColors.error,
                          child: const Icon(Icons.delete,
                              color: AppColors.white),
                        ),
                        onDismissed: (_) {
                          widget.onRemover(index);
                          setState(() {});
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${p.nomePerfil} (${p.quantidade}x)',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      Calculos.formatarValor(
                                          p.resultado.valorTotal),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${p.material.nome} • ${Calculos.formatarPeso(p.resultado.pesoTotal)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: widget.projetos.isNotEmpty
          ? Container(
              color: AppColors.navy,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              child: ElevatedButton.icon(
                onPressed: _gerarPdf,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Gerar PDF'),
              ),
            )
          : null,
    );
  }
}
