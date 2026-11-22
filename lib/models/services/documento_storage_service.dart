import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../documento.dart';

class DocumentoStorageService {
  static const String _chaveDocumentos = 'documentos';

  Future<void> salvar(List<Documento> documentos) async {
    final prefs = await SharedPreferences.getInstance();

    final listaJson = documentos
        .map((documento) => documento.toMap())
        .toList();

    await prefs.setString(
      _chaveDocumentos,
      jsonEncode(listaJson),
    );
  }

  Future<List<Documento>> consultar() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString(_chaveDocumentos);

    if (dados == null) {
      return [];
    }

    final List<dynamic> listaJson = jsonDecode(dados);

    return listaJson.map((item) {
      final mapa = Map<String, String>.from(item);
      return Documento.fromMap(mapa);
    }).toList();
  }

  Future<void> excluirTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveDocumentos);
  }
}