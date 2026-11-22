import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';
import 'editor_view.dart';

class HomeView extends StatefulWidget {
  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  const HomeView({
    super.key,
    required this.authViewModel,
    required this.documentosViewModel,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AuthViewModel get authViewModel => widget.authViewModel;

  DocumentosViewModel get documentosViewModel =>
      widget.documentosViewModel;

  @override
  void initState() {
    super.initState();
    documentosViewModel.carregarDocumentos();
  }

  void _mostrarPreferencias(BuildContext context) {
    String tema = authViewModel.temaSelecionado;
    bool notificacoes = authViewModel.notificacoesAtivadas;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, atualizarDialogo) {
            return AlertDialog(
              title: const Text('Minhas preferências'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: ${authViewModel.usuarioAtual?.nome ?? ''}',
                  ),
                  Text(
                    'E-mail: ${authViewModel.usuarioAtual?.email ?? ''}',
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tema do aplicativo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: tema,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'Claro',
                        child: Text('Claro'),
                      ),
                      DropdownMenuItem(
                        value: 'Escuro',
                        child: Text('Escuro'),
                      ),
                    ],
                    onChanged: (novoTema) {
                      if (novoTema == null) return;

                      atualizarDialogo(() {
                        tema = novoTema;
                      });

                      authViewModel.alterarTemaSelecionado(tema);
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notificações'),
                    value: notificacoes,
                    onChanged: (valor) {
                      atualizarDialogo(() {
                        notificacoes = valor;
                      });

                      authViewModel.alterarNotificacoes(valor);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await authViewModel.salvarPreferenciasAtuais();

                    if (!context.mounted) return;

                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
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

  Future<void> _criarDocumento() async {
    final controller = TextEditingController();

    final nome = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo documento'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nome do documento',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (!mounted || nome == null || nome.isEmpty) return;

    await documentosViewModel.criarDocumento(
      nome: nome,
      conteudo: '',
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documento criado com sucesso!'),
      ),
    );
  }

  Future<void> _excluirDocumento(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir documento'),
          content: const Text(
            'Deseja realmente excluir este documento?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmar != true) return;

    await documentosViewModel.excluirDocumento(index);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documento excluído com sucesso!'),
      ),
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
            onPressed: () async {
              await authViewModel.fazerLogout();

              if (!context.mounted) return;

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
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
              height: 150,
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
                        trailing: IconButton(
                          tooltip: 'Excluir documento',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _excluirDocumento(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: EditorView(
                viewModel: documentosViewModel,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _criarDocumento,
        icon: const Icon(Icons.add),
        label: const Text('Novo documento'),
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