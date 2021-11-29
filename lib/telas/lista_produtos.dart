import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lico/models/produto.dart';
import 'package:lico/repositories/listas_repositorio.dart';
import 'package:lico/repositories/produto_repositorio.dart';
import 'package:lico/rotas/rotas.dart';
import 'package:provider/src/provider.dart';

class ListaProdutos extends StatefulWidget {
  final int codigoListaCompra;
  const ListaProdutos({Key? key, required this.codigoListaCompra})
      : super(key: key);

  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  @override
  Widget build(BuildContext context) {
    final produtoProvider = context.watch<ListaRepository>();
    List<ProdutoResource> produto = produtoProvider.listarProdutos;
    TextEditingController teste = TextEditingController();

    teste.text = "0,00";
    double tela = MediaQuery.of(context).size.width;
    double medida = tela * 0.50;
    double medida2 = tela * 0.30;
    double medida3 = tela * 0.20;
    _AtualizarPreco(int codigoProduto, String valorNovo) {
      debugPrint("estáAqui");
      produtoProvider.atualizarPrecoProduto(codigoProduto, valorNovo);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Lico"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Rotas.CADASTRAR_PRODUTO,
                  arguments: {"codigo_lista": widget.codigoListaCompra},
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            // flex: Flex(direction: top),
            child: ListView.builder(
              itemCount: produto.length,
              itemBuilder: (context, index) {
                debugPrint(produto[index].toString());
                // if(produto)
                Icon icone = Icon(Icons.shopping_bag_outlined);
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment(-0.9, 0.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            print("teste");
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                              top: 10,
                            ),
                            // width: ,
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Container(
                                    width: medida,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            produto[index].nome,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              produto[index]
                                                      .quantidade
                                                      .toString() +
                                                  "x - RS " +
                                                  produto[index]
                                                      .valor
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                Container(
                                  width: medida2,
                                  child: Container(
                                    width: medida2,
                                    decoration: BoxDecoration(
                                      // color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            final _valor =
                                                TextEditingController();
                                            final GlobalKey<FormState>
                                                _formKey =
                                                GlobalKey<FormState>();
                                            return SimpleDialog(
                                              title: Text(
                                                  "Insira preço desse produto"),
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 22.0,
                                                          right: 22),
                                                  child: Form(
                                                    key: _formKey,
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          controller: _valor,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            label: Row(
                                                              children: [
                                                                Text(
                                                                    "Preço do produto "),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          validator: (valor) {
                                                            if (valor
                                                                    ?.trim()
                                                                    .isEmpty ==
                                                                true) {
                                                              return "Preencha por favor";
                                                            }
                                                          },
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: ElevatedButton(
                                                            child: Text(
                                                                "Atualizar preço"),
                                                            onPressed: () {
                                                              debugPrint(
                                                                  "clicou em atualizar preo");
                                                              _AtualizarPreco(
                                                                  produto[index]
                                                                      .codigoProduto,
                                                                  _valor.text);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text("Preço"),
                                    ),
                                  ),
                                ),
                                Container(
                                  // width: medida3,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.shopping_bag_outlined),
                                  ),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // gradient: LinearGradient(
                              //   colors: [Colors.purple, Colors.blue],
                              //   begin: Alignment.topLeft,
                              //   end: Alignment.bottomRight,
                              // ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            height: 50,
            child: Text(
              "Total: RS 150,00",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
