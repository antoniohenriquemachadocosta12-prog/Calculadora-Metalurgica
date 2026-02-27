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

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'densidade': densidade,
        'precoKg': precoKg,
        'categoria': categoria,
      };

  factory MaterialMetal.fromJson(Map<String, dynamic> json) => MaterialMetal(
        id: json['id'] as String,
        nome: json['nome'] as String,
        densidade: (json['densidade'] as num).toDouble(),
        precoKg: (json['precoKg'] as num).toDouble(),
        categoria: json['categoria'] as String,
      );

  @override
  String toString() => nome;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MaterialMetal && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
