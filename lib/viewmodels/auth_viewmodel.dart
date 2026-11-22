import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  final BancoLocalService _bancoLocalService = BancoLocalService();

  final PreferencesService _preferencesService = PreferencesService();

  bool carregando = false;
  Usuario? usuarioAtual;
  Map<String, dynamic> preferencias = {};

  String temaSelecionado = 'Claro';
  bool notificacoesAtivadas = true;

  void alterarTemaSelecionado(String tema) {
    temaSelecionado = tema;
    preferencias['tema'] = tema;
    notifyListeners();
  }

  void alterarNotificacoes(bool ativadas) {
    notificacoesAtivadas = ativadas;
    preferencias['notificacoes'] = ativadas;
    notifyListeners();
  }

  Future<void> salvarPreferenciasAtuais() async {
    if (usuarioAtual == null) return;

    await _preferencesService.salvar(
      email: usuarioAtual!.email,
      tema: temaSelecionado,
      notificacoes: notificacoesAtivadas,
    );

    preferencias = {
      'tema': temaSelecionado,
      'notificacoes': notificacoesAtivadas,
    };

    notifyListeners();
  }

  Future<void> restaurarSessao() async {
    final sessao = await _preferencesService.consultarSessao();

    if (sessao == null) return;

    usuarioAtual = Usuario(
      nome: sessao['nome']!,
      email: sessao['email']!,
      senha: '',
    );

    preferencias = await _preferencesService.consultar(
      usuarioAtual!.email,
    );

    temaSelecionado = preferencias['tema'] ?? 'Claro';
    notificacoesAtivadas =
        preferencias['notificacoes'] ?? true;

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

      temaSelecionado = preferencias['tema'] ?? 'Claro';
      notificacoesAtivadas =
          preferencias['notificacoes'] ?? true;

      await _preferencesService.salvarSessao(
        nome: usuario.nome,
        email: usuario.email,
      );

      return true;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> fazerLogout() async {
    await _preferencesService.encerrarSessao();

    usuarioAtual = null;
    preferencias = {};
    temaSelecionado = 'Claro';
    notificacoesAtivadas = true;

    notifyListeners();
  }

  Future<List<Usuario>> consultarUsuarios() {
    return _bancoLocalService.consultar();
  }
}