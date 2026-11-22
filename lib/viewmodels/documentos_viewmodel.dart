import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../models/services/documento_storage_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  final DocumentoStorageService _storageService =
      DocumentoStorageService();

  final List<Documento> _documentos = [];

  final TextEditingController editorController =
      TextEditingController(
    text: 'Bem-vindo ao seu Editor de Documentos!\n\n'
        'Aqui você pode redigir notas, editar arquivos '
        'de texto e gerenciar seus documentos com facilidade.',
  );

  int? documentoSelecionado;
  bool carregando = false;

  List<Documento> get documentos =>
      List.unmodifiable(_documentos);

  Future<void> carregarDocumentos() async {
    carregando = true;
    notifyListeners();

    try {
      final documentosSalvos = await _storageService.consultar();

      _documentos
        ..clear()
        ..addAll(documentosSalvos);

      if (_documentos.isEmpty) {
        _documentos.addAll([
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
        ]);

        await _storageService.salvar(_documentos);
      }
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  void abrirDocumento(int index) {
    documentoSelecionado = index;
    editorController.text = _documentos[index].conteudo;
    notifyListeners();
  }

  void atualizarConteudo(String conteudo) {
    editorController.text = conteudo;
    notifyListeners();
  }

  Future<void> criarDocumento({
    required String nome,
    required String conteudo,
  }) async {
    _documentos.add(
      Documento(nome: nome, conteudo: conteudo),
    );

    documentoSelecionado = _documentos.length - 1;

    editorController.text = conteudo;

    await _storageService.salvar(_documentos);

    notifyListeners();
  }

  Future<void> salvarDocumento() async {
    if (documentoSelecionado == null) return;

    final index = documentoSelecionado!;

    _documentos[index] = Documento(
      nome: _documentos[index].nome,
      conteudo: editorController.text,
    );

    await _storageService.salvar(_documentos);

    notifyListeners();
  }

  Future<void> excluirDocumento(int index) async {
    if (index < 0 || index >= _documentos.length) return;

    _documentos.removeAt(index);

    documentoSelecionado = null;
    editorController.clear();

    await _storageService.salvar(_documentos);

    notifyListeners();
  }

  @override
  void dispose() {
    editorController.dispose();
    super.dispose();
  }
}