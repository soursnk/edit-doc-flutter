class Documento {
  final String nome;
  final String conteudo;

  Documento({
    required this.nome,
    required this.conteudo,
  });

  Map<String, String> toMap() {
    return {
      'nome': nome,
      'conteudo': conteudo,
    };
  }

  factory Documento.fromMap(Map<String, String> map) {
    return Documento(
      nome: map['nome'] ?? '',
      conteudo: map['conteudo'] ?? '',
    );
  }
}