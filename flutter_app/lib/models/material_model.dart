class MaterialMetal {
  final String id;
  final String nome;
  final double densidade; // kg/m³
  final double precoKg; // R$/kg
  final String categoria;

  const MaterialMetal({
    required this.id,
    required this.nome,
    required this.densidade,
    required this.precoKg,
    required this.categoria,
  });

  @override
  String toString() => nome;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MaterialMetal && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
