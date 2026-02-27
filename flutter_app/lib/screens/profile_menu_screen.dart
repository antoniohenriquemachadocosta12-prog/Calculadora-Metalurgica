import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/perfil_model.dart';
import '../models/projeto_model.dart';
import '../widgets/logo_widget.dart';
import '../widgets/perfil_diagram.dart';
import '../services/storage_service.dart';
import 'measurement_form_screen.dart';
import 'project_list_screen.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  final List<Projeto> _projetos = [];
  EmpresaInfo _empresa = EmpresaInfo();
  ClienteInfo _cliente = ClienteInfo();
  String? _categoriaFiltro;
  bool _carregando = true;

  Map<String, List<PerfilMetal>> get _perfisPorCategoria =>
      PerfilFactory.porCategoria();

  List<String> get _categorias => _perfisPorCategoria.keys.toList()..sort();

  List<PerfilMetal> get _perfisFiltrados {
    if (_categoriaFiltro == null) return PerfilFactory.todos();
    return _perfisPorCategoria[_categoriaFiltro] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final projetos = await StorageService.carregarProjetos();
    final empresa = await StorageService.carregarEmpresa();
    final cliente = await StorageService.carregarCliente();
    if (mounted) {
      setState(() {
        _projetos.addAll(projetos);
        _empresa = empresa;
        _cliente = cliente;
        _carregando = false;
      });
    }
  }

  Future<void> _salvar() async {
    await StorageService.salvarProjetos(_projetos);
    await StorageService.salvarEmpresa(_empresa);
    await StorageService.salvarCliente(_cliente);
  }

  void _selecionarPerfil(PerfilMetal perfil) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MeasurementFormScreen(
          perfil: perfil,
          projetos: _projetos,
          empresa: _empresa,
          cliente: _cliente,
          onProjetoAdicionado: (projeto) {
            setState(() => _projetos.add(projeto));
            _salvar();
          },
        ),
      ),
    );
  }

  void _verLista() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectListScreen(
          projetos: _projetos,
          empresa: _empresa,
          cliente: _cliente,
          onRemover: (index) {
            setState(() => _projetos.removeAt(index));
            _salvar();
          },
          onLimpar: () {
            setState(() => _projetos.clear());
            _salvar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LogoWidget(size: LogoSize.sm),
            SizedBox(width: 10),
            Text(
              'Calculadora do Serralheiro',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          if (_projetos.isNotEmpty)
            Badge(
              label: Text('${_projetos.length}'),
              child: IconButton(
                icon: const Icon(Icons.list_alt),
                onPressed: _verLista,
              ),
            ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtro por categoria
                Container(
                  color: AppColors.cream,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoriaChip(null, 'Todos'),
                        ..._categorias.map((c) => _buildCategoriaChip(c, c)),
                      ],
                    ),
                  ),
                ),
                // Grid de perfis
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _perfisFiltrados.length,
                      itemBuilder: (context, index) {
                        final perfil = _perfisFiltrados[index];
                        return _buildPerfilCard(perfil);
                      },
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _projetos.isNotEmpty
          ? Container(
              color: AppColors.navy,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              child: ElevatedButton.icon(
                onPressed: _verLista,
                icon: const Icon(Icons.list_alt),
                label: Text('Ver Lista (${_projetos.length} itens)'),
              ),
            )
          : null,
    );
  }

  Widget _buildCategoriaChip(String? value, String label) {
    final selected = _categoriaFiltro == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? AppColors.white : AppColors.dark,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
        onSelected: (_) => setState(() => _categoriaFiltro = value),
      ),
    );
  }

  Widget _buildPerfilCard(PerfilMetal perfil) {
    return Card(
      child: InkWell(
        onTap: () => _selecionarPerfil(perfil),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PerfilDiagram(
                  perfilId: perfil.id,
                  size: 80,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                perfil.nome,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
