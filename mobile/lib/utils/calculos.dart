import 'dart:math';
import '../models/material_metal.dart';
import '../models/resultado.dart';

/// Calcula a área transversal (mm²) de um perfil dado tipo e medidas
double calcularAreaTransversal(String tipoPerfil, Map<String, double> medidas) {
  switch (tipoPerfil) {
    case 'cantoneira_igual': {
      final a = medidas['aba'] ?? 0;
      final e = medidas['espessura'] ?? 0;
      return 2 * a * e - e * e;
    }
    case 'cantoneira_desigual':
    case 'angulo_dobrado': {
      final a = medidas['aba_a'] ?? 0;
      final b = medidas['aba_b'] ?? 0;
      final e = medidas['espessura'] ?? 0;
      return (a + b - e) * e;
    }
    case 'perfil_i':
    case 'perfil_h': {
      final h = medidas['altura'] ?? 0;
      final b = medidas['mesa'] ?? 0;
      final tw = medidas['alma'] ?? 0;
      final tf = medidas['mesa_esp'] ?? 0;
      return b * tf * 2 + (h - 2 * tf) * tw;
    }
    case 'perfil_u': {
      final h = medidas['altura'] ?? 0;
      final b = medidas['mesa'] ?? 0;
      final tw = medidas['alma'] ?? 0;
      final tf = medidas['mesa_esp'] ?? 0;
      return (h - 2 * tf) * tw + 2 * b * tf;
    }
    case 'perfil_c': {
      final h = medidas['altura'] ?? 0;
      final b = medidas['mesa'] ?? 0;
      final a = medidas['aba'] ?? 0;
      final e = medidas['espessura'] ?? 0;
      return (h + 2 * b + 2 * a - 4 * e) * e;
    }
    case 'perfil_z': {
      final h = medidas['altura'] ?? 0;
      final b = medidas['mesa'] ?? 0;
      final e = medidas['espessura'] ?? 0;
      return (h + 2 * b - 2 * e) * e;
    }
    case 'perfil_t': {
      final h = medidas['altura'] ?? 0;
      final b = medidas['mesa'] ?? 0;
      final tw = medidas['alma'] ?? 0;
      final tf = medidas['mesa_esp'] ?? 0;
      return b * tf + (h - tf) * tw;
    }
    case 'tubo_retangular': {
      final a = medidas['largura'] ?? 0;
      final b = medidas['altura'] ?? 0;
      final e = medidas['espessura'] ?? 0;
      return 2 * e * (a + b - 2 * e);
    }
    case 'tubo_quadrado': {
      final a = medidas['lado'] ?? 0;
      final e = medidas['espessura'] ?? 0;
      return 4 * e * (a - e);
    }
    case 'tubo_redondo': {
      final de = medidas['diametro_ext'] ?? 0;
      final e = medidas['espessura'] ?? 0;
      final di = de - 2 * e;
      return pi / 4 * (de * de - di * di);
    }
    case 'barra_redonda':
    case 'vergalhao': {
      final d = medidas['diametro'] ?? 0;
      return pi / 4 * d * d;
    }
    case 'barra_quadrada': {
      final a = medidas['lado'] ?? 0;
      return a * a;
    }
    case 'barra_chata': {
      final a = medidas['largura'] ?? 0;
      final e = medidas['espessura'] ?? 0;
      return a * e;
    }
    case 'barra_sextavada': {
      final s = medidas['chaveta'] ?? 0;
      return (sqrt(3) / 2) * s * s;
    }
    case 'tubo_oval': {
      final a = medidas['eixo_maior'] ?? 0;
      final b = medidas['eixo_menor'] ?? 0;
      final e = medidas['espessura'] ?? 0;
      final areaExt = pi * (a / 2) * (b / 2);
      final areaInt = pi * ((a / 2) - e) * ((b / 2) - e);
      return areaExt - areaInt;
    }
    case 'omega': {
      final h = medidas['altura'] ?? 0;
      final b = medidas['mesa'] ?? 0;
      final a = medidas['aba'] ?? 0;
      final e = medidas['espessura'] ?? 0;
      return (b + 2 * h + 2 * a - 4 * e) * e;
    }
    case 'trilho': {
      final h = medidas['altura'] ?? 0;
      final hc = medidas['cabeca'] ?? 0;
      final hb = medidas['base'] ?? 0;
      // Aproximação: cabeça + alma + base
      final ec = h * 0.15;
      final ea = h * 0.12;
      final eb = h * 0.18;
      return hc * ec + (h - ec - eb) * ea + hb * eb;
    }
    // Chapas – calculadas por volume, sem comprimento na área transversal
    case 'chapa':
    case 'chapa_xadrez': {
      // Retorna espessura em mm (usado diferente no cálculo)
      return medidas['espessura'] ?? 0;
    }
    case 'tela_soldada': {
      // Retorna marcador especial
      return -1;
    }
    default:
      return 0;
  }
}

/// Calcula o peso por metro linear (kg/m) com base na área transversal (mm²) e densidade (kg/m³)
double calcularPesoPorMetro(double areaMm2, double densidadeKgM3) {
  // área em mm² → m²: / 1_000_000
  // peso por metro: área_m² × densidade_kg/m³ = kg/m
  return (areaMm2 / 1e6) * densidadeKgM3;
}

/// Ponto de entrada principal do cálculo
Resultado calcular({
  required String tipoPerfil,
  required Map<String, double> medidas,
  required MaterialMetal material,
  required int quantidade,
}) {
  double pesoUnitario; // kg/m (ou kg/peça para chapas)
  double comprimento;

  if (tipoPerfil == 'chapa' || tipoPerfil == 'chapa_xadrez') {
    final largura = (medidas['largura'] ?? 0) / 1000; // mm → m
    final comp = (medidas['comprimento'] ?? 0) / 1000; // mm → m
    final espessura = (medidas['espessura'] ?? 0) / 1000; // mm → m
    final fatorXadrez = tipoPerfil == 'chapa_xadrez' ? 1.04 : 1.0;
    pesoUnitario = largura * comp * espessura * material.densidade * fatorXadrez;
    comprimento = 1; // peça unitária
  } else if (tipoPerfil == 'tela_soldada') {
    final largura = medidas['largura'] ?? 0;
    final comp = medidas['comprimento'] ?? 0;
    final d = medidas['diametro'] ?? 0;
    final esp = medidas['espacamento'] ?? 150;
    final areaFio = pi / 4 * (d / 1000) * (d / 1000); // m²
    final qtdLinhasLarg = (largura / (esp / 1000)).ceil();
    final qtdLinhasComp = (comp / (esp / 1000)).ceil();
    final comprimentoTotal =
        qtdLinhasLarg * comp + qtdLinhasComp * largura; // m
    pesoUnitario = comprimentoTotal * areaFio * material.densidade;
    comprimento = 1;
  } else {
    final area = calcularAreaTransversal(tipoPerfil, medidas);
    pesoUnitario = calcularPesoPorMetro(area, material.densidade);
    comprimento = medidas['comprimento'] ?? 1;
  }

  final pesoTotal = pesoUnitario * comprimento * quantidade;
  final valorUnitario = pesoUnitario * material.precoKg;
  final valorTotal = valorUnitario * comprimento * quantidade;

  return Resultado(
    pesoUnitario: pesoUnitario,
    pesoTotal: pesoTotal,
    valorUnitario: valorUnitario,
    valorTotal: valorTotal,
    material: material,
    precoKg: material.precoKg,
    comprimento: comprimento,
    quantidade: quantidade,
  );
}
