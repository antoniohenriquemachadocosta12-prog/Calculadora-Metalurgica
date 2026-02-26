import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/material_model.dart';
import '../data/materiais.dart';

class MaterialSelectorScreen extends StatefulWidget {
  final MaterialMetal? materialAtual;

  const MaterialSelectorScreen({super.key, this.materialAtual});

  @override
  State<MaterialSelectorScreen> createState() =>
      _MaterialSelectorScreenState();
}

class _MaterialSelectorScreenState extends State<MaterialSelectorScreen> {
  String _busca = '';
  String? _categoriaFiltro;
  final _searchController = TextEditingController();

  List<MaterialMetal> get _materiaisFiltrados {
    var lista = buscarMateriais(_busca);
    if (_categoriaFiltro != null) {
      lista = lista.where((m) => m.categoria == _categoriaFiltro).toList();
    }
    return lista;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categorias = categoriasDisponiveis();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Material'),
      ),
      body: Column(
        children: [
          // Barra de busca
          Container(
            color: AppColors.cream,
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar material...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _busca.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _busca = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.white,
              ),
              onChanged: (v) => setState(() => _busca = v),
            ),
          ),
          // Filtro por categoria
          Container(
            color: AppColors.cream,
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoriaChip(null, 'Todos'),
                  ...categorias.map((c) => _buildCategoriaChip(c, c)),
                ],
              ),
            ),
          ),
          // Contador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_materiaisFiltrados.length} materiais',
                  style: const TextStyle(
                    color: AppColors.medium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Lista de materiais
          Expanded(
            child: ListView.builder(
              itemCount: _materiaisFiltrados.length,
              itemBuilder: (context, index) {
                final mat = _materiaisFiltrados[index];
                final selecionado = mat.id == widget.materialAtual?.id;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        selecionado ? AppColors.primary : AppColors.navy,
                    child: Text(
                      mat.categoria[0],
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(
                    mat.nome,
                    style: TextStyle(
                      fontWeight:
                          selecionado ? FontWeight.w700 : FontWeight.normal,
                      color: selecionado ? AppColors.primary : AppColors.dark,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    '${mat.densidade.toInt()} kg/m³ • R\$ ${mat.precoKg.toStringAsFixed(2)}/kg • ${mat.categoria}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: selecionado
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(mat),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaChip(String? value, String label) {
    final selected = _categoriaFiltro == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
        selected: selected,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? AppColors.white : AppColors.dark,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
        onSelected: (_) => setState(() {
          _categoriaFiltro = value;
        }),
      ),
    );
  }
}
