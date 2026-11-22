class PreferencesService {
  static final Map<String, Map<String, dynamic>> _dados = {};

  Future<void> salvar({
    required String email,
    required String tema,
    required bool notificacoes,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    _dados[email.trim().toLowerCase()] = {
      'tema': tema,
      'notificacoes': notificacoes,
    };
  }

  Future<Map<String, dynamic>> consultar(String email) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    return Map<String, dynamic>.from(
      _dados[email.trim().toLowerCase()] ?? {},
    );
  }
}