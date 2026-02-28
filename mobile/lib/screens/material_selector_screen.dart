import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/materiais.dart';
import '../models/material_metal.dart';
import '../theme/app_theme.dart';

final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

class MaterialSelectorScreen extends StatelessWidget {
  final MaterialMetal materialAtual;

  const MaterialSelectorScreen({super.key, required this.materialAtual});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecionar Material')),
      backgroundColor: AppColors.cream,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: materiais.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) {
          final mat = materiais[i];
          final selecionado = mat.id == materialAtual.id;
          return _MaterialCard(
            material: mat,
            selecionado: selecionado,
            onTap: () => Navigator.of(context).pop(mat),
          );
        },
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final MaterialMetal material;
  final bool selecionado;
  final VoidCallback onTap;

  const _MaterialCard({
    required this.material,
    required this.selecionado,
    required this.onTap,
  });

  Color get _cor {
    if (material.id.contains('inox')) return AppColors.teal;
    if (material.id.contains('aluminio')) return const Color(0xFF6C8EBF);
    if (material.id.contains('aco')) return AppColors.navy;
    if (material.id == 'cobre') return const Color(0xFFB87333);
    if (material.id == 'latao') return const Color(0xFFD4A843);
    return AppColors.darkGray;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selecionado ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selecionado ? AppColors.navy : AppColors.borderGray,
            width: selecionado ? 2 : 1,
          ),
          boxShadow: selecionado
              ? [BoxShadow(color: AppColors.navy.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selecionado ? Colors.white.withOpacity(0.15) : _cor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.hardware_outlined,
                color: selecionado ? Colors.white : _cor,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.nome,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: selecionado ? Colors.white : AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    material.descricao,
                    style: TextStyle(
                      fontSize: 12,
                      color: selecionado ? Colors.white70 : AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _InfoChip(
                        label: '${material.densidade.toStringAsFixed(0)} kg/m³',
                        cor: selecionado ? Colors.white24 : AppColors.teal.withOpacity(0.12),
                        textCor: selecionado ? Colors.white : AppColors.teal,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        label: '${_moeda.format(material.precoKg)}/kg',
                        cor: selecionado ? Colors.white24 : AppColors.orange.withOpacity(0.12),
                        textCor: selecionado ? Colors.white : AppColors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (selecionado)
              const Icon(Icons.check_circle, color: AppColors.orange, size: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color cor;
  final Color textCor;

  const _InfoChip({required this.label, required this.cor, required this.textCor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: textCor, fontWeight: FontWeight.w500)),
    );
  }
}
