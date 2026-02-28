import 'resultado.dart';

class EmpresaInfo {
  final String nome;
  final String cnpj;
  final String telefone;
  final String email;
  final String endereco;

  const EmpresaInfo({
    required this.nome,
    this.cnpj = '',
    this.telefone = '',
    this.email = '',
    this.endereco = '',
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'cnpj': cnpj,
        'telefone': telefone,
        'email': email,
        'endereco': endereco,
      };

  factory EmpresaInfo.fromJson(Map<String, dynamic> json) => EmpresaInfo(
        nome: json['nome'] ?? '',
        cnpj: json['cnpj'] ?? '',
        telefone: json['telefone'] ?? '',
        email: json['email'] ?? '',
        endereco: json['endereco'] ?? '',
      );
}

class ClienteInfo {
  final String nome;
  final String telefone;
  final String observacoes;

  const ClienteInfo({
    this.nome = '',
    this.telefone = '',
    this.observacoes = '',
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'telefone': telefone,
        'observacoes': observacoes,
      };

  factory ClienteInfo.fromJson(Map<String, dynamic> json) => ClienteInfo(
        nome: json['nome'] ?? '',
        telefone: json['telefone'] ?? '',
        observacoes: json['observacoes'] ?? '',
      );
}

class ItemProjeto {
  final String id;
  final String tipoPerfil;
  final String nomePerfil;
  final Map<String, double> medidas;
  final int quantidade;
  final double comprimento;
  final Resultado resultado;
  final String? descricao;

  const ItemProjeto({
    required this.id,
    required this.tipoPerfil,
    required this.nomePerfil,
    required this.medidas,
    required this.quantidade,
    required this.comprimento,
    required this.resultado,
    this.descricao,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipoPerfil': tipoPerfil,
        'nomePerfil': nomePerfil,
        'medidas': medidas.map((k, v) => MapEntry(k, v)),
        'quantidade': quantidade,
        'comprimento': comprimento,
        'resultado': resultado.toJson(),
        'descricao': descricao,
      };

  factory ItemProjeto.fromJson(Map<String, dynamic> json) => ItemProjeto(
        id: json['id'],
        tipoPerfil: json['tipoPerfil'],
        nomePerfil: json['nomePerfil'],
        medidas: (json['medidas'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
        quantidade: (json['quantidade'] as num).toInt(),
        comprimento: (json['comprimento'] as num).toDouble(),
        resultado: Resultado.fromJson(json['resultado']),
        descricao: json['descricao'],
      );

  ItemProjeto copyWith({
    String? id,
    String? tipoPerfil,
    String? nomePerfil,
    Map<String, double>? medidas,
    int? quantidade,
    double? comprimento,
    Resultado? resultado,
    String? descricao,
  }) {
    return ItemProjeto(
      id: id ?? this.id,
      tipoPerfil: tipoPerfil ?? this.tipoPerfil,
      nomePerfil: nomePerfil ?? this.nomePerfil,
      medidas: medidas ?? this.medidas,
      quantidade: quantidade ?? this.quantidade,
      comprimento: comprimento ?? this.comprimento,
      resultado: resultado ?? this.resultado,
      descricao: descricao ?? this.descricao,
    );
  }
}

class Projeto {
  final String id;
  final String nome;
  final DateTime dataCriacao;
  final List<ItemProjeto> itens;
  final EmpresaInfo empresa;
  final ClienteInfo cliente;

  const Projeto({
    required this.id,
    required this.nome,
    required this.dataCriacao,
    required this.itens,
    required this.empresa,
    required this.cliente,
  });

  double get totalPeso => itens.fold(0, (sum, i) => sum + i.resultado.pesoTotal);
  double get totalValor => itens.fold(0, (sum, i) => sum + i.resultado.valorTotal);

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'dataCriacao': dataCriacao.toIso8601String(),
        'itens': itens.map((i) => i.toJson()).toList(),
        'empresa': empresa.toJson(),
        'cliente': cliente.toJson(),
      };

  factory Projeto.fromJson(Map<String, dynamic> json) => Projeto(
        id: json['id'],
        nome: json['nome'],
        dataCriacao: DateTime.parse(json['dataCriacao']),
        itens: (json['itens'] as List).map((i) => ItemProjeto.fromJson(i)).toList(),
        empresa: EmpresaInfo.fromJson(json['empresa']),
        cliente: ClienteInfo.fromJson(json['cliente']),
      );

  Projeto copyWith({
    String? id,
    String? nome,
    DateTime? dataCriacao,
    List<ItemProjeto>? itens,
    EmpresaInfo? empresa,
    ClienteInfo? cliente,
  }) {
    return Projeto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      itens: itens ?? this.itens,
      empresa: empresa ?? this.empresa,
      cliente: cliente ?? this.cliente,
    );
  }
}
