import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lico/models/lista_compras.dart';
import 'package:lico/repositories/listas_repositorio.dart';
import 'package:lico/rotas/rotas.dart';
import 'package:provider/src/provider.dart';

import 'lista_produtos.dart';

class ListasDeCompras extends StatefulWidget {
  const ListasDeCompras({Key? key}) : super(key: key);

  @override
  _ListasDeComprasState createState() => _ListasDeComprasState();
}

class _ListasDeComprasState extends State<ListasDeCompras> {
  @override
  Widget build(BuildContext context) {
    final listasCompras = context.watch<ListaRepository>();
    List<ListaComprasResource> listas = listasCompras.listasCompras;
    debugPrint("listar listas");
    for (var i = 0; i < listas.length; i++) {
      debugPrint(listas[i].codigoLista.toString());
    }
    debugPrint("fim das litas");
    return Scaffold(
      appBar: AppBar(
        title: Text("Lico"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
              onPressed: () {
                print("teste");
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: listasCompras.listasCompras.length,
        itemBuilder: (context, index) {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaProdutos(
                            codigoListaCompra: listas[index].codigoLista,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, bottom: 20),
                            child: Row(
                              children: [
                                Text(
                                  listas[index].nome,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 5, left: 20),
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         "10/24 produtos",
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.w300,
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       top: 10, left: 20, bottom: 20),
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         "RS 45,00",
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [Colors.purple, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            onDismissed: (direction) {
              int codigo = listas[index].codigoLista;
              debugPrint(codigo.toString());
              listasCompras.deletar(listas[index].codigoLista.toString());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final _nome = TextEditingController();
              final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
              return SimpleDialog(
                title: Text("Criar nova lista"),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 22),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nome,
                            decoration: InputDecoration(
                              label: Row(
                                children: [
                                  Text("Nome da lista "),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            validator: (valor) {
                              if (valor?.trim().isEmpty == true) {
                                return "Preencha por favor";
                              }
                            },
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("Cadastrar"),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  listasCompras.cadastrar(ListaComprasResource(
                                      codigoLista: 0,
                                      nome: _nome.text,
                                      finalizado: 0));
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          );
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      ),
    );
  }
}
