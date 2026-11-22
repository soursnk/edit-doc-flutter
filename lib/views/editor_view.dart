import 'package:flutter/material.dart';
import '../viewmodels/documentos_viewmodel.dart';

class EditorView extends StatelessWidget {
  final DocumentosViewModel viewModel;

  const EditorView({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Área de Edição',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TextField(
            controller: viewModel.editorController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: 'Digite o conteúdo do seu documento...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            viewModel.salvarDocumento();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Documento salvo com sucesso!'),
              ),
            );
          },
          icon: const Icon(Icons.save),
          label: const Text('Salvar documento'),
        ),
      ],
    );
  }
}