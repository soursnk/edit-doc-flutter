
import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/validadores.dart';

class CadastroView extends StatefulWidget {
  final AuthViewModel viewModel;

  const CadastroView({super.key, required this.viewModel});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    final sucesso = await widget.viewModel.cadastrar(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      tema: widget.viewModel.temaSelecionado,
      notificacoes: widget.viewModel.notificacoesAtivadas,
    );

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este e-mail já está cadastrado.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.person_add_alt_1,
                    size: 70,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Criar conta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: validarNome,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: validarEmail,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
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
                          RadioGroup<String>(
                            groupValue: viewModel.temaSelecionado,
                            onChanged: (value) {
                              if (value != null) {
                                viewModel.alterarTemaSelecionado(value);
                              }
                            },
                            child: Column(
                              children: [
                                RadioListTile<String>(
                                  title: const Text('Tema Claro'),
                                  secondary: const Icon(Icons.light_mode),
                                  value: 'Claro',
                                ),
                                RadioListTile<String>(
                                  title: const Text('Tema Escuro'),
                                  secondary: const Icon(Icons.dark_mode),
                                  value: 'Escuro',
                                ),
                              ],
                            ),
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
                        onPressed: viewModel.carregando
                            ? null
                            : _cadastrar,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: viewModel.carregando
                            ? const CircularProgressIndicator()
                            : const Text('Cadastrar'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
