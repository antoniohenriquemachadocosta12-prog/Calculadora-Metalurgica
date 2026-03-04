import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/projeto.dart';

class StorageService {
  static const String _projetosKey = 'projetos';
  static const String _empresaKey = 'empresa';

  // ── Projetos ────────────────────────────────────────────────────────────────

  Future<List<Projeto>> carregarProjetos() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_projetosKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => Projeto.fromJson(e)).toList();
  }

  Future<void> salvarProjetos(List<Projeto> projetos) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(projetos.map((p) => p.toJson()).toList());
    await prefs.setString(_projetosKey, json);
  }

  Future<void> adicionarProjeto(Projeto projeto) async {
    final projetos = await carregarProjetos();
    projetos.add(projeto);
    await salvarProjetos(projetos);
  }

  Future<void> atualizarProjeto(Projeto projeto) async {
    final projetos = await carregarProjetos();
    final idx = projetos.indexWhere((p) => p.id == projeto.id);
    if (idx >= 0) projetos[idx] = projeto;
    await salvarProjetos(projetos);
  }

  Future<void> removerProjeto(String id) async {
    final projetos = await carregarProjetos();
    projetos.removeWhere((p) => p.id == id);
    await salvarProjetos(projetos);
  }

  // ── Empresa ─────────────────────────────────────────────────────────────────

  Future<EmpresaInfo?> carregarEmpresa() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_empresaKey);
    if (json == null) return null;
    return EmpresaInfo.fromJson(jsonDecode(json));
  }

  Future<void> salvarEmpresa(EmpresaInfo empresa) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_empresaKey, jsonEncode(empresa.toJson()));
  }
}
