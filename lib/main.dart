import 'package:flutter/material.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/documentos_viewmodel.dart';

import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatefulWidget {
  const MeuApp({super.key});

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  final AuthViewModel authViewModel = AuthViewModel();

  final DocumentosViewModel documentosViewModel =
      DocumentosViewModel();

  bool inicializado = false;

  @override
  void initState() {
    super.initState();
    _inicializarAplicativo();
  }

  Future<void> _inicializarAplicativo() async {
    await authViewModel.restaurarSessao();

    if (!mounted) return;

    setState(() {
      inicializado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!inicializado) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return ListenableBuilder(
      listenable: authViewModel,
      builder: (context, child) {
        final temaEscuro =
            authViewModel.temaSelecionado == 'Escuro';

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Editor de Documentos',
          themeMode:
              temaEscuro ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          initialRoute:
              authViewModel.usuarioAtual != null ? '/home' : '/',
          routes: {
            '/': (context) => LoginView(
                  viewModel: authViewModel,
                ),
            '/cadastro': (context) => CadastroView(
                  viewModel: authViewModel,
                ),
            '/home': (context) => HomeView(
                  authViewModel: authViewModel,
                  documentosViewModel: documentosViewModel,
                ),
          },
        );
      },
    );
  }

  @override
  void dispose() {
    authViewModel.dispose();
    documentosViewModel.dispose();
    super.dispose();
  }
}