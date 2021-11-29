import 'package:flutter/material.dart';
import 'package:lico/repositories/listas_repositorio.dart';
import 'package:lico/repositories/produto_repositorio.dart';
import 'package:lico/rotas/rotas.dart';
import 'package:lico/telas/cadastrar_produto.dart';
import 'package:lico/telas/lista_produtos.dart';
import 'package:lico/telas/listas.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ListaRepository()),
        ChangeNotifierProvider(create: (context) => ProdutoRepositories()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ListasDeCompras(),
        routes: {
          Rotas.CADASTRAR_PRODUTO: (_) => CadastrarProduto(),
        },
      ),
    );
  }
}
