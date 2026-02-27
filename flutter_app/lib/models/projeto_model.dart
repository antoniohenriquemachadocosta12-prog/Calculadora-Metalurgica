import 'material_model.dart';

class Resultado {
  final double pesoUnitario;
  final double pesoTotal;
  final double valorUnitario;
  final double valorTotal;
  final String materialNome;
  final double precoKg;

  const Resultado({
    required this.pesoUnitario,
    required this.pesoTotal,
    required this.valorUnitario,
    required this.valorTotal,
    required this.materialNome,
    required this.precoKg,
  });

  Map<String, dynamic> toJson() => {
        'pesoUnitario': pesoUnitario,
        'pesoTotal': pesoTotal,
        'valorUnitario': valorUnitario,
        'valorTotal': valorTotal,
        'materialNome': materialNome,
        'precoKg': precoKg,
      };

  factory Resultado.fromJson(Map<String, dynamic> json) => Resultado(
        pesoUnitario: (json['pesoUnitario'] as num).toDouble(),
        pesoTotal: (json['pesoTotal'] as num).toDouble(),
        valorUnitario: (json['valorUnitario'] as num).toDouble(),
        valorTotal: (json['valorTotal'] as num).toDouble(),
        materialNome: json['materialNome'] as String,
        precoKg: (json['precoKg'] as num).toDouble(),
      );
}

class Projeto {
  final int id;
  final String tipoPerfilId;
  final String nomePerfil;
  final Map<String, double> medidas;
  final MaterialMetal material;
  final int quantidade;
  final Resultado resultado;

  const Projeto({
    required this.id,
    required this.tipoPerfilId,
    required this.nomePerfil,
    required this.medidas,
    required this.material,
    required this.quantidade,
    required this.resultado,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipoPerfilId': tipoPerfilId,
        'nomePerfil': nomePerfil,
        'medidas': medidas,
        'material': material.toJson(),
        'quantidade': quantidade,
        'resultado': resultado.toJson(),
      };

  factory Projeto.fromJson(Map<String, dynamic> json) => Projeto(
        id: json['id'] as int,
        tipoPerfilId: json['tipoPerfilId'] as String,
        nomePerfil: json['nomePerfil'] as String,
        medidas: (json['medidas'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
        material:
            MaterialMetal.fromJson(json['material'] as Map<String, dynamic>),
        quantidade: json['quantidade'] as int,
        resultado:
            Resultado.fromJson(json['resultado'] as Map<String, dynamic>),
      );
}

class EmpresaInfo {
  String nome;
  String cnpj;

  EmpresaInfo({this.nome = '', this.cnpj = ''});

  bool get isEmpty => nome.isEmpty && cnpj.isEmpty;

  Map<String, dynamic> toJson() => {'nome': nome, 'cnpj': cnpj};

  factory EmpresaInfo.fromJson(Map<String, dynamic> json) => EmpresaInfo(
        nome: json['nome'] as String? ?? '',
        cnpj: json['cnpj'] as String? ?? '',
      );
}

class ClienteInfo {
  String nome;
  String telefone;
  String obs;

  ClienteInfo({this.nome = '', this.telefone = '', this.obs = ''});

  bool get isEmpty => nome.isEmpty && telefone.isEmpty;

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'telefone': telefone,
        'obs': obs,
      };

  factory ClienteInfo.fromJson(Map<String, dynamic> json) => ClienteInfo(
        nome: json['nome'] as String? ?? '',
        telefone: json['telefone'] as String? ?? '',
        obs: json['obs'] as String? ?? '',
      );
}
