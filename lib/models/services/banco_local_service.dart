import '../usuario.dart';

class BancoLocalService {
  static final List<Usuario> _usuarios = [];

  Future<bool> inserir({
    required String nome,
    required String email,
    required String senha,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    final existe = _usuarios.any(
      (usuario) =>
          usuario.email.toLowerCase() ==
          email.trim().toLowerCase(),
    );

    if (existe) {
      return false;
    }

    _usuarios.add(
      Usuario(
        nome: nome.trim(),
        email: email.trim().toLowerCase(),
        senha: senha,
      ),
    );

    return true;
  }

  Future<List<Usuario>> consultar() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    return List<Usuario>.from(_usuarios);
  }

  Future<Usuario?> verificarLogin({
    required String email,
    required String senha,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    for (final usuario in _usuarios) {
      if (usuario.email.toLowerCase() ==
              email.trim().toLowerCase() &&
          usuario.senha == senha) {
        return usuario;
      }
    }

    return null;
  }
}