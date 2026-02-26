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
}

class EmpresaInfo {
  String nome;
  String cnpj;

  EmpresaInfo({this.nome = '', this.cnpj = ''});

  bool get isEmpty => nome.isEmpty && cnpj.isEmpty;
}

class ClienteInfo {
  String nome;
  String telefone;
  String obs;

  ClienteInfo({this.nome = '', this.telefone = '', this.obs = ''});

  bool get isEmpty => nome.isEmpty && telefone.isEmpty;
}
