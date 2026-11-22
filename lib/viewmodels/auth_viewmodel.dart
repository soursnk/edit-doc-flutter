
import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  final BancoLocalService _bancoLocalService =
      BancoLocalService();

  final PreferencesService _preferencesService =
      PreferencesService();

  bool carregando = false;
  Usuario? usuarioAtual;
  Map<String, dynamic> preferencias = {};

  String temaSelecionado = 'Claro';
  bool notificacoesAtivadas = true;

  void alterarTemaSelecionado(String tema) {
    temaSelecionado = tema;
    notifyListeners();
  }

  void alterarNotificacoes(bool ativadas) {
    notificacoesAtivadas = ativadas;
    notifyListeners();
  }

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String tema,
    required bool notificacoes,
  }) async {
    carregando = true;
    notifyListeners();

    try {
      final cadastrado = await _bancoLocalService.inserir(
        nome: nome,
        email: email,
        senha: senha,
      );

      if (!cadastrado) return false;

      await _preferencesService.salvar(
        email: email,
        tema: tema,
        notificacoes: notificacoes,
      );

      return true;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<bool> fazerLogin({
    required String email,
    required String senha,
  }) async {
    carregando = true;
    notifyListeners();

    try {
      final usuario = await _bancoLocalService.verificarLogin(
        email: email,
        senha: senha,
      );

      if (usuario == null) return false;

      usuarioAtual = usuario;

      preferencias = await _preferencesService.consultar(
        usuario.email,
      );

      return true;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<List<Usuario>> consultarUsuarios() {
    return _bancoLocalService.consultar();
  }
}
