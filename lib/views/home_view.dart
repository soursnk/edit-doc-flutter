import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';
import 'editor_view.dart';

class HomeView extends StatelessWidget {
  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  const HomeView({
    super.key,
    required this.authViewModel,
    required this.documentosViewModel,
  });

  void _mostrarPreferencias(BuildContext context) {
    final usuario = authViewModel.usuarioAtual;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Minhas preferências'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${usuario?.nome ?? ''}'),
              Text('E-mail: ${usuario?.email ?? ''}'),
              const SizedBox(height: 12),
              Text(
                'Tema: ${authViewModel.preferencias['tema'] ?? 'Claro'}',
              ),
              Text(
                'Notificações: '
                '${authViewModel.preferencias['notificacoes'] == true ? 'Ativadas' : 'Desativadas'}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarUsuarios(BuildContext context) async {
    final List<Usuario> usuarios =
        await authViewModel.consultarUsuarios();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Usuários cadastrados'),
          content: SizedBox(
            width: double.maxFinite,
            child: usuarios.isEmpty
                ? const Text('Nenhum usuário cadastrado.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = usuarios[index];

                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(usuario.nome),
                        subtitle: Text(usuario.email),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = authViewModel.usuarioAtual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor de Documentos'),
        actions: [
          IconButton(
            tooltip: 'Preferências',
            onPressed: () => _mostrarPreferencias(context),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            tooltip: 'Usuários cadastrados',
            onPressed: () => _mostrarUsuarios(context),
            icon: const Icon(Icons.people),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${usuario?.nome ?? 'usuário'}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            const Text(
              'Meus documentos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 110,
              child: ListenableBuilder(
                listenable: documentosViewModel,
                builder: (context, child) {
                  return ListView.builder(
                    itemCount: documentosViewModel.documentos.length,
                    itemBuilder: (context, index) {
                      final documento =
                          documentosViewModel.documentos[index];

                      return ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(documento.nome),
                        onTap: () {
                          documentosViewModel.abrirDocumento(index);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: EditorView(
                viewModel: documentosViewModel,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Desenvolvido por: Nycolle Khetlem Souza Ramos',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}