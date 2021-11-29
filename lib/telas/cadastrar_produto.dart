import 'package:flutter/material.dart';
import 'package:lico/models/produto.dart';
import 'package:lico/repositories/listas_repositorio.dart';
import 'package:lico/repositories/produto_repositorio.dart';
import 'package:lico/rotas/rotas.dart';
import 'package:provider/src/provider.dart';

class CadastrarProduto extends StatefulWidget {
  const CadastrarProduto({Key? key}) : super(key: key);

  @override
  _CadastrarProdutoState createState() => _CadastrarProdutoState();
}

class _CadastrarProdutoState extends State<CadastrarProduto> {
  dynamic valorSelecionado;
  List listaItems = [
    "Produto 1",
    "Produto 2",
    "Produto 3",
    "Produto 4",
  ];

  @override
  Widget build(BuildContext context) {
    final _nome = TextEditingController();
    final _quantidade = TextEditingController();
    final _valor = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final produtoProvider = context.watch<ListaRepository>();
    double noventaPorCento = MediaQuery.of(context).size.width * 0.90;
    return Scaffold(
      appBar: AppBar(
        title: Text("Lico"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: Text(
                  "Cadastrar Produto",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Center(
                child: Text(
                  "Unico campo obrigatório é o nome do produto!",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: noventaPorCento,
                // alignment: Alignment.center,
                // height: 456,
                margin:
                    EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _nome,
                        decoration: InputDecoration(
                          label: Text("Nome do produto"),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 140,
                    //   child: ListView.builder(
                    //       itemCount: produto.length,
                    //       itemBuilder: (context, index) {
                    //         return CheckboxListTile(
                    //           title: Text(produto[index].nome),
                    //           value: false,
                    //           onChanged: (c) {},
                    //         );
                    //       }),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: (noventaPorCento - 8) * 0.40,
                                child: TextField(
                                  controller: _quantidade,
                                  decoration: InputDecoration(
                                    label: Text("Quantidade"),
                                  ),
                                ),
                              ),
                              Container(
                                width: (noventaPorCento - 8) * 0.40,
                                margin: EdgeInsets.only(left: 10),
                                child: TextField(
                                  controller: _valor,
                                  decoration: InputDecoration(
                                    label: Text("Valor"),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: noventaPorCento * 0.80,
                      child: ElevatedButton(
                        style: ButtonStyle(),
                        onPressed: () {},
                        child: Text("Cadastrar e ficar"),
                      ),
                    ),
                    Container(
                      width: noventaPorCento * 0.80,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green)),
                        onPressed: () {
                          if (_valor.text.isEmpty) {
                            _valor.text = "0";
                          }

                          produtoProvider.cadastrarProduto(ProdutoResource(
                            codigoProduto: 0,
                            nome: _nome.text,
                            quantidade: double.parse(_quantidade.text),
                            valor: double.parse(_valor.text),
                          ));
                          Navigator.pop(context);
                        },
                        child: Text("Cadastrar e sair"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
