
import 'package:flutter/material.dart';

import '../utils/validadores.dart';
import '../viewmodels/auth_viewmodel.dart';

class CadastroView extends StatefulWidget {
  final AuthViewModel viewModel;

  const CadastroView({
    super.key,
    required this.viewModel,
  });

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = widget.viewModel;

    final cadastrado = await viewModel.cadastrar(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      tema: viewModel.temaSelecionado,
      notificacoes: viewModel.notificacoesAtivadas,
    );

    if (!mounted) return;

    if (!cadastrado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este e-mail já está cadastrado!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuário cadastrado com sucesso!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: validarNome,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: validarEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: validarSenha,
              ),
              const SizedBox(height: 24),
              const Text(
                'Preferências do Aplicativo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Escolha o tema:'),
              ListenableBuilder(
                listenable: viewModel,
                builder: (context, child) {
                  return Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Tema Claro'),
                        secondary: const Icon(Icons.light_mode),
                        value: 'Claro',
                        groupValue: viewModel.temaSelecionado,
                        onChanged: (value) {
                          if (value != null) {
                            viewModel.alterarTemaSelecionado(value);
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Tema Escuro'),
                        secondary: const Icon(Icons.dark_mode),
                        value: 'Escuro',
                        groupValue: viewModel.temaSelecionado,
                        onChanged: (value) {
                          if (value != null) {
                            viewModel.alterarTemaSelecionado(value);
                          }
                        },
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Receber notificações'),
                        subtitle: const Text(
                          'Ativar ou desativar notificações',
                        ),
                        secondary: const Icon(Icons.notifications),
                        value: viewModel.notificacoesAtivadas,
                        onChanged: viewModel.alterarNotificacoes,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              ListenableBuilder(
                listenable: viewModel,
                builder: (context, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: viewModel.carregando
                        ? null
                        : _cadastrar,
                    child: viewModel.carregando
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Cadastrar',
                            style: TextStyle(fontSize: 16),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
