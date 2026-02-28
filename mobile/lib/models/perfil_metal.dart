class CampoMedida {
  final String id;
  final String label;
  final String unidade;
  final String hint;

  const CampoMedida({
    required this.id,
    required this.label,
    required this.unidade,
    required this.hint,
  });
}

class PerfilMetal {
  final String id;
  final String nome;
  final String categoria;
  final String descricao;
  final String icone;
  final List<CampoMedida> campos;

  const PerfilMetal({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.descricao,
    required this.icone,
    required this.campos,
  });
}
