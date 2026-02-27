import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/projeto_model.dart';

class StorageService {
  static const _projetosKey = 'projetos_lista';
  static const _empresaKey = 'empresa_info';
  static const _clienteKey = 'cliente_info';

  static Future<void> salvarProjetos(List<Projeto> projetos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = projetos.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_projetosKey, jsonList);
  }

  static Future<List<Projeto>> carregarProjetos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_projetosKey);
    if (jsonList == null || jsonList.isEmpty) return [];
    return jsonList
        .map((s) => Projeto.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> salvarEmpresa(EmpresaInfo empresa) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_empresaKey, jsonEncode(empresa.toJson()));
  }

  static Future<EmpresaInfo> carregarEmpresa() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_empresaKey);
    if (json == null) return EmpresaInfo();
    return EmpresaInfo.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  static Future<void> salvarCliente(ClienteInfo cliente) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clienteKey, jsonEncode(cliente.toJson()));
  }

  static Future<ClienteInfo> carregarCliente() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_clienteKey);
    if (json == null) return ClienteInfo();
    return ClienteInfo.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }
}
