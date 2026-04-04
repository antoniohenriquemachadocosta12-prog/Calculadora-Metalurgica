import 'package:flutter/material.dart';
import '../data/perfis.dart';
import '../models/perfil_metal.dart';
import '../theme/app_theme.dart';
import 'measurement_form_screen.dart';

// Responsivo: número de colunas conforme largura
int _crossAxisCount(double width) {
  if (width >= 1200) return 5;
  if (width >= 900) return 4;
  if (width >= 600) return 3;
  return 2;
}

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
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 600;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          // ── Header com AppBar embutida ──────────────────────────────────
          _Header(
            isWide: isWide,
            busca: _busca,
            onBuscaChanged: (v) => setState(() => _busca = v),
            onProjetosPressed: () => Navigator.of(context).pushNamed('/projetos'),
          ),

          // ── Filtros por categoria ───────────────────────────────────────
          _FiltroBarra(
            categorias: cats,
            categoriaFiltro: _categoriaFiltro,
            onChanged: (c) => setState(
              () => _categoriaFiltro = _categoriaFiltro == c ? null : c,
            ),
            onTodos: () => setState(() => _categoriaFiltro = null),
          ),

          // ── Grid responsivo de perfis ───────────────────────────────────
          Expanded(
            child: _perfisFiltrados.isEmpty
                ? _EmptySearch(busca: _busca)
                : GridView.builder(
                    padding: EdgeInsets.all(isWide ? 20 : 14),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _crossAxisCount(width),
                      crossAxisSpacing: isWide ? 14 : 10,
                      mainAxisSpacing: isWide ? 14 : 10,
                      childAspectRatio: isWide ? 1.35 : 1.15,
                    ),
                    itemCount: _perfisFiltrados.length,
                    itemBuilder: (ctx, i) {
                      final p = _perfisFiltrados[i];
                      return _PerfilCard(
                        perfil: p,
                        isWide: isWide,
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

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final bool isWide;
  final String busca;
  final ValueChanged<String> onBuscaChanged;
  final VoidCallback onProjetosPressed;

  const _Header({
    required this.isWide,
    required this.busca,
    required this.onBuscaChanged,
    required this.onProjetosPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.navy,
            const Color(0xFF243660),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(isWide ? 24 : 16, 12, isWide ? 24 : 16, 16),
          child: Column(
            children: [
              // Barra de título
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('M',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'MontarCalcPro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  _HeaderButton(
                    icon: Icons.folder_open_outlined,
                    label: 'Projetos',
                    onPressed: onProjetosPressed,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Busca
              TextField(
                onChanged: onBuscaChanged,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Buscar perfil metálico...',
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
                  suffixIcon: busca.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                          onPressed: () => onBuscaChanged(''),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _HeaderButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white70, size: 18),
      label: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
      ),
    );
  }
}

// ── Filtros ───────────────────────────────────────────────────────────────────

class _FiltroBarra extends StatelessWidget {
  final List<String> categorias;
  final String? categoriaFiltro;
  final ValueChanged<String> onChanged;
  final VoidCallback onTodos;

  const _FiltroBarra({
    required this.categorias,
    required this.categoriaFiltro,
    required this.onChanged,
    required this.onTodos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          _FiltroChip(
            label: 'Todos',
            icone: Icons.apps_rounded,
            selecionado: categoriaFiltro == null,
            onTap: onTodos,
          ),
          ...categorias.map(
            (c) => _FiltroChip(
              label: c,
              icone: _categoriaIcone(c),
              selecionado: categoriaFiltro == c,
              onTap: () => onChanged(c),
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoriaIcone(String cat) {
    switch (cat) {
      case 'Estrutural': return Icons.architecture;
      case 'Tubo': return Icons.water_outlined;
      case 'Barra': return Icons.horizontal_rule;
      case 'Chapa': return Icons.layers_outlined;
      default: return Icons.more_horiz;
    }
  }
}

class _FiltroChip extends StatelessWidget {
  final String label;
  final IconData icone;
  final bool selecionado;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    required this.icone,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            color: selecionado ? AppColors.navy : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selecionado ? AppColors.navy : AppColors.borderGray,
              width: selecionado ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icone,
                size: 13,
                color: selecionado ? Colors.white : AppColors.darkGray,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: selecionado ? Colors.white : AppColors.darkGray,
                  fontSize: 12,
                  fontWeight: selecionado ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Cards ─────────────────────────────────────────────────────────────────────

class _PerfilCard extends StatefulWidget {
  final PerfilMetal perfil;
  final VoidCallback onTap;
  final bool isWide;

  const _PerfilCard({required this.perfil, required this.onTap, required this.isWide});

  @override
  State<_PerfilCard> createState() => _PerfilCardState();
}

class _PerfilCardState extends State<_PerfilCard> {
  bool _hovered = false;

  Color get _cor {
    switch (widget.perfil.categoria) {
      case 'Estrutural': return AppColors.navy;
      case 'Tubo': return AppColors.teal;
      case 'Barra': return AppColors.orange;
      case 'Chapa': return const Color(0xFF7B5EA7);
      default: return AppColors.darkGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? _cor.withValues(alpha: 0.5) : AppColors.borderGray,
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? _cor.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _hovered ? 16 : 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ícone do perfil
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _hovered
                            ? _cor.withValues(alpha: 0.15)
                            : _cor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          widget.perfil.icone,
                          style: TextStyle(
                            fontSize: 20,
                            color: _cor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Badge categoria
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: _cor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.perfil.categoria,
                        style: TextStyle(
                          fontSize: 9,
                          color: _cor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  widget.perfil.nome,
                  style: TextStyle(
                    fontSize: widget.isWide ? 12 : 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  widget.perfil.descricao,
                  style: TextStyle(
                    fontSize: widget.isWide ? 10 : 11,
                    color: AppColors.darkGray.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Estado vazio ──────────────────────────────────────────────────────────────

class _EmptySearch extends StatelessWidget {
  final String busca;

  const _EmptySearch({required this.busca});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: AppColors.navy.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Text(
            'Nenhum resultado para "$busca"',
            style: const TextStyle(color: AppColors.darkGray, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
