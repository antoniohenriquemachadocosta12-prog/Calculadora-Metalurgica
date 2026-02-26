import 'dart:math' as math;

typedef AreaCalculator = double Function(Map<String, double> medidas);

class CampoPerfil {
  final String key;
  final String label;
  final String unidade;

  const CampoPerfil({
    required this.key,
    required this.label,
    this.unidade = 'mm',
  });
}

class PerfilMetal {
  final String id;
  final String nome;
  final String icone;
  final String categoria;
  final List<CampoPerfil> campos;
  final AreaCalculator calcularArea;
  final bool isVolume;

  const PerfilMetal({
    required this.id,
    required this.nome,
    required this.icone,
    required this.categoria,
    required this.campos,
    required this.calcularArea,
    this.isVolume = false,
  });

  @override
  String toString() => nome;
}

// ============================================================
// Fábricas de perfis com fórmulas de cálculo
// ============================================================

class PerfilFactory {
  // Perfil C (U enrijecido)
  static PerfilMetal perfilC() => PerfilMetal(
        id: 'perfil_c',
        nome: 'Perfil C',
        icone: '\u2293',
        categoria: 'Perfis Estruturais',
        campos: const [
          CampoPerfil(key: 'altura', label: 'Altura (alma)'),
          CampoPerfil(key: 'largura', label: 'Largura (mesa)'),
          CampoPerfil(key: 'espessura', label: 'Espessura'),
          CampoPerfil(key: 'aba', label: 'Aba (virada)'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final h = (m['altura'] ?? 0) / 1000;
          final b = (m['largura'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          final a = (m['aba'] ?? 0) / 1000;
          return (h * e) + (2 * b * e) + (2 * a * e) - (4 * e * e);
        },
      );

  // Perfil U
  static PerfilMetal perfilU() => PerfilMetal(
        id: 'perfil_u',
        nome: 'Perfil U',
        icone: 'U',
        categoria: 'Perfis Estruturais',
        campos: const [
          CampoPerfil(key: 'altura', label: 'Altura (alma)'),
          CampoPerfil(key: 'largura', label: 'Largura (mesa)'),
          CampoPerfil(key: 'espessura', label: 'Espessura'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final h = (m['altura'] ?? 0) / 1000;
          final b = (m['largura'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          return (h * e) + (2 * b * e) - (2 * e * e);
        },
      );

  // Barra Quadrada
  static PerfilMetal barraQuadrada() => PerfilMetal(
        id: 'barra_quadrada',
        nome: 'Barra Quadrada',
        icone: '\u25A0',
        categoria: 'Barras',
        campos: const [
          CampoPerfil(key: 'lado', label: 'Lado'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final l = (m['lado'] ?? 0) / 1000;
          return l * l;
        },
      );

  // Barra Retangular
  static PerfilMetal barraRetangular() => PerfilMetal(
        id: 'barra_retangular',
        nome: 'Barra Retangular',
        icone: '\u25AC',
        categoria: 'Barras',
        campos: const [
          CampoPerfil(key: 'largura', label: 'Largura'),
          CampoPerfil(key: 'altura', label: 'Altura'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final b = (m['largura'] ?? 0) / 1000;
          final h = (m['altura'] ?? 0) / 1000;
          return b * h;
        },
      );

  // Barra Redonda
  static PerfilMetal barraRedonda() => PerfilMetal(
        id: 'barra_redonda',
        nome: 'Barra Redonda',
        icone: '\u25CF',
        categoria: 'Barras',
        campos: const [
          CampoPerfil(key: 'diametro', label: 'Diâmetro'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final d = (m['diametro'] ?? 0) / 1000;
          return math.pi * (d / 2) * (d / 2);
        },
      );

  // Barra Sextavada
  static PerfilMetal barraSextavada() => PerfilMetal(
        id: 'barra_sextavada',
        nome: 'Barra Sextavada',
        icone: '\u2B22',
        categoria: 'Barras',
        campos: const [
          CampoPerfil(key: 'chave', label: 'Medida entre faces'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final s = (m['chave'] ?? 0) / 1000;
          return (3 * math.sqrt(3) / 2) * (s / 2) * (s / 2);
        },
      );

  // Tubo Quadrado
  static PerfilMetal tuboQuadrado() => PerfilMetal(
        id: 'tubo_quadrado',
        nome: 'Tubo Quadrado',
        icone: '\u25A1',
        categoria: 'Tubos',
        campos: const [
          CampoPerfil(key: 'lado', label: 'Lado externo'),
          CampoPerfil(key: 'espessura', label: 'Espessura da parede'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final l = (m['lado'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          final li = l - 2 * e;
          return (l * l) - (li * li);
        },
      );

  // Tubo Retangular
  static PerfilMetal tuboRetangular() => PerfilMetal(
        id: 'tubo_retangular',
        nome: 'Tubo Retangular',
        icone: '\u25AD',
        categoria: 'Tubos',
        campos: const [
          CampoPerfil(key: 'largura', label: 'Largura externa'),
          CampoPerfil(key: 'altura', label: 'Altura externa'),
          CampoPerfil(key: 'espessura', label: 'Espessura da parede'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final b = (m['largura'] ?? 0) / 1000;
          final h = (m['altura'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          return (b * h) - ((b - 2 * e) * (h - 2 * e));
        },
      );

  // Tubo Redondo
  static PerfilMetal tuboRedondo() => PerfilMetal(
        id: 'tubo_redondo',
        nome: 'Tubo Redondo',
        icone: '\u25CB',
        categoria: 'Tubos',
        campos: const [
          CampoPerfil(key: 'diametro_ext', label: 'Diâmetro externo'),
          CampoPerfil(key: 'espessura', label: 'Espessura da parede'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final de = (m['diametro_ext'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          final re = de / 2;
          final ri = re - e;
          return math.pi * (re * re - ri * ri);
        },
      );

  // Cantoneira (L)
  static PerfilMetal cantoneira() => PerfilMetal(
        id: 'cantoneira',
        nome: 'Cantoneira (L)',
        icone: 'L',
        categoria: 'Perfis Estruturais',
        campos: const [
          CampoPerfil(key: 'aba_a', label: 'Aba A'),
          CampoPerfil(key: 'aba_b', label: 'Aba B'),
          CampoPerfil(key: 'espessura', label: 'Espessura'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final a = (m['aba_a'] ?? 0) / 1000;
          final b = (m['aba_b'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          return (a * e) + (b * e) - (e * e);
        },
      );

  // Chapa / Placa
  static PerfilMetal chapa() => PerfilMetal(
        id: 'chapa',
        nome: 'Chapa / Placa',
        icone: '\u25AE',
        categoria: 'Chapas',
        campos: const [
          CampoPerfil(key: 'largura', label: 'Largura'),
          CampoPerfil(key: 'altura', label: 'Altura (comprimento)'),
          CampoPerfil(key: 'espessura', label: 'Espessura'),
        ],
        isVolume: true,
        calcularArea: (m) {
          final b = (m['largura'] ?? 0) / 1000;
          final h = (m['altura'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          return b * h * e;
        },
      );

  // Perfil I (Duplo T)
  static PerfilMetal perfilI() => PerfilMetal(
        id: 'perfil_i',
        nome: 'Perfil I (Duplo T)',
        icone: 'I',
        categoria: 'Perfis Estruturais',
        campos: const [
          CampoPerfil(key: 'altura', label: 'Altura total'),
          CampoPerfil(key: 'largura', label: 'Largura da mesa'),
          CampoPerfil(key: 'esp_alma', label: 'Espessura da alma'),
          CampoPerfil(key: 'esp_mesa', label: 'Espessura da mesa'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final h = (m['altura'] ?? 0) / 1000;
          final b = (m['largura'] ?? 0) / 1000;
          final tw = (m['esp_alma'] ?? 0) / 1000;
          final tf = (m['esp_mesa'] ?? 0) / 1000;
          return (2 * b * tf) + ((h - 2 * tf) * tw);
        },
      );

  // Perfil T
  static PerfilMetal perfilT() => PerfilMetal(
        id: 'perfil_t',
        nome: 'Perfil T',
        icone: 'T',
        categoria: 'Perfis Estruturais',
        campos: const [
          CampoPerfil(key: 'altura', label: 'Altura da alma'),
          CampoPerfil(key: 'largura', label: 'Largura da mesa'),
          CampoPerfil(key: 'esp_alma', label: 'Espessura da alma'),
          CampoPerfil(key: 'esp_mesa', label: 'Espessura da mesa'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final h = (m['altura'] ?? 0) / 1000;
          final b = (m['largura'] ?? 0) / 1000;
          final tw = (m['esp_alma'] ?? 0) / 1000;
          final tf = (m['esp_mesa'] ?? 0) / 1000;
          return (b * tf) + (h * tw);
        },
      );

  // Perfil Z
  static PerfilMetal perfilZ() => PerfilMetal(
        id: 'perfil_z',
        nome: 'Perfil Z',
        icone: 'Z',
        categoria: 'Perfis Estruturais',
        campos: const [
          CampoPerfil(key: 'altura', label: 'Altura (alma)'),
          CampoPerfil(key: 'largura', label: 'Largura (mesa)'),
          CampoPerfil(key: 'espessura', label: 'Espessura'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final h = (m['altura'] ?? 0) / 1000;
          final b = (m['largura'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          return (h * e) + (2 * b * e) - (2 * e * e);
        },
      );

  // Tubo Oblongo (oval)
  static PerfilMetal tuboOblongo() => PerfilMetal(
        id: 'tubo_oblongo',
        nome: 'Tubo Oblongo',
        icone: '\u2B2D',
        categoria: 'Tubos',
        campos: const [
          CampoPerfil(key: 'largura', label: 'Largura externa'),
          CampoPerfil(key: 'altura', label: 'Altura externa'),
          CampoPerfil(key: 'espessura', label: 'Espessura da parede'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final b = (m['largura'] ?? 0) / 1000;
          final h = (m['altura'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          final aExt = math.pi * (b / 2) * (h / 2);
          final aInt = math.pi * ((b / 2) - e) * ((h / 2) - e);
          return aExt - aInt;
        },
      );

  // Vergalhão (barra nervurada)
  static PerfilMetal vergalhao() => PerfilMetal(
        id: 'vergalhao',
        nome: 'Vergalhão',
        icone: '\u2739',
        categoria: 'Barras',
        campos: const [
          CampoPerfil(key: 'bitola', label: 'Bitola (diâmetro nominal)'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final d = (m['bitola'] ?? 0) / 1000;
          return math.pi * (d / 2) * (d / 2);
        },
      );

  // Barra Chata
  static PerfilMetal barraChata() => PerfilMetal(
        id: 'barra_chata',
        nome: 'Barra Chata',
        icone: '\u2501',
        categoria: 'Barras',
        campos: const [
          CampoPerfil(key: 'largura', label: 'Largura'),
          CampoPerfil(key: 'espessura', label: 'Espessura'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final b = (m['largura'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          return b * e;
        },
      );

  // Cantoneira de abas iguais
  static PerfilMetal cantoneiraIgual() => PerfilMetal(
        id: 'cantoneira_igual',
        nome: 'Cantoneira Abas Iguais',
        icone: 'L=',
        categoria: 'Perfis Estruturais',
        campos: const [
          CampoPerfil(key: 'aba', label: 'Aba'),
          CampoPerfil(key: 'espessura', label: 'Espessura'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
        ],
        calcularArea: (m) {
          final a = (m['aba'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          return (2 * a * e) - (e * e);
        },
      );

  // Telha / Chapa Ondulada
  static PerfilMetal telha() => PerfilMetal(
        id: 'telha',
        nome: 'Telha / Chapa Ondulada',
        icone: '\u223F',
        categoria: 'Chapas',
        campos: const [
          CampoPerfil(key: 'largura', label: 'Largura útil'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
          CampoPerfil(key: 'espessura', label: 'Espessura'),
        ],
        isVolume: true,
        calcularArea: (m) {
          final b = (m['largura'] ?? 0) / 1000;
          final c = (m['comprimento'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          // Fator 1.1 para compensar ondulação
          return b * c * e * 1.1;
        },
      );

  // Chapa Expandida (metal expandido)
  static PerfilMetal chapaExpandida() => PerfilMetal(
        id: 'chapa_expandida',
        nome: 'Chapa Expandida',
        icone: '\u2B53',
        categoria: 'Chapas',
        campos: const [
          CampoPerfil(key: 'largura', label: 'Largura'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
          CampoPerfil(key: 'espessura', label: 'Espessura original'),
        ],
        isVolume: true,
        calcularArea: (m) {
          final b = (m['largura'] ?? 0) / 1000;
          final c = (m['comprimento'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          // Fator 0.5 - metal expandido tem ~50% do volume sólido
          return b * c * e * 0.5;
        },
      );

  // Chapa Perfurada
  static PerfilMetal chapaPerfurada() => PerfilMetal(
        id: 'chapa_perfurada',
        nome: 'Chapa Perfurada',
        icone: '\u2B58',
        categoria: 'Chapas',
        campos: const [
          CampoPerfil(key: 'largura', label: 'Largura'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
          CampoPerfil(key: 'espessura', label: 'Espessura'),
          CampoPerfil(key: 'area_aberta', label: 'Área aberta (%)', unidade: '%'),
        ],
        isVolume: true,
        calcularArea: (m) {
          final b = (m['largura'] ?? 0) / 1000;
          final c = (m['comprimento'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          final pct = (m['area_aberta'] ?? 40) / 100;
          return b * c * e * (1 - pct);
        },
      );

  // Chapa Xadrez
  static PerfilMetal chapaXadrez() => PerfilMetal(
        id: 'chapa_xadrez',
        nome: 'Chapa Xadrez',
        icone: '\u2B1A',
        categoria: 'Chapas',
        campos: const [
          CampoPerfil(key: 'largura', label: 'Largura'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
          CampoPerfil(key: 'espessura', label: 'Espessura'),
        ],
        isVolume: true,
        calcularArea: (m) {
          final b = (m['largura'] ?? 0) / 1000;
          final c = (m['comprimento'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          // Fator 1.06 para compensar o relevo xadrez
          return b * c * e * 1.06;
        },
      );

  // Grade / Grelha
  static PerfilMetal grade() => PerfilMetal(
        id: 'grade',
        nome: 'Grade / Grelha',
        icone: '#',
        categoria: 'Chapas',
        campos: const [
          CampoPerfil(key: 'largura', label: 'Largura'),
          CampoPerfil(key: 'comprimento', label: 'Comprimento'),
          CampoPerfil(key: 'espessura', label: 'Espessura da barra'),
          CampoPerfil(key: 'area_aberta', label: 'Área aberta (%)', unidade: '%'),
        ],
        isVolume: true,
        calcularArea: (m) {
          final b = (m['largura'] ?? 0) / 1000;
          final c = (m['comprimento'] ?? 0) / 1000;
          final e = (m['espessura'] ?? 0) / 1000;
          final pct = (m['area_aberta'] ?? 50) / 100;
          return b * c * e * (1 - pct);
        },
      );

  /// Retorna todos os perfis disponíveis (25 tipos base)
  static List<PerfilMetal> todos() => [
        perfilC(),
        perfilU(),
        perfilI(),
        perfilT(),
        perfilZ(),
        cantoneira(),
        cantoneiraIgual(),
        barraQuadrada(),
        barraRetangular(),
        barraRedonda(),
        barraSextavada(),
        barraChata(),
        vergalhao(),
        tuboQuadrado(),
        tuboRetangular(),
        tuboRedondo(),
        tuboOblongo(),
        chapa(),
        chapaXadrez(),
        chapaExpandida(),
        chapaPerfurada(),
        telha(),
        grade(),
      ];

  /// Retorna perfis agrupados por categoria
  static Map<String, List<PerfilMetal>> porCategoria() {
    final perfis = todos();
    final map = <String, List<PerfilMetal>>{};
    for (final p in perfis) {
      map.putIfAbsent(p.categoria, () => []).add(p);
    }
    return map;
  }
}
