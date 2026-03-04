class MaterialMetal {
  final String id;
  final String nome;
  final double densidade; // kg/m³
  final double precoKg; // R$/kg
  final String descricao;

  const MaterialMetal({
    required this.id,
    required this.nome,
    required this.densidade,
    required this.precoKg,
    required this.descricao,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'densidade': densidade,
        'precoKg': precoKg,
        'descricao': descricao,
      };

  factory MaterialMetal.fromJson(Map<String, dynamic> json) => MaterialMetal(
        id: json['id'],
        nome: json['nome'],
        densidade: (json['densidade'] as num).toDouble(),
        precoKg: (json['precoKg'] as num).toDouble(),
        descricao: json['descricao'],
      );
}
