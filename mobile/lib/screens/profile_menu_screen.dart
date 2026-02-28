import 'package:flutter/material.dart';
import '../data/perfis.dart';
import '../models/perfil_metal.dart';
import '../theme/app_theme.dart';
import 'measurement_form_screen.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  String? _categoriaFiltro;
  String _busca = '';

  List<PerfilMetal> get _perfisFiltrados {
    return perfis.where((p) {
      final matchCategoria = _categoriaFiltro == null || p.categoria == _categoriaFiltro;
      final matchBusca = _busca.isEmpty ||
          p.nome.toLowerCase().contains(_busca.toLowerCase()) ||
          p.categoria.toLowerCase().contains(_busca.toLowerCase());
      return matchCategoria && matchBusca;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cats = categorias;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('MetalCalc Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open_outlined),
            tooltip: 'Meus Projetos',
            onPressed: () => Navigator.of(context).pushNamed('/projetos'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header / Search
          Container(
            color: AppColors.navy,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecione o Perfil',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (v) => setState(() => _busca = v),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar perfil...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // Filtros por categoria
          Container(
            color: AppColors.navy.withOpacity(0.05),
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _FiltroChip(
                  label: 'Todos',
                  selecionado: _categoriaFiltro == null,
                  onTap: () => setState(() => _categoriaFiltro = null),
                ),
                ...cats.map(
                  (c) => _FiltroChip(
                    label: c,
                    selecionado: _categoriaFiltro == c,
                    onTap: () => setState(
                      () => _categoriaFiltro = _categoriaFiltro == c ? null : c,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grid de Perfis
          Expanded(
            child: _perfisFiltrados.isEmpty
                ? const Center(
                    child: Text('Nenhum perfil encontrado',
                        style: TextStyle(color: AppColors.darkGray)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.15,
                    ),
                    itemCount: _perfisFiltrados.length,
                    itemBuilder: (ctx, i) {
                      final p = _perfisFiltrados[i];
                      return _PerfilCard(
                        perfil: p,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MeasurementFormScreen(perfil: p),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _FiltroChip extends StatelessWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          decoration: BoxDecoration(
            color: selecionado ? AppColors.orange : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selecionado ? AppColors.orange : AppColors.borderGray,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selecionado ? Colors.white : AppColors.darkGray,
              fontSize: 12,
              fontWeight: selecionado ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _PerfilCard extends StatelessWidget {
  final PerfilMetal perfil;
  final VoidCallback onTap;

  const _PerfilCard({required this.perfil, required this.onTap});

  Color get _categoriaColor {
    switch (perfil.categoria) {
      case 'Estrutural':
        return AppColors.navy;
      case 'Tubo':
        return AppColors.teal;
      case 'Barra':
        return AppColors.orange;
      case 'Chapa':
        return const Color(0xFF7B5EA7);
      default:
        return AppColors.darkGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _categoriaColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        perfil.icone,
                        style: TextStyle(
                          fontSize: 22,
                          color: _categoriaColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _categoriaColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      perfil.categoria,
                      style: TextStyle(
                        fontSize: 10,
                        color: _categoriaColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                perfil.nome,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                perfil.descricao,
                style: const TextStyle(fontSize: 11, color: AppColors.darkGray),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
