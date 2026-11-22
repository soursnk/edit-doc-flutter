class Usuario {
  final String nome;
  final String email;
  final String senha;

  Usuario({
    required this.nome,
    required this.email,
    required this.senha,
  });

  Map<String, String> toMap() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  factory Usuario.fromMap(Map<String, String> map) {
    return Usuario(
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
    );
  }
}