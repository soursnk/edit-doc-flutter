
String? validarNome(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Por favor, informe seu nome completo';
  }

  return null;
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Informe seu e-mail';
  }

  String email = value.trim();
  final partes = email.split('@');

  if (partes.length != 2 || partes[0].isEmpty) {
    return 'Informe um e-mail válido';
  }

  String dominio = partes[1];

  if (!(dominio.endsWith('.com') ||
      dominio.endsWith('.com.br'))) {
    return 'O e-mail deve terminar em .com ou .com.br';
  }

  if (dominio.startsWith('.') ||
      dominio.contains('..') ||
      dominio.split('.').any((parte) => parte.isEmpty) ||
      partes[0].contains(' ') ||
      dominio.contains(' ')) {
    return 'Informe um domínio válido';
  }

  return null;
}

String? validarSenha(String? value) {
  if (value == null || value.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  }

  return null;
}
