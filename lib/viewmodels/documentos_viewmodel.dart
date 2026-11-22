import 'package:flutter/material.dart';
import '../models/documento.dart';

class DocumentosViewModel extends ChangeNotifier {
  final List<Documento> _documentos = [
    Documento(
      nome: 'Documento 01 - Relatório de Atividades.txt',
      conteudo: '',
    ),
    Documento(
      nome: 'Documento 02 - Anotações de Flutter.pdf',
      conteudo: '',
    ),
    Documento(
      nome: 'Documento 03 - Ideias para o Projeto.txt',
      conteudo: '',
    ),
  ];

  final TextEditingController editorController =
      TextEditingController(
    text: 'Bem-vindo ao seu Editor de Documentos!\n\n'
        'Aqui você pode redigir notas, editar arquivos '
        'de texto e gerenciar seus documentos com facilidade.',
  );

  List<Documento> get documentos =>
      List.unmodifiable(_documentos);

  void abrirDocumento(int index) {
    editorController.text = _documentos[index].conteudo;
    notifyListeners();
  }

  void atualizarConteudo(String conteudo) {
    editorController.text = conteudo;
    notifyListeners();
  }

  void salvarDocumento() {
    if (_documentos.isNotEmpty) {
      _documentos[0] = Documento(
        nome: _documentos[0].nome,
        conteudo: editorController.text,
      );
    }

    notifyListeners();
  }

  @override
  void dispose() {
    editorController.dispose();
    super.dispose();
  }
}