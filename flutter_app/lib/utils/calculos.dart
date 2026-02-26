import '../models/material_model.dart';
import '../models/perfil_model.dart';
import '../models/projeto_model.dart';

class Calculos {
  /// Calcula peso e valor de um perfil metálico.
  ///
  /// Para perfis lineares: peso = área da seção × comprimento × densidade
  /// Para chapas/volume: peso = volume × densidade
  static Resultado calcular({
    required PerfilMetal perfil,
    required Map<String, double> medidas,
    required MaterialMetal material,
    required int quantidade,
  }) {
    final area = perfil.calcularArea(medidas);

    double pesoUnitario;
    if (perfil.isVolume) {
      // Para chapas, a função já retorna o volume em m³
      pesoUnitario = area * material.densidade;
    } else {
      // Para perfis lineares, multiplica área (m²) × comprimento (m)
      final comprimento = (medidas['comprimento'] ?? 0) / 1000;
      pesoUnitario = area * comprimento * material.densidade;
    }

    final pesoTotal = pesoUnitario * quantidade;
    final valorUnitario = pesoUnitario * material.precoKg;
    final valorTotal = pesoTotal * material.precoKg;

    return Resultado(
      pesoUnitario: pesoUnitario,
      pesoTotal: pesoTotal,
      valorUnitario: valorUnitario,
      valorTotal: valorTotal,
      materialNome: material.nome,
      precoKg: material.precoKg,
    );
  }

  /// Formata peso em kg com 3 casas decimais
  static String formatarPeso(double peso) {
    return '${peso.toStringAsFixed(3)} kg';
  }

  /// Formata valor em R$ com 2 casas decimais
  static String formatarValor(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2)}';
  }
}
