import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _chaveUsuarioLogado = 'usuario_logado';
  static const String _chaveNomeUsuario = 'usuario_nome';
  static const String _chaveEmailUsuario = 'usuario_email';

  String _normalizarEmail(String email) {
    return email.trim().toLowerCase();
  }

  Future<void> salvar({
    required String email,
    required String tema,
    required bool notificacoes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final emailNormalizado = _normalizarEmail(email);

    await prefs.setString('tema_$emailNormalizado', tema);
    await prefs.setBool(
      'notificacoes_$emailNormalizado',
      notificacoes,
    );
  }

  Future<Map<String, dynamic>> consultar(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final emailNormalizado = _normalizarEmail(email);

    return {
      'tema': prefs.getString('tema_$emailNormalizado') ?? 'Claro',
      'notificacoes':
          prefs.getBool('notificacoes_$emailNormalizado') ?? true,
    };
  }

  Future<void> salvarSessao({
    required String nome,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_chaveUsuarioLogado, true);
    await prefs.setString(_chaveNomeUsuario, nome);
    await prefs.setString(_chaveEmailUsuario, email);
  }

  Future<Map<String, String>?> consultarSessao() async {
    final prefs = await SharedPreferences.getInstance();

    final usuarioLogado =
        prefs.getBool(_chaveUsuarioLogado) ?? false;

    if (!usuarioLogado) {
      return null;
    }

    final nome = prefs.getString(_chaveNomeUsuario);
    final email = prefs.getString(_chaveEmailUsuario);

    if (nome == null || email == null) {
      return null;
    }

    return {
      'nome': nome,
      'email': email,
    };
  }

  Future<void> encerrarSessao() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_chaveUsuarioLogado);
    await prefs.remove(_chaveNomeUsuario);
    await prefs.remove(_chaveEmailUsuario);
  }
}