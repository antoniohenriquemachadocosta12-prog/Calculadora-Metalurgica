import 'material_metal.dart';

class Resultado {
  final double pesoUnitario; // kg/m
  final double pesoTotal; // kg
  final double valorUnitario; // R$/m
  final double valorTotal; // R$
  final MaterialMetal material;
  final double precoKg;
  final double comprimento; // m
  final int quantidade;

  const Resultado({
    required this.pesoUnitario,
    required this.pesoTotal,
    required this.valorUnitario,
    required this.valorTotal,
    required this.material,
    required this.precoKg,
    required this.comprimento,
    required this.quantidade,
  });

  Map<String, dynamic> toJson() => {
        'pesoUnitario': pesoUnitario,
        'pesoTotal': pesoTotal,
        'valorUnitario': valorUnitario,
        'valorTotal': valorTotal,
        'material': material.toJson(),
        'precoKg': precoKg,
        'comprimento': comprimento,
        'quantidade': quantidade,
      };

  factory Resultado.fromJson(Map<String, dynamic> json) => Resultado(
        pesoUnitario: (json['pesoUnitario'] as num).toDouble(),
        pesoTotal: (json['pesoTotal'] as num).toDouble(),
        valorUnitario: (json['valorUnitario'] as num).toDouble(),
        valorTotal: (json['valorTotal'] as num).toDouble(),
        material: MaterialMetal.fromJson(json['material']),
        precoKg: (json['precoKg'] as num).toDouble(),
        comprimento: (json['comprimento'] as num).toDouble(),
        quantidade: (json['quantidade'] as num).toInt(),
      );
}
